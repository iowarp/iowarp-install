vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO iowarp/content-transfer-engine
    REF "f1de9307efae2a3f863c1555439bd15fc8654222"
    SHA512 9434e07c8075f2533a2020905fa009d15a9f2af331f175de4d1125fc6e4743dab494367091987e7f7832e7c2ca2a968df93368195966c66ea06e3a09745a7b82
    HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    hdf5 HERMES_ENABLE_VFD
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

# vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")