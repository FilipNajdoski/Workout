using backend.Core.Entities;

namespace backend.Core.Interfaces
{
    public interface IMovementRepository
    {
        Task<IEnumerable<Movement>> GetAllAsync();
        Task<Movement?> GetByIdAsync(int id);
        Task<Movement> AddAsync(Movement movement);
        Task<Movement> UpdateAsync(Movement movement);
        Task DeleteAsync(int id);
    }

}
