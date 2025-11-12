from spack.package import *


class Iowarp(Package):
    """IOWarp: Unified platform for distributed, tiered storage and context management.
    Meta-package that installs all IOWarp components from the unified core repository."""
    
    homepage = "https://github.com/iowarp/core"
    git = "https://github.com/iowarp/core.git"
    phases = []

    version("main", branch="main", preferred=True)
    version("dev", branch="dev")

    # Common variants
    variant("posix", default=True, description="Enable POSIX adapter")
    variant("mpiio", default=True, description="Enable MPI I/O adapter")
    variant("stdio", default=True, description="Enable STDIO adapter")
    variant("debug", default=False, description="Build in Debug mode")
    variant("vfd", default=False, description="Enable HDF5 VFD")
    variant("ares", default=False, description="Enable full libfabric install")
    variant("mochi", default=False, description="Build with mochi-thallium support")
    variant("encrypt", default=False, description="Include encryption libraries")
    variant("compress", default=False, description="Include compression libraries")
    variant("python", default=False, description="Install python bindings")
    variant("elf", default=True, description="Build elf toolkit")
    variant("zmq", default=True, description="Build ZeroMQ support")
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")

    # Component variants
    variant("runtime", default=True, description="Enable Chimaera runtime component")
    variant("cte", default=True, description="Enable context-transfer-engine component")
    variant("cae", default=True, description="Enable context-assimilation-engine component")
    variant("cee", default=True, description="Enable context-exploration-engine component")

    # Main dependency on the unified core package
    depends_on('iowarp-core')
    depends_on('iowarp-core@main', when='@main')
    depends_on('iowarp-core@dev', when='@dev')
    
    # Propagate all variants to iowarp-core
    depends_on('iowarp-core+debug', when='+debug')
    depends_on('iowarp-core+posix', when='+posix')
    depends_on('iowarp-core+mpiio', when='+mpiio')
    depends_on('iowarp-core+stdio', when='+stdio')
    depends_on('iowarp-core+vfd', when='+vfd')
    depends_on('iowarp-core+ares', when='+ares')
    depends_on('iowarp-core+mochi', when='+mochi')
    depends_on('iowarp-core+encrypt', when='+encrypt')
    depends_on('iowarp-core+compress', when='+compress')
    depends_on('iowarp-core+python', when='+python')
    depends_on('iowarp-core+elf', when='+elf')
    depends_on('iowarp-core+zmq', when='+zmq')
    depends_on('iowarp-core+cuda', when='+cuda')
    depends_on('iowarp-core+rocm', when='+rocm')
    depends_on('iowarp-core+runtime', when='+runtime')
    depends_on('iowarp-core+cte', when='+cte')
    depends_on('iowarp-core+cae', when='+cae')
    depends_on('iowarp-core+cee', when='+cee')

    depends_on('py-ppi-jarvis-cd', type=('build', 'run'))
