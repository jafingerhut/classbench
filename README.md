# Introduction

This repository is starting out with the original distributed version
of the ClassBench files, obtained from here on 2023-Oct-25:

+ https://www.arl.wustl.edu/classbench/

In particular, these three files:

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
