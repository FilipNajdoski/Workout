namespace backend.Core.Entities
{
    public class Users
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public string Role { get; set; }
        public virtual UserPreferences? UserPreferences { get; set; }
    }
}
