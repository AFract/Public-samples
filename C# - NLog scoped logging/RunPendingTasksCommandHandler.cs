using MediatR;

namespace AFract.Samples.ScopedLogging.Service;

// ReSharper disable once UnusedType.Global
public class RunPendingTasksCommandHandler : IRequestHandler<RunPendingTasksCommand, RunPendingTasksCommandResult>
{
    private readonly IMediator _mediator;
    private readonly ILogger<RunPendingTasksCommandHandler> _logger;

    public RunPendingTasksCommandHandler(
        IMediator mediator,
        ILogger<RunPendingTasksCommandHandler> logger
    )
    {
        _mediator = mediator;
        _logger = logger;
    }

    public async Task<RunPendingTasksCommandResult> Handle(RunPendingTasksCommand request, CancellationToken cancellationToken)
    {

        if (false /* nProgress.Any() */)
        {
            _logger.LogWarning("There's one or more operation in execution, exiting. Running operations : " /*+
                String.Join(", ", inProgress.Select(o => o.Id))*/);

            return new RunPendingTasksCommandResult();
        }


        _logger.LogInformation("Starting task");

        try
        {
            var startTime = DateTime.Now;
            using (_logger.BeginScope(new KeyValuePair<string, object>[]
               {
                       new("OperationType", "CurrentOperationType"),
                       new("CorrelationGuid", Guid.NewGuid()),
                       new("StartTime", startTime.ToString("yy-MM-dd HHmmss"))
               }))
            {

                _logger.LogInformation("Logging in scope");

                // Run mediator command. It should run within specified scope
            }

            _logger.LogInformation("End of processing task");
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Global error while processing task");
        }

        return new RunPendingTasksCommandResult();
    }
}
