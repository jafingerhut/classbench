#! /bin/bash

INFILE="../parameter_files/acl1_seed"
OUTFILE="acl1_1000"

make
#valgrind --tool=memcheck ./db_generator -bc ${INFILE} 1000 2 0.5 -0.1 ${OUTFILE} |& tee out-test-short.txt
valgrind --tool=memcheck ./db_generator -bc ${INFILE} 1000 0 0 0 ${OUTFILE} |& tee out-test-short.txt

echo ""
echo "If successful, there should have been a file named ${OUTFILE} written."
ls -l ${OUTFILE}
