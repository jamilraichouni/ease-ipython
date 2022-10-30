import os
from pathlib import Path

pid = os.getpid()
print(f"PID: {pid}")
Path("/tmp/pid").write_text(str(pid))
breakpoint()
