Table of Contents
=================

*   [Project Overview](#project-overview)
    *   [Detailed Summary](#detailed-summary)
*   [Installation Guide](#installation-guide)
    *   [Environment Requirements](#environment-requirements)
    *   [Dependencies](#dependencies)
    *   [Distribution Files](#distrubution-files)
    *   [Installation Instructions](#installation-instructions)
    *   [Test Cases](#test-cases)
*   [User Guide](#user-guide)

Project Overview
================

**Project Name:** PNNL HPDA Sparse-BLAS

**Principle Investigator:** Ang Li 

**Developers:** Chenhao Xie, Jieyang Chen, Jiajia Li, Shuaiwen Song, Linghao Song, Jesun Firoz

**General Area or Topic of Investigation:** Implementing and optimizing sparse Basic Linear Algebra Subprograms (BLAS) on modern multi-GPU systems.

**Release Number:** 0.2

**License:** MIT License


Installation Guide
==================

The following sections detail the compilation, packaging, and installation of the software. Also included are test data and scripts to verify the installation was successful.

Environment Requirements
------------------------

**Programming Language:** CUDA C/C++

**Operating System & Version:** Ubuntu 16.04

**Required Disk Space:** 2.5MB (additional space is required for storing test input matrix files).

**Required Memory:** Varies with different tests.

**Nodes / Cores Used:** One node with one or more Nvidia GPUs. Using NSHMEM (sptrsv_v3) requires the GPUs are directly P2P connected by NVLink/NVSwitch/NV-SLI.

Dependencies
------------
| Name | Version | Download Location | Country of Origin | Special Instructions |
| ---- | ------- | ----------------- | ----------------- | -------------------- |
| GCC | 5.4.0 | [https://gcc.gnu.org/](https://gcc.gnu.org/) | USA | None |  
| CUDA | 10.1 or newer | [https://developer.nvidia.com/cuda-toolkit](https://developer.nvidia.com/cuda-toolkit) | USA | None |  
| OpenMP | 3.1 or newer |[https://www.openmp.org/](https://www.openmp.org/) | USA | None |  
| NVSHMEM | 0.3.0 or newer | [https://developer.nvidia.com/nvshmem](https://developer.nvidia.com/nvshmem) | USA | Early Access |
| MPICH | 1.4.1 or newer | [https://www.mpich.org/](https://www.mpich.org/) | USA | None |

Distribution Files
------------------
| File | Description |
| ---- | ------- |
| ./sample\_matrix | Sample matrices for testing. Other matrix can be put in. | 
| ./spmv | Source code for sparse matrix vector multiplication. | 
| ./sptrsv | Source code for sparse triangular solver. | 
| ./sptrans | Source code for sparse matrix transpose. | 
| ./spmm | Source code for sparse matrix matrix multiplication. | 
| shared.mk | Compiler configuration file. |
| Makefile | Compile the library. |
| run\_test.py | Python script to test the SBLAS library listed in matrices.txt. |
| matrices.txt | Listing matrices to be tested by run\_test.py|
| full\_matrices.txt | Listing realworld-graph type of matrices. |
| results.csv | File generated by running run\_test.py, list testing results for the lib. |


Installation Instructions
-------------------------

(1) Modify ```shared.mk```, update the path variables ```CUDA_PATH``` to match the CUDA installation directory, ```ARCH``` to match the GPU compute capability, for example, for Tesla-V100 GPU, it is -gencode=arch=compute_70,code=compute_70, ```NVSHMEM_HOME``` to specifiy the rooting path to NVSHMEM library (e.g., /usr/local/nvshmem_0.3.0/).

(2) Type ```make``` in this directory to compile the library. Or you can enter into the directory of each kernel and type ```make``` to compile a particular kernel.

Test Cases
----------

* To verify the whole library, after successfully making. You need to modify ```run_test.py```, setting number of gpus to be tested (from 1 gpu to x gpus) and the matrix path. The default path is the sample_matrix included in this repository. Then, execute the "run_test.py" by ```python run_test.py```. It will test all the sblas kernels, kernel_versions, and gpus accordingly.

* To verify each kernel, enter into a kernel directory and execute "run.sh". You may need to add execution permision by typing ```chmod +x run.sh``` before being able to execute. 


SpMV User Guide
==========

#### Using the test binary

* ##### if use randomly generated input matrix 
	
 	```./test_spmv g [matri size n] [num. of GPU(s)] [num. of repeat test(s)] [kernel version (1, 2, or 3)]```
    
    * ```[matri size n]```: It will ramdomly generate (double floating point) a non-uniformly distributed input matrix with size n*n. The dimension can be arbitrary large as long as it can fit into the CPU RAM. However, since the baseline version is not optimized for large scale, it will fail to launch if the matrix is too large. SpMV version 1 uses static sheduleing rule which also bring limitation on matrix size but has less strict constrain than the baseline version. 
    * ```[num. of GPU(s)]```: The number of GPU(s) will be applied to the baseline version and version 1. SpMV version 2 will be optimum number of GPU(s) from 1 to the number GPU(s) specified. 
    * ```[num. of repeat test(s)]```: Number of repeat test to be run. 
    * ```[kernel version (1, 2, or 3)]```: 1: the regular sparse matrix-vector multiplication in Nvidia's cuSparse; 2: the optimized sparse matrix-vector multiplication in Nvidia's cuSparse; 3: the sparse matrix-vector multiplication implemented in CSR5. Kernel version will be applied to SpVM version 1 and 2 only. The baseline version will use the kernel version 1 only.

*  ##### if use input matrix from file

	```./spmv f [path to matrix file] [num. of GPU(s)] [num. of repeat test(s)] [kernel version (1, 2, or 3)] [data type ('f' or 'b')] ```. 
    * ```[path to matrix file]```: It will load input matrix from the given path. The matrix files can be obtained from: [The SuiteSparse Matrix Collection]( https://sparse.tamu.edu/). 
    For example: 
    	* [Rail4284](https://sparse.tamu.edu/MM/Mittelmann/rail4284.tar.gz)
    	* [Circuit5M](https://sparse.tamu.edu/MM/Freescale/circuit5M.tar.gz)
    	* [ASIC_680k](https://sparse.tamu.edu/MM/Sandia/ASIC_680k.tar.gz)
    * ```[data type ('f' or 'b')]```: Some matries are filled with floating point elements and some are filled with binary elements. Since we only implemented double floating point SpVM, we will convert and treat all of them as double floating point elements. This require users to sprcify the data type in original matrix. 
    * ```[num. of GPU(s)]```: The number of GPU(s) will be applied to the baseline version and version 1. SpMV version 2 will be optimum number of GPU(s) from 1 to the number GPU(s) specified. 
    * ```[num. of repeat test(s)]```: Number of repeat test to be run. 
    * ```[kernel version (1, 2, or 3)]```: 1: the regular sparse matrix-vector multiplication in Nvidia's cuSparse; 2: the optimized sparse matrix-vector multiplication in Nvidia's cuSparse; 3: the sparse matrix-vector multiplication implemented in CSR5. Kernel version will be applied to SpVM version 1 and 2 only. The baseline version will use the kernel version 1 only.

* ##### Output
The test binary will run tests on all three SpMV versions with options specified by users. The exection time of each run and the averge time will be reported. The correctness of the output of SpVM version 1 and 2 are verified by comparing their results with the output of the baseline version. If the baseline version failed to launch (e.g., run out of memory error), the comparion result will output as 'N/A', since no comparison can be done.
    
### Description of SpMV Kernels

All SpVM version perform the matrix-vector operation:
    	y = α ∗ A ∗ x + β ∗ y
        
##### spMV_mgpu_baseline:
------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int |Number of rows of the input matrix A. |
| n | int|Number of columns of the input matrix A. | 
| nnz |long long| Number of nonzero elements in the input matrix A. | 
| alpha |double *|  Scalar used for multiplication.|
| csrVal |double *|  Array of nnz nonzero elements of matrix A as in CSR format.|
| csrRowPtr |long long *| Array of m+1 elements that contains the start of every row and the end of the last row plus one.|
| csrColIndex |int *|Array of nnz column indices of the nonzero elements of matrix A.|
| x | double * |Vector x |
| beta |double *|  Scalar used for multiplication.|
| y | double * |Vector y |
| ngpu | int |Number of GPU(s) to be used. |
------------
| Output | type|  Description |
| ---- |----| ------- | 
| y | double * |Vector y |

##### spMV_mgpu_v1:
------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int |Number of rows of the input matrix A. |
| n | int|Number of columns of the input matrix A. | 
| nnz |long long| Number of nonzero elements in the input matrix A. | 
| alpha |double *|  Scalar used for multiplication.|
| csrVal |double *|  Array of nnz nonzero elements of matrix A as in CSR format.|
| csrRowPtr |long long *| Array of m+1 elements that contains the start of every row and the end of the last row plus one.|
| csrColIndex |int *|Array of nnz column indices of the nonzero elements of matrix A.|
| x | double * |Vector x |
| beta |double *|  Scalar used for multiplication.|
| y | double * |Vector y |
| ngpu | int |Number of GPU(s) to be used. |
| kernel | int |The computing kernel (1 - 3) to be used. 1: the regular sparse matrix-vector multiplication in Nvidia's cuSparse; 2: the optimized sparse matrix-vector multiplication in Nvidia's cuSparse; 3: the sparse matrix-vector multiplication implemented in CSR5. |
------------
| Output | type|  Description |
| ---- |----| ------- | 
| y | double * |Vector y |


##### spMV_mgpu_v2:

------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int |Number of rows of the input matrix A. |
| n | int|Number of columns of the input matrix A. | 
| nnz |long long| Number of nonzero elements in the input matrix A. | 
| alpha |double *|  Scalar used for multiplication.|
| csrVal |double *|  Array of nnz nonzero elements of matrix A as in CSR format.|
| csrRowPtr |long long *| Array of m+1 elements that contains the start of every row and the end of the last row plus one.|
| csrColIndex |int *|Array of nnz column indices of the nonzero elements of matrix A.|
| x | double * |Vector x. |
| beta |double *|  Scalar used for multiplication.|
| y | double * |Vector y. |
| ngpu | int |Number of GPU(s) to be used. |
| kernel | int |The computing kernel (1 - 3) to be used. 1: the regular sparse matrix-vector multiplication in Nvidia's cuSparse; 2: the optimized sparse matrix-vector multiplication in Nvidia's cuSparse; 3: the sparse matrix-vector multiplication implemented in CSR5. |
| nb | int |Number of elements per task. |
| q | int |Number of Hyper-Q(s) on each GPU. |
------------
| Output | type|  Description |
| ---- |----| ------- | 
| y | double * |Vector y |



SpTrsv User Guide
==========

#### Using SpTrsv

* ##### if use input mtx matrix  
	
 	```./test_sptrsv -n [#gpu] -rhs 1 -forward -mtx [A.mtx]```
    
    * ```[#gpu]```: The number of GPU(s) will be applied 
    * ```[A.mtx]```: It will load input matrix from the given path
    * ```-rhs 1```: remain parameter for futher extend the SpTRSV to SpTRSM
    * ```-forward```: solve for L matrix. For U matrix using -backward (not test)
    
* ##### Output

The ./test_sptrsv will run tests based on imput matrix with options specified by users (in the common file). The exection time will be reported. The correctness of the output of SpTRSV are verified by comparing their results with the x_ref.
    

### Description of Main.cu

The main function is used to read the input matrix, transfer it to L matrix under csc compression.    

### Description of SpTRSV Kernels

All SpTRSV version perform the matrix solver operation:
    	L ∗ x = B
        
##### sptrsv_syncfree_serialref.h:
------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| cscColPtrTR |int *| Array of n+1 elements that contains the start of every row and the end of the last row plus one.|
| cscRowIdxTR |int *| Array of nnz row indices of the nonzero elements of matrix L.|
| cscValTR |double *| Array of nnz nonzero elements of matrix L as in CSC format.|
| m | int |Number of rows of the input matrix L. |
| n | int |Number of columns of the input matrix L. | 
| nnzTR | int | Number of nonzero elements in the input matrix L. | 
| substitution | int | forward of backward.|
| rhs | int| Number of col in X for SpTRSM (not implement) |
| x | double * | Vector x |
| b | double * | Vector B |
| x_ref | double * | the reference X generated by main.cu which is used to varification the result|
------------
| Output | type|  Description |
| ---- |----| ------- | 
| x | double * (default) |Vector x |

##### sptrsv_syncfree_cuda.h:
------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| cscColPtrTR |int *| Array of n+1 elements that contains the start of every row and the end of the last row plus one.|
| cscRowIdxTR |int *| Array of nnz row indices of the nonzero elements of matrix L.|
| cscValTR |double *| Array of nnz nonzero elements of matrix L as in CSC format.|
| m | int |Number of rows of the input matrix L. |
| n | int |Number of columns of the input matrix L. | 
| nnzTR | int | Number of nonzero elements in the input matrix L. | 
| substitution | int | forward of backward.|
| rhs | int | Number of col in X for SpTRSM (not implement) |
| opt | int | Number of warp defined in common |
| x | double * | Vector x |
| b | double * | Vector B |
| x_ref | double * | the reference X generated by main.cu which is used to varification the result |
| gflops | double * | performance |
| ngpu | int | Number of GPUs used |
------------
| Output | type|  Description |
| ---- |----| ------- | 
| x | double * (default) | Vector x |
| gflops | double * | performance |


SpTrans User Guide
==========

#### Using 

* ##### if use input mtx matrix  
	
 	```./test_sptrans -n [#gpu] -csr -mtx [A.mtx]```
    
    * ```[#gpu]```: The number of GPU(s) will be applied 
    * ```[A.mtx]```: It will load input matrix from the given path
    * ```-csr```: the input matrix should be compressed in csr format
    
* ##### Output

The ./test_sptrans will run tests based on imput matrix with options specified by users (in the common file). The exection time will be reported. The correctness of the output of SpTRANS are verified by comparing their results with the output of cpu kernal.
    

### Description of Main.cu

The main function is used to read the input matrix, transfer it in CPU (transfer.h) to generate csc compression for ref.    

### Description of SpTRSV Kernels

All SpTRANS version perform the matrix T operation:
    	X(csr) -> X(csc)
        
##### sptrans_cuda.h:
Single GPU version using cusparse algorithem

------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int |Number of rows of the input matrix X. |
| n | int |Number of columns of the input matrix X. | 
| nnz | int | Number of nonzero elements in the input matrix L. | 
| csrRowPtr |int *| Array of m+1 elements that contains the start of every row and the end of the last row plus one.|
| csrColIdx |int *| Array of nnz Col indices of the nonzero elements of matrix X.|
| csrVal |double *| Array of nnz nonzero elements of matrix L as in CSR format.|
| cscRowIdx |int *| Array of nnz Row indices of the nonzero elements of matrix X.|
| cscColPtr |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal |double *| Array of nnz nonzero elements of matrix L as in CSC format.|
| cscRowIdx_ref |int *| Array of nnz Row indices of the nonzero elements of reference matrix X.|
| cscColPtr_ref |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal_ref |double *| Array of nnz nonzero elements of matrix L as in CSC format.|

------------
| Output | type|  Description |
| ---- |----| ------- | 
| cscRowIdx |int *| Array of nnz Row indices of the nonzero elements of matrix X.|
| cscColPtr |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal |double *| Array of nnz nonzero elements of matrix L as in CSC format.|

##### sptrans_kernal.h:
Multiple GPUs version 

------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int |Number of rows of the input matrix X. |
| n | int |Number of columns of the input matrix X. | 
| nnz | int | Number of nonzero elements in the input matrix L. | 
| ngpu | int | Number of GPUs used |
| csrRowPtr |int *| Array of m+1 elements that contains the start of every row and the end of the last row plus one.|
| csrColIdx |int *| Array of nnz Col indices of the nonzero elements of matrix X.|
| csrVal |double *| Array of nnz nonzero elements of matrix L as in CSR format.|
| cscRowIdx |int *| Array of nnz Row indices of the nonzero elements of matrix X.|
| cscColPtr |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal |double *| Array of nnz nonzero elements of matrix L as in CSC format.|
| cscRowIdx_ref |int *| Array of nnz Row indices of the nonzero elements of reference matrix X.|
| cscColPtr_ref |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal_ref |double *| Array of nnz nonzero elements of matrix L as in CSC format.|

------------
| Output | type|  Description |
| ---- |----| ------- | 
| cscRowIdx |int *| Array of nnz Row indices of the nonzero elements of matrix X.|
| cscColPtr |int *| Array of n+1 elements that contains the start of every Col and the end of the last Col plus one.|
| cscVal |double *| Array of nnz nonzero elements of matrix L as in CSC format.|

    


SpMM User Guide
==========

#### Using the SpMM

* ##### if use input mtx matrix  
	
 	```./test_spmm [input sparse matrix A file] [output column number] [number of GPU(s)] [number of test(s)]```
    
    * ```[number of GPU(s)]```: The number of GPU(s) to run on 
    * ```[input sparse matrix A file]```: the input sparse matrix to be loaded from the given path
    * ```[output column number]```: Number of columns for the dense matrix (column major)
    * ```[number of test(s)]```: No of times the test will be executed with the same input.
    
* ##### Output

The ./test_spmm will first report the execution time of the SpMM operation with the given input using CuSPARSE library and single GPU. Next it will report the execution time with the specified number of GPUs. In addition, a breakdown of total multi-gpu execution time is also reported in terms of compute time, communication time, and post-processing time.
    

### Description of dspmm_baseline_test.cu

The driver program reads the sparse matrix provided in mmio format, stores it in a compressed sparse row (CSR) data structure on the  host, executes CuSPARSE single-gpu and our multi-gpu implementation, and report execution time in both cases.    

### Description of SpMM Kernels

SpMM multiplies two matrices, where matrix A is sparse and matrix B is dense:
    	A * B = C
        
##### dspmm_mgpu_baseline.cu:
This file contains the main function ```cusparse_mgpu_csrmm``` to perform the muti-gpu multiplication. In the multi-gpu version, matrix A (the sparse matrix) is copied from the host to each GPU, and the columns of matrix B is partitioned evenly to each GPU. Each gpu computes its part of the multiplication, and at the end of the execution the results are combined in matrix C. The function allocates device memory for the CSR representation of the matrix A , as well as device memory for the part of matrix B and C on each device. The memcpys are done in separate streams for each device for faster allocation. Once memory is allocated, CuSPARSE function ```cusparseDcsrmm``` is called on each device to perform multiplication on each device. Once the multiplication kernels finish execution, the result is copied back to the host.

------------
| Input parameter | type|  Description |
| ---- |----| ------- | 
| m | int| Number of rows in matrix A|
| k | int| Number of columns in matrix A and number of rows in matrix B|
| n | int| Number of columns in matrix B|


| alpha | double *|scalar used for multiplication|
| beta | double *|scalar used for multiplication|
| host_csrRowPtr_A | int *|pointers to the beginning of the rows in the CSR representation of matrix A on the host. |
| host_csrColIndex_A | int *| Column indices in the CSR representation of matrix A on the host|
| host_csrVal_A | double *| Non-zero values stored in the sparse matrix A on the host|
| host_B_dense | double *| Dense matrix B on the host|
| ngpu |int| Number of GPUs to be used|

------------
| Output | type|  Description |
| ---- |----| ------- | 
| host_C_dense | double *| Resultant dense matrix C|



