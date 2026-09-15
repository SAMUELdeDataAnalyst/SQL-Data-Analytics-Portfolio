---Populate Property Address Data

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID=b.ParcelID
and a.UniqueID <>b.UniqueID
where a.PropertyAddress  is null

Update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID=b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress  is null

Select UniqueID
from [Nashville Housing]
WHere PropertyAddress is null


--Breaking Address into indiviual columns( Address, City and State)

Select PropertyAddress
from [Nashville Housing];

select
  Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) - 1) as Address,
  Substring(PropertyAddress, CharIndex(',', PropertyAddress) + 1, len(PropertyAddress)) as AddressRest
from [Nashville Housing];

ALTER TABLE [Nashville Housing] 
ADD PropertySplitAddress nvarchar(255);
GO

UPDATE [Nashville Housing] 
SET PropertySplitAddress = Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) - 1);
GO

ALTER TABLE [Nashville Housing]
ADD PropertySplitCity nvarchar(255);
GO

UPDATE [Nashville Housing]
SET PropertySplitCity = Substring(PropertyAddress, CharIndex(',', PropertyAddress) + 1);
GO



Select
ParseName(Replace(OwnerAddress,',','.'),3),
ParseName(Replace(OwnerAddress,',','.'),2),
ParseName(Replace(OwnerAddress,',','.'),1)
from [Nashville Housing]

ALTER TABLE [Nashville Housing] 
ADD OwnerSplitAddress nvarchar(255);
GO

UPDATE [Nashville Housing] 
SET OwnerSplitAddress = ParseName(Replace(OwnerAddress,',','.'),3)
GO

ALTER TABLE [Nashville Housing]
ADD OwnerSplitCity nvarchar(255);
GO

UPDATE [Nashville Housing]
SET OwnerSplitCity = ParseName(Replace(OwnerAddress,',','.'),2)
GO

ALTER TABLE [Nashville Housing]
ADD OwnerSplitState nvarchar(255);
GO

UPDATE [Nashville Housing]
SET OwnerSplitState = ParseName(Replace(OwnerAddress,',','.'),1)
GO

--Change 1 and 0 to Yes and No in ' SOld as Vacant' Field
 


Select SoldAsVacant, 
Case
When SoldAsVacant=1 then 'Yes'
when SoldAsVacant=0 then 'No'
     else SoldAsVacant
End
from [Nashville Housing]

Alter Table [Nashville Housing] Alter Column SoldAsVacant varchar(max)

Update [Nashville Housing]
set SoldAsVacant=Case
When SoldAsVacant=1 then 'Yes'
when SoldAsVacant=0 then 'No'
     else SoldAsVacant
End


--Remove Duplicates
With RowNumCTE as(
Select *, ROW_NUMBER()
Over (Partition by
ParcelID,
PropertyAddress,
SaleDate,
SalePrice, 
SoldAsVacant,
LegalReference
order by 
UniqueID)rownum
from [Nashville Housing]
)

Delete 
from RowNumCTE
where rownum >1




--Remove Unused Columns

Select * 
from [Nashville Housing]

Alter Table [Nashville Housing] 
Drop column OwnerAddress, TaxDistrict, PropertyAddress