using Projects;

var builder = DistributedApplication.CreateBuilder(args);

// Note : these parameters are read in appsettings.json of current program
var user = builder.AddParameter("postgresUsername", false);
var password = builder.AddParameter("postgresPassword", true);
var postgres = builder.AddPostgres("postgres")
    .WithHostPort(5432)
    .WithUserName(user)
    .WithPassword(password)
    .WithDataVolume("pgdata") // Use Podman volume. Alternately, it could be :     //.WithDataBindMount(source: "./pgdata") // Host-side folder for data persistence
    .WithLifetime(ContainerLifetime.Persistent);

var postgresdb = postgres.AddDatabase("Test");

var consoleApp = builder.AddProject<EFCoreWithPostgreSQL_Console>("PostgreConsole")
    .WithReference(postgresdb)
    .WaitFor(postgres);

builder.AddProject<EFCoreWithPostgreSQL_WebAPI>("PostgreWebAPI")
    .WithReference(postgresdb)
    .WithOtlpExporter()
    .WaitFor(postgres)
    .WaitFor(consoleApp);

builder.Build().Run();