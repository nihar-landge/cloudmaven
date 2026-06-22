---
title: "Monitoring Linux Systems: From Raw Commands to Production Tools"
date: <2026-03-31>
tags: [devops, linux, monitoring, prometheus, grafana, sysadmin, open-source, sre]
description: "Before you install Prometheus, know what it's actually measuring. A practical guide to Linux monitoring — from raw terminal commands to open source and paid tools."
---

# Monitoring Linux Systems: From Raw Commands to Production Tools

You get paged at 2am. Your app is down. What do you actually do?

If your answer is *"open Grafana"* — great. But what if Grafana is also down? What if you're SSH'd into a bare VM with nothing installed? What if the monitoring stack itself is the problem?

That's when you fall back to the terminal. And if you've never done it by hand, you're flying blind.

This post covers the full monitoring spectrum — **manual Linux commands**, **open source tools**, and **paid platforms** — so you understand not just *how* to use these tools, but *what they're actually measuring* underneath.

---

## The Three Pillars of Monitoring

Before diving in, a quick mental model. Modern observability is built on three things:

| Pillar | What it captures | Example |
|--------|-----------------|---------|
| **Metrics** | Numeric time-series data | CPU %, request rate, memory usage i.e resources uses|
| **Logs** | Text events from services | Error messages, access logs, crash dumps |
| **Traces** | A request's journey across services | Distributed tracing in microservices |

Most teams start with metrics, add logs, and reach for traces only when they scale. All three matter — but the commands below are what power everything at layer zero.

---

## Part 1 — Manual Monitoring with Linux Commands

> Zero tools. Zero agents. Just the OS telling you what's happening.

This is the foundation. Every monitoring tool — Prometheus, Datadog, Netdata — is ultimately reading the same kernel data these commands expose. Knowing this layer makes you a better engineer, not just a better tool user.

---

### CPU

```bash
# Live process and CPU overview — the classic
top

# Better interactive version with color (install if not present)
htop

# Per-core utilization every 1 second
mpstat -P ALL 1

# CPU, memory, and I/O snapshot — 5 samples, 1s apart
vmstat 1 5

# Historical + live CPU usage (needs sysstat package)
sar -u 1 5

# Load averages — 1, 5, and 15 minute windows
uptime

# CPU architecture, cores, threads
lscpu
```

**What to look for:** Load average above your core count means the system is saturated. `top` sorts by CPU by default — the process at the top is your first suspect.

---

### Memory

```bash
# RAM and swap — human readable
free -h

# Detailed memory breakdown straight from the kernel
cat /proc/meminfo

# Memory stats summary
vmstat -s

# Per-process memory sorted by usage (needs smem)
smem -r
```

**What to look for:** High swap usage with low available RAM is a red flag — you're paging to disk, which kills performance. `free -h` gives you the one-line answer instantly.

---

### Disk I/O & Storage

```bash
# Disk space per mounted filesystem
df -h

# Directory sizes — useful when logs have eaten your disk
du -sh /var/log/*

# Per-device I/O stats (needs sysstat)
iostat -xz 1

# Live per-process disk I/O (needs iotop, run as root)
iotop

# Block device tree
lsblk

# Partition table
fdisk -l
```

**What to look for:** `df -h` showing `/` at 95%+ is an emergency. `iostat` shows you `%util` — if a disk is at 100% utilization, it's your bottleneck.

---

### Network

```bash
# NIC-level RX/TX bytes, errors, drops
ip -s link

# Open ports and which process owns them
ss -tulnp

# Protocol-level stats (TCP retransmits, UDP errors)
netstat -s

# Live bandwidth per connection (needs iftop)
iftop

# In/out gauge per interface (needs nload)
nload

# Packet capture on an interface
tcpdump -i eth0

# Connectivity and latency
ping <host>
traceroute <host>
mtr <host>           # Best of both — live traceroute

# Measure HTTP response time for an endpoint
curl -o /dev/null -w "%{time_total}\n" -s <url>
```

**What to look for:** Dropped packets in `ip -s link` suggest NIC or switch issues. `ss -tulnp` is your go-to to confirm a service is actually listening on the port you expect.

---

### Processes

```bash
# All running processes with CPU and memory
ps aux

# Sort by CPU hogs
ps aux --sort=-%cpu

# Sort by memory hogs
ps aux --sort=-%mem

# Find a process by name
pgrep -l nginx

# Kill by PID or name
kill <pid>
pkill nginx

# Trace system calls of a running process (powerful for debugging)
strace -p <pid>

# List open files and connections by process
lsof -p <pid>
```

**What to look for:** `ps aux --sort=-%cpu | head -10` gives you the top 10 CPU consumers instantly. `strace` is surgical — use it when a process is stuck and you don't know why.

---

### Logs

```bash
# Follow system log live
tail -f /var/log/syslog

# Follow a specific service's logs (systemd)
journalctl -u nginx -f

# Logs from the last 1 hour
journalctl --since "1 hour ago"

# Filter errors from any log file
grep -i "error" /var/log/syslog

# Kernel ring buffer — hardware, drivers, OOM killer
dmesg | tail -50
```

**What to look for:** `dmesg | grep -i "oom"` will tell you if the OOM killer has been murdering your processes — a common cause of mysterious app restarts.

---

### System Health Snapshot

```bash
# Kernel version and OS info
uname -a

# All IP addresses on this machine
hostname -I

# Distro details
cat /etc/os-release

# Status of a specific service
systemctl status <service-name>

# NTP / time sync status (clock drift breaks SSL and logs)
timedatectl

# Who is currently logged in
who
w

# Login history
last
```

---

### Quick Health Check Script

Save this as `health-check.sh` — run it whenever you SSH into an unknown machine:

```bash
#!/bin/bash
echo "=== System Info ===" && uname -a
echo ""
echo "=== CPU Load ===" && uptime
echo ""
echo "=== Memory ===" && free -h
echo ""
echo "=== Disk ===" && df -h
echo ""
echo "=== Top 5 CPU Processes ===" && ps aux --sort=-%cpu | head -6
echo ""
echo "=== Top 5 MEM Processes ===" && ps aux --sort=-%mem | head -6
echo ""
echo "=== Open Ports ===" && ss -tulnp
```

Run with: `bash health-check.sh`

> 💡 Put this in your GitHub dotfiles repo so it's always one `curl | bash` away on any new machine.

---

## Part 2 — Open Source Tools

Manual commands are great for a quick look. But you can't watch a terminal 24/7, can't correlate data across 10 servers, and can't get paged when something breaks. That's what tools are for.

---

### Prometheus

> &lt; Collects metrics from your servers/containers and fires alerts automatically &gt;

Pulls data from all your services every few seconds → stores it → fires alerts when something is wrong.

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [prometheus/prometheus](https://github.com/prometheus/prometheus) |
| **Official Docs** | [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/) |


**Quick install**

```bash
# Create a persistent volume and launch the Prometheus container via Docker
docker volume create prometheus-data
docker run -p 9090:9090 \
  -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus prom/prometheus
```

---

### Grafana

> &lt; Turns raw data into beautiful visual dashboards and charts &gt;

Connects to Prometheus (or any database) → queries it → shows charts in a web UI

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [grafana/grafana](https://github.com/grafana/grafana) |
| **Official Docs** | [Grafana Documentation](https://grafana.com/docs/grafana/latest/introduction/) |


**Quick install**

```bash
sudo apt-get install -y apt-transport-https wget gnupg
sudo apt-get update
sudo apt-get install grafana
```

---

### Grafana Loki

> &lt; Stores and searches your app logs cheaply (like Prometheus but for logs) &gt;

Agent collects logs → compresses them → stores on S3/GCS → you search them with LogQL

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [grafana/loki](https://github.com/grafana/loki) |
| **Official Docs** | [Grafana Loki Documentation](https://grafana.com/docs/loki/latest/) |


**Quick install**

```bash
wget https://raw.githubusercontent.com/grafana/loki/v3.7.0/cmd/loki/loki-local-config.yaml -O loki-config.yaml
docker run --name loki -d \
  -v $(pwd):/mnt/config \
  -p 3100:3100 grafana/loki:3.7.0 \
  -config.file=/mnt/config/loki-config.yaml
```

---

### Netdata

> &lt; Real-time server monitoring with zero setup — just install and go &gt;

Agent runs on your server → auto-discovers everything (Nginx, MySQL, Docker) → shows live dashboard instantly

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [netdata/netdata](https://github.com/netdata/netdata) |
| **Official Docs** | [Netdata Documentation](https://learn.netdata.cloud/docs/) |


**Quick install**

```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh
sh /tmp/netdata-kickstart.sh
```

---

### Zabbix

> &lt;  All-in-one monitoring for servers, networks, switches, and legacy hardware &gt;

Central server polls agents on your machines (or uses SNMP for routers) → stores in MySQL → shows in web UI

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [zabbix/zabbix](https://github.com/zabbix/zabbix) |
| **Official Docs** | [Zabbix Documentation](https://www.zabbix.com/documentation/current/en/manual

) |


**Quick install**

```bash
docker run --name zabbix-server-mysql -t \
  -e DB_SERVER_HOST="mysql-server" \
  -e MYSQL_DATABASE="zabbix" \
  -e MYSQL_USER="zabbix" \
  -e MYSQL_PASSWORD="zabbix_pwd" \
  -p 10051:10051 \
  -d zabbix/zabbix-server-mysql:alpine-7.4-latest
```

---

### OpenTelemetry Collector

> &lt;  Routes your metrics/logs/traces to any backend tool without vendor lock-in &gt;

Receives data from your app → processes/filters it → sends to Prometheus, Datadog, or any other tool

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **GitHub** | [open-telemetry/opentelemetry-collector](https://github.com/open-telemetry/opentelemetry-collector) |
| **Official Docs** | [Opentelemetry Documentation](https://opentelemetry.io/docs/collector/) |


**Quick install**

```bash
docker run -p 4317:4317 -p 4318:4318 \
  -v $(pwd)/config.yaml:/etc/otelcol/config.yaml \
  otel/opentelemetry-collector:0.148.0
```

---

## Part 3 — Paid Tools

Open source tools are powerful, but they come with an ops burden — you host them, you maintain them, you scale them. Paid tools trade money for that time. Here's what the landscape looks like.

---

### Datadog

> &lt;  All-in-one SaaS monitoring — metrics, logs, traces, dashboards, AI alerts &gt;

Install one agent on your server → it sends everything to Datadog cloud → you view it in their polished UI

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [Datadog Documentation](https://docs.datadoghq.com/getting_started/agent/#installation) |
| **Pricing** | Starts at $15/host/month, free tier for 5 hosts |

---

### New Relic

> &lt;  Full observability SaaS with the best free tier — 100 GB/month free &gt;

 all data goes to New Relic's data lake → query everything with NRQL (SQL-like language)

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [New Relic Documentation](https://docs.newrelic.com) |
| **Pricing** | Free (100 GB/mo), paid from $0.30/GB after that |

---

### Dynatrace

> &lt; Enterprise-grade AI monitoring that automatically finds the root cause of problems &gt;

Install OneAgent once → it auto-discovers all processes, maps all dependencies, and AI (Davis) tells you exactly what broke and why

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [Dynatrace Documentation](https://docs.dynatrace.com/docs/license/cost-overview) |
| **Pricing** | $0.04/host-hour, no free tier (15-day trial only) |

---

### Grafana Cloud

> &lt; Managed version of Prometheus + Grafana + Loki — no self-hosting needed &gt;

Same as Prometheus/Grafana/Loki but Grafana hosts and manages everything for you

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [Grafana Cloud Documentation](https://grafana.com/docs/grafana-cloud/) |
| **Pricing** | Free (10k metrics, 50GB logs), paid from $19/month |

---

### AWS CloudWatch

> &lt; Native monitoring for anything running inside AWS (EC2, RDS, Lambda, S3) &gt;

Zero setup — AWS automatically starts collecting metrics the moment you create a resource

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [AWS CloudWatch Cloud Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) |
| **Pricing** | Pay-per-use, free tier: 10 metrics + 5GB log |
---

### Azure Monitor

> &lt; Native monitoring for anything running in Microsoft Azure &gt;

Zero setup — AWS automatically starts collecting metrics the moment you create a resource

**At a glance**

| | |
|---|---|
| **Type** | &lt;Metrics / Logs / Traces / All-in-one&gt; |
| **Official Docs** | [Azure Monitor Cloud Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/overview) |
| **GitHub** | [microsoft/AzureMonitorCommunity](https://github.com/microsoft/AzureMonitorCommunity) |
| **Pricing** | Pay-per-GB ingested, limited free tier available |
---

