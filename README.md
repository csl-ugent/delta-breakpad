# ∆Breakpad

## Setting up Docker
Start by executing the setup.sh script. This will check out the git submodules
of the repository, as well as Breakpad (through the depot_tools). All results
are generated in a Docker environment. This can either be built in the normal
docker fashion:

    # docker build -t dbp .

Or it can be built using Docker Compose:

    # docker-compose build

The second option is mostly for debugging and development purposes, to more
easily configure how and where directories are mounted. Both options require a
SPEC tarball be present at modules/SPEC_CPU2006v1.1.tar.bz2 .

## Generating results
Results are generated inside the docker, at /opt/data. To easily get at these
results, it's best to mount a host a directory at this location. This can happen
through the docker-compose.yml file when using Docker Compose, or on the command
line when doing a normal build:

    # docker run -i -t -v /my/host/dir/results:/opt/data dbp 

Or after having edited docker-compose.yml (by default the data is generated in
a named volume):

    # docker-compose run main

You can also start up the docker with a bash session to manually run the scripts
or do measurements, like so:

    # docker run -i -t -v /my/host/dir/results:/opt/data --entrypoint bash dbp

Or:

    # docker-compose run --entrypoint bash main
