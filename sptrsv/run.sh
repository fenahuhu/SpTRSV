HYDRA_HOME=/raid/home/xiec066/hydra

cd sptrsv_v1 && make
./test_sptrsv -n 2 -rhs 1 -forward -mtx ../../sample_matrix/qh768.mtx 128 8 1
cd ../sptrsv_v2 && make
./test_sptrsv -n 2 -rhs 1 -forward -mtx ../../sample_matrix/qh768.mtx 128 8 1
cd ../sptrsv_v3 && make
$HYDRA_HOME/bin/mpirun -n 2 -ppn 2 ./test_sptrsv -n 1 -k 1 -mtx ash85/ash85.mtx
