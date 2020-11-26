FROM ubuntu:focal-20201106 AS android-sdk

# set input arguments to defaults
ARG ANDROID_SDK_VERSION="6858069"

# download android sdk archive
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && \
    apt-get install -y \
      curl \
      unzip && \
    BASE_URL=https://dl.google.com/android/repository/ && \
    curl -sSf \
      -L ${BASE_URL}/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
      -o /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d /tmp && \
    mkdir -p /tmp/android-sdk/cmdline-tools/latest && \
    mv /tmp/cmdline-tools/* /tmp/android-sdk/cmdline-tools/latest

FROM ubuntu:focal-20201106

# set input arguments to defaults
ARG CMAKE_VERSION="3.16.3"
ARG CLANG_VERSION="10"
ARG ANDROID_SDK_PLATFORM_VERSION="27"
ARG ANDROID_SDK_BUILD_TOOLS_VERSION="27.0.3"

# set basic environment variables
ENV HOME="/root" \
    TERM="xterm" \
    ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${HOME}/.cargo/bin"

# copy over android sdk files
COPY --from=android-sdk /tmp/android-sdk ${ANDROID_SDK_ROOT}

# install packages
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      apt-utils \
      git \
      python3 \
      cmake=${CMAKE_VERSION}* \
      make \
      clang-${CLANG_VERSION} \
      ninja-build \
      libssl-dev \
      pkg-config \
      curl \
      default-jdk && \
    update-alternatives --install \
      /usr/bin/cc cc /usr/bin/clang-${CLANG_VERSION} 100 && \
    update-alternatives --install \
      /usr/bin/c++ c++ /usr/bin/clang++-${CLANG_VERSION} 100 && \
    update-alternatives --install \
      /usr/bin/python python /usr/bin/python3 100 && \
    curl -sSf https://sh.rustup.rs | sh -s -- -y && \
    cargo install sccache --features=gcs && \
    yes | sdkmanager --licenses && \
    sdkmanager \
      "platforms;android-22" \
      "platforms;android-${ANDROID_SDK_PLATFORM_VERSION}" \
      "build-tools;${ANDROID_SDK_BUILD_TOOLS_VERSION}" \ 
      platform-tools \
      ndk-bundle && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf \
      ${HOME}/.cargo/registry \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*

# default command
CMD ["bash"]

# labels
LABEL maintainer WNProject
LABEL org.opencontainers.image.source \
      https://github.com/WNProject/DockerBuildAndroid
