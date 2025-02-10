using backend.Core.Entities;
using backend.Core.Interfaces;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services
{
    public class AuthService
    {
        private readonly IUserRepository _userRepository;

        public AuthService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<Users> AuthenticateAsync(string username, string password)
        {
            var user = await _userRepository.GetUserByUsernameAsync(username);
            if (user == null || !VerifyPassword(password, user.PasswordHash))
            {
                return null; // Authentication failed
            }

            return user; // Authentication successful
        }

        public async Task<bool> RegisterAsync(string username, string password, string role)
        {
            if (await _userRepository.GetUserByUsernameAsync(username) != null)
            {
                return false; // Username already exists
            }

            var hashedPassword = HashPassword(password);
            var user = new Users
            {
                Username = username,
                PasswordHash = hashedPassword,
                Role = role
            };

            await _userRepository.AddUserAsync(user);
            return true;
        }

        public async Task<bool> SavePreferences(int userId, UserPreferences preferences)
        {
            var user = await _userRepository.GetUserByIdAsync(userId);
            if (user == null)
            {
                return false;
            }

            preferences.UserId = userId;
            await _userRepository.SavePreferencesAsync(preferences);
            return true;
        }

        private string HashPassword(string password)
        {
            using var sha256 = SHA256.Create();
            var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(bytes);
        }

        private bool VerifyPassword(string password, string storedHash)
        {
            var hashedPassword = HashPassword(password);
            return hashedPassword == storedHash;
        }
    }
}