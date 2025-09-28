from spack.package import *


class Iowarp(Package):
    homepage = "https://grc.iit.edu/docs/hermes/main-scenario"
    git = "https://github.com/iowarp/content-transfer-engine.git"
    phases = []

    version(
        "main",
        branch="main",
        git="https://github.com/iowarp/content-transfer-engine.git",
        preferred=True,
    )
    version(
        "dev", branch="dev",
        git="https://github.com/iowarp/content-transfer-engine.git"
    )
    version("priv", branch="dev",
            git="https://github.com/lukemartinlogan/hermes.git")
    version(
        "ai", branch="dev",
        git="https://github.com/iowarp/content-transfer-engine.git"
    )

    # Common across cte-hermes-shm and hermes
    variant("posix", default=True, description="Enable POSIX adapter")
    variant("mpiio", default=True, description="Enable MPI I/O adapter")
    variant("stdio", default=True, description="Enable STDIO adapter")
    variant("debug", default=False, description="Build shared libraries")
    variant("vfd", default=False, description="Enable HDF5 VFD")
    variant("ares", default=False, description="Enable full libfabric install")
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
    variant("ppi", default=True, description="Force install ppi")

    depends_on("cte-hermes-shm")
    depends_on("cte-hermes-shm@main", when="@main")
    depends_on("cte-hermes-shm@dev", when="@dev")
    depends_on("cte-hermes-shm@priv", when="@priv")
    depends_on("cte-hermes-shm@ai", when="@ai")

    depends_on("iowarp-cte")
    depends_on("iowarp-cte -nocompile", when="~nocompile")
    depends_on("iowarp-cte +nocompile", when="+nocompile")
    depends_on("iowarp-cte@main", when="@main")
    depends_on("iowarp-cte@priv", when="@priv")
    depends_on("iowarp-cte@dev", when="@dev")
    depends_on("iowarp-cte@ai", when="@ai")
    
    depends_on('iowarp-cte+debug', when='+debug')
    depends_on('iowarp-cte+ares', when='+ares')
    depends_on('iowarp-cte+encrypt', when='+encrypt')
    depends_on('iowarp-cte+compress', when='+compress')
    depends_on('iowarp-cte+python', when='+python')

    depends_on('iowarp-cte+posix', when='+posix')
    depends_on('iowarp-cte+mpiio', when='+mpiio')
    depends_on('iowarp-cte+stdio', when='+stdio')
    depends_on('iowarp-cte+vfd', when='+vfd')

    depends_on('iowarp-runtime@ai', when='@ai', type=('build', 'run'))

    depends_on('py-ppi-jarvis-cd', when='+ppi', type=('build', 'run')) 
    depends_on('py-ppi-jarvis-cd@ai', when='@ai', type=('build', 'run')) 
    depends_on('iowarp-base')

    # GPU variants
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")
    depends_on("iowarp-cte+cuda", when="+cuda")
    depends_on("iowarp-cte+rocm", when="+rocm")

