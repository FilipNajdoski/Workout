using Application.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;

        public AuthController(AuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var user = await _authService.AuthenticateAsync(request.Username, request.Password);
            if (user == null)
            {
                return Unauthorized("Invalid username or password.");
            }

            return Ok(user);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            var success = await _authService.RegisterAsync(request.Username, request.Password, request.Role);
            if (!success)
            {
                return BadRequest("Username already exists.");
            }

            return Ok("Registration successful.");
        }
    }

    public class LoginRequest
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }

    public class RegisterRequest
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string Role { get; set; }
    }
}