#!/bin/bash

(Xvfb ${DISPLAY} -screen 0 1920x1080x8 -nolisten tcp 0>/dev/null 2>&1 &)
"$@"
