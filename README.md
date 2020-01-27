# Subsonic Docker Configuration

This repoository contains configuration files for building Docker images for [Subsonic](http://www.subsonic.org/), a personal media streaming server. The Docker image that can created with this configuration is light-weight (based on [Alpine Linux](https://alpinelinux.org/)) and contains all necessary tools for running Subsonic including Java ([Open JDK JRE](http://openjdk.java.net/)) and some audio conversion tools ([ffmpeg](https://www.ffmpeg.org/), [LAME](http://lame.sourceforge.net/)).

## Details

The following table provides an overview of the software components used in this Docker image:

| Name | Version | Comments |
| --- | --- | ---
| Alpine Linux | 3.7.x | Linux Kernel 4.9.x |
| OpenJDK JRE | 1.8.0_x | |
| Subsonic | 6.1.6 | Standalone version running on Jetty |
| LAME | 3.100 | |
| ffmpeg | 3.4 | |


## Building the Image

Clone this repository and build the image using the following command:

```
$ docker build -t <your-name>/subsonic subsonic
```

## Downloading the Image

An already built image is hosted on [Dockerhub](https://hub.docker.com/r/gzurowski/subsonic/) and can be downloaded with the following command:

```
$ docker pull gzurowski/subsonic
```

## Running the Image

A Docker container can be launched using the following example command:

```
$ docker run -it --rm \
  --publish 4040:4040
  --volume "<path-to-your-music-files>:/var/music:ro"
  --volume "<path-to-store-config>:/var/subsonic"
  gzurowski/subsonic
```

## Configuration

The following two volumes are defined for persisting data:

| Name | Location |
| --- | --- |
| `/var/subsonic` | All of Subsonics dynamic files including configuration properties and the database. Note: All Subsonic binaries are located in the container image at path `/opt/subsonic`. |
| `/var/music` | Location to your media files / music collection. |
