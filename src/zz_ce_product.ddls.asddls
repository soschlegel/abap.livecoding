@EndUserText.label: 'Custom Entity for Products'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_LC_PRODUCTS_999'
define custom entity ZZ_CE_Product
{
  key Product                        : abap.char( 40 );
      @OData.property.valueControl   : 'ProductType_vc'
      ProductType                    : abap.char( 4 );
      ProductType_vc                 : rap_cp_odata_value_control;
      @OData.property.valueControl   : 'CrossPlantStatus_vc'
      CrossPlantStatus               : abap.char( 2 );
      CrossPlantStatus_vc            : rap_cp_odata_value_control;
      @OData.property.valueControl   : 'CrossPlantStatusValidityDat_vc'
      CrossPlantStatusValidityDate   : rap_cp_odata_v2_edm_datetime;
      CrossPlantStatusValidityDat_vc : rap_cp_odata_value_control;

}
