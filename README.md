SELECT * FROM [Portfolio project].DBO.coviddeath
order by 3,4

SELECT * FROM [Portfolio project]..covidvaccination
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio project]..coviddeath
order by 1,2

--Looking at Total cases vs Total deaths
--shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (cast(total_deaths as decimal)/cast(total_cases as decimal))*100 as DeathPercentage
From [Portfolio project]..coviddeath
where location like '%states%'
order by 1, 2


--Looking at Total cases vs Total Population
--shows what percentage of population got covid 
Select location, date, total_cases, population, (cast(total_cases as decimal)/cast(population as decimal))*100 as IncidencePercentage
From [Portfolio project]..coviddeath
where location like '%states%'
order by 1, 2

--Looking at countries with highest infection rate compared to population

Select location, MAX(total_cases) as HighestInfectionCount, population, (MAX(cast(total_cases as decimal)/cast(population as decimal)))*100 as IncidencePercentage

From [Portfolio project]..coviddeath
Group by location, population
order by IncidencePercentage desc


--Showing countries with highest Death count per population
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount

From [Portfolio project]..coviddeath
where continent is not NULL
Group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENTS

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount

From [Portfolio project]..coviddeath
where continent is not NULL
Group by location
order by TotalDeathCount desc


-- GLOBAL NUMBERS

SELECT  
    SUM(new_cases) AS Total_Cases, 
    SUM(CAST(new_deaths AS DECIMAL)) AS TotalDeaths, 
    100.0 * SUM(CAST(new_deaths AS DECIMAL)) / NULLIF(SUM(CAST(new_cases AS DECIMAL)), 0) AS DeathPercentage
FROM 
    [Portfolio project]..coviddeath
WHERE 
    continent IS NOT NULL
--GROUP BY 
--    date
ORDER BY 
    1,2;
--Looking at Total Population vs Vaccinations 


	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.date)
	as RollingPeopleVaccinated, --(RollingPeopleVaccinated/population)*100
	From [Portfolio project]..coviddeath dea
	Join [Portfolio project]..covidvaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null 
	order by 2,3

	--USE CTE
	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.date)
	as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
	From [Portfolio project]..coviddeath dea
	Join [Portfolio project]..covidvaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null 
	--order by 2,3
	)
	Select * , (RollingPeopleVaccinated/Population)*100
	From PopvsVac


	--TEMP TABLE

	DROP Table if exists #PercentPopulationVaccinated
	Create Table  #PercentPopulationVaccinated
	(
	Continent nvarchar(255), 
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)


	Insert into #PercentPopulationVaccinated
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.date)
	as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
	From [Portfolio project]..coviddeath dea
	Join [Portfolio project]..covidvaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null 
	order by 2,3

	Select * , (RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated


	--Crrating View to store data for later visualization 

	Create View PercentPopulationVaccinated as 
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.date)
	as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
	From [Portfolio project]..coviddeath dea
	Join [Portfolio project]..covidvaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null 
	--order by 2,3

	Select * 
	From PercentPopulationVaccinated 
