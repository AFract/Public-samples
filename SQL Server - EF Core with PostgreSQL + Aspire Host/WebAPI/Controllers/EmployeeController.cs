using EFCoreWithPostgreSQL.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace EFCoreWithPostgreSQL.WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class EmployeeController(ILogger<EmployeeController> logger, IDbContextFactory<TestContext> contextFactory)
    : ControllerBase
{
    private readonly ILogger<EmployeeController> _logger = logger;

    // GET: /Employee
    [HttpGet]
    public ActionResult<IEnumerable<Employee>> Get()
    {
        using var context = contextFactory.CreateDbContext();
        return Ok(context.Employees.ToList());
    }

    // GET: /Employee/Cound
    [HttpGet("Count")]
    public ActionResult<IEnumerable<Employee>> GetCount()
    {
        using var context = contextFactory.CreateDbContext();
        return Ok(context.Employees.Count());
    }

    // GET: /Employee/{id}
    [HttpGet("{id}")]
    public ActionResult<Employee> Get(Guid id)
    {
        using var context = contextFactory.CreateDbContext();
        var employee = context.Employees.Find(id);
        if (employee == null)
        {
            return NotFound();
        }

        return Ok(employee);
    }

    // POST: /Employee
    [HttpPost]
    public ActionResult<Employee> Create([FromBody] Employee employee)
    {
        using var context = contextFactory.CreateDbContext();
        context.Employees.Add(employee);
        context.SaveChanges();
        return CreatedAtAction(nameof(Get), new { id = employee.EmployeeId }, employee);
    }

    // PUT: /Employee/{id}
    [HttpPut("{id}")]
    public IActionResult Update(Guid id, [FromBody] Employee updatedEmployee)
    {
        if (id != updatedEmployee.EmployeeId)
        {
            return BadRequest();
        }

        using var context = contextFactory.CreateDbContext();
        var employee = context.Employees.Find(id);
        if (employee == null)
        {
            return NotFound();
        }

        // Update fields
        context.Entry(employee).CurrentValues.SetValues(updatedEmployee);
        context.SaveChanges();
        return NoContent();
    }

    // DELETE: /Employee/{id}
    [HttpDelete("{id}")]
    public IActionResult Delete(Guid id)
    {
        using var context = contextFactory.CreateDbContext();
        var employee = context.Employees.Find(id);
        if (employee == null)
        {
            return NotFound();
        }

        context.Employees.Remove(employee);
        context.SaveChanges();
        return NoContent();
    }
}