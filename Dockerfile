# Step 1: Base runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

# Step 2: Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file & restore dependencies
COPY MyMvcApp.csproj .
RUN dotnet restore "MyMvcApp.csproj"

# Copy all source code
COPY . .

# Build & publish app
RUN dotnet publish "MyMvcApp.csproj" -c Release -o /app/publish

# Step 3: Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyMvcApp.dll"]
