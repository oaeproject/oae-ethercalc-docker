# Ethercalc docker image

Fork repo of ethercalc for OAE.

## Usage

### Run from dockerhub

```
docker run -it --name=ethercalc --net=host oaeproject/oae-ethercalc-docker
```

### Build the image locally

```
# Step 1: Build the image
docker build -f Dockerfile -t oae-ethercalc:latest .
# Step 2: Run the container
docker run -it --name=ethercalc --net=host oae-ethercalc:latest
```
