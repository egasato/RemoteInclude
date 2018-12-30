#!/usr/bin/env bash

#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

# Load the properties of the project
source ./project.properties.sh

# Create all the directories that are mounted inside the container
mkdir -p .abuild scripts build/{Debug,Release,RelWithDebInfo,MinSizeRel}/xz/{src/$_PROJECT_NAME,build,pkg/$_PROJECT_NAME} 2> /dev/null

# Fix all the line endings of the scripts
dos2unix *.sh scripts/*.sh scripts/*.gawk PKGBUILD

# Compute the name of the image
__img=$(echo -n "$_PROJECT_NAME" | tr 'A-Z' 'a-z' | tr -s ' ' | tr ' ' '-')

# Create the Docker image
if [[ -z ${TESTING+x} ]]; then
    docker build                                                \
        --build-arg AUTHOR_USER="$_AUTHOR_USER"                 \
        --build-arg AUTHOR_NAME="$_AUTHOR_NAME"                 \
        --build-arg AUTHOR_NAME_ASCII="$_AUTHOR_NAME_ASCII"     \
        --build-arg AUTHOR_EMAIL="$_AUTHOR_EMAIL"               \
        --build-arg PROJECT_NAME="$_PROJECT_NAME"               \
        --build-arg PROJECT_DESCRIPTION="$_PROJECT_DESCRIPTION" \
        --build-arg PROJECT_VERSION="$_PROJECT_VERSION"         \
        --build-arg PROJECT_SHA512="$_PROJECT_SHA512"           \
        \
        --build-arg AUTHOR_CONTACT="$_AUTHOR_CONTACT"             \
        --build-arg AUTHOR_CONTACT_ASCII="$_AUTHOR_CONTACT_ASCII" \
        --build-arg PROJECT_VENDOR="$_PROJECT_VENDOR"             \
        --build-arg PROJECT_VENDOR_ASCII="$_PROJECT_VENDOR_ASCII" \
        --build-arg PROJECT_HOMEPAGE="$_PROJECT_HOMEPAGE"         \
        --build-arg PROJECT_URL="$_PROJECT_URL"                   \
        --build-arg PROJECT_SOURCE="$_PROJECT_SOURCE"             \
        \
        --build-arg LABEL_BUILD_DATE="$_LABEL_BUILD_DATE"   \
        --build-arg LABEL_NAME="$_LABEL_NAME"               \
        --build-arg LABEL_DESCRIPTION="$_LABEL_DESCRIPTION" \
        --build-arg LABEL_USAGE="$_LABEL_USAGE"             \
        --build-arg LABEL_URL="$_LABEL_URL"                 \
        --build-arg LABEL_VCS_URL="$_LABEL_VCS_URL"         \
        --build-arg LABEL_VCS_REF="$_LABEL_VCS_REF"         \
        --build-arg LABEL_VENDOR="$_LABEL_VENDOR"           \
        --build-arg LABEL_VERSION="$_LABEL_VERSION"         \
        \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        \
        -t "$__img-xz"   \
        -f Dockerfile.xz \
        .
else
    docker build -t remoteinclude-xz -f Dockerfile.xz .
fi

# Run the container
echo
if [[ "$OSTYPE" == "cygwin" ]]; then
    winpty docker run                                                                                                                     \
        --rm                                                                                                                              \
        --privileged=true --cap-add=SYS_ADMIN                                                                                             \
        --interactive --tty                                                                                                               \
        --mount type=bind,src="$(cygpath -w "$(pwd)/build/Debug")",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/build/Debug"                   \
        --mount type=bind,src="$(cygpath -w "$(pwd)/build/Release")",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/build/Release"               \
        --mount type=bind,src="$(cygpath -w "$(pwd)/build/RelWithDebInfo")",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/build/RelWithDebInfo" \
        --mount type=bind,src="$(cygpath -w "$(pwd)/build/MinSizeRel")",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/build/MinSizeRel"         \
        "$__img-xz" "$@"
else
    docker run                                                                                                      \
        --rm                                                                                                        \
        --privileged=true --cap-add=SYS_ADMIN                                                                       \
        --interactive --tty                                                                                         \
        --mount type=bind,src="$(pwd)/build/Debug",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/Debug"                   \
        --mount type=bind,src="$(pwd)/build/Release",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/Release"               \
        --mount type=bind,src="$(pwd)/build/RelWithDebInfo",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/RelWithDebInfo" \
        --mount type=bind,src="$(pwd)/build/MinSizeRel",dst="/home/$_AUTHOR_USER/$_PROJECT_NAME/MinSizeRel"         \
        "$__img-xz" "$@"
fi
