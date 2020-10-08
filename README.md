## About

Database backup docker image. Based on [Laravel](https://laravel.com/) with [Laravel backup](https://github.com/spatie/laravel-backup) package.

#### How
Simply dump [any](https://spatie.be/docs/laravel-backup/v6/requirements) (supported by [Laravel backup](https://github.com/spatie/laravel-backup)) database on a schedule and store dump on any (supported by [Laravel](https://laravel.com/)) [disk](https://laravel.com/docs/8.x/filesystem). Everything is customizable via env variables.


#### Envs list
Currently this image use just few env variables for itself. Everything else is customizable via [Laravel](https://laravel.com/) and [Laravel backup](https://github.com/spatie/laravel-backup) env variables.

Variable name | Default value | Comment
--- | --- | ---
BACKUP_SCHEDULE | 0 * * * * | Every hour by default
CLEANUP_SCHEDULE | 0 1 * * * | Every day by default
FILENAME_PREFIX |  | Dump filename prefix
BACKUP_DISK | local | Backup disk; could be comma separated string in case you want to use multiple disks