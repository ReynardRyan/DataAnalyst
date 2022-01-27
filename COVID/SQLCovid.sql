-- TABLE COVIDDEATHS

-- HIGHEST POPULATION

SELECT distinct location, sum(population) over() as total_population
from CovidDeaths
order by total_population desc 


-- HIGHEST TOTAL DEATHS

SELECT distinct location, sum(total_cases) as total_cases, sum(total_deaths) as total_deaths
from CovidDeaths
where continent is not null
group by location
order by total_deaths desc


-- TOTAL CASES, TOTAL DEATHS, DEATHS PERCENTAGE OVERALL
-- 1

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, round((sum(cast(new_deaths as int))/sum(new_cases))*100, 3) as DeathsPercentage
from coviddeaths
where continent is not null
order by 1, 2


-- TOTAL DEATHS BY LOCATION
-- 2
select location, sum(cast(new_deaths as int)) as TotalDeathCount
FROM CovidDeaths
where continent is null and location in ('Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
group by location 
order by TotalDeathCount desc


-- TOTAL CASES VS TOTAL DEATHS

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 3) as DeathsPercentage
from coviddeaths
where location = 'indonesia'
order by location, date


-- TOTAL CASES VS POPULATION

select location, date, total_cases, population, concat(round((total_cases/population)*100, 2), '%') as PercentagePopulationInfected
from coviddeaths
where location = 'indonesia' and
continent is not null
order by PercentagePopulationInfected desc


-- CONTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
-- 3

select location, population, MAX(total_cases) AS HighestInfectionCountry, round(max((total_cases/population)*100), 3) as PercentagePopulationInfected
from coviddeaths
group by location, population
order by PercentagePopulationInfected desc 


-- 4

select location, population, date, MAX(total_cases) AS HighestInfectionCountry, round(max((total_cases/population)*100), 3) as PercentagePopulationInfected
from coviddeaths
group by location, population, date
order by PercentagePopulationInfected desc 


-- CONTINENTS WITH HIGHEST DEATH PER POPULATION

select continent, MAX(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc 


-- GLOBAL NUMBERS

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, concat(round((sum(cast(new_deaths as int))/sum(new_cases))*100, 2), '%') as DeathsPercentage
from coviddeaths
where continent is not null
group by date
order by 1, 2   


-- TABLE COVIDVACCINATIONS

-- TOTAL POPULATION VS VACCINATIONS

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) as peopleVaccinated
from CovidDeaths as cd
join CovidVaccinations as cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null
order by 2, 3


