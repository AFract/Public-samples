using System.Diagnostics;
using Microsoft.EntityFrameworkCore;
using SQL_Server_In_Memory_DB.Factories;
using SQL_Server_In_Memory_DB.Models;

namespace SQL_Server_In_Memory_DB
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            Console.WriteLine("in-memory database");
            IDbContextFactory<TestContext> factory = new InMemoryDbContextFactory();
            await RunActions(factory);

            Console.WriteLine("SQL Server database");
            factory = new SqlServerDbContextFactory(ConnectionStrings.ConnectionString);
            await RunActions(factory);
        }

        private static async Task RunActions(IDbContextFactory<TestContext> factory)
        {
            // Run migrations only on non-existing DB
            if (factory is SqlServerDbContextFactory)
            {
                using (var context = await factory.CreateDbContextAsync())
                {
                    await context.Database.MigrateAsync();
                }
            }

            // Perform seeding if table is empty
            using (var context = await factory.CreateDbContextAsync())
            {
                await context.Database.EnsureCreatedAsync();

                if (!context.Test1s.Any())
                {
                    context.Test1s.AddRange(
                        new Test1() { Id = 1000000, Value = "Seeding" },
                        new Test1 { Id = 1000001, Value = "Seeding" }
                    );
                    await context.SaveChangesAsync();
                }
            }

            // Cleanup
            using (var context = await factory.CreateDbContextAsync())
            {
                context.Test1s.RemoveRange(context.Test1s.Where(t => t.Id != 1000000 && t.Id != 1000001));
                await context.SaveChangesAsync();
            }

            Stopwatch sw = Stopwatch.StartNew();

            long sum = 0;
            for (int i = 0; i < 10000; i++)
            {
                using (var context = await factory.CreateDbContextAsync())
                {
                    context.Test1s.Add(new Test1() { Id = i, Value = "test" });
                    await context.SaveChangesAsync();

                    //Console.WriteLine(context.Test1s.Count());
                }

                using (var context = await factory.CreateDbContextAsync())
                {
                    sum += await context.Test1s.CountAsync();
                }
            }

            Console.WriteLine("Sum: " + sum);
            Console.WriteLine("Elapsed: " + sw.Elapsed);
        }
    }
    }
