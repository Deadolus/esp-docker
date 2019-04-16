ESP docker container
============
Complete ESP32 / ESP8266 environment in a Docker container.

Tested on Linux only.

Building
-------------
Just run "./build.sh", or "docker build -t deadolus/esp-idf ." directly.
You may of course change the name of the container.

Running
-------------
Run

"./run.sh"

run.sh has some options which you can set via Environment variables.

* NO_TTY - Do not run docker with -t flag
* DOCKERHOSTNAME - set Docker Hostname. I use it to run tests headless
* HOST_USB - Use the USB of the Host (useful if you want your physical device to be recognized by adb inside the container)
* HOST_NET - Use the network of the host
* HOST_DISPLAY - Allow the container to use the Display of the host. E.g. Let the emulator run on the Hosts Display environment.

You may use a Variable like this: "HOST_NET=1 ./run.sh"

