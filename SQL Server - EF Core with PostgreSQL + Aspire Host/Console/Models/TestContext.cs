using Microsoft.EntityFrameworkCore;

namespace EFCoreWithPostgreSQL.Console.Models;

public partial class TestContext : DbContext
{
    public TestContext()
    {
    }

    public TestContext(DbContextOptions<TestContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Employee> Employees { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.EmployeeId).HasName("PK_Employee");

            entity
                .ToTable("Employee");

            entity.Property(e => e.EmployeeId)
                .ValueGeneratedNever()
                .HasColumnName("EmployeeID");
            entity.Property(e => e.Address)
                .IsRequired()
                .HasMaxLength(1024);
            entity.Property(e => e.AnnualSalary).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Department)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Position)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false);
        });
    }
}