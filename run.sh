HYDRA_HOME=/raid/home/xiec066/hydra

#sptrsv_v1
./test_sptrsv_v1 -n 2 -rhs 1 -forward -mtx sample_matrix/qh768.mtx 128 8 1
#/sptrsv_v2
./test_sptrsv_v2 -n 2 -rhs 1 -forward -mtx sample_matrix/qh768.mtx 128 8 1
#/sptrsv_v3
$HYDRA_HOME/bin/mpirun -n 2 -ppn 2 ./test_sptrsv_v3 -n 1 -k 1 -mtx sample_matrix/qh768.mtx 128 8 1
