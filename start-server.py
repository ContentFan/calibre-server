import os
import re
from subprocess import run, Popen
from pathlib import Path

# 1. Determine correct paths to libraries
LIBS_ROOT = Path(os.environ["LIBS_ROOT"])
LIBS = []

if (LIBS_ROOT / "metadata.db").is_file():
    LIBS.append(LIBS_ROOT)
else:
    for child in LIBS_ROOT.iterdir():
        if child.is_file():
            continue
        if child.name.startswith("."):
            continue
        if len(list(child.iterdir())) == 0 or (child / "metadata.db").is_file():
            LIBS.append(child)
if len(LIBS) == 0:
    main_lib = LIBS_ROOT / "MainLibrary"
    main_lib.mkdir()
    LIBS.append(main_lib)

# 2. Prepare and execute except script to set username and password
CALIBRE_USER = os.environ["CALIBRE_USER"]
CALIBRE_PASS = os.environ["CALIBRE_PASS"]

with open("adduser.ex", "r") as sources:
    lines = sources.readlines()
with open("adduser.ex", "w") as sources:
    for line in lines:
        line = re.sub(r"^set USER placeholder", f"set USER {CALIBRE_USER}", line)
        line = re.sub(
            r"^set PASSWORD placeholder", f"set PASSWORD {CALIBRE_PASS}", line
        )
        sources.write(line)

result = run(
    [
        "expect",
        "adduser.ex",
    ]
)

result.check_returncode()


# 3. Init db if empty or list content if exists
result = run(["./calibredb", "list", *[f"--with-library={x}" for x in LIBS]])

result.check_returncode()

# 4. Run server
os.execv(
    "./calibre-server",
    [
        "calibre-server",   # https://stackoverflow.com/questions/2904171/first-parameter-of-os-exec
        "--enable-auth",
        "--userdb",
        "users.sqlite",
        "--disable-use-bonjour",
        "--ban-after=5",
        "--ban-for=5",
        *[str(x) for x in LIBS],
    ],
)
