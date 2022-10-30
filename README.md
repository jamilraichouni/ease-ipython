# Inject IPython kernel in Eclipse EASE run

## Introduction

This is a little example project meant to showcase how one can inject/ embed
an IPython kernel in a halted (breakpoint) Python script that is run in
[Eclipse EASE](https://www.eclipse.org/ease/).

The core trick/ information has been seen in a
[YouTube video](https://www.youtube.com/watch?v=xt9v5t4_zvE) titled
"Extending GDB with Python - Lisa Roach", a record of a talk that was
presented at PyBay2019 - 4th annual Bay Area Regional Python conference.

The aim is to have a fully scoped (EASE context) IPython console at a dedicated
runtime location to ease :-) debugging a Python script that runs in EASE.

So far the author had no success with getting EASE to process any input that
has been sent via the standard input
(see here: [https://github.com/labs4capella/python4capella/issues/155#issuecomment-1291765346](https://github.com/labs4capella/python4capella/issues/155#issuecomment-1291765346))

It feels a bit impossible to directly communicate via the Python process'
standard input when a script is being executed by EASE. Attempts to attach a
Python debugger to a running EASE Python script were also not successful.

This is why the author decided to try to inject an IPython kernel using
[GDB: The GNU Project Debugger](https://www.sourceware.org/gdb/). That is
working and all steps necessary to run the demo will be described in the
following.
To see what is needed within a Debian Linux container you can just refer to the
two `Dockerfile` build scripts, the different `.py` and `.sh` scripts and the
files extending and configuring GDB for our hack.

## Preconditions

This project provides two Docker files and a couple of scripts that are used
in a running container. Hence, you need Docker or any other engine capable of
building and running Docker files.

First step is to clone the project and change into the checkout directory:

```bash
git clone ease-ipython
cd ease-ipython
```

## Build the Docker images

The build and run configuration are given in the file `docker-compose.yml`.
Execute the following two commands to build the base container with a Debian
linux stuffed with a virtual display, Python (incl. debug symbols, ipython.
etc.), a preconfigured GDB and a fresh installation of Eclipse (Modeling
package).

Eclipse will be downloaded from [here](https://www.eclipse.org/downloads/packages). You can also manually download the "Eclipse Modeling Tools" package and
place the downloaded archive as `eclipse.tar.gz` in the subdirectory
`baseeclipse`. The downloaded archive will be used when you set the value for
the build argument `BUILD_TYPE` (see in the `docker-compose.yml`) to `online`.

The second image derives from the base Eclipse image and installs scripts that
run the simple example Python script in an EASE context (see heading
"Run the Docker images" below. The second and final images also adds some
plugins (Py4J and EASE features) to the clean Eclipse Modeling Tool package.

```bash
docker compose build baseeclipse
docker compose build easeipython
```

## Run the Docker images

Open three terminal windows and run the following. Here, it is of help (not
necessary) that you use a terminal emulator that allows to split the window
to be able to see multiple terminal sessions in parallel.

### Terminal window 1:

Start the container in a way that runs the Python script `my_script.py` in
Eclipse using EASE:

```bash
docker compose run --rm -it --name=ease easeipython /tmp/my_script.sh
```

Wait until the output from terminal window 1 shows that Python halted in a
breakpoint - you should see a `(Pdb)` prompt. Note that Java exceptions will
probably be thrown a couple of seconds later. These exceptions can be ignored
as long as the exception at the bottom of the stack trace shows

`java.lang.IllegalStateException: Workbench has not been created yet`.

### Terminal window 2:

In a second terminal session we inject Python code to embed an IPython kernel
into the running Python process.
The GNU Debugger (GDB) is used to do that by attaching to the Python process
that is run in EASE:

```bash
docker exec -it ease /tmp/inject_ipython_kernel.sh
```

Above injects the IPython kernel in the EASE Python process. We get a weird
output sharing different information about threads which can be ignored.
Now we want to connect a Jupyter console client to that IPython kernel.
We do that in a third terminal session:

### Terminal window 3:

```bash
docker exec -it ease /tmp/jupyter_client.sh
```

This gives us an IPython prompt and we can demonstrate that we have access to
the scope within EASE:

```python
In [1]: from eclipse.system.resources import getWorkspace

In [2]: getWorkspace().getLocation().toString()
Out[2]: '/tmp/workspace'

In [3]:
```
