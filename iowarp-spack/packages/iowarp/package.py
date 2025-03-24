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

    depends_on("iowarp-cte")
    depends_on("iowarp-cte -nocompile", when="~nocompile")
    depends_on("iowarp-cte +nocompile", when="+nocompile")
    depends_on("iowarp-cte@main", when="@main")
    depends_on("iowarp-cte@priv", when="@priv")
    depends_on("iowarp-cte@dev", when="@dev")
    
    depends_on('iowarp-cte+debug', when='+debug')
    depends_on('iowarp-cte+ares', when='+ares')
    depends_on('iowarp-cte+encrypt', when='+encrypt')
    depends_on('iowarp-cte+compress', when='+compress')
    depends_on('iowarp-cte+python', when='+python')

    depends_on('iowarp-cte+posix', when='+posix')
    depends_on('iowarp-cte+mpiio', when='+mpiio')
    depends_on('iowarp-cte+stdio', when='+stdio')
    depends_on('iowarp-cte+vfd', when='+vfd')

    depends_on('py-ppi-jarvis-cd', when='+ppi', type=('build', 'run'))
    depends_on('py-ppi-scspkg', when='+ppi', type=('build', 'run'))
    depends_on('ppi-chi-nettest', when='+ppi', type=('build', 'run'))
    depends_on('py-iowarp-runtime-util', type=('build', 'run'))
    depends_on('iowarp-base')
