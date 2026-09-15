Select * from PortfolioProject..CovidDeaths
--Where continent is not null
order by 3,4

--Select * from CovidVaccinations
--order by 3,4

--Data we are going to be using 
Select location,date,total_cases,new_cases,total_deaths, population
from CovidDeaths
order by 1,2

--Total Cases vs Total Deaths
--(Shows the likelihood of dying if you contract covid in your country)
Select location,date,total_cases,total_deaths ,
(total_deaths / NULLIF(total_cases,0))*100 as DeathPercentage
from CovidDeaths
where location = 'Africa' 
Order by 1,2

-- Looking at Totalcases vs Population)
-- Shows the percentage of the contracted
Select location,date,Population,total_cases,
(total_cases / Population)*100 as PercentPopulationinfected
from CovidDeaths
where location = 'Africa' 
Order by 1,2

--Looking at the coutries with the highest infected rate 
Select location,Population,max(total_cases) as Highestinfectedcount, 
Max((total_cases/ Nullif (Population,0)))*100 as PercentPopulationinfected
from CovidDeaths
--where location = 'Africa' 
Group by location, population
Order by PercentPopulationinfected desc

--showing countries with highest death per country
Select location, max(total_deaths) as TotalDeathcount
from CovidDeaths
--where location= 'Africa''Europe''Asia''Oceania''South America''North America' 
Group by location
Order by TotalDeathcount desc

--LETS GROUP THINGS BY CONTINENT

Select continent, max(total_deaths) as TotalDeathcount
from CovidDeaths
--Where continent is null
Group by continent
Order by TotalDeathcount desc

--GLOBAL NUMBERS
select date, sum(new_cases)as Globaldeath,
sum(new_deaths),
sum(new_deaths)/sum(new_cases)*100 as Deathpercentage
from CovidDeaths
group by date
order by 1
 
select  sum(new_cases)as GlobalCases,
sum(new_deaths) GlobalDeaths,
sum(new_deaths)/sum(new_cases)*100 as Deathpercentage
from CovidDeaths
--group by date
order by 1


--Looking at Total Population vs Vaccinations
--Using CTE
with PopvsVac(continent,location,date,population,new_vaccinations,
RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date, dea.population,
vac.new_vaccinations,
Sum(nullif(vac.new_vaccinations,0)) 
over ( Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date
--order by 2,3
)
 Select * , (RollingPeopleVaccinated/population)*100
 from PopvsVac

---Creating a view for data visualisation

Create View 
PercentageVaccinated 
as
select dea.continent,dea.location,dea.date, dea.population,
vac.new_vaccinations,
Sum(nullif(vac.new_vaccinations,0)) 
over ( Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date
--order by 2,3
 