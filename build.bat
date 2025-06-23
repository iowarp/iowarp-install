git clone https://github.com/microsoft/vcpkg
xcopy /Y /E ports vcpkg\ports
cd vcpkg
call bootstrap-vcpkg.bat
.\vcpkg install cte-hermes-shm[core]
.\vcpkg install iowarp-runtime[core]
.\vcpkg install content-assimilation-engine[poco,s3]

