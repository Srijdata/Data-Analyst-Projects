---Cleaning data in SQL Queries


Select * 
FROM Projects.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
FROM Projects.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



--Populate Property Address Data


Select *
FROM Projects.dbo.NashvilleHousing
order by ParcelID





Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


---Breaking out Address into individual Columns (Address, City, State)

Select PropertyAddress FROM Projects.dbo.NashvilleHousing






SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM Projects.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 


Select *
FROM Projects.dbo.NashvilleHousing;






Select OwnerAddress
From Projects.dbo.NashvilleHousing



Select PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
From Projects.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)


Select *
From Projects.dbo.NashvilleHousing




------Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count (SoldAsVacant)
From Projects.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From Projects.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END




---------------Remove Duplicates------------------------------------------------------------------------------------------------------------------------------------

WITH RowNumCTE AS(
Select *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER by UniqueID
) row_num

FROM Projects.dbo.NashvilleHousing

)
Select *
FROM RowNumCTE
where row_num > 1
ORDER by PropertyAddress







WITH RowNumCTE AS(
Select *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER by UniqueID
) row_num

FROM Projects.dbo.NashvilleHousing

)
Delete
FROM RowNumCTE
where row_num > 1
--ORDER by PropertyAddress



WITH RowNumCTE AS(
Select *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER by UniqueID
) row_num

FROM Projects.dbo.NashvilleHousing

)
Select *
FROM RowNumCTE
where row_num > 1
ORDER by PropertyAddress






--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------DELETE UNUSED COLUMNS


Select *
From Projects.dbo.NashvilleHousing

ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN SaleDate