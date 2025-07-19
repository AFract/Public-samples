using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace JwtTokenGenAndValidate.Controllers;

[ApiController]
[Route("[controller]")]
public class BearerGenController : ControllerBase
{
    [HttpGet]
    public string GenerateJwtToken()
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(BearerConsts.Key));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: BearerConsts.Issuer,
            audience: BearerConsts.Audience,
            claims: new[] {
                new Claim(JwtRegisteredClaimNames.Sub, "user_id"),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            },
            expires: DateTime.Now.AddMinutes(30),
            signingCredentials: credentials
        );

        var strBearerToken = new JwtSecurityTokenHandler().WriteToken(token);

        return "Bearer " + strBearerToken;
    }

}