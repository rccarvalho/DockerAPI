using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using ViaCEP;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;

namespace API.Linux.Controllers
{
    [ApiController]
    [Route("v1/[controller]")]
    public class ViaCepController : ControllerBase
    {
        private readonly ILogger<ViaCepController> _logger;
        private readonly IViaCEPClient _viaCEPClient;

        public ViaCepController(ILogger<ViaCepController> logger,
                                IViaCEPClient viaCEPClient)
        {
            _logger = logger;
            _viaCEPClient = viaCEPClient;
        }

        [AllowAnonymous]
        [Route("Search"), HttpPost]
        public ViaCepResult Search([FromBody] string zipCode)
        {
            var client = new ViaCepClient();

            var result = client.Search(zipCode);

            string jsonString = JsonSerializer.Serialize(result);

            Console.WriteLine(jsonString);

            return result;
        }
    }
}