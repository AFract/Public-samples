This folder contains three projects : 
- One Aspire Host program that starts Aspire orchestration with a PostgreSQL container
- One console project that connects to the PostgreSQL instance, creates the DB schema, and fills the DB with random data
- One Web API project that connects to the PostgreSQL instance and display the data through an API controller, and exposes an OpenAPI json definition + Scalar UI to access controllers

If Console and/or Web API project is/are started directly, the PostgreSQL server must have been started manually before, for example with :
`podman run --name postgres -e POSTGRES_USER=username -e POSTGRES_PASSWORD=password -p 5432:5432 -v /var/lib/data -d postgres`
Or start the Aspire host that will run the PostgreSQL server (podman must be installed and machine running)