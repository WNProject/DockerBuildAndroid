FROM ubuntu:focal-20201008 AS android-sdk

# set input arguments to defaults
ARG ANDROID_SDK_VERSION="6858069"

# download android sdk archive
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && \
    apt-get install -y \
      curl \
      unzip && \
    BASE_URL=https://dl.google.com/android/repository/ && \
    curl \
      -L ${BASE_URL}/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
      -o /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d /tmp && \
    mkdir -p /tmp/android-sdk/cmdline-tools/latest && \
    mv /tmp/cmdline-tools/* /tmp/android-sdk/cmdline-tools/latest

FROM ubuntu:focal-20201008

# set input arguments to defaults
ARG CMAKE_VERSION="3.16.3"
ARG ANDROID_SDK_PLATFORM_VERSION="22"

# set basic environment variables
ENV HOME="/root" \
    TERM="xterm" \
    ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin"

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
      clang-10 \
      ninja-build \
      default-jdk && \
    update-alternatives --install \
      /usr/bin/cc cc /usr/bin/clang-10 100 && \
    update-alternatives --install \
      /usr/bin/c++ c++ /usr/bin/clang++-10 100 && \
    update-alternatives --install \
      /usr/bin/python python /usr/bin/python3 100 && \
    yes | sdkmanager --licenses && \
    sdkmanager \
      "platforms;android-${ANDROID_SDK_PLATFORM_VERSION}" \
      "build-tools;27.0.3" \ 
      platform-tools \
      ndk-bundle && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*

# default command
CMD ["bash"]

# labels
LABEL maintainer WNProject
LABEL org.opencontainers.image.source \
      https://github.com/WNProject/DockerBuildAndroid
