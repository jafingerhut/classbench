#! /bin/bash

INFILE="../db_generator/acl1_1000"

make
valgrind --tool=memcheck ./trace_generator 1 0.1 10 ${INFILE} |& tee out-test-short.txt

echo ""
echo "If successful, there should have been a file named ${INFILE}_trace written."
ls -l ${INFILE}_trace
