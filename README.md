# Introduction

This repository contains some updated versions of a collection of
programs and data files called _ClassBench_, written by David Taylor
(with collaboration and/or advice from Jonathan Turner).

The original versions of the ClassBench files were obtained from this
page on 2023-Oct-25:

+ https://www.arl.wustl.edu/classbench/

ClassBench consists of these programs:

+ A _Filter Set Generator_ that produces synthetic filter sets that
  accurately model the characteristics of real filter sets.  Along
  with varying the size of the filter sets, it provides high-level
  control over the composition of the filters in the resulting filter
  set.  The program is called `db_generator` and can be found in the
  directory with that name.
+ A _Trace Generator_ that produces a sequence of packet headers to
  exercise the synthetic filter set.  Along with specifying the
  relative size of the trace, it provides a simple mechanism for
  controlling locality of reference in the trace.  This program can be
  found in the directory `trace_generator`.

ClassBench also includes a set of _Parameter files_ that contain
statistics about filter sets, which can be used as input to the Filter
Set Generator.

The original authors also describe a _Filter Set Analyzer_ program
that reads in a filter set, and calculates the statistics stored in a
parameter file as a result.  The original version of program was not
published by the ClassBench authors, and when asked in October 2023
they no longer had a copy of it.

An independent implementation of at least part of the Filter Set
Analyzer can be found here:

+ https://github.com/jafingerhut/flokkun-pakka


# Instructions for use

I have tested building and running this code on the following systems.
It should work on many more, too.

+ macOS Ventura 13.6.4 with gcc version `Apple clang version 15.0.0`,
  arm64
+ Ubuntu 20.04 with gcc version 9.4.0, both x86_64 and arm64

To build the Filter Set Generator program `db_generator`:

```bash
cd db_generator
make
```

You can get some help on its command line options by running:

```bash
./db_generator -h
```

One example command line that generates a filter set with almost 5000
filters, using the parameters in the parameter file `acl1_seed`,
writing the result to file `acl1_5000`:

```bash
cd db_generator
./db_generator -bc ../parameter_files/acl1_seed 5000 0 0 0 acl1_5000
```

To build the Trace Generator program `trace_generator`:

```bash
cd trace_generator
make
```

You can get some help on its command line options by running:

```bash
./trace_generator -h
```

TODO: Add an example of running `trace_generator`.

Documentation on the format of parameter files can be found
[here](parameter_files/README.md) and [here](db_generator/README).


# Origin

These are the three files that were used as the starting point for the
files in this repository:

+ https://www.arl.wustl.edu/classbench/db_generator.tar.gz
+ https://www.arl.wustl.edu/classbench/trace_generator.tar.gz
+ https://www.arl.wustl.edu/classbench/parameter_files.tar.gz

I have put these into a Git repository so that I can make changes to
the code, which appear to be required in order to enable this code to
compile with an almost 20-year-later version of G++ than it was
probably originally developed to compile with.

```bash
$ md5sum *.tar.gz
ed11a1659a936a051d3b6c976b043b14  db_generator.tar.gz
01625a458d3364110e7413307e8c4087  parameter_files.tar.gz
9a8cf10954c201be442689e612972404  trace_generator.tar.gz
```

# License

The README from the original source code files has only this for a
license, that I have found:

```
David E. Taylor
Applied Research Laboratory
Department of Computer Science and Engineering
Washington University in Saint Louis
det3@arl.wustl.edu

DISCLAIMER: This code is freely available for academic, non-commercial
research and educational purposes.  The author, Applied Research
Laboratory, Department of Computer Science and Engineering, and
Washington University in Saint Louis are NOT liable for ANYTHING.
This code is provided with absolutely NO GUARANTEE or WARRANTY.
```
