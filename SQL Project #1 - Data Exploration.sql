/*
COVID 19 Data Exploration

Skills Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM CovidDeaths
ORDER BY 3,4

SELECT *
FROM CovidVaccinations
ORDER BY 3,4


--Select the Data we are going to start with

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2


-- Total Cases vs. Total Deaths
-- Shows Likelihood of Dying if You Contract COVID in Your Country

SELECT Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / (CONVERT(float, total_cases)))*100 AS death_percentage
FROM CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2


-- Total Cases vs. Population
-- Shows What Percentage of Population Got COVID

SELECT Location, date, total_cases, population, (CONVERT(float, total_cases) / population)*100 AS contract_percentage
FROM CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, MAX(total_cases) AS HighestInfectionCount, population, MAX((CONVERT(float, total_cases) / population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC


-- Showing Countries with Highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Let's Break Things Dwon by Continent




-- Showing Continents with Highest Death Count per Population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2



-- Looking at Total Population vs. Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3