@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS-View for Product Rating'
@Metadata.allowExtensions: false
define root view entity ZLC_I_ProdRating_999
  as select from zlc_prodrate_999
{
      //ZLC_PRODRATE_999
      @UI.hidden: true
  key rating_uuid,
      @UI: {
        identification: [{ position: 10, label: 'Forename' }],
        lineItem: [{ position: 10, label: 'Forename' }]
       }
      forename,
      surname,
      email,

      product,
      rating
      //    _association_name // Make association public
}
