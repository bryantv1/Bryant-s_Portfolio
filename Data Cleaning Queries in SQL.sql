/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]

------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Data Format

ALTER TABLE [Nashville Housing]
ADD SaleDateConverted Date; 

UPDATE [Nashville Housing]
SET SaleDateConverted = CONVERT(DATE,SaleDate)

------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT PropertyAddress
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]
WHERE PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM AnalystBuilder_SQL.dbo.[Nashville Housing] a
JOIN AnalystBuilder_SQL.dbo.[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM AnalystBuilder_SQL.dbo.[Nashville Housing] a
JOIN AnalystBuilder_SQL.dbo.[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

SELECT 
	  PropertyAddress
	, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) as Address
	, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM AnalystBuilder_SQL.dbo.[Nashville Housing] 

ALTER TABLE [Nashville Housing]
ADD 
	  PropertySplitAddress varchar(255)
	, PropertySplitCity varchar(255);
UPDATE [Nashville Housing]
SET 
	  PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)
	, PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

-- For Owner Address as well

SELECT 
	  OwnerAddress
	, PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
	, PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
	, PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM AnalystBuilder_SQL.dbo.[Nashville Housing] 

ALTER TABLE [Nashville Housing]
ADD 
	  OwnerSplitAddress varchar(255)
	, OwnerSplitCity varchar(255)
	, OwnerSplitState varchar(255)

UPDATE [Nashville Housing]
SET 
	  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
	, OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
	, OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes or No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
	, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		   WHEN SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *
	, ROW_NUMBER() OVER (
		PARTITION BY 
			  ParcelID
			, PropertyAddress
			, SalePrice
			, SaleDate
			, LegalReference
			ORDER BY 
				UniqueID
				) as row_num
					
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM AnalystBuilder_SQL.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

------------------------------------------------------------------------------------------------------------------------------------
