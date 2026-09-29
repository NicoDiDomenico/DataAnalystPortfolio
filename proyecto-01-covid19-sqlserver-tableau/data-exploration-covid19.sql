---- A) DISPARADOR - Correo del Stakeholder:
/*
"Hola, equipo de Datos. Viendo las noticias recientes sobre la pandemia, tengo tres grandes preocupaciones que necesito que validen con nuestra base de datos:
1. Tengo la sensación de que la letalidad del virus está fuera de control a nivel global y que una inmensa proporción de los contagiados termina falleciendo.
2. Me parece que los continentes en vías de desarrollo (como Sudamérica y África) son los que concentran la mayor cantidad de muertes absolutas por falta de infraestructura.
3. Siento que el virus contagió a la población de todos los países de manera uniforme y estimo que las tasas de infección explotaran para todos lados al mismo tiempo."
*/

---- B) SQL: Enfocado en la exploración de datos y preparación para visualización.
-- Observamos todos los datos
select *
from PortfolioProject.dbo.CovidDeaths
order by 3, 4
/* Notamos que cuando el continente es nulo location tiene el el nombre del continente 
--> Hay que tener en cuenta esto al con sonsultar solo paises */

select *
from PortfolioProject.dbo.CovidVaccinations 
order by 3, 4

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
	inner join PortfolioProject.dbo.CovidVaccinations cv
	on cv.date = cd.date
	and cv.location = cd.location
	where cv.continent is not null
)
select *
from RollingPeopleVaccinated_CTE
order by 2,3;

-- Tabla Temporal:
select 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	cv.new_vaccinations,
	isnull(SUM(cast (cv.new_vaccinations as int)) OVER (Partition by cd.location order by cd.location, cd.date ), 0) as RollingPeopleVaccinated
into #RollingPeopleVaccinated_TT
from PortfolioProject.dbo.CovidDeaths cd
inner join PortfolioProject.dbo.CovidVaccinations cv
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

-- Creando vista para usarla enposibles visualizaciones posteriores
create view PercentPopulationVaccinated as
select 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	cv.new_vaccinations,
	isnull(SUM(cast (cv.new_vaccinations as int)) OVER (Partition by cd.location order by cd.location, cd.date ), 0) as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths cd
inner join PortfolioProject.dbo.CovidVaccinations cv
on cv.date = cd.date
and cv.location = cd.location
where cv.continent is not null;

select *
from PercentPopulationVaccinated


---- C) Consultas utilizadas para el proyecto de Tableau
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

-- 2. Distribución de Muertes por Región Continente
-- La Unión Europea ya forma parte de Europa
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

---- D) Visualización de Datos en Tableau
-- Visualizaciones: https://public.tableau.com/views/CovidDashboard_17899345726940/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

---- E) Validación de Hipótesis y Conclusiones
/*
Respuesta a la Premisa 1 - Letalidad Global:
La percepción es incorrecta. Como se puede observar en la tarjeta de "Global Numbers", si bien el volumen es altísimo (más de 150 millones de casos y 
3.18 millones de muertes), el Death Percentage (tasa de letalidad global) se mantiene en un 2,11%

Respuesta a la Premisa 2 - Impacto por Continente
Los datos desmienten la hipótesis. Los continentes con mayor cantidad de muertes absolutas son Europa (liderando con más de 1 millón) y Norteamérica, 
mientras que África y Oceanía presentan los números más bajos del gráfico de barra "Total Death Per Continent".

Respuesta a la Premisa 3 - Evolución de Infecciones por País:
Los datos desmienten que el impacto haya sido uniforme a nivel global. Observando el mapa de calor, es evidente que las tasas de infección varían 
drásticamente de un país a otro en la actualidad, con focos claros en Estados Unidos y Europa frente a bajas concentraciones en África y gran
parte de Asia. 
Además, al analizar el gráfico de líneas temporales y sus proyecciones, comprobamos que tampoco habrá una 'explosión' uniforme a 
futuro. El modelo estima escenarios sumamente dispares: proyecta que Estados Unidos mantendrá una tendencia alcista superando el 16,29% de población 
infectada para agosto de 2021, mientras que para países como Sudáfrica se estima un crecimiento mucho menor (3,55%), y proyecta curvas completamente 
planas y cercanas a cero para países como Japón (0,36%) y China.
*/