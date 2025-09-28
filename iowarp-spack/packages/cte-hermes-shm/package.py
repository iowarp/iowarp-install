from spack.package import *

class CteHermesShm(CMakePackage):
    homepage = "https://github.com/lukemartinlogan/cte-hermes-shm/wiki"
    git = "https://github.com/iowarp/cte-hermes-shm.git"
    
    # Branch versions
    version('main', branch='main', preferred=True)
    version('dev', branch='dev')
    version('ai', branch='49-refactor-with-ai')
    
    # Main variants
    variant('debug', default=False, description='Build shared libraries')
    variant('mochi', default=True, description='Build with mochi-thallium support')
    variant('cereal', default=True, description='Build with cereal support')
    variant('boost', default=True, description='Build with boost support')
    variant('mpiio', default=True, description='Build with MPI support')
    variant('vfd', default=False, description='Build with HDF5 support')
    variant('zmq', default=False, description='Build ZeroMQ tests')
    variant('adios', default=False, description='Build Adios support')
    variant('elf', default=False, description='Build elf toolkit')
    variant('python', default=False, description='Build python')
    variant('jarvis', default=True, description='Install jarvis deployment tool')
    variant('nocompile', default=False, description='Do not compile the library (used for dev purposes)')

    # Required deps
    depends_on('cmake@3.25:')
    depends_on('catch2@3.0.1')
    depends_on('yaml-cpp')
    depends_on('doxygen')
    depends_on('iowarp-base')

    # Machine variants
    variant('ares', default=False, description='Build in ares')
    depends_on('libfabric fabrics=sockets,tcp,udp,verbs,mlx,rxm,rxd,shm',
               when='+ares')

    # Main dependencies
    depends_on('libelf', when='+elf')
    depends_on('mochi-thallium+cereal', when='+mochi')
    depends_on('argobots@1.1+affinity', when='+mochi')
    depends_on('cereal', when='+cereal')
    depends_on('boost@1.7: +context +fiber +coroutine +regex +system +filesystem +serialization +pic +math',
               when='+boost')
    depends_on('mpi', when='+mpiio')
    depends_on('hdf5', when='+vfd')
    depends_on('libzmq', when='+zmq')
    depends_on('adios2', when='+adios')

    # Python dependencies
    depends_on('py-ppi-jarvis-cd', when='+jarvis', type=('build'))
    depends_on('py-pybind11', when='+python')
    depends_on('python', when='+python')
    depends_on('py-pip', when='+python')
    # depends_on('py-scipy', when='+python')
    # depends_on('py-numpy', when='+python')
    # depends_on('py-scikit-learn', when='+python')
    # depends_on('py-pandas', when='+python')

    # Compress variant
    variant('compress', default=False,
            description='Build with compression support')
    depends_on('lzo', when='+compress')
    depends_on('bzip2', when='+compress')
    depends_on('zstd', when='+compress')
    depends_on('lz4', when='+compress')
    depends_on('zlib', when='+compress')
    depends_on('xz', when='+compress')
    depends_on('brotli', when='+compress')
    depends_on('snappy', when='+compress')
    depends_on('c-blosc2', when='+compress')

    # Encryption variant
    variant('encrypt', default=False,
            description='Build with encryption support')
    depends_on('openssl', when='+encrypt')

    # GPU variants
    variant("cuda", default=False, description="Enable CUDA support for iowarp")
    variant("rocm", default=False, description="Enable ROCm support for iowarp")
    depends_on("cuda", when="+cuda")
    depends_on("rocm-core", when="+rocm")

    def cmake_args(self):
        args = []
        # args.append(self.define('BUILD_HSHM_TESTS', 'OFF'))
        if '+debug' in self.spec:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Debug'))
        if '+vfd' in self.spec:
            args.append(self.define('HSHM_ENABLE_VFD', 'ON'))
        if '+compress' in self.spec:
            args.append(self.define('HSHM_ENABLE_COMPRESS', 'ON'))
        if '+encrypt' in self.spec:
            args.append(self.define('HSHM_ENABLE_ENCRYPT', 'ON'))
        if '+mochi' in self.spec:
            args.append(self.define('HSHM_RPC_THALLIUM', 'ON'))
        if '+zmq' in self.spec:
            args.append(self.define('HSHM_ENABLE_ZMQ_TESTS', 'ON'))
        if '+elf' in self.spec:
            args.append(self.define('HSHM_ENABLE_ELF', 'ON'))
        if '+nocompile' in self.spec:
            args.append(self.define('HSHM_NO_COMPILE', 'ON'))
        if "+cuda" in self.spec:
            args.append(self.define("HSHM_ENABLE_CUDA", "ON"))
        if "+rocm" in self.spec:
            args.append(self.define("HSHM_ENABLE_ROCM", "ON"))
        return args

    def setup_run_environment(self, env):
        env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
        env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
