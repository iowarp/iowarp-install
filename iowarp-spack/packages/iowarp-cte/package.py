from spack.package import *

class IowarpCte(CMakePackage):
    homepage = "https://grc.iit.edu/docs/hermes/main-scenario"
    git = "https://github.com/iowarp/content-transfer-engine.git"

    version(
        "main",
        branch="main", 
        preferred=True,
    )
    version("dev", branch="dev")
    version("priv", branch="main", submodules=True)
    version("ai", branch="37-use-the-ai-prompt-runtime", submodules=True)

    # Common across cte-hermes-shm and hermes
    variant("posix", default=True, description="Enable POSIX adapter")
    variant("mpiio", default=True, description="Enable MPI I/O adapter")
    variant("stdio", default=True, description="Enable STDIO adapter")
    variant("debug", default=False, description="Build shared libraries")
    variant("vfd", default=False, description="Enable HDF5 VFD")
    variant("ares", default=False, description="Enable full libfabric install")
    variant("adios", default=False, description="Build Adios tests")
    variant("encrypt", default=False,
            description="Include encryption libraries")
    variant("compress", default=False,
            description="Include compression libraries")
    variant("python", default=False, description="Install python bindings")
    variant(
        "nocompile",
        default=False,
        description="Do not compile the library (used for dev purposes)",
    )
    variant("depsonly", default=False, description="Only install dependencies")

    depends_on("iowarp-runtime")
    depends_on("iowarp-runtime -nocompile", when="~nocompile")
    depends_on("iowarp-runtime +nocompile", when="+nocompile")
    depends_on("iowarp-runtime@main", when="@main")
    depends_on("iowarp-runtime@priv", when="@priv")
    depends_on("iowarp-runtime@dev", when="@dev")

    depends_on('cte-hermes-shm+elf')
    depends_on('cte-hermes-shm+debug', when='+debug')
    depends_on('cte-hermes-shm+mpiio')
    depends_on('cte-hermes-shm+ares', when='+ares')
    depends_on('cte-hermes-shm+vfd', when='+vfd')
    depends_on('cte-hermes-shm+adios', when='+adios')
    depends_on('cte-hermes-shm+encrypt', when='+encrypt')
    depends_on('cte-hermes-shm+compress', when='+compress')
    depends_on('py-ppi-jarvis-cd', type=('build'))
    depends_on('iowarp-base')

    # GPU variants
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")
    depends_on("iowarp-runtime+cuda", when="+cuda")
    depends_on("iowarp-runtime+rocm", when="+rocm")


    def cmake_args(self):
        args = [self.define_from_variant("CTE_ENABLE_PYTHON","python")]
        if "+debug" in self.spec:
            args.append("-DCMAKE_BUILD_TYPE=Debug")
        else:
            args.append("-DCMAKE_BUILD_TYPE=Release")
        if "+posix" in self.spec:
            args.append("-DCTE_ENABLE_POSIX_ADAPTER=ON")
        if "+mpiio" in self.spec:
            args.append("-DCTE_ENABLE_MPIIO_ADAPTER=ON")
            if "openmpi" in self.spec:
                args.append("-DCTE_OPENMPI=ON")
            elif "mpich" in self.spec:
                args.append("-DCTE_MPICH=ON")
        if "+stdio" in self.spec:
            args.append("-DCTE_ENABLE_STDIO_ADAPTER=ON")
        if "+vfd" in self.spec:
            args.append("-DCTE_ENABLE_VFD=ON")
        if "+compress" in self.spec:
            args.append(self.define("CTE_ENABLE_COMPRESS", "ON"))
        if "+encrypt" in self.spec:
            args.append(self.define("CTE_ENABLE_ENCRYPT", "ON"))
        if "+nocompile" in self.spec or "+depsonly" in self.spec:
            args.append(self.define("CTE_NO_COMPILE", "ON"))
        if "+python" in self.spec:
            args.append(self.define("CTE_ENABLE_PYTHON", "ON"))
        if "+cuda" in self.spec:
            args.append(self.define("CTE_ENABLE_CUDA", "ON"))
        if "+rocm" in self.spec:
            args.append(self.define("CTE_ENABLE_ROCM", "ON"))
        return args

    def setup_run_environment(self, env):
        # This is for the interceptors
        env.prepend_path("LD_LIBRARY_PATH", self.prefix.lib)
        env.prepend_path("PYTHONPATH", self.prefix.lib)
        env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
        env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
        


# class IowarpCte(CMakePackage):
#     homepage = "https://grc.iit.edu/docs/hermes/main-scenario"
#     git = "https://github.com/iowarp/content-transfer-engine.git"

#     version(
#         "main",
#         branch="main",
#         git="https://github.com/iowarp/content-transfer-engine.git",
#         preferred=True,
#     )
#     version(
#         "dev", branch="dev",
#         git="https://github.com/iowarp/content-transfer-engine.git"
#     )
#     version("priv", branch="main",
#             git="https://github.com/iowarp/content-transfer-engine.git")

#     variant("debug", default=False, description="Build shared libraries")
#     variant("ares", default=False, description="Enable full libfabric install")
#     variant("encrypt", default=False,
#             description="Include encryption libraries")
#     variant("compress", default=False,
#             description="Include compression libraries")
#     variant("python", default=False, description="Install python bindings")
#     variant(
#         "nocompile",
#         default=False,
#         description="Do not compile the library (used for dev purposes)",
#     )
#     variant("depsonly", default=False, description="Only install dependencies")

#     depends_on("iowarp-runtime")
#     depends_on("iowarp-runtime -nocompile", when="~nocompile")
#     depends_on("iowarp-runtime +nocompile", when="+nocompile")
#     depends_on("iowarp-runtime@main", when="@main")
#     depends_on("iowarp-runtime@priv", when="@priv")
#     depends_on("iowarp-runtime@dev", when="@dev")

#     depends_on('cte-hermes-shm+elf')
#     depends_on('cte-hermes-shm+debug', when='+debug')
#     depends_on('cte-hermes-shm+ares', when='+ares')
#     depends_on('cte-hermes-shm+encrypt', when='+encrypt')
#     depends_on('cte-hermes-shm+compress', when='+compress')
#     depends_on('py-ppi-jarvis-cd', type=('build'))
#     depends_on('iowarp-base')

#     # GPU variants
#     variant("cuda", default=False, description="Enable CUDA support for iowarp")
#     variant("rocm", default=False, description="Enable ROCm support for iowarp")
#     depends_on("iowarp-runtime+cuda", when="+cuda")
#     depends_on("iowarp-runtime+rocm", when="+rocm")


#     def cmake_args(self):
#         args = []
#         if "+debug" in self.spec:
#             args.append("-DCMAKE_BUILD_TYPE=Debug")
#         else:
#             args.append("-DCMAKE_BUILD_TYPE=Release")
#         if "+ares" in self.spec:
#             args.append("-DHERMES_ENABLE_ARES=ON")
#         if "+compress" in self.spec:
#             args.append(self.define("HERMES_ENABLE_COMPRESS", "ON"))
#         if "+encrypt" in self.spec:
#             args.append(self.define("HERMES_ENABLE_ENCRYPT", "ON"))
#         if "+nocompile" in self.spec or "+depsonly" in self.spec:
#             args.append(self.define("HERMES_NO_COMPILE", "ON"))
#         if "+python" in self.spec:
#             args.append(self.define("HERMES_ENABLE_PYTHON", "ON"))
#         if "+cuda" in self.spec:
#             args.append(self.define("HERMES_ENABLE_CUDA", "ON"))
#         if "+rocm" in self.spec:
#             args.append(self.define("HERMES_ENABLE_ROCM", "ON"))
#         return args

#     def setup_run_environment(self, env):
#         # This is for the interceptors
#         env.prepend_path("LD_LIBRARY_PATH", self.prefix.lib)
#         env.prepend_path("PYTHONPATH", self.prefix.lib)
#         env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
#         env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
        
