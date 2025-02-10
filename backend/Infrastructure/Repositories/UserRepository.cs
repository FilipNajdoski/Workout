using backend.Core.Entities;
using backend.Core.Interfaces;
using Infrastructure.Configurations;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDbContext _context;

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Users> GetUserByUsernameAsync(string username)
        {
            return await _context.Users.SingleOrDefaultAsync(u => u.Username == username);
        }

        public async Task AddUserAsync(Users user)
        {
            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();
        }

        public async Task SavePreferencesAsync(UserPreferences preferences)
        {
            var existingUserPreference = await _context.UserPreferences.Where(u => u.UserId == preferences.UserId)
                                           .FirstOrDefaultAsync();

            if (existingUserPreference == null)
            {
                await _context.UserPreferences.AddAsync(preferences);
                
            }
            else
            {
                 _context.UserPreferences.Entry(existingUserPreference).CurrentValues.SetValues(preferences);
            }

            await _context.SaveChangesAsync();
        }
        public async Task<Users> GetUserByIdAsync(int userId)
        {
            var user = await _context.Users
                .Where(u => u.Id == userId)
                .FirstOrDefaultAsync();
            return user;
        }
    }
}
