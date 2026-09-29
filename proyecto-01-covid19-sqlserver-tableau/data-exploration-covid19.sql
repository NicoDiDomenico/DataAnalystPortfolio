---- A) SQL: Enfocado en la exploración de datos y preparación para visualización.
-- Observamos todos los datos
select *
from PortfolioProject.dbo.CovidVaccinations 
order by 3, 4
/* Notamos que cuando el continente es nulo location tiene el el nombre del continente 
--> Hay que tener en cunenta esto al con sonsultar solo paises */

-- Seleccionar los datos que se van a usar
select 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1, 2;

-- Casos totales vs muertes totales
-- Probabilidad de morir al contraer covid en mi pais
select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 as '% Deaths'
from PortfolioProject.dbo.CovidDeaths
where location = 'Argentina'
order by 1, 2;

-- Casos totales vs población
select 
	location, 
	date, 
	population, 
	total_cases, 
	(total_cases/ population)*100 as '% Cases'
from PortfolioProject.dbo.CovidDeaths
where location = 'Argentina'
order by 1, 2;

-- Mirando los paises con la tasa de infeccion mas alta comparanda con la población
select 
	location, 
	population, 
	MAX(total_cases) as HighestInfectionCount,
	MAX(total_cases)/MAX(population)*100 as PercentPopulationInfected
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location, population
order by PercentPopulationInfected desc;

-- Mirando los paises con mayor cantidad de muertes por poblacion
select 
	location, 
	MAX(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathsCount desc;

-- Desglose por continente
select 
	continent, 
	MAX(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathsCount desc;

-- Mostrando el continente con mayor número de muertes
select
	continent, 
	MAX(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by 2 desc;

/* Nos damos cuenta que los datos correctos estan en los continentes nulos por lo tanto agrupamos por locacion: */
select 
	location, 
	MAX(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject.dbo.CovidDeaths
where continent is null
group by location
order by 2 desc;

-- 2. Números globales
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS int)) AS total_deaths, 
    SUM(CAST(new_deaths AS int)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--where location like '%states%'
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Observando la poblacion total vs vacunaciones
-- CTE:
with RollingPeopleVaccinated_CTE as (
	select 
		cd.continent, 
		cd.location, 
		cd.date, 
		cd.population, 
		cv.new_vaccinations,
		isnull(SUM(cast (cv.new_vaccinations as int)) OVER (Partition by cd.location order by cd.location, cd.date ), 0) as RollingPeopleVaccinated
	from PortfolioProject.dbo.CovidDeaths cd
	inner join CovidVaccinations cv
	on cv.date = cd.date
	and cv.location = cd.location
	where cv.continent is not null
)
select *
from RollingPeopleVaccinated_CTE
order by 2,3;

-- Temporary Table:
select 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	cv.new_vaccinations,
	isnull(SUM(cast (cv.new_vaccinations as int)) OVER (Partition by cd.location order by cd.location, cd.date ), 0) as RollingPeopleVaccinated
into #RollingPeopleVaccinated_TT
from CovidDeaths cd
inner join CovidVaccinations cv
on cv.date = cd.date
and cv.location = cd.location
where cv.continent is not null
GO
select *
from #RollingPeopleVaccinated_TT
order by 2,3;
GO
drop table #RollingPeopleVaccinated_TT;

-- NOTA: Usar mejor la CTE, resultó más rápida.

-- Creando vista para usarla en visualizaciones posteriores
create view PercentPopulationVaccinated as
select 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	cv.new_vaccinations,
	isnull(SUM(cast (cv.new_vaccinations as int)) OVER (Partition by cd.location order by cd.location, cd.date ), 0) as RollingPeopleVaccinated
from CovidDeaths cd
inner join CovidVaccinations cv
on cv.date = cd.date
and cv.location = cd.location
where cv.continent is not null;

select *
from PercentPopulationVaccinated


---- B) Queries used for Tableau Project

-- 1. KPIs Globales (Casos, Muertes y Tasa de Letalidad)
Select 
	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int)) / SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International" Location
/*elect 
	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))*100 / NULLIF(SUM(new_cases), 0) as DeathPercentage
From PortfolioProject..CovidDeaths
----Where location like '%states%'
where location = 'World'
--Group By date
order by 1,2*/


-- 2. Distribución de Muertes por Región Continente
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3. Porcentaje de Población Infectada por País
Select 
	Location, 
	Population, 
	MAX(total_cases) as HighestInfectionCount, 
	(Max(total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- 4. Serie Temporal: Infección Poblacional por Fecha y País
Select 
	Location, 
	Population,
	date, 
	MAX(total_cases) as HighestInfectionCount, 
	(Max(total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
