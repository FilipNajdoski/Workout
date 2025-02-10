using backend.Core.Entities;

namespace backend.Core.Interfaces
{
    public interface IUserRepository
    {
        Task<Users> GetUserByUsernameAsync(string username);
        Task<UserPreferences> GetUserPreferencesByUserId(int userId);
        Task AddUserAsync(Users user);
        Task SavePreferencesAsync(UserPreferences preferences);
        Task<Users> GetUserByIdAsync(int userId);
    }
}
