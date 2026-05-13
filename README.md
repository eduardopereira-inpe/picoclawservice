# picoclawservice

This repository contains example `systemd` service files to run **PicoClaw** automatically on Linux startup.

## Service Location

All custom `systemd` services should be placed in:

```bash
/etc/systemd/system/
````

---

# 1. Create the PicoClaw Service

Create the main service file:

```bash
sudo vim /etc/systemd/system/picoclaw.service
```

Example content:

```ini
[Unit]
Description=PicoClaw Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/picoclaw
ExecStart=/opt/picoclaw/picoclaw
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

# 2. Reload systemd

After creating or modifying a service file, reload `systemd`:

```bash
sudo systemctl daemon-reload
```

---

# 3. Enable the Service

Enable the service to start automatically during boot:

```bash
sudo systemctl enable picoclaw
```

---

# 4. Start the Service

Start the service immediately:

```bash
sudo systemctl start picoclaw
```

---

# 5. Check Service Status

Verify that the service is running correctly:

```bash
sudo systemctl status picoclaw
```

---

# 6. View Logs

To inspect runtime logs:

```bash
journalctl -u picoclaw -f
```

---

# Launcher Service Example

If you also use a launcher process, create another service:

```bash
sudo vim /etc/systemd/system/picoclawlauncher.service
```

Example content:

```ini
[Unit]
Description=PicoClaw Launcher Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/picoclaw
ExecStart=/opt/picoclaw/launcher.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Reload `systemd` again:

```bash
sudo systemctl daemon-reload
```

Enable the launcher service:

```bash
sudo systemctl enable picoclawlauncher
```

Start the launcher service:

```bash
sudo systemctl start picoclawlauncher
```

Check launcher status:

```bash
sudo systemctl status picoclawlauncher
```

---

# Useful Commands

Restart a service:

```bash
sudo systemctl restart picoclaw
```

Stop a service:

```bash
sudo systemctl stop picoclaw
```

Disable automatic startup:

```bash
sudo systemctl disable picoclaw
```

---

# Notes

* Replace `/opt/picoclaw` with the actual installation directory.
* Replace `picoclaw` or `launcher.sh` with the correct executable names.
* Avoid running services as `root` in production environments when possible.
* Use `Restart=always` to keep the service alive after crashes or unexpected exits.
