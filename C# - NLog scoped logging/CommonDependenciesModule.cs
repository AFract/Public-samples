using Autofac;
using Autofac.Extensions.DependencyInjection;
using MediatR.Extensions.Autofac.DependencyInjection;
using MediatR.Extensions.Autofac.DependencyInjection.Builder;
using NLog.Extensions.Logging;

namespace AFract.Samples.ScopedLogging.Service;

public class CommonDependenciesModule : Module
{
    /// <inheritdoc />
    protected override void Load(ContainerBuilder builder)
    {
        // Logging 
        var services = new ServiceCollection();
        services.AddLogging(c => c.AddNLog());
        builder.Populate(services);

        // MediatR
        var configuration = MediatRConfigurationBuilder
            .Create(typeof(Program).Assembly)
            .WithAllOpenGenericHandlerTypesRegistered()
            .Build();
        builder.RegisterMediatR(configuration);
    }
}