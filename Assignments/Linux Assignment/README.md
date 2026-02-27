# Linux Assignment – Practical Solutions
**Name:** Nihar Landge  
**Date:** 27 Feb 2026  
**Environment:** Ubuntu 24.04.4 LTS (linux-01) on Multipass (Mac)

---

## Q1. Permissions & umask

**Output:**
- `umask` → `0002`
- `ls -l test.txt` → `-rw-rw-r-- 1 ubuntu ubuntu 0 Feb 27 11:42 test.txt`

**Explanation:**  
Default file base permission is `0666`. With `umask 0002`, the result is `0666 - 0002 = 0664` → `rw-rw-r--` (owner and group can read/write, others can only read).

📸 Screenshot: `Screenshot-2026-02-27-at-1.21.46-PM.jpg`

---

## Q2. User Management


**Explanation:**  
Creates user `intern1` with `/bin/bash` as default shell and account expiry set to 7 days from today using `date -d "+7 days"`.

📸 Screenshot: `Screenshot-2026-02-27-at-1.22.44-PM.jpg`

---

## Q3. SSH Keypair & Passwordless Login

**Output:**  
Successfully logged into localhost without a password. SSH connected to Ubuntu 24.04.4 LTS and showed system info (59.4% disk, 23% memory, 104 processes).

**Note:** SSH is running on port `2222` (not default 22) on this VM.

📸 Screenshots:  
- `Screenshot-2026-02-27-at-1.23.47-PM.jpg`  
- `Screenshot-2026-02-27-at-1.25.13-PM.jpg`

---

## Q4. Package Management

**Output:**
- `htop` installed successfully
- `dpkg -S /usr/bin/bash` → `bash: /usr/bin/bash`

**Note:** `/bin/bash` returns no result on Ubuntu 24.04 because `/bin` is a symlink to `/usr/bin`. The correct path is `/usr/bin/bash`.

📸 Screenshot: `Screenshot-2026-02-27-at-1.26.27-PM.jpg`

---

## Q5. Cron Job

**Output from `/tmp/cron_test.log`:**
```
Fri Feb 27 12:33:01 IST 2026
Fri Feb 27 12:34:01 IST 2026
```

📸 Screenshots:  
- `Screenshot-2026-02-27-at-1.28.01-PM.jpg`  
- `Screenshot-2026-02-27-at-1.28.23-PM.jpg`

---

## Q6. Systemd Timer

**Service file `/etc/systemd/system/hello.service`:**
```ini
[Unit]
Description=Hello Systemd Service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo "Hello from systemd" >> /tmp/hello.txt'
```

**Timer file `/etc/systemd/system/hello.timer`:**
```ini
[Unit]
Description=Run hello.service every 2 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=2min
Unit=hello.service

[Install]
WantedBy=timers.target
```

**Commands used:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hello.timer
systemctl list-timers --all | grep hello
cat /tmp/hello.txt
```

**Output:**
- Timer enabled: symlink created at `/etc/systemd/system/timers.target.wants/hello.timer`
- `hello.timer` visible in `systemctl list-timers`
- `/tmp/hello.txt` contains `Hello from systemd`

📸 Screenshots:  
- `Screenshot-2026-02-27-at-1.28.54-PM.jpg`  
- `Screenshot-2026-02-27-at-1.29.33-PM.jpg`  
- `Screenshot-2026-02-27-at-1.31.48-PM.jpg`

---

## Q7. Networking

### a. Ping & Traceroute

**Key output:** Ping to `8.8.8.8` successful, avg RTT ~64ms. Traceroute reached `104.18.27.120` via 7 hops.

### b. Listening TCP Ports & Port 80 Check

**Output:** Port `80` is open and listening (both IPv4 and IPv6). Port `2222` also listening (SSH).

### d. curl headers & DNS lookup

**Output:**
- `HTTP/1.1 200 OK`, Server: cloudflare, Content-Type: text/html
- DNS A records: `104.18.27.120`, `104.18.26.120`

📸 Screenshots:  
- `Screenshot-2026-02-27-at-1.32.15-PM.jpg`  
- `Screenshot-2026-02-27-at-1.32.37-PM.jpg`  
- `Screenshot-2026-02-27-at-1.32.59-PM.jpg`  
- `Screenshot-2026-02-27-at-1.33.25-PM.jpg`

---

## Q8. Monitoring

### a. Disk Usage

**Output:**
- `/dev/sda1` → 3.9G total, 2.3G used, 1.6G available → **60% used**
- `/var/log` → **27M**

### b. Top 3 Processes by Memory


### c. Last 20 Lines of Journal & Syslog

**Output:** Shows cron jobs (`/usr/bin/date >> /tmp/cron_test.log`), `disk_check.service` start/deactivate, and `sysstat-collect.service` activity.

📸 Screenshots:  
- `Screenshot-2026-02-27-at-1.33.46-PM.jpg`  
- `Screenshot-2026-02-27-at-1.34.02-PM.jpg`

---

## Q9. Logs

### a. Last 20 lines of system logs

Shows cron session open/close for user ubuntu, `disk_check.service` started and deactivated.

### b. Apache/Nginx Log Locations
- **Apache:** `/var/log/apache2/access.log` and `/var/log/apache2/error.log`
- **Nginx:** `/var/log/nginx/access.log` and `/var/log/nginx/error.log`

---

## Bonus


### Cron vs Systemd Timers
> **Cron** is simple and file-based with no dependency management; **systemd timers** are more powerful, support service dependencies, log via journald, and handle missed runs (persistent timers).
