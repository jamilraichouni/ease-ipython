source /usr/share/gdb/auto-load/usr/bin/python3.9-gdb.py
source ~/gdbextension.py
set history save on
set history filename ~/.gdb_history
handle SIG33 noprint pass
set pagination off
