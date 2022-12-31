### Podman

Building image:
```sh
podman build -t calibre .
```

Running:
```sh
podman run --rm \
    -e CALIBRE_USER=<user> \
    -e CALIBRE_PASS=<password> \
    -p 8787:8080 \
    -v <path-to-library>:/opt/calibre/library \
    calibre
```

After that server should be available at http://localhost:8787/

### UFW
```sh
sudo ufw allow 8787 comment "Calibre Server"
```

### Systemd

Modify `calibre-server.service` and put it at `~/.config/systemd/user/` directory.

Reload the daemon:
```sh
systemctl --user daemon-reload
```

Run service:
```sh
systemctl --user start calibre-server.service
```

Enable service:
```sh
systemctl --user enable calibre-server.service
```