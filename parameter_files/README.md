# Syntax of ClassBench parameter files

Note: These notes were written by Andy Fingerhut in 2023-2024.  I did
not create this file format.  Instead, I am learning about it from
these sources:

+ the `db_generator` program source code, plus the file
  `db_generator/README` (I wrote most of these notes before
  discovering the latter file)
+ the example parameter files in this directory
+ the ClassBench technical report, below (especially Section 4
  "Parameter Files")

```
@Techreport{TT2004a,
  author={Taylor, David E. and Turner, Jonathan S.},
  year =         "2004",
  title={ClassBench: A Packet Classification Benchmark},
  institution =  "Washington University in St. Louis",
  number =       "WUCSE-2004-28",
  address =      "St. Louis, MO",
  month =        "May",
  note =         "",
  url={https://www.arl.wustl.edu/~jon.turner/pubs/2004/wucse-2004-28.pdf}
}
```

Terms:

+ rule set - called "filter set" by ClassBench authors.  With no other
  qualifications used to specify which rule set is meant, this term in
  this article refers to the rule set that was analyzed in order to
  create a particular parameter file.

The `db_generator` program expects all of the sections described below
to appear in a parameter file, in the order listed below.  All 12 of
the parameter files included with ClassBench have the sections in this
same order.

```
-scale
-prots
-flags
-extra
-spar
-spem
-dpar
-dpem
-wc_wc
-wc_hi
-hi_wc
-hi_hi
-wc_lo
-lo_wc
-hi_lo
-lo_hi
-lo_lo
-wc_ar
-ar_wc
-hi_ar
-ar_hi
-wc_em
-em_wc
-hi_em
-em_hi
-lo_ar
-ar_lo
-lo_em
-em_lo
-ar_ar
-ar_em
-em_ar
-em_em
-snest
-sskew
-dnest
-dskew
-pcorr
```


## Number of rules (`scale`)

Reference: `db_generator` function `read_scale`.

Example lines from file `acl1_seed`:

```
-scale
733
#
```

`-scale` is one of many "key words" that mark the beginning of
different sections of the file.

733 is the number of rules in the rule set that was analyzed.

The line containing only `#` is a line that marks the end of the
section.


## IP protocols (`prots`)

Reference: `db_generator` method `ProtList::read`, and function
`select_ports`.

Example lines from file `acl1_seed`:

```
-prots
0	0.08458390	1.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000
1	0.03137790	1.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000
6	0.87312412	0.21562500	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.13124999	0.00000000	0.00000000	0.00000000	0.65312499	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000
17	0.01091405	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.12500000	0.00000000	0.00000000	0.00000000	0.87500000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000
#
```

`-prots` is the key word marking the beginning of this section.

Each of the lines after that, before the end of section line `#`, has
the same format:

+ A protocol id value.  These are the same as the IPv4 protocol or
  IPv6 Next Header field values, many of which are listed here:
  https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers
  + NOTE: A value of 0 here actually means a don't care protocol,
    i.e. completely wildcard in all 8 bit positions, _not_ a rule that
    is exact match equal to 0 on the protocol value.  Search for the
    special case for `prot_num` equal to 0 in file `FilterList.cc` as
    the proof of this.
  + This implies that the parameter file format _cannot_ support
    recording statistics for rules that are exact match 0 on the IP
    protocol value.
  + TODO: It would be good to generalize this, since protocol value 0
    might be used to match on IPv6 packet with proto 0 for the IPv6
    Hop-by-Hop Option.  One straightforward way would be to use a
    protocol value of 0 in the parameter file to mean rules that are
    exact match 0 for the protocol field, and a new value like -1 for
    the protocol for rules that are wildcard on the protocol.
+ The fraction of rules that are exact match on this protocol value,
  if it is non-0, or the fraction of rules that are completely
  wildcard on the protocol value, if it is 0.  The total of these
  values across all lines should add up to 1, but `db_generator`
  actually ignores the last value and treats it as if it were whatever
  value is required to make all values sum to 1.
+ A sequence of 25 values, which are fractions of rules with each of
  25 kinds of L4 port match criteria.  See below for the order of
  these 25 values and their meanings.

Section 3.3.2 of the ClassBench tech report defines these abbreviations:

+ WC - wildcard.  Any value of the field matches.
+ HI - ephemeral user port range [1024, 65535].  Note that the
  `db_generator` program correctly uses [1024,65535] for HI port range
  (see RFC 6056 and https://en.wikipedia.org/wiki/Ephemeral_port), not
  [1023,65535] as described in the technical report.
+ LO - well-known system port range [0, 1023].
+ AR - arbitrary range
+ EM - exact match

The `db_generator` program uses pairs of these abbreviations in lower
case, e.g. `lo_wc`, to mean that the source port is LO, and the
destination port is WC.

The order of these can be found in function `select_ports`, and
fortunately it is also in the same relative order in method
`PrefixList::read_type`.  The order is:

+ `wc_wc`
+ `wc_hi`
+ `hi_wc`
+ `hi_hi`
+ `wc_lo`
+ `lo_wc`
+ `hi_lo`
+ `lo_hi`
+ `lo_lo`
+ `wc_ar`
+ `ar_wc`
+ `hi_ar`
+ `ar_hi`
+ `wc_em`
+ `em_wc`
+ `hi_em`
+ `em_hi`
+ `lo_ar`
+ `ar_lo`
+ `lo_em`
+ `em_lo`
+ `ar_ar`
+ `ar_em`
+ `em_ar`
+ `em_em`


## Flags (`flags`)

Example lines from file `acl1_seed`:

```
-flags
0	0x0000/0x0000,1.00000000	
1	0x0000/0x0000,1.00000000	
6	0x0000/0x0000,0.81250000	0x0000/0x0200,0.09375000	0x1000/0x1000,0.09375000	
17	0x0000/0x0000,1.00000000	
#
```

Reference: `db_generator` method `FlagList::read`.

Each line begins with an IP protocol value, for which the rest of the
line is relevant.

After that are a number of value/mask pairs in hexadecimal, preceded
with '0x', separated by a slash '/' character.  After that is a comma,
and a fraction of rules with that IP protocol value that should use
that value/mask.

The `db_generator` implementation in ClassBench supports at most 10
such specifications for a single IP protocol.

TODO: What part of a packet is this intended to match?  In the
ClassBench parameter files, the flags appear to be 16 bits in size,
and to have non-0 values outside of the least significant 6 bits, so
it does not appear to be the 6 bits of TCP flags.  Or, if it is the 6
bits of TCP flags, it isn't clear what bit positions that the 6 bits
of TCP flags are placed in within the 16-bit flags field.


## Extra field (`extra`)

Example lines from file `acl1_seed`:

```
-extra
0
#
```

Reference: `db_generator` method `ExtraList::read`.

Note: All 12 of the example parameter files included with ClassBench
have exactly the same contents for their extra section.

TODO: Consider documenting this more fully later, in terms of other
contents that the `db_generator` program supports in this section.


## L4 source/destination port arbitrary range (`spar`, `dpar`) and exact match (`spem`, `dpem`) lists

Reference: `db_generator` method `PortList::read`.

The syntax of all 4 of these sections is the same.

Example of an empty specification from `acl1_seed`:

```
-spar
#
```

Example of a non-empty `spar` specification from `ipc1_seed`:

```
-spar
0.29411766	20:23
0.29411766	109:110
0.23529412	20:21
0.14705883	1645:1646
0.02941176	5000:5001
#
```

Each line consists of a fraction, white space, and a port range
specified as <minport>, colon (:), and <maxport>.

The probabilities should sum to 1, but `db_generator` always replaces
the last value with whatever makes the total become 1.

The ranges should always have <minport> less than or equal to
<maxport>.

In an exact match section, i.e. one with `em` in its name, the minimum
and maximum port value on a single line must be equal.


## Source/destination address prefix length distributions (25 different section names)

Reference: `db_generator` method `PrefixList::read` and other methods
in `PrefixList` class.

The syntax of all 25 of these sections is the same.  The
`db_generator` program requires that they appear in the same order as
shown in Section "IP protocols" above.

Example of a `-wc_em` specification from `acl1_seed`:

```
-wc_em
51,0.00470588	23,1.00000000
52,0.01411765	30,1.00000000
53,0.00705882	31,1.00000000
54,0.04470588	23,0.05263158	32,0.94736844
55,0.02823529	23,1.00000000
62,0.01176471	32,1.00000000
63,0.04235294	31,0.61111110	32,0.38888890
64,0.84705883	32,1.00000000
#
```

The format of each line is at least 2, and `db_generator` supports up
to 34, <integer>,<fraction> pairs.

For the first such pair on a line, the integer is the sum of the IPv4
source and destination prefix lengths, in the range [0,64].  The
fraction values on each line are the fractions of rules that have that
total IPv4 source and destination prefix length.

Within a single line, the remaining integer values are the lengths of
the IPv4 source address prefix, with corresponding fractions adding up
to one in each line.

When generating rules that do not use the smoothing option, first the
pair of source/destination port range types are generated.  In this
example, for those rules that have WC for the L4 source port and EM
for the L4 destination port, first a random choice is made among all
of the total prefix lengths in the range [0,64] that have a non-0
fraction, and after that choice is made, then a random choice is made
among all of the source prefix lengths that have a non-0 fraction.
The destination IP prefix length is whatever value makes the total of
the source and destination prefix lengths add up to the total value.


## Prefix nesting thresholds (`snest`, `dnest`)

Reference: For `snest`, `db_generator` method `sbintree::read_nest`.
For `dnest`, `db_generator` method `dbintree::read_nest`.

TODO: Is there any significant difference between the sbintree and
dbintree methods?

Example of a `-snest` specification from `acl1_seed`:

```
-snest
4
#
```

The value is a single positive integer.

According to the description in the ClassBench technical report,
Section 4, heading "Prefix Nesting Thresholds", the `snest` value is
simply the maximum number of source IPv4 prefixes among all rules that
can match the same value, i.e. they "nest".  Similarly `dnest` is the
corresponding maximum value among all destination IPv4 prefixes in all
rules.


## Source and destination IP address skew (`sskew`, `dskew`)

Reference: For `sskew`, `db_generator` method `sbintree::read_skew`.
For `dskew`, `db_generator` method `dbintree::read_skew`.

TODO: Is there any significant difference between the sbintree and
dbintree methods?

Example of a `-sskew` specification from `acl1_seed`:

```
-sskew
0	0.00000000	1.00000000	0.99862826
1	1.00000000	0.00000000	1.00000000
2	1.00000000	0.00000000	1.00000000
3	1.00000000	0.00000000	1.00000000
4	1.00000000	0.00000000	1.00000000
5	1.00000000	0.00000000	1.00000000
6	0.50000000	0.50000000	0.99862635
7	1.00000000	0.00000000	1.00000000
8	1.00000000	0.00000000	1.00000000
9	1.00000000	0.00000000	1.00000000
10	1.00000000	0.00000000	1.00000000
11	1.00000000	0.00000000	1.00000000
12	1.00000000	0.00000000	1.00000000
13	1.00000000	0.00000000	1.00000000
14	1.00000000	0.00000000	1.00000000
15	1.00000000	0.00000000	1.00000000
16	1.00000000	0.00000000	1.00000000
17	1.00000000	0.00000000	1.00000000
18	1.00000000	0.00000000	1.00000000
19	1.00000000	0.00000000	1.00000000
20	1.00000000	0.00000000	1.00000000
21	1.00000000	0.00000000	1.00000000
22	1.00000000	0.00000000	1.00000000
23	1.00000000	0.00000000	1.00000000
24	0.50000000	0.50000000	0.49318182
25	0.33333334	0.66666669	0.73978359
26	0.20000000	0.80000001	0.32311377
27	0.22222222	0.77777779	0.36449289
28	0.25000000	0.75000000	0.46052003
29	0.25000000	0.75000000	0.36467236
30	0.46808508	0.53191489	0.48157272
31	0.73913044	0.26086956	0.46088934
32	0.00000000	1.00000000	0.46088934
#
```

The format of each line is:

+ integer IPv4 prefix length, range [0,32]
+ 3 floating point values, which in the source code are called
  `p1child`, `p2child`, and `skew`.  They are all member fields of the
  class `sbintree`, and also `dbintree`.


## Prefix correlation (`pcorr`)

Reference: `db_generator` method `dbintree::read_corr`.

Example of a `-sskew` specification from `acl1_seed`:

```
-pcorr
1	0.20879121
2	0.43708611
3	1.00000000
4	0.87878788
5	0.86206895
6	0.83999997
7	1.00000000
8	1.00000000
9	0.97619045
10	1.00000000
11	1.00000000
12	1.00000000
13	1.00000000
14	1.00000000
15	1.00000000
16	1.00000000
17	1.00000000
18	1.00000000
19	1.00000000
20	1.00000000
21	1.00000000
22	0.00000000
23	0.00000000
24	0.00000000
25	0.00000000
26	0.00000000
27	0.00000000
28	0.00000000
29	0.00000000
30	0.00000000
31	0.00000000
32	0.00000000
#
```

The format of each line is an integer prefix length in the range
[1,32], followed by a floating point value.  This value is stored in
the field `corr` of class `dbintree` in the `db_generator`.

This is likely related to the "correlation" between destination and
source IP address prefixes mentioned in Section 3.4 of the tech
report.
