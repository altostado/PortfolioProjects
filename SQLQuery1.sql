--SELECT *
--FROM PortfolioProject..Covidvaccinations
--order by 3,4

--SELECT *
--FROM PortfolioProject..Coviddeaths
--order by 3,4

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..Coviddeaths
--order by 1,2

--SELECT Location, date, Population, total_cases,  (total_cases/population)*100 as PercentagePopulationInfected
--FROM PortfolioProject..Coviddeaths
----WHERE location like '%states%'
--order by 1,2

--SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentagePopulationInfected
--FROM PortfolioProject..Coviddeaths
----WHERE location like '%states%'
--GROUP BY Location, Population
--order by PercentagePopulationInfected DESC

--SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases) * 100 as DeathPercentage
--FROM PortfolioProject..Coviddeaths
--Where continent is not null
----Group by date
--order by 1,2


--SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases) * 100 as DeathPercentage
--FROM PortfolioProject..Coviddeaths
--Where continent is not null
----Group by date
--order by 1,2


--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as Snowball

--FROM PortfolioProject..Coviddeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	On dea.Location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--Order by 2,3



--Creating table

--Drop table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--Snowball numeric
--)



--Insert into #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as Snowball
--FROM PortfolioProject..Coviddeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	On dea.Location = vac.location
--	and dea.date = vac.date
----where dea.continent is not null

--SELECT *, (Snowball/population)*100
--From PercentPopulationVaccinated


--Creating View

--IF OBJECT_ID('PercentPopulationVaccinated', 'V') IS NOT NULL
  --  DROP VIEW PercentPopulationVaccinated
--GO

Create View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.location
	and dea.date = vac.date
where dea.continent is not null



--SELECT * 
--FROM PercentPopulationVaccinated


-- Use CTE


With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(Bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)

SELECT *, (RollingPeopleVaccinated/Population) * 100
From PopvsVac

-- Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(Bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population) * 100 as Calc
From PercentPopulationVaccinated

-- Create view to store data for later visualizations

Create View PercentPopulationVaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(Bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.Location = vac.location
	and dea.date = vac.date
where dea.continent is not null