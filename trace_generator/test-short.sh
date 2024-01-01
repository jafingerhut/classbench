#! /bin/bash

INFILE="../db_generator/acl1_1000"

which valgrind > /dev/null
exit_status=$?
if [ ${exit_status} == 0 ]
then
    V="valgrind --tool=memcheck "
else
    V=""
fi

make
${V} ./trace_generator 1 0.1 10 ${INFILE} 2>&1 | tee out-test-short.txt

echo ""
echo "If successful, there should have been a file named ${INFILE}_trace written."
ls -l ${INFILE}_trace
