using MediatR;

namespace AFract.Samples.ScopedLogging.Service;

public class RunPendingTasksCommand : IRequest<RunPendingTasksCommandResult>;