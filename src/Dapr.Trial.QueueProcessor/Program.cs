using Dapr.Client;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton(new DaprClientBuilder().Build());

var app = builder.Build();

app.UseCloudEvents();

app.MapSubscribeHandler();

app.MapGet("/", async (DaprClient dapr) => await dapr.GetStateAsync<int>("statestore", "counter"));

app.MapPost("/counter", async ([FromBody] int counter, ILogger<Program> logger, DaprClient dapr) =>
{
    var newCounter = counter * counter;
    logger.LogInformation("Updating counter: {newCounter}", newCounter);
    // Save state out to a data store.  We don't care which one!
    await dapr.SaveStateAsync("statestore", "counter", newCounter);
    return Results.Accepted("/", newCounter);
}).WithTopic("pubsub", "counter", enableRawPayload: true);

app.Run();
