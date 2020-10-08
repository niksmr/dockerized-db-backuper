<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        //
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        $schedule->command('backup:clean')
            ->cron(config('backup.settings.cleanup_schedule', '0 1 * * *'))
            ->sendOutputTo('/proc/1/fd/1'); // Docker (pid 1) stdout

        $schedule->command('backup:run')
            ->cron(config('backup.settings.backup_schedule', '0 * * * *'))
            ->sendOutputTo('/proc/1/fd/1'); // Docker (pid 1) stdout
    }

    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
