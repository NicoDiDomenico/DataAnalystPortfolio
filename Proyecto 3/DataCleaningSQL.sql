---- Data Cleaning in SQL 
-- Cleaning Data in SQL Queries
--------------------------------------------------------------------------------------------------------------------------

-- Observamos los datos
select * 
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--  1) Standardize Date Format
select SaleDate, Convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

-- No funciona porque al estar configurado como DATETIME SQL le vuelve a colocar el tiempo 00:00:00 por defecto!
update PortfolioProject.dbo.NashvilleHousing
set SaleDate = Convert(Date, SaleDate);

-- ALTERNATIVA:
-- 1. Agregar la nueva columna
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date;

-- 2. Poblar la nueva columna con la fecha limpia
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

-- 3. Verificar
SELECT SaleDate, SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing;

 --------------------------------------------------------------------------------------------------------------------------

-- 2) Populate Property Address data
-- Notamos que Property Address es null, lo cual es ilogico porque la propiedad tiene que tener siempre la misma direccion
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

-- Por lo tanto usamos otro registro que tiene la direccion para colocarlo en el registro nulo:
-- Chequeamos
SELECT A.[UniqueID ] , A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on a.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null
order by A.ParcelID

-- Lo aplicamos:
update A
set A.PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on a.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null;

--------------------------------------------------------------------------------------------------------------------------

-- 3) Breaking out Address into Individual Columns (Address, City, State)
-- Property Address:
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
	substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing A;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

-- 2. Poblar la nueva columna con la fecha limpia
UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress));

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM PortfolioProject.dbo.NashvilleHousing;

-- Owner Address:
SELECT 
	OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- 4) Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct SoldAsVacant, count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;

-- OP 1:
Update NashvilleHousing
SET SoldAsVacant = 'Y'
where SoldAsVacant = 'Yes';

Update NashvilleHousing
SET SoldAsVacant = 'N'
where SoldAsVacant = 'No';
 
-- OP 2:
Select 
	SoldAsVacant,
	CASE when SoldAsVacant = 'Yes' then 'Y'
		 when SoldAsVacant = 'No' then 'N'
		 else SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Yes' then 'Y'
		 when SoldAsVacant = 'No' then 'N'
		 else SoldAsVacant
	END

-- Verificamos:
Select distinct SoldAsVacant, count(SoldAsVacant) as Cantidad
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5) Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- 6) Delete Unused Columns
/*
SaleDate lo reemplazamo en el paso 1) al cambiarle el formato
OwnerAddress y OwnerAddress los reemplazamos en el paso 3) al separar sus datos.
TaxDistrict se consideró innecesario para futuros analisis.
*/
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate