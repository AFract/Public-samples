using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using SQL_Server_In_Memory_DB.Models;

namespace SQL_Server_In_Memory_DB.Factories;

public class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<TestContext>
{
    public TestContext CreateDbContext(string[] args)
    {
        var options = new DbContextOptionsBuilder<TestContext>()
            .UseSqlServer(ConnectionStrings.ConnectionString)
            .Options;

        return new TestContext(options);
    }
}