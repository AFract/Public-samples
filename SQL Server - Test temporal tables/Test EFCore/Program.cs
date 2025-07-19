using System.Data.SqlTypes;
using ConsoleApp1.Models;
using Microsoft.EntityFrameworkCore;

namespace TemporalTable;

internal class Program
{
    static async Task Main(string[] args)
    {
        Console.WriteLine("Hello, World!");

        TestContext testContext = new TestContext();
            
        var current = testContext.Employees.ToList(); // Current
        Console.WriteLine("Current {0}", current.Count);

        var all = testContext.Employees.TemporalAll().ToList(); // Current
        Console.WriteLine("All {0}", all.Count);

        var byProcStock = await testContext.Procedures.SpsEmployeeHistoryAsync(SqlDateTime.MinValue.Value, DateTime.MaxValue);
        Console.WriteLine("History by procstock {0}", byProcStock.Count);

        var complex = testContext
            .Employees
            .TemporalAll()
            //.Where(e => e.Name == "Rainbow Dash")
            .OrderBy(e => EF.Property<DateTime>(e, "ValidFrom"))
            .Select(
                e => new
                {
                    Employee = e,
                    ValidFrom = EF.Property<DateTime>(e, "ValidFrom"),
                    ValidTo = EF.Property<DateTime>(e, "ValidTo")
                })
            .ToList();
        Console.WriteLine("Complex {0}", complex.Count);
        foreach (var pointInTime in complex)
        {
            Console.WriteLine(
                $"  Employee {pointInTime.Employee.Name} was '{pointInTime.Employee.Position}' from {pointInTime.ValidFrom} to {pointInTime.ValidTo}");
        }
    }
}