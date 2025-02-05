using backend.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Configurations
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>().HasKey(u => u.Id);
            modelBuilder.Entity<User>().Property(u => u.Username).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<User>().Property(u => u.PasswordHash).IsRequired();
            modelBuilder.Entity<User>().Property(u => u.Role).IsRequired();
        }
    }
}