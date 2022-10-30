#!/bin/bash
jupyter console --existing kernel-$(cat /tmp/pid).json
