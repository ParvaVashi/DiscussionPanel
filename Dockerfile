FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 5085

ENV ASPNETCORE_URLS=http://+:5085

FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
ARG configuration=Release
WORKDIR /src
COPY ["DiscussionPanel.csproj", "./"]
RUN dotnet restore "DiscussionPanel.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DiscussionPanel.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "DiscussionPanel.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DiscussionPanel.dll"]
