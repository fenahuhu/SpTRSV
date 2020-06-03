include shared.mk

.PHONY: all clean

#all: test_spmv test_sptrsv test_sptrans test_spmm
all: test_sptrsv

test_sptrsv:
	(cd sptrsv/sptrsv_v1 && make)
	(cd sptrsv/sptrsv_v2 && make)
	(cd sptrsv/sptrsv_v3 && make)

clean:
	(rm test_sptrsv*)



