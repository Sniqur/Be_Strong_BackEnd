FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /app

COPY SampleWebApiAspNetCore.sln .
COPY SampleWebApiAspNetCore/*.csproj ./SampleWebApiAspNetCore/
RUN dotnet nuget locals --clear all


RUN dotnet restore "./SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj"

RUN dotnet restore --disable-parallel

COPY SampleWebApiAspNetCore/ ./SampleWebApiAspNetCore/
WORKDIR /app/SampleWebApiAspNetCore
RUN dotnet publish -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:7.0

WORKDIR /app

COPY --from=build /out .

# Expose port 80 for the web API
# EXPOSE 80
EXPOSE 5001

ENV ASPNETCORE_URLS=http://+:5001
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]

