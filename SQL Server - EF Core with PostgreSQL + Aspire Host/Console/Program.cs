using System.Diagnostics;
using Bogus;
using EFCoreWithPostgreSQL.Console.Models;
using Microsoft.EntityFrameworkCore;

namespace EFCoreWithPostgreSQL.Console;

internal class Program
{
    static async Task Main(string[] args)
    {
        System.Console.WriteLine("Hello, World!");

        var opt = new DbContextOptionsBuilder<TestContext>()
            .UseNpgsql("Host=localhost;Database=Test;Username=username;Password=password")
            .Options;
        
        var testContext = new TestContext(opt);

        var sw = Stopwatch.StartNew();

        await testContext.Database.MigrateAsync();

        System.Console.WriteLine($"Migration done in {sw.Elapsed}");
        sw.Restart();

        var employeeGenerator = GetEmployeeGenerator();
        var generatedEmployees = employeeGenerator.Generate(1000);

        System.Console.WriteLine($"Random data generated in {sw.Elapsed}");
        sw.Restart();

        testContext.Employees.AddRange(generatedEmployees);
        await testContext.SaveChangesAsync();

        System.Console.WriteLine($"Random data inserted in {sw.Elapsed}");
        sw.Restart();

        testContext = new TestContext(opt);

        var current = testContext.Employees.ToList(); // Current
        System.Console.WriteLine($"{current.Count} records retrieved in {sw.Elapsed}");
    }


    private static Faker<Employee> GetEmployeeGenerator()
    {
        return new Faker<Employee>()
            .RuleFor(e => e.EmployeeId, _ => Guid.NewGuid())
            .RuleFor(e => e.Name, f => f.Name.FullName())
            .RuleFor(e => e.Address, f => f.Address.FullAddress())
            .RuleFor(e => e.Department, (f, e) => f.Company.Bs())
            .RuleFor(e => e.Position, (f, e) => f.Company.CatchPhrase())
            .RuleFor(e => e.AnnualSalary, f => f.Random.Int(18000, 900000));

    }
}