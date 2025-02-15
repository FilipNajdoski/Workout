using backend.Core.Entities;
using backend.Core.Interfaces;
using Infrastructure.Configurations;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories
{
    /// <summary>
    /// Repository class for managing Movement entities.
    /// </summary>
    public class MovementRepository : IMovementRepository
    {
        private readonly AppDbContext _context;

        public MovementRepository(AppDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Retrieves all movements.
        /// </summary>
        /// <returns>A list of all movements.</returns>
        public async Task<IEnumerable<Movement>> GetAllAsync()
        {
            return await _context.Movements.ToListAsync();
        }

        /// <summary>
        /// Retrieves a movement by its unique identifier.
        /// </summary>
        /// <param name="id">The unique identifier of the movement.</param>
        /// <returns>The movement with the specified identifier.</returns>
        public async Task<Movement?> GetByIdAsync(int id)
        {
            return await _context.Movements.FindAsync(id);
        }

        /// <summary>
        /// Adds a new movement.
        /// </summary>
        /// <param name="movement">The movement to add.</param>
        /// <returns>The added movement.</returns>
        public async Task<Movement> AddAsync(Movement movement)
        {
            await _context.Movements.AddAsync(movement);
            await _context.SaveChangesAsync();
            return movement;
        }

        /// <summary>
        /// Updates an existing movement.
        /// </summary>
        /// <param name="movement">The movement to update.</param>
        /// <returns>The updated movement.</returns>
        public async Task<Movement> UpdateAsync(Movement movement)
        {
            _context.Movements.Update(movement);
            await _context.SaveChangesAsync();
            return movement;
        }

        /// <summary>
        /// Deletes a movement by its unique identifier.
        /// </summary>
        /// <param name="id">The unique identifier of the movement to delete.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        public async Task DeleteAsync(int id)
        {
            var movement = await _context.Movements.FindAsync(id);
            if (movement != null)
            {
                _context.Movements.Remove(movement);
                await _context.SaveChangesAsync();
            }
        }
    }
}
