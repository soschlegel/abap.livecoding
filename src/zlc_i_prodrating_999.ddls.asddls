@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS-View for Product Rating'
@Metadata.allowExtensions: true
define root view entity ZLC_I_ProdRating_999
  as select from zlc_prodrate_999
  association [1] to zz_ce_product as _Product on _Product.Product = $projection.product
{
  key rating_uuid,
      forename,
      surname,
      email,
      product,
      rating,
      _Product
}
