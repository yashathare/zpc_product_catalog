@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Catalog - Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PC_Product
  provider contract transactional_query
  as projection on ZR_PC_PRODUCT
{
  key ProductUuid,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.9
      ProductId,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
      ProductName,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.8
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_PC_CategoryVH', element: 'Category' }, useForValidation: false }]
      Category,
      @Consumption.filter.selectionType: #RANGE
      Price,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' }, useForValidation: true }]
      CurrencyCode,
      @Consumption.filter.selectionType: #RANGE
      Stock,
      @Search.defaultSearchElement: true
      @Search.ranking: #LOW
      @Search.fuzzinessThreshold: 0.8
      Description,
      CreatedBy,
      CreatedAt,
      LastChangedAt,
      LocalLastChangedAt
}
