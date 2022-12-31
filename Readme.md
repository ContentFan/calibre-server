Building image:
```sh
podman build -t calibre .
```

Running calibre server:
```sh
podman run --rm \
    -e CALIBRE_USER=<user> \
    -e CALIBRE_PASS=<password> \
    -p 8787:8080 \
    -v <path-to-library>:/opt/calibre/library \
    calibre
```

After that server should be available at http://localhost:8787/
