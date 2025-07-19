using Autofac;
using Autofac.Extensions.DependencyInjection;

namespace AFract.Samples.ScopedLogging.Service;

public static class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Test");
        var host = Host.CreateDefaultBuilder(args)
            .ConfigureAppConfiguration(conf =>
            {
                // Required to have appsettings properly loaded when the app is ran as a windows service, otherwise it will look for it in a wrong folder, like C:\Windows\System.
                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
            })
            .UseServiceProviderFactory(new AutofacServiceProviderFactory(builder =>
            {
                // Register types
                builder.RegisterModule<CommonDependenciesModule>();
            }))
            .ConfigureServices(services =>
            {
                services.AddHostedService<SynchronizationJobWorker>();
            })
            .UseWindowsService(s =>
            {
                s.ServiceName = "AFract Samples scoped logging service";
            })
            .Build();

        host.Run();
    }
}