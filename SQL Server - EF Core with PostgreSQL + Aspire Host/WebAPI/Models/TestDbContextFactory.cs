using Microsoft.EntityFrameworkCore;

namespace EFCoreWithPostgreSQL.WebAPI.Models;

public class TestDbContextFactory : IDbContextFactory<TestContext>
{
    /// <inheritdoc />
    public TestContext CreateDbContext()
    {
        var opt = new DbContextOptionsBuilder<TestContext>()
            .UseNpgsql("Host=localhost;Database=Test;Username=username;Password=password")
            .Options;

        var testContext = new TestContext(opt);

        return testContext;
    }
}