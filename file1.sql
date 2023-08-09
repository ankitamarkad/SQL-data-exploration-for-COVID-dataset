CREATE database portfolioproject;
use portfolioproject;

SELECT * 
FROM coviddeaths;

SELECT * 
FROM covidvaccinations;

Select *
From coviddeaths
Where continent is not null 
order by 3,4

SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as deathpercentage
FROM coviddeaths
ORDER BY 1,2 ;

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
Where location = "Bahrain"
and continent is not null 
order by 1,2

Select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From coviddeaths
order by 1,2 ;

SELECT location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where continent is not null 
Group by location, population
order by PercentPopulationInfected desc

SELECT location, MAX(total_deaths) as TotalDeathCount
From coviddeaths
Where continent is not null 
Group by location
order by TotalDeathCount desc

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


SELECT date, SUM(new_cases), (SUM(new_deaths)/SUM(new_cases))*100 as deathpercent
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
 as rollingpeoplevaccination
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

DROP Table if exists #PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
continent varchar(200),
location varchar(200),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
