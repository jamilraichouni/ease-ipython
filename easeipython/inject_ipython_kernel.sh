#!/bin/bash
gdb --pid=$(cat /tmp/pid) --eval-command="py \"import IPython; IPython.embed_kernel()\""
