@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Category Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_PC_CategoryVH
  as select distinct from zpc_product
{
  key category as Category
}
where category <> ''
