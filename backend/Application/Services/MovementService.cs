using backend.Core.Entities;
using backend.Core.Interfaces;

namespace Application.Services
{
    public class MovementService
    {
        private readonly IMovementRepository _movementRepository;

        public MovementService(IMovementRepository movementRepository)
        {
            _movementRepository = movementRepository;
        }

        public async Task<IEnumerable<Movement>> GetAll()
        {
            return await _movementRepository.GetAllAsync();
        }

        public async Task<Movement?> GetById(int id)
        {
            return await _movementRepository.GetByIdAsync(id);
        }

        public async Task<Movement> Add(Movement movement)
        {
            return await _movementRepository.AddAsync(movement);
        }

        public async Task<Movement> Update(Movement movement)
        {
            return await _movementRepository.UpdateAsync(movement);
        }

        public async Task Delete(int id)
        {
            await _movementRepository.DeleteAsync(id);
        }
    }
}
