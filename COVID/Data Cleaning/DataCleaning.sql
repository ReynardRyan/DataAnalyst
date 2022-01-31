use Covid

select *from housingdata

-- DATE FORMAT

select saledate, convert(date, saledate)
from HousingData

alter table housingdata
alter column saledate date


-- POPULATE PROPERTY ADDRESS DATA

select *
from HousingData
order by ParcelID


select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
 


-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

select PropertyAddress
from HousingData
--order by ParcelID

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress)) as address
from housingdata

alter table housingdata
add PropertySplitAddress nvarchar(255) 

update HousingData
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table housingdata
add PropertySplitCity nvarchar(255) 

update HousingData
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress))


--CONTOH
select PARSENAME(replace('joko reynard alpha ryan', ' ', '.'), 4)


SELECT PARSENAME(REPLACE(owneraddress, ',', '.'), 3), PARSENAME(REPLACE(owneraddress, ',', '.'), 2), PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
from HousingData

alter table housingdata
add OwnerSplitAddress nvarchar(255) 

update HousingData
set OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 3)

alter table housingdata
add OwnerSplitCity nvarchar(255) 

update HousingData
set OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

alter table housingdata
add OwnerSplitState nvarchar(255) 

update HousingData
set OwnerSplitState= PARSENAME(REPLACE(owneraddress, ',', '.'), 1)

select ownersplitaddress, ownersplitcity, ownersplitstate
from HousingData


--CHANGE Y AND NO TO YES AND NO IN "SOLD AS VACANT" FIELD

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
end
from housingdata

select distinct soldasvacant, count(soldasvacant)
from housingdata
group by soldasvacant

update HousingData
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
end


use Covid


-- REMOVE DUPLICATES

with RowNumCTE as (
select *, ROW_NUMBER() OVER(PARTITION BY parcelID, propertyaddress, saleprice, saledate, legalreference order by uniqueID) as row_num
from HousingData)

select * 
from RowNumCTE
where row_num > 1


-- DELETE UNUSED COLUMNS

ALTER TABLE housingdata
drop column owneraddress, taxdistrict, propertyaddress, saledate

select *from HousingData

