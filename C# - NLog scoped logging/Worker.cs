using MediatR;

namespace AFract.Samples.ScopedLogging.Service;

public class SynchronizationJobWorker : BackgroundService
{
    private readonly ILogger<SynchronizationJobWorker> _logger;
    private readonly IHostApplicationLifetime _hostApplicationLifetime;
    private readonly IMediator _mediator;

    private const int DefaultWaitTime = 60;
    private const int OneSecondInMs = 1000;

    public SynchronizationJobWorker(ILogger<SynchronizationJobWorker> logger,
        IHostApplicationLifetime hostApplicationLifetime, 
        IMediator mediator)
    {
        _logger = logger;
        _hostApplicationLifetime = hostApplicationLifetime;
        _mediator = mediator;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var runPendingTasks = new RunPendingTasksCommand();
                await _mediator.Send(runPendingTasks, stoppingToken);

                await WaitOrExit();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during RunPendingTasksCommand");
            }
        }
    }

    private async Task WaitOrExit()
    {
        if (/*_configuration.Value.ExecuteOnceAndExit*/ false)
        {
            _logger.LogInformation("ExecuteOnceAndExit is true : exiting.");
            _hostApplicationLifetime.StopApplication();
        }

        var waitTime = (int?)10; //_configuration.Value.WaitTimeInSeconds;

        if (waitTime is 0 or null)
        {
            _logger.LogInformation("Wait time not configured, using 60s by default.");
            waitTime = DefaultWaitTime;
        }

        await Task.Delay(waitTime.Value * OneSecondInMs);
    }

    /// <inheritdoc />
    public override Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Start event received");
        return base.StartAsync(cancellationToken);
    }

    /// <inheritdoc />
    public override Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Stop event received");
        return base.StopAsync(cancellationToken);
    }
}