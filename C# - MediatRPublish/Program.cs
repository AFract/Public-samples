using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddMediatR(config =>
{
    config.RegisterServicesFromAssemblyContaining<Program>();
    //builder.Services.AddTransient<INotificationHandler<EntityNotificationTyped<A>>, GenericNotificationHandler>();
    //builder.Services.AddTransient<INotificationHandler<EntityNotificationTyped<B>>, GenericNotificationHandler>();
});

var app = builder.Build();

var publisher = app.Services.GetRequiredService<IPublisher>();

Console.WriteLine("Publishing A");
await publisher.Publish(new EntityNotificationTyped<A>());

Console.WriteLine(Environment.NewLine + "Publishing B");
await publisher.Publish(new EntityNotificationTyped<B>());

Console.WriteLine("End");
