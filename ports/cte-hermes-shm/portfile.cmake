vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO iowarp/cte-hermes-shm
        REF "15b02d691f1fc9fe0c1e7d03f27fca8aef6d517c"
        SHA512 ffca801d544b28cefb1ac8b4388e00dec6c10eb7bd3d8ea2e4fae0c75c515a65d2e4c06823dd49c2f64393ce3472e2186a7efabdcf3dd932c8bf8b1c4f4218d2
        HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    bench BUILD_HSHM_BENCHMARKS
    cereal HSHM_ENABLE_CEREAL
    coverage HSHM_ENABLE_COVERAGE
    doxygen HSHM_ENABLE_DOXYGEN
    elf HSHM_USE_ELF
    mpi HSHM_ENABLE_MPI
    openmp HSHM_ENABLE_OPENMP
    pthread HSHM_ENABLE_PTHREADS
    shared BUILD_SHARED_LIBS
    test BUILD_HSHM_TESTS
    thallium HSHM_RPC_THALLIUM
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
