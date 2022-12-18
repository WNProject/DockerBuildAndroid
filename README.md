# Docker Build Android

[![License]](LICENSE)
[![CI][CI Badge]][CI Workflow]

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
docker build . -t build-android --build-arg ANDROID_SDK_PLATFORM_VERSION=31 .
```

Currently only version `31` for the **Android SDK** platform is supported. Note
that `ANDROID_SDK_PLATFORM_VERSION` defaults to `31` if not supplied.

<!-- external links -->
[License]: https://img.shields.io/github/license/WNProject/DockerBuildAndroid?label=License
[CI Badge]: https://github.com/WNProject/DockerBuildAndroid/actions/workflows/ci.yml/badge.svg?branch=main
[CI Workflow]: https://github.com/WNProject/DockerBuildAndroid/actions/workflows/ci.yml?query=branch%3Amain
