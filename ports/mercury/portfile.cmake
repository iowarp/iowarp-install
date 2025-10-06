vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mercury-hpc/mercury
    REF "v${VERSION}"
    SHA512 6cd1e91da5ba654f7e8e053536040efae4ea37b1adec15abb2dc5e2c093c56ee95587492996e768eb0d9278aaa182726b7bb0697b51db1a2c6026e129f49d2f3
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMERCURY_USE_BOOST_PP=ON
        -DNA_USE_OFI=OFF
        -DNA_USE_SM=ON
        -DBUILD_SHARED_LIBS=ON
)

vcpkg_cmake_install()

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
