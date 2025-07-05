--cleaning data in sql queries

select*
from PortfolioProject1..Nashvillehousing

--standardize data format

select SaleDate, convert(date,saledate)
from PortfolioProject1..nashvillehousing

update PortfolioProject1.dbo.Nashvillehousing
set SaleDate = convert(date, SaleDate)

-- If it doesn't Update properly

alter table PortfolioProject1.dbo.Nashvillehousing
add saledateconverted2 date;

update PortfolioProject1.dbo.Nashvillehousing
set SaleDate = convert(date, SaleDate)

--Populate Property Address data

select*
from PortfolioProject1..nashvillehousing
--where propertyaddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject1..nashvillehousing a
join PortfolioProject1..nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject1..nashvillehousing a
join PortfolioProject1..nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject1..nashvillehousing
--where propertyaddress is null
--order by ParcelID

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address
,SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as address
--(-1) means comma remove as address, & ',' we want searching for 12th position so 12th one is comma
--CHARINDEX(',',PropertyAddress) -->it specify total char count
from PortfolioProject1..nashvillehousing

alter table PortfolioProject1.dbo.Nashvillehousing
add propertysplitaddress varchar(255);

update PortfolioProject1.dbo.Nashvillehousing
set propertysplitaddress = convert(date, SaleDate)

alter table PortfolioProject1.dbo.Nashvillehousing
add propertysplitcity varchar(255);

update PortfolioProject1.dbo.Nashvillehousing
set propertysplitcity = convert(date, SaleDate)


select*
from PortfolioProject1..Nashvillehousing

select OwnerAddress
from PortfolioProject1..Nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject1.dbo.NashvilleHousing



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



-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),count(soldasvacant)
from PortfolioProject1..Nashvillehousing
group by SoldAsVacant
order by 2

select soldasvacant
,case when soldasvacant ='Y' then 'YES'
when soldasvacant = 'N' then 'NO'
else soldasvacant
end
from PortfolioProject1..Nashvillehousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	   
-- Remove Duplicates
with rownumcte as(
select*,
row_number () over(
partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
				 uniqueid
				 ) row_num

from PortfolioProject1..Nashvillehousing
order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


select*
from PortfolioProject1..Nashvillehousing

-- Delete Unused Columns

Select *
From PortfolioProject1..NashvilleHousing


ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
````