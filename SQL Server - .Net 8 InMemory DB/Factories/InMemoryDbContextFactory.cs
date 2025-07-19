using Microsoft.EntityFrameworkCore;
using SQL_Server_In_Memory_DB.Models;

namespace SQL_Server_In_Memory_DB.Factories;

public class InMemoryDbContextFactory : IDbContextFactory<TestContext>
{
    private readonly string _databaseName;

    public InMemoryDbContextFactory(string databaseName = "TestDatabase")
    {
        _databaseName = databaseName;
    }

    public TestContext CreateDbContext()
    {
        var options = new DbContextOptionsBuilder<TestContext>()
            .UseInMemoryDatabase(databaseName: _databaseName)
            .Options;

        return new TestContext(options);
    }
}