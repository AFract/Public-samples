using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using SQL_Server_In_Memory_DB.Models;

namespace SQL_Server_In_Memory_DB.Factories;

public class SqlServerDbContextFactory : IDbContextFactory<TestContext>
{
    private readonly string _connectionString;

    public SqlServerDbContextFactory(string connectionString)
    {
        _connectionString = connectionString;
    }

    public TestContext CreateDbContext()
    {
        var options = new DbContextOptionsBuilder<TestContext>()
            .UseSqlServer(_connectionString)
            .Options;

        return new TestContext(options);
    }
}