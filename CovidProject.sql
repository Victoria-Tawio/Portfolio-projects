SELECT * 
FROM portfolio.coviddeaths
order by 3,4
;

/*SELECT * 
FROM portfolio.covidvaccinations
order by 3,4
; */

/* select data i will be using */

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolio.coviddeaths
order by 1,2
;

/*Looking at the Total Cases vs Total Deaths
Shows likelihood of dying in Afghanistan*/

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM portfolio.coviddeaths
where location like '%afghanistan%'
order by 1,2
;

/*Looking at the Total Cases vs Population
Shows what percentage of population got Covid
*/


SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM portfolio.coviddeaths
where location like '%afghanistan%'
order by 1,2
;


/*Looking at countries with highest infection rate compared to population*/

SELECT Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM portfolio.coviddeaths
where location like '%afghanistan%'
group by location, population
order by PercentPopulationInfected desc
;

/*showing countries with highest death count per population*/

SELECT Location, max(Total_deaths) as TotalDeathCount
FROM portfolio.coviddeaths
where location like '%afghanistan%'
group by location
order by TotalDeathCount desc
;

/*Looking at Total population vs Vaccinations*/

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
 Over
 (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
/*(RollingPeopleVaccinated/population)*100 */
FROM portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
order by 1,2
;
   
/*USE CTE*/

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
/*order by 1,2*/
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac
   
   
/*Creating view to store data for later visualizations*/

Create View PopvsVac
 as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
 Over
 (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
/*(RollingPeopleVaccinated/population)*100 */
FROM portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
/*order by 1,2*/
;
   
   





