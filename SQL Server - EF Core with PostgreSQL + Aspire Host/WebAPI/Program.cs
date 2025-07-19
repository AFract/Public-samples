using Scalar.AspNetCore;
using System.Net.Mime;
using System.Text;
using EFCoreWithPostgreSQL.WebAPI.Models;

namespace EFCoreWithPostgreSQL.WebAPI;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.

        builder.Services.AddControllers();
        // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
        builder.Services.AddOpenApi();

        builder.Services.AddDbContextFactory<TestContext, TestDbContextFactory>();

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();

            // Map the Scalar UI endpoint
            app.MapScalarApiReference();
        }

        app.UseHttpsRedirection();

        app.UseAuthorization();

        app.MapControllers();

        app.MapGet("", httpContext =>
        {
            httpContext.Response.ContentType = MediaTypeNames.Text.Html;

            var html = "Browse<br/> " +
                       "<br/>- <a href=\"/openapi/v1.json\">OpenAPI</a> " +
                       "<br/>- <a href=\"/scalar\">Scalar</a>" +
                       "<br/>- <a href=\"/Employee\">Employee Controller</a>";
            httpContext.Response.ContentLength = Encoding.UTF8.GetByteCount(html);
            return httpContext.Response.WriteAsync(html);

        });

        app.Run();
    }
}