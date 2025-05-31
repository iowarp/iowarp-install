vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hyoklee/content-assimilation-engine
    REF "3752ef5e2500c95ead20aab985b05e8b54304bdc"
    SHA512 2a558098fd9bed0b5dd48f9dc656f7bf991ea3033fa00f1b40e9d28f8af67a21daaa199b32ab924c8c65764dcb6b7708f44f67835da893007eafd553e0dfb621
    HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    poco POCO
    aws AWS    
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/omni"
    OPTIONS
    ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

# vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")