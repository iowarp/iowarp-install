# Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *


class IowarpCore(CMakePackage):
    """IOWarp Core: Unified repository containing runtime (Chimaera), 
    context-transport-primitives, context-transfer-engine, 
    context-assimilation-engine, and context-exploration-engine."""

    homepage = "https://github.com/iowarp/core"
    git = "https://github.com/iowarp/core.git"

    # Branch versions
    version('main', branch='main', submodules=True, preferred=True)
    version('dev', branch='dev', submodules=True)

    # Build variants
    variant('debug', default=False, description='Build in Debug mode')
    variant('shared', default=True, description='Build shared libraries')
    
    # Component enable/disable variants
    variant('runtime', default=True, description='Enable Chimaera runtime component')
    variant('cte', default=True, description='Enable context-transfer-engine component')
    variant('cae', default=True, description='Enable context-assimilation-engine component')
    variant('cee', default=True, description='Enable context-exploration-engine component')
    
    # Feature variants
    variant('posix', default=True, description='Enable POSIX adapter')
    variant('mpiio', default=True, description='Enable MPI I/O adapter')
    variant('stdio', default=True, description='Enable STDIO adapter')
    variant('vfd', default=False, description='Enable HDF5 VFD')
    variant('ares', default=False, description='Enable full libfabric install')
    variant('mochi', default=False, description='Build with mochi-thallium support')
    variant('encrypt', default=False, description='Include encryption libraries')
    variant('compress', default=False, description='Include compression libraries')
    variant('python', default=False, description='Install python bindings')
    variant('elf', default=True, description='Build elf toolkit')
    variant('zmq', default=True, description='Build ZeroMQ support')
    variant('cuda', default=False, description='Enable CUDA support')
    variant('rocm', default=False, description='Enable ROCm support')

    # Base dependencies (always required)
    depends_on('iowarp-base')
    depends_on('iowarp-base+vfd', when='+vfd')
    depends_on('iowarp-base+compress', when='+compress')
    depends_on('iowarp-base+encrypt', when='+encrypt')
    depends_on('iowarp-base+cuda', when='+cuda')
    depends_on('iowarp-base+rocm', when='+rocm')
    depends_on('iowarp-base+mochi', when='+mochi')
    depends_on('iowarp-base+ares', when='+ares')
    depends_on('iowarp-base+elf', when='+elf')
    depends_on('iowarp-base+mpi', when='+mpiio')
    
    # Build tool dependencies
    depends_on('py-ppi-jarvis-cd', type=('build'))

    def cmake_args(self):
        args = []
        
        # Build type
        if '+debug' in self.spec:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Debug'))
        else:
            args.append(self.define('CMAKE_BUILD_TYPE', 'Release'))
        
        # Shared/static libraries
        args.append(self.define_from_variant('BUILD_SHARED_LIBS', 'shared'))
        
        # Component enable/disable (using the naming from CMakeLists.txt)
        args.append(self.define_from_variant('WRP_CORE_ENABLE_RUNTIME', 'runtime'))
        args.append(self.define_from_variant('WRP_CORE_ENABLE_CTE', 'cte'))
        args.append(self.define_from_variant('WRP_CORE_ENABLE_CAE', 'cae'))
        args.append(self.define_from_variant('WRP_CORE_ENABLE_CEE', 'cee'))
        
        # Context-transport-primitives (HSHM) options
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
        if '+cuda' in self.spec:
            args.append(self.define('HSHM_ENABLE_CUDA', 'ON'))
        if '+rocm' in self.spec:
            args.append(self.define('HSHM_ENABLE_ROCM', 'ON'))
        
        # Disable tests and benchmarks for production builds
        args.append(self.define('HSHM_BUILD_TESTS', 'OFF'))
        args.append(self.define('HSHM_BUILD_BENCHMARKS', 'OFF'))
        
        # Chimaera runtime options (if enabled)
        if '+runtime' in self.spec:
            if '+cuda' in self.spec:
                args.append(self.define('CHIMAERA_ENABLE_CUDA', 'ON'))
            if '+rocm' in self.spec:
                args.append(self.define('CHIMAERA_ENABLE_ROCM', 'ON'))
        
        # Context-transfer-engine (CTE) options (if enabled)
        if '+cte' in self.spec:
            if '+posix' in self.spec:
                args.append(self.define('CTE_ENABLE_POSIX_ADAPTER', 'ON'))
            if '+mpiio' in self.spec:
                args.append(self.define('CTE_ENABLE_MPIIO_ADAPTER', 'ON'))
                if 'openmpi' in self.spec:
                    args.append(self.define('CTE_OPENMPI', 'ON'))
                elif 'mpich' in self.spec:
                    args.append(self.define('CTE_MPICH', 'ON'))
            if '+stdio' in self.spec:
                args.append(self.define('CTE_ENABLE_STDIO_ADAPTER', 'ON'))
            if '+vfd' in self.spec:
                args.append(self.define('CTE_ENABLE_VFD', 'ON'))
            if '+compress' in self.spec:
                args.append(self.define('CTE_ENABLE_COMPRESS', 'ON'))
            if '+encrypt' in self.spec:
                args.append(self.define('CTE_ENABLE_ENCRYPT', 'ON'))
            if '+python' in self.spec:
                args.append(self.define('CTE_ENABLE_PYTHON', 'ON'))
            if '+cuda' in self.spec:
                args.append(self.define('CTE_ENABLE_CUDA', 'ON'))
            if '+rocm' in self.spec:
                args.append(self.define('CTE_ENABLE_ROCM', 'ON'))
        
        # Context-assimilation-engine (CAE) options (if enabled)
        if '+cae' in self.spec:
            if '+posix' in self.spec:
                args.append(self.define('CAE_ENABLE_POSIX_ADAPTER', 'ON'))
            if '+mpiio' in self.spec:
                args.append(self.define('CAE_ENABLE_MPIIO_ADAPTER', 'ON'))
                if 'openmpi' in self.spec:
                    args.append(self.define('CAE_OPENMPI', 'ON'))
                elif 'mpich' in self.spec:
                    args.append(self.define('CAE_MPICH', 'ON'))
            if '+stdio' in self.spec:
                args.append(self.define('CAE_ENABLE_STDIO_ADAPTER', 'ON'))
            if '+vfd' in self.spec:
                args.append(self.define('CAE_ENABLE_VFD', 'ON'))
            if '+cuda' in self.spec:
                args.append(self.define('CAE_ENABLE_CUDA', 'ON'))
            if '+rocm' in self.spec:
                args.append(self.define('CAE_ENABLE_ROCM', 'ON'))
        
        return args

    def setup_run_environment(self, env):
        # Set up library and module paths
        env.prepend_path('LD_LIBRARY_PATH', self.prefix.lib)
        env.prepend_path('CMAKE_MODULE_PATH', self.prefix.cmake)
        env.prepend_path('CMAKE_PREFIX_PATH', self.prefix.cmake)
        
        # Add Python paths if Python bindings are enabled
        if '+python' in self.spec:
            env.prepend_path('PYTHONPATH', self.prefix.lib)

