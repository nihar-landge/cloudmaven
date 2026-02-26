# Day 2 - Linux: SSH, Package Management, Cron & systemd

**Environment:** Mac + Multipass Ubuntu VM

---

## 1. SSH Hardening

- Generated SSH key pair on Mac
- Injected public key into VM
- Disabled password login & root login
- Changed SSH port 22 → 2222
- Fixed systemd socket override issue


![SSH hardening config settings](screenshots/SSH_config_settings.png)


![SSH listening on port 2222](screenshots/SSH_listening_on_port_2222.png)


![Public key in authorized_keys](screenshots/Public_key_in_authorized_keys.png)

---

## 2. Package Management

- Updated package list with `apt update`
- Installed nginx, verified status, removed it
- Listed packages with `dpkg -l`


![nginx installation output](screenshots/nginx_installed.png)


![nginx active & running](screenshots/nginx_running_status.png)
![nginx removed cleanly](screenshots/nginx_removed_with_purge.png)

---

## 3. Cron Job Scheduling

- Cron job runs every 5 minutes → writes to test.log
- Daily job at 1 AM → archives logs with tar


![Both cron jobs active](screenshots/crontab_-l_showing_both_jobs.png)
![Proof cron job executed](screenshots/test.log_showing_output.png)

---

## 4. systemd Service & Timer

- Created `disk_check.sh` script
- Created service + timer unit files
- Timer runs every 5 minutes
- Verified with `systemctl list-timers`


![Proof timer wrote to /tmp/systemd.log](screenshots/systemd.log.png)

---

## 5. Homework - Log Archive

- Created `/var/log/myapp/` with sample log file
- Archived logs using tar with date in filename

```bash
tar -czf /tmp/myapp-$(date +%F).tar.gz /var/log/myapp/*.log
```

