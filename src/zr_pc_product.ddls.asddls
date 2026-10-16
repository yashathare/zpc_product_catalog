@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Catalog'
define root view entity ZR_PC_PRODUCT
  as select from zpc_product
{
  key product_uuid      as ProductUuid,
      product_id        as ProductId,
      product_name      as ProductName,
      category          as Category,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price             as Price,
      currency_code     as CurrencyCode,
      stock             as Stock,
      description       as Description,
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
