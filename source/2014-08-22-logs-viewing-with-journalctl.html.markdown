---
title: Logs viewing with journalctl
date: 2014-08-22 06:38 UTC
tags: linux
---

If you can't find syslog in `/var/log/messages` (on Fedora-family dist) or `/var/syslog` (Debian-family),
it is highly likely that your system makes use of systemd's journalctl.

You can install rsyslog, but use it only when monitoring tools you're using rely on old log files hierarchy.

For day-to-day use journalctl is very friendly to use:

1. Tab-completion:

   ~~~
   ~ ❯❯❯ journalctl <TAB>
    -- possible fields --
   CODE_FILE   MESSAGE_ID          USER_UNIT         _COMM            _KERNEL_SUBSYSTEM            _SYSTEMD_CGROUP      _TRANSPORT      __CURSOR
   CODE_FUNC   PRIORITY            _AUDIT_LOGINUID   _EXE             _MACHINE_ID                  _SYSTEMD_OWNER_UID   _UDEV_DEVLINK   __MONOTONIC_TIMESTAMP
   CODE_LINE   SYSLOG_FACILITY     _AUDIT_SESSION    _GID             _PID                         _SYSTEMD_SESSION     _UDEV_DEVNODE   __REALTIME_TIMESTAMP
   ERRNO       SYSLOG_IDENTIFIER   _BOOT_ID          _HOSTNAME        _SELINUX_CONTEXT             _SYSTEMD_UNIT        _UDEV_SYSNAME
   MESSAGE     SYSLOG_PID          _CMDLINE          _KERNEL_DEVICE   _SOURCE_REALTIME_TIMESTAMP   _SYSTEMD_USER_UNIT   _UID  
   ~~~

2. Filter by application using `_COMM`, ex.

   ~~~
   ~ ❯❯❯ journalctl _COMM=anacron
   -- Logs begin at Wed 2014-04-16 09:14:59 CEST, end at Fri 2014-08-22 09:01:09 CEST. --
   Apr 16 09:48:35 localhost.localdomain anacron[1113]: Anacron started on 2014-04-16
   Apr 16 09:48:35 localhost.localdomain anacron[1113]: Will run job `cron.daily' in 49 min.
   Apr 16 09:48:35 localhost.localdomain anacron[1113]: Will run job `cron.weekly' in 69 min.
   Apr 16 09:48:35 localhost.localdomain anacron[1113]: Will run job `cron.monthly' in 89 min.
   Apr 16 09:48:35 localhost.localdomain anacron[1113]: Jobs will be executed sequentially
   Apr 16 10:01:01 localhost.localdomain anacron[13065]: Anacron started on 2014-04-16
   Apr 16 10:01:01 localhost.localdomain anacron[13065]: Will run job `cron.daily' in 5 min.
   Apr 16 10:01:01 localhost.localdomain anacron[13065]: Will run job `cron.weekly' in 25 min.
   Apr 16 10:01:01 localhost.localdomain anacron[13065]: Will run job `cron.monthly' in 45 min.
   Apr 16 10:01:01 localhost.localdomain anacron[13065]: Jobs will be executed sequentially
   Apr 16 10:06:01 localhost.localdomain anacron[13065]: Job `cron.daily' started
   Apr 16 10:08:41 localhost.localdomain anacron[13065]: Job `cron.daily' terminated
   -- Reboot --
   Apr 16 10:22:37 localhost.localdomain anacron[1114]: Anacron started on 2014-04-16
   Apr 16 10:22:37 localhost.localdomain anacron[1114]: Will run job `cron.daily' in 7 min.
   Apr 16 10:22:37 localhost.localdomain anacron[1114]: Will run job `cron.weekly' in 27 min.
   Apr 16 10:22:37 localhost.localdomain anacron[1114]: Will run job `cron.monthly' in 47 min.
   Apr 16 10:22:37 localhost.localdomain anacron[1114]: Jobs will be executed sequentially
   Apr 16 10:29:37 localhost.localdomain anacron[1114]: Job `cron.daily' started
   Apr 16 10:29:38 localhost.localdomain anacron[1114]: Job `cron.daily' terminated (mailing output)
   ...
   ~~~

3. Filter additionally by time range using `--since` and `--until`.\\
   ex. for last two days

   ~~~
   ~ ❯❯❯ journalctl _COMM=anacron --since=-2d
   -- Logs begin at Wed 2014-04-16 09:14:59 CEST, end at Fri 2014-08-22 09:50:05 CEST. --
   Aug 21 09:01:01 localhost.localdomain anacron[4620]: Anacron started on 2014-08-21
   Aug 21 09:01:01 localhost.localdomain anacron[4620]: Will run job `cron.daily' in 15 min.
   Aug 21 09:01:01 localhost.localdomain anacron[4620]: Jobs will be executed sequentially
   Aug 21 09:16:01 localhost.localdomain anacron[4620]: Job `cron.daily' started
   Aug 21 09:18:09 localhost.localdomain anacron[4620]: Job `cron.daily' terminated (mailing output)
   Aug 21 09:18:09 localhost.localdomain anacron[4620]: Normal exit (1 job run)
   -- Reboot --
   Aug 22 08:01:01 localhost.localdomain anacron[2812]: Anacron started on 2014-08-22
   Aug 22 08:01:01 localhost.localdomain anacron[2812]: Will run job `cron.daily' in 29 min.
   Aug 22 08:01:01 localhost.localdomain anacron[2812]: Jobs will be executed sequentially
   Aug 22 08:30:01 localhost.localdomain anacron[2812]: Job `cron.daily' started
   Aug 22 08:32:18 localhost.localdomain anacron[2812]: Job `cron.daily' terminated (mailing output)
   Aug 22 08:32:18 localhost.localdomain anacron[2812]: Normal exit (1 job run)
   ~~~

For more options check `man journalctl`.
