#! /bin/bash

INFILE="../parameter_files/acl1_seed"
OUTFILE="acl1_1000"

which valgrind > /dev/null
exit_status=$?
if [ ${exit_status} == 0 ]
then
    V="valgrind --tool=memcheck "
else
    V=""
fi

make
#${V} ./db_generator -bc ${INFILE} 1000 2 0.5 -0.1 ${OUTFILE} |& tee out-test-short.txt
${V} ./db_generator -bc ${INFILE} 1000 0 0 0 ${OUTFILE} 2>&1 | tee out-test-short.txt

echo ""
echo "If successful, there should have been a file named ${OUTFILE} written."
ls -l ${OUTFILE}
