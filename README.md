# Docker Build Android

[![License]](LICENSE)
[![Build][Build Badge]][Build Workflow]

Docker container containing all needed **Android** C/C++ build tools. Each
container will contain only one version of the **Android SDK** but will contain
all additional libraries and build tools needed (**Python 3**, **Ninja**, etc).

## Usage

There are 2 ways to use this container [Interactive](#interactive) and
[Command](#command) mode.

### Interactive

This will drop you into an interactive `bash` session.

```bash
docker run -it -v /src:/src build-android
```

### Command

This will run the supplied command directly.

```bash
docker run -v /src:/src build-android [command]
```

## Building

```bash
docker build . -t build-android --build-arg ANDROID_SDK_PLATFORM_VERSION=22 .
```

Currently only version `22` for the **Android SDK** platform is supported. Note
that `ANDROID_SDK_PLATFORM_VERSION` defaults to `22` if not supplied.

<!-- external links -->
[License]: https://img.shields.io/github/license/WNProject/DockerBuildAndroid?label=License
[Build Badge]: https://github.com/WNProject/DockerBuildAndroid/workflows/Build/badge.svg?branch=main
[Build Workflow]: https://github.com/WNProject/DockerBuildAndroid/actions?query=workflow%3ABuild+branch%3Amain
