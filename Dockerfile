FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY dockerSample/*.csproj ./dockerSample/
RUN dotnet restore

# copy everything else and build app
COPY dockerSample/. ./dockerSample/
WORKDIR /app/dockerSample
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime
WORKDIR /app
COPY --from=build /app/dockerSample/out ./
EXPOSE 808/tcp

ENTRYPOINT ["dotnet", "dockerSample.dll"]
