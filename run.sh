DOCKER_IMAGE="deadolus/esp-idf"
DOCKER_ARGS=""
if [ "$NO_TTY" = "" ]; then
DOCKER_ARGS="${DOCKER_ARGS} -t"
fi
if [ "$DOCKERHOSTNAME" != "" ]; then
DOCKER_ARGS="${DOCKER_ARGS} -h $DOCKERHOSTNAME"
fi
if [ "$HOST_USB" != "" ]; then
DOCKER_ARGS="${DOCKER_ARGS} -v /dev/bus/usb:/dev/bus/usb"
fi
if [ "$HOST_NET" != "" ]; then
DOCKER_ARGS="${DOCKER_ARGS} --net=host"
fi
if [ "$HOST_DISPLAY" != "" ]; then
DOCKER_ARGS="${DOCKER_ARGS} --env=DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"

#This will overwrite DOCKERHOSTNAME setting.
DOCKER_ARGS="${DOCKER_ARGS} -h $HOSTNAME"
fi

#Run docker!
docker run -i $DOCKER_ARGS -v `pwd`/projects:/projects --privileged --group-add plugdev $DOCKER_IMAGE $@
