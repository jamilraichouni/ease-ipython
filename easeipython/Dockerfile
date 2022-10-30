ARG BASE_IMAGE
FROM ${BASE_IMAGE}
COPY inject_ipython_kernel.sh /tmp
COPY jupyter_client.sh /tmp
COPY my_script.* /tmp

ENV PY4J_REPOSITORY=https://eclipse.py4j.org/
ENV EASE_REPOSITORY=http://download.eclipse.org/ease/release/latest

# To get install item identifiers from below: Eclipse -> install software
# -> insert & select update site -> disable "group items by category"
# -> click "more" -> Select "General Information"

# Install Py4J
RUN eclipse -nosplash -consolelog \
  -application org.eclipse.equinox.p2.director \
  -repository ${PY4J_REPOSITORY} -installIU org.py4j.feature.feature.group

# Install EASE
# EASE Core Framework (Incubation) - All the core component mandatory for EASE
# EASE Py4J Support (Incubation) - Python (using Py4J) integration into EASE as Python Engine. Needs an external python interpreter for script execution.
# EASE Python Support (Incubation) - EASE component used to handle python language.This feature does not contain any Python Engine.
# EASE Modules (Incubation) - EASE basic modules to interact with Eclipse Workbench
# EASE UI Components (Incubation) - All the EASE component for User Interface integration
RUN eclipse -nosplash -consolelog \
  -application org.eclipse.equinox.p2.director \
  -repository ${EASE_REPOSITORY} -installIU \
  org.eclipse.ease.feature.feature.group,org.eclipse.ease.lang.python.py4j.feature.feature.group,org.eclipse.ease.lang.python.feature.feature.group,org.eclipse.ease.modules.feature.feature.group,org.eclipse.ease.ui.feature.feature.group
