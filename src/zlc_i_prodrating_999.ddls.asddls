@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS-View for Product Rating'
define root view entity ZLC_I_ProdRating_999
  as select from zlc_prodrate_999
{
      //ZLC_PRODRATE_999
  key rating_uuid,
      forename,
      surname,
      email,
      product,
      rating
      //    _association_name // Make association public
}
