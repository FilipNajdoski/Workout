using backend.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Configurations
{
    public class AppDbContext : DbContext
    {
        private readonly ILoggerFactory _loggerFactory;
        public AppDbContext(DbContextOptions<AppDbContext> options, ILoggerFactory loggerFactory) : base(options) 
        {
            _loggerFactory = loggerFactory;
        }

        public DbSet<Users> Users { get; set; }
        public DbSet<UserPreferences> UserPreferences { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Define User entity
            modelBuilder.Entity<Users>().HasKey(u => u.Id);
            modelBuilder.Entity<Users>().Property(u => u.Username).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<Users>().Property(u => u.PasswordHash).IsRequired();
            modelBuilder.Entity<Users>().Property(u => u.Role).IsRequired();

            // Define UserPreferences entity
            modelBuilder.Entity<UserPreferences>().HasKey(up => up.UserId);
            modelBuilder.Entity<UserPreferences>().Property(up => up.Name).IsRequired().HasMaxLength(255);
            modelBuilder.Entity<UserPreferences>().Property(up => up.Gender).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<UserPreferences>().Property(up => up.FitnessLevel).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<UserPreferences>().Property(up => up.Goal).IsRequired().HasMaxLength(100);
            modelBuilder.Entity<UserPreferences>().Property(up => up.PreferredWorkoutType).IsRequired().HasMaxLength(100);
            modelBuilder.Entity<UserPreferences>().Property(up => up.ActivityLevel).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<UserPreferences>().Property(up => up.MotivationLevel).IsRequired().HasMaxLength(50);

            modelBuilder.Entity<Users>()
            .HasOne(u => u.UserPreferences)
            .WithOne(up => up.User)
            .HasForeignKey<UserPreferences>(up => up.UserId)
            .OnDelete(DeleteBehavior.Cascade); // Or `Restrict` depending on your needs
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseLoggerFactory(_loggerFactory); // Enables logging
            base.OnConfiguring(optionsBuilder);
        }
    }
}
