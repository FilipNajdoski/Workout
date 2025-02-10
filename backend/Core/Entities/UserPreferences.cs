using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Core.Entities
{
    public class UserPreferences
    {
        [Key, ForeignKey("Users")]
        public int UserId { get; set; }

        [Required]
        [MaxLength(255)]
        public string Name { get; set; }

        [Required]
        public int Age { get; set; }

        [Required]
        [MaxLength(50)]
        public string Gender { get; set; }

        [Required]
        public decimal Height { get; set; }

        [Required]
        public decimal Weight { get; set; }

        public decimal? BodyFatPercentage { get; set; }

        [Required]
        [MaxLength(50)]
        public string FitnessLevel { get; set; }

        [Required]
        [MaxLength(100)]
        public string Goal { get; set; }

        [Required]
        public int WorkoutDaysPerWeek { get; set; }

        [Required]
        [MaxLength(100)]
        public string PreferredWorkoutType { get; set; }

        [Required]
        public string AvailableEquipment { get; set; }

        [Required]
        [MaxLength(50)]
        public string ActivityLevel { get; set; }

        [Required]
        public string HealthConditions { get; set; }

        public string PastInjuries { get; set; }

        public string DietaryPreference { get; set; }

        public string WorkoutExperience { get; set; }

        [Required]
        public string AvailableWorkoutTimes { get; set; }

        [Required]
        [MaxLength(50)]
        public string MotivationLevel { get; set; }

        [Required]
        public int AverageDailySteps { get; set; }

        [Required]
        public int WorkoutDurationMinutes { get; set; }

        public string? StressLevel { get; set; }

        public string? SleepQuality { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public virtual Users? User { get; set; }

    }
}
