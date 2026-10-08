/*
==========================================================================================================================
---- A) CASO DE NEGOCIO / DISPARADOR DEL STAKEHOLDER
==========================================================================================================================

STAKEHOLDER: Director de Operaciones & Inversiones Inmobiliarias.

CONTEXTO & PROBLEMA DE NEGOCIO:
"La dirección comercial busca identificar oportunidades de inversión y comprender el comportamiento del mercado inmobiliario 
en el área metropolitana de Nashville. Sin embargo, los datos transaccionales brutos presentan inconsistencias severas, 
registros duplicados y campos no atómicos que impiden construir un tablero confiable y ágil en Power BI."

PREGUNTAS:

1. ¿En el año 2015 logramos superar el volumen de ventas mes a mes respecto al año 2014, o el mercado se contrajo? 
¿Cuál fue el complejo residencial que concentró la mayor cantidad de ventas durante el 2015?

2. Para la ciudad de Nashville, ¿cuál fue el uso de suelo (LandUse) más revendido y cuál fue el mayor número de 
transacciones que llegó a registrar un inmueble individual?

3. ¿Cuáles son las ciudades que concentran el mayor volumen de transacciones (demanda) en el área metropolitana 
y cuáles registran el precio de venta promedio más elevado?

4. ¿Qué proporción de propiedades se transfirieron desocupadas frente a las ocupadas y cuál es la brecha de precio entre ambas?

==========================================================================================================================
*/

/*
==========================================================================================================================
---- B) Limpieza y Transformación de Datos en SQL 
==========================================================================================================================
*/
--------------------------------------------------------------------------------------------------------------------------
-- 1) Observar los datos
select * 
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--  2) Estandarizar el formato de fecha
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

-- 3) Completar los datos faltantes en la dirección de la propiedad (PropertyAddress)
-- Notamos que Property Address es null, lo cual es ilogico porque la propiedad tiene que tener siempre la misma direccion
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

-- Por lo tanto usamos otro registro que tiene la direccion para colocarlo en el registro nulo:
-- Chequear:
SELECT A.[UniqueID ] , A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on a.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null
order by A.ParcelID

-- Aplicar:
update A
set A.PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on a.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null;

--------------------------------------------------------------------------------------------------------------------------

-- 4) Separar la dirección en columnas individuales (Dirección, Ciudad, Estado)
-- Con PropertyAddress:
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
	substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing A;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress));

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM PortfolioProject.dbo.NashvilleHousing;

-- Con Owner Address:
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

-- 5) Cambiar "Yes" y "No" a "Y" y "N" en el campo "Sold as Vacant"
Select SoldAsVacant, count(SoldAsVacant)
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
Select SoldAsVacant, count(SoldAsVacant) as Cantidad
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6) Eliminar duplicados
-- Los row_num = 2 son todos duplicados:
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
/*
Select *
From RowNumCTE
Where row_num > 1
Order by UniqueID;
*/
-- Los borramos:
Delete
From RowNumCTE
Where row_num > 1

---------------------------------------------------------------------------------------------------------

-- 7) Eliminar columnas no utilizadas
/*
SaleDate lo reemplazamo en el paso 1) al cambiarle el formato
OwnerAddress y PropertyAddress los reemplazamos en el paso 3) al separar sus datos.
TaxDistrict se consideró innecesario para futuros analisis.
*/
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

---------------------------------------------------------------------------------------------------------

-- 8) Tabla lista para exportar a Power BI
CREATE VIEW dbo.vw_NashvilleHousing_Clean AS
SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

---------------------------------------------------------------------------------------------------------

-- 9) Link del informe hecho en Power Bi:
-- https://drive.google.com/file/d/1Lp_RdMxPOwbrfRt_RQXFycVgMMvrVffa/view?usp=sharing

---------------------------------------------------------------------------------------------------------

-- 10) Respuestas a las preguntas del stakeholder fundamentadas con el informe:
/*
1. Cómo se puede visualizar en el grafico de líneas, el ritmo comercial habitual mes a mes en 2015 fue 
estable y similar al de 2014; sin embargo, la facturación total anual cayó porque en 2014 ocurrió una 
operación atípica de $1,54 mil M que infló ese año de manera excepcional y no representaba una tendencia 
recurrente de mercado. Además 1212 LAUREL ST fue el activo con mayor absorción y volumen de operaciones 
de ese año (230 transacciones) como se puede observar en el gráfico de barras apiladas.

2. En Nashville, el fenómeno de reventa se concentra mayoritariamente en residencias para una sola familia, 
esto se peude ver en el grafico circular donde ocupa el 57,99%. Además el techo de reventas fue de 4 operaciones 
en el histórico analizado.

3. Como se observa en el Treemap y en las columnas del Gráfico inferior, Nashville concentra la gran mayoría de 
operaciones con 40 mil ventas (40.216 operaciones), seguida muy de lejos por Antioch (6.286) y Hermitage (3.126).
Además, como muestra la línea del Gráfico de columnas y líneas inferior, los precios más elevados corresponden a 
Nashville con un promedio de $366.625 y a Brentwood con $312.258, contrastando con zonas más accesibles como Madison
que promedia $136.537.

4. Del total de transacciones analizadas, el 8,28% de las propiedades se transfirieron desocupadas frente al 91,72%
ocupadas, registrando una brecha de precio promedio de $19.992 a favor de las desocupadas (6,1%), con un valor de 
cierre promedio de $309.000 frente a los $329.000 de las habitadas como se puede observar en el gráfico de barras 
apiladas.
*/

---------------------------------------------------------------------------------------------------------
