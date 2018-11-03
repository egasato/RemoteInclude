<p align="center">
    <!-- ![RemoteInclude](https://github.com/egasato/RemoteInclude/raw/master/media/RemoteInclude.png) -->
    <img alt="RemoteInclude" src="https://github.com/egasato/RemoteInclude/raw/master/media/RemoteInclude.png" />
</p>

<p align="center">Easily include remote CMake scripts into your project.</p>

<p align="center">
    <!-- ![Travis CI (master)](https://img.shields.io/travis/com/egasato/RemoteInclude/master.svg) -->
    <a title="Travis CI (master)" href="https://travis-ci.org/egasato/RemoteInclude">
        <img alt="build | passing" src="https://img.shields.io/travis/com/egasato/RemoteInclude/master.svg" />
    </a>
    <!-- ![Travis CI (develop)](https://img.shields.io/travis/com/egasato/RemoteInclude/develop.svg) -->
    <a title="Travis CI (develop)" href="https://travis-ci.org/egasato/RemoteInclude">
        <img alt="build | passing" src="https://img.shields.io/travis/com/egasato/RemoteInclude/develop.svg" />
    </a>
    <!-- [![AppVeyor (master)](https://img.shields.io/appveyor/ci/egasato/RemoteInclude/master.svg)](https://ci.appveyor.com/project/egasato/RemoteInclude) -->
    <a title="AppVeyor (master)" href="https://ci.appveyor.com/project/egasato/RemoteInclude">
        <img alt="build | passing" src="https://img.shields.io/appveyor/ci/egasato/RemoteInclude/master.svg" />
    </a>
    <!-- [![AppVeyor (develop)](https://img.shields.io/appveyor/ci/egasato/RemoteInclude/develop.svg)](https://ci.appveyor.com/project/egasato/RemoteInclude) -->
    <a title="AppVeyor (develop)" href="https://ci.appveyor.com/project/egasato/RemoteInclude">
        <img alt="build | passing" src="https://img.shields.io/appveyor/ci/egasato/RemoteInclude/develop.svg" />
    </a>
    <!-- ![GitHub tag](https://img.shields.io/github/tag/expressjs/express.svg) -->
    <a title="Latest release" href="https://github.com/egasato/RemoteInclude/releases">
        <img alt="tag | vX.X.X.X" src="https://img.shields.io/github/tag/egasato/RemoteInclude.svg" />
    </a>
    <!-- [![GitHub Issues](https://img.shields.io/github/issues/egasato/RemoteInclude.svg)](https://github.com/egasato/RemoteInclude/issues) -->
    <a title="GitHub Issues" href="https://github.com/egasato/RemoteInclude/issues">
        <img alt="issues | N open" src="https://img.shields.io/github/issues/egasato/RemoteInclude.svg" />
    </a>
    <!-- [![HitCount](http://hits.dwyl.io/egasato/RemoteInclude.svg)](http://hits.dwyl.io/egasato/RemoteInclude) -->
    <a title="HitCount" href="http://hits.dwyl.io/egasato/RemoteInclude">
        <img alt="HitCount | N hits" src="http://hits.dwyl.io/egasato/RemoteInclude.svg" />
    </a>
    <!-- [![License](https://img.shields.io/github/license/egasato/RemoteInclude.svg)](https://opensource.org/licenses/MPL-2.0) -->
    <a title="License" href="https://opensource.org/licenses/MPL-2.0">
        <img alt="license | MPL-2.0" src="https://img.shields.io/github/license/egasato/RemoteInclude.svg" />
    </a>
</p>

<p align="center">
    <sub>Built with <span color="red">&#128151;</span> by <a href="https://twitter.com/esa_u7">Esaú García Sánchez-Torija</a> and <a href="https://github.com/egasato/RemoteInclude/graphs/contributors">contributors</a>
</p>

## Table of Contents
- [Requirements](#requirements)
- [API](#api)
- [Installation](#installation)
- [Usage](#usage)

## Requirements
For this project to work you need (or your project needs) to meet the following requirements.
- Use **CMake 3.0.2** or newer (**CMake 3.11** recommended).
- **MUST NOT** define the name `RemoteInclude`.
- **MUST NOT** define the name `_RemoteInclude`.

## API
This section provides documentation on how each macro or function in RemoteInclude works.
It's intended to be a technical reference.

```cmake
RemoteInclude(
    inclusion_name          # String
    URL url                 # URL
    DESTINATION path        # Path
    INACTIVITY_TIMEOUT time # [Number]
    TIMEOUT time            # [Number]
    CACHE time              # [Number]
    EXPECTED_HASH hash      # [String]
    EXPECTED_MD5 hash       # [String]
    SHOW_PROGRESS           # [Boolean]
    OVERWRITE               # [Boolean]
)
```

### Parameters
#### inclusion_name
This **string** is used to create a single variable.
Since macros run in the same scope as the caller (parent scope), this variable is used as a suffix to make it less likely to collide with any other variable.
It is recommended to use a meaningful name so that if any error occurs it will be easily identified (by you).

#### URL
This **string** is used to download the remote script.
The only requirements for this variable, to prevent fatal errors, is that is is defined, not empty and has a protocol handle that matches `^[a-zA-Z]://`.

#### DESTINATION
This **string** is used to write the contents of the remote script.
If the destination is a relative path, it will be converted to an absolute path by adding the prefix `${CMAKE_CURRENT_BINARY_DIR}/downloads`.
If the destination is not defined or is empty a fatal error will be thrown.
If the destination is a folder or the parent directory of the destination is a file, then another fatal error will be thrown.
The last checks done to this parameter are related to the [OVERWRITE](#overwrite) and [CACHE](#cache) parameters.

#### INACTIVITY_TIMEOUT
This **number** represents the maximum number of seconds of inactivity once the download process starts.
If the download is stuck without any kind progress for more seconds than specified, a fatal error will be triggered.
The default value is 0 seconds.

#### TIMEOUT
This **number** represents the maximum number of seconds of (in)activity once the download process starts.
This timeout applies even if the download is not idle, so if you are downloading a very big file, a fatal error could be thrown because the whole download process lasts more than the timeout.
The default value is 2 seconds.

#### CACHE
This **number** enables file caching, in hope to improve performance.
It represents the number of seconds a file is considered valid and so it must be re-downloaded if the timestamp is not recent enough.
In order to force the download, don't set this parameter or set it to 0.
If the desired behaviour is exactly the opposite (download only once), then use a negative number.

#### EXPECTED_HASH
This **string** is the expected hash, in hexadecimal format, of the remote file.
The format of the parameter is expected to be `ALGO=hash`, where `HASH` could be `MD5`, `SHA1`, `SHA224`, `SHA256`, `SHA384`, or `SHA512`.
By default, this parameter is empty, which results in no hash check being done.

#### EXPECTED_MD5
This **string** is the expected `MD5` hash, in hexadecimal format, of the downloaded file.
By default, this parameter is empty, which results in no `MD5` hash check being done.

#### SHOW_PROGRESS
This **boolean** enables logging during the download process.
The verbosity depends on the download speed.
If the download process is too slow, more messages are shown.

#### OVERWRITE
This **boolean** enables file overwriting.
By default, it is disabled to prevent accidental errors, because *some* IDEs may auto-reload the project while you are writing the destination path.

## Installation
This section provides instructions to easily install this project.
First of all, clone the repository in your favorite location.
```bash
git clone https://github.com/egasato/RemoteInclude.git
cd RemoteInclude
```
Then, we need to configure the project, which really easy if you have used CMake before.
There is no need to use a specific configuration mode because there is no compilation, just CMake scripts.
```bash
mkdir build
cd build
cmake ..
```
After the project has been configured, it is as easy as running the `install` target.
```bash
cmake --build . --target install
```

Alternatively, you can download your preferred installer at the [releases](https://github.com/egasato/RemoteInclude/releases) page.

## Usage
In order to use this project, a few additions have to be done to your `CMakeLists.txt`.
If you prefer, you can put the following contents in a custom `.cmake` file and include it in your `CMakeLists.txt` so it does not clutter your original file.
```cmake
# Search the package
find_package(RemoteInclude QUIET NO_MODULE)

# Log the result
if (RemoteInclude_FOUND)
    message(STATUS "Project \"RemoteInclude\" was found!")
else ()
    message(STATUS "Project \"RemoteInclude\" was NOT found!")
endif ()

# If it was NOT found, download the project
if (NOT RemoteInclude_FOUND)

    # Include support to download the Git project at configure time
    include(FetchContent)

    # Specify how to retrieve the contents
    FetchContent_Declare(
            RemoteInclude
            GIT_REPOSITORY https://github.com/egasato/RemoteInclude.git
            GIT_TAG        develop
    )

    # Get the properties of the project
    FetchContent_GetProperties(RemoteInclude)

    # Download the contents if not done before
    if (NOT RemoteInclude_POPULATED)
        message(STATUS "Downloading \"RemoteInclude\" contents...")
        FetchContent_Populate(RemoteInclude)
        set(RemoteInclude_POPULATED  "${remoteinclude_POPULATED}")
        set(RemoteInclude_SOURCE_DIR "${remoteinclude_SOURCE_DIR}")
        set(RemoteInclude_BINARY_DIR "${remoteinclude_BINARY_DIR}")
    endif ()

    # Add the project
    add_subdirectory(${RemoteInclude_SOURCE_DIR} ${RemoteInclude_BINARY_DIR})

    # Search the package again
    set(RemoteInclude_DIR "${RemoteInclude_BINARY_DIR}")
    find_package(RemoteInclude QUIET NO_MODULE REQUIRED)

    # Log the result
    if (RemoteInclude_FOUND)
        message(STATUS "Project \"RemoteInclude\" was found!")
    else ()
        message(FATAL_ERROR "Project \"RemoteInclude\" was NOT found!")
        return()
    endif ()

endif ()
```

You can view the whole `CMakeLists.txt` file at [RemoteInclude-Test](https://github.com/egasato/RemoteInclude-Test).
