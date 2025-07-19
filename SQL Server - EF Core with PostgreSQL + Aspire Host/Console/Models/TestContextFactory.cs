using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace EFCoreWithPostgreSQL.Console.Models;

public class TestContextFactory : IDesignTimeDbContextFactory<TestContext>
{
    public TestContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<TestContext>();
        optionsBuilder.UseNpgsql("Host=localhost;Database=Test;Username=username;Password=password");

        return new TestContext(optionsBuilder.Options);
    }
}