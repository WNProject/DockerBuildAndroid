FROM ubuntu:focal-20240416

# set input arguments to defaults
ARG CMAKE_VERSION="3.16.3"
ARG CLANG_VERSION="10"
ARG ANDROID_SDK_VERSION="6858069"
ARG ANDROID_SDK_PLATFORM_VERSION="31"
ARG ANDROID_SDK_BUILD_TOOLS_VERSION="30.0.3"
ARG NDK_VERSION="23.2.8568313"

# set basic environment variables
ENV HOME="/root" \
    TERM="xterm" \
    ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin"
ENV PATH="${PATH}:${HOME}/.cargo/bin"

# install packages
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
      apt-utils \
      ca-certificates \
      clang-${CLANG_VERSION} \
      cmake=${CMAKE_VERSION}* \
      curl \
      default-jdk \
      git \
      libssl-dev \
      make \
      ninja-build \
      pkg-config \
      python3 \
      unzip && \
    update-alternatives --install \
      /usr/bin/cc cc /usr/bin/clang-${CLANG_VERSION} 100 && \
    update-alternatives --install \
      /usr/bin/c++ c++ /usr/bin/clang++-${CLANG_VERSION} 100 && \
    update-alternatives --install \
      /usr/bin/python python /usr/bin/python3 100 && \
    curl -sSf https://sh.rustup.rs | sh -s -- -y && \
    cargo install sccache --features=gcs && \
    BASE_URL=https://dl.google.com/android/repository/ && \
    curl -sSf \
      -L ${BASE_URL}/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
      -o /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d /tmp && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mv /tmp/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager \
      'platforms;android-22' \
      "platforms;android-${ANDROID_SDK_PLATFORM_VERSION}" \
      "build-tools;${ANDROID_SDK_BUILD_TOOLS_VERSION}" \
      platform-tools \
      "ndk;${NDK_VERSION}" && \
    sdkmanager --uninstall emulator && \
    rm -rf ${ANDROID_SDK_ROOT}/platform-tools-2 && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf \
      ${HOME}/.cargo/registry \
      ${HOME}/.cargo/git \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*

# default command
CMD ["bash"]

# labels
LABEL maintainer WNProject
LABEL org.opencontainers.image.source \
      https://github.com/WNProject/DockerBuildAndroid
