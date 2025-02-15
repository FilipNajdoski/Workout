using Application.Services;
using backend.Core.Entities;
using Microsoft.AspNetCore.Mvc;

namespace API.Controlers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MovementController : ControllerBase
    {
        private readonly MovementService _movementService;

        public MovementController(MovementService movementService)
        {
            _movementService = movementService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Movement>>> GetAll()
        {
            var movements = await _movementService.GetAll();
            return Ok(movements);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Movement>> GetById(int id)
        {
            var movement = await _movementService.GetById(id);
            if (movement == null)
            {
                return NotFound();
            }
            return Ok(movement);
        }

        [HttpPost]
        public async Task<ActionResult<Movement>> Add(Movement movement)
        {
            var createdMovement = await _movementService.Add(movement);
            return CreatedAtAction(nameof(GetById), new { id = createdMovement.Id }, createdMovement);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Movement movement)
        {
            if (id != movement.Id)
            {
                return BadRequest();
            }

            var updatedMovement = await _movementService.Update(movement);
            if (updatedMovement == null)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var movement = await _movementService.GetById(id);
            if (movement == null)
            {
                return NotFound();
            }

            await _movementService.Delete(id);
            return NoContent();
        }
    }
}
