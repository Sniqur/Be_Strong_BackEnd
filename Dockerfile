# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app



# Copy the solution and project files
COPY SampleWebApiAspNetCore.sln .
COPY SampleWebApiAspNetCore/*.csproj ./SampleWebApiAspNetCore/
RUN dotnet nuget locals --clear all


RUN dotnet restore "./SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj"

RUN dotnet restore --disable-parallel


# Copy the rest of the application source code and build it
COPY SampleWebApiAspNetCore/ ./SampleWebApiAspNetCore/
WORKDIR /app/SampleWebApiAspNetCore
RUN dotnet publish -c Release -o /out

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /out .

# Expose port 80 for the web API
EXPOSE 8080
# Start the web application
ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]

