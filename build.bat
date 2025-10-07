git clone https://github.com/microsoft/vcpkg
xcopy /Y /E ports vcpkg\ports
cd vcpkg
call bootstrap-vcpkg.bat
REM .\vcpkg install cte-hermes-shm[core]
REM .\vcpkg install iowarp-runtime[core]
.\vcpkg install content-assimilation-engine[poco,s3]

