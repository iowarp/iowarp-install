# wrpgit

Implement a python script named wrpgit that clones or updates a set of iowarp-related repos using a yaml schema

The API looks as follows:
```bash
wrpgit clone
wrpgit pull
wrpgit setup
wrpgit env
wrpgit build
wrpgit install
wrpgit clear
```

Make a requirements.txt that contains python's git library and the following GitHub repo: https://github.com/iowarp/ppi-jarvis-util.git

The script assumes that an environment variable named IOWARP is set and points to the directory the user wants place iowarp packages. At the beginning of the script, it checks to see if this environment variable is set. If not, it errors. 

## YAML Schema
The yaml file that wrpgit parses looks like this:
```yaml
username: iowarp
core_dev: True
modules:
- name: cte-hermes-shm
  build: True
  type: cmake
  preset: debug
- name: iowarp-runtime
  build: True
  preset: debug
  type: cmake
  preset: debug
  depends_on: cte-hermes-shm
- name: content-transfer-engine
  build: True
  type: cmake
  preset: debug
  depends_on: iowarp-runtime
- name: content-assimilation-engine
  build: True
  type: cmake
  preset: debug
  depends_on: content-assimilation-engine
- name: ppi-jarvis-cd
  build: False
  type: python
  depends_on: ppi-jarvis-util
- name: ppi-jarvis-util
  build: False
  type: python
- name: iowarp-runtime-util
  build: False
  type: python
  depends_on: ppi-jarvis-util
- name: ppi-chi-nettest
  build: False
  type: cmake
  preset: debug
```


## wrpgit clone
First create a class named GitUrl. The constructor of GitUrl takes as input the username and package name. With this knowledge, it constructs two urls internally.

self.url_https = https://github.com/username/package name.git
self.url_ssh = git@github.com:username/package name.git

Next create a class named IowarpClone. This class will use python's git library to clone the iowarp repos. Each of the repos in iowarp-spack/packages should be attempted for cloning. The algorithm should work as follows:

```
For each repo in modules of the yaml file:
1. If the username is not iowarp, clone repo with the ssh url
2. If that clone fails, then attempt to clone from iowarp. If core_dev is False, then use https url. Otherwise use ssh url.
3. If clone fails again, then print a warning to the screen saying clone failed and then continue.
```

Place all cloned repos in the directory pointed by the IOWARP environment variable. Create an empty file in the IOWARP directory named .wrpclone. This can be checked to see if IOWARP environment variable is correct.

## wrpgit pull

Essentially calls git pull in each of the cloned repos. First check if the IOWARP variable is set and that a file named .wrpgit exists in that directory. If it doesn't, exit with an error message saying that IOWARP/.wrpgit does not exist. Are you sure that clone was used properly? Otherwise, continue.

List each of the subdirectories in this repo and then do git pull [remote] [branch] in each of them. remote and branch may be empty strings.

## wrpgit setup

In certain directories of IOWARP, there should be a .vscode folder that contains a CMakePresets.yaml. Replace IOWARP_PREFIX with ${HOME}/.scspkg/repo_name. Copy into the repo's root directory. Also re-run the wrpgit env code

Build an scspkg for the repo. E.g., scspkg create iowarp-runtime for iowarp-runtime. Use the depends_on key of the module to perform ``scspkg dep add dep_name`` for each item in the depends_on list. 

## wrpgit env
In each module defined in the YAML, go to their directory and create an env.sh file. The env.sh should load the dependencies for the module and then use scspkg to dump the current environment. For example, for iowarp-runtime, do this:
```bash
module load cte-hermes-shm
scspkg build profile m=cmake path=.env.cmake
scspkg build profile m=dotenv path=.env
```

After creating this file, execute it with Exec + LocalExecInfo from jarvis-util. Use bash instead of source.

## wrpgit build

For CMake modules: Check if CMakeLists.txt and CMakePresets.json exist. If so, create a subdirectory named build. If it exists already, that is ok. Execute the cmake command that uses the given preset. If the preset is None or empty string, then don't pass it as a parameter to the cmake build command. If configure or build fail, then exit.

For python modules: First check to see if there is a requirements.txt in the repo directory. If so, do ``pip install -r requirements.txt``. If that fails, then quit building. Next, do ``pip install -e .`` to install the package locally.

Only build modules where build: True is set. 

## wrpgit install
In each of the IOWARP directories containing a CMakeLists.txt, run the cmake command to install. Assume the subdirectory name is build.

## wrpgit clear
In each of the IOWARP directories containing a CMakeLists.txt, delete the directory named "build".


## wrpgit fork
Extend the YAML schema to add the "fork" key:
```yaml
- name: content-transfer-engine
  fork: True
  build: True
  type: cmake
  preset: debug
  depends_on: iowarp-runtime
```

Let's add a new function named fork. Usage:
```bash
wrpgit fork
```

This function will use the github command line to fork a repository from the iowarp URL to a personal account. Anything with fork False will be skipped.

## wrpgit init
Remove config as a parameter to each function. Let's assume the config is located in the same directory as the wrpgit file itself. Use pathlib to get this location. In addition, implement an init function for wrpgit. 
Usage: ``wrpgit init``.

This function will produce a default yaml file for wrpgit cli. The default YAML looks as follows:
```
username: iowarp
core_dev: True
modules:
- name: cte-hermes-shm
  build: True
  fork: False
  type: cmake
  preset: debug
- name: iowarp-runtime
  build: True
  fork: False
  preset: debug
  type: cmake
  preset: debug
  depends_on: cte-hermes-shm
- name: content-transfer-engine
  build: True
  fork: False
  type: cmake
  preset: debug
  depends_on: iowarp-runtime
- name: content-assimilation-engine
  build: True
  fork: False
  type: cmake
  preset: debug
  depends_on: content-transfer-engine
- name: ppi-jarvis-cd
  build: False
  fork: False
  type: python
  depends_on: ppi-jarvis-util
- name: ppi-jarvis-util
  build: False
  fork: False
  type: python
- name: iowarp-runtime-util
  build: False
  fork: False
  type: python
  depends_on: ppi-jarvis-util
- name: ppi-chi-nettest
  build: False
  fork: False
  type: cmake
  preset: debug
```

# Teardown 

Create a new function called teardown. This will delete all scspkg modules:
Usage: wrpgit teardown

Internally, the function will iterate over each module in the config and then call ``scspkg destroy [module]``.

# Recreate

Create a new function called recreate. This function will call teardown and then setup:
Usage: wrpgit recreate
