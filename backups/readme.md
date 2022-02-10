# docker-volume-backup
Docker image for performing simple backups of Docker volumes. 
## Main features:

- Mount volumes into the container, and they'll get backed up
- Use full cron expressions for scheduling the backups
- Backs up to local disk, AWS S3, or both
- Allows triggering a backup manually if needed
- Optionally stops containers for the duration of the backup, and starts them again afterward, to ensure consistent backups
- Optionally docker execs commands before/after backing up a container, to allow easy integration with database backup tools, for example
- Optionally ships backup metrics to InfluxDB, for monitoring