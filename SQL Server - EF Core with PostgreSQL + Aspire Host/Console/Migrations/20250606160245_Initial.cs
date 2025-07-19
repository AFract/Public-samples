using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EFCoreWithPostgreSQL.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Employee",
                columns: table => new
                {
                    EmployeeID = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Position = table.Column<string>(type: "character varying(100)", unicode: false, maxLength: 100, nullable: false),
                    Department = table.Column<string>(type: "character varying(100)", unicode: false, maxLength: 100, nullable: false),
                    Address = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    AnnualSalary = table.Column<decimal>(type: "numeric(10,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Employee", x => x.EmployeeID);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Employee");
        }
    }
}
