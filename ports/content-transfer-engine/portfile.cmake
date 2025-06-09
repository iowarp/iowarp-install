vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO iowarp/content-transfer-engine
    REF "f1de9307efae2a3f863c1555439bd15fc8654222"
    SHA512 46d23501e09522fc28b7f730f8e9836ee569f80b6d6c2a7944343361b5291c954285124c5354b8bdf814d00293a21ebd2a2064c345237bcf79a7e926e8ac30c5    
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