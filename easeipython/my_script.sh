#!/bin/bash
APP=org.eclipse.ease.runScript
WORKSPACE=/tmp/workspace
eclipse -consolelog -data $WORKSPACE \
    -application $APP -script "file:/tmp/my_script.py"
