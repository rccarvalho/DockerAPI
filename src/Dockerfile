FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build-env
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY *.sln ./
COPY API.Linux/API.Linux.csproj API.Linux/
COPY ViaCEP/ViaCEP.csproj ViaCEP/
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR "API.Linux"
#RUN mv appsettings.Docker.json appsettings.json
RUN dotnet publish "API.Linux.csproj" -c Release -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY --from=build-env /app .
ENTRYPOINT ["dotnet", "API.Linux.dll"]

EXPOSE 80
