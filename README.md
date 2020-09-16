# Live-Coding Session

The aim of this Session, is to show how fast you can develop solutions with RAP and Steampunk, that would normally cost you days!

- [Live-Coding Session](#live-coding-session)
  - [Our Scenario](#our-scenario)
  - [What's RAP](#whats-rap)
  - [Getting the Products](#getting-the-products)
  - [Create Table](#create-table)
  - [Create Business Object](#create-business-object)
    - [Create CDS Root View](#create-cds-root-view)
    - [Create Behavior Definition](#create-behavior-definition)
    - [Create Behavior Implementation](#create-behavior-implementation)
    - [Create the Service Definition](#create-the-service-definition)
    - [Create the Service Binding](#create-the-service-binding)
    - [Define Metadata-Annotations](#define-metadata-annotations)
  - [Consume OData-Service](#consume-odata-service)
    - [Get the Metadata](#get-the-metadata)
    - [Create OData Consumption Model](#create-odata-consumption-model)
  - [Create a Custom Entity](#create-a-custom-entity)
  - [Extend the CDS View](#extend-the-cds-view)
  - [Build your first BO with RAP-Generator (optional)](#build-your-first-bo-with-rap-generator-optional)

## Our Scenario

In a short time, we want to build a simple application, where a customer can rank a product. But to make it more exotic and show the strength of the cloud, our product list is not on the same system, but somewhere on an other system and has to be consumed via OData.

## What's RAP

The ABAP RESTful Programming Model is the newest way and technology provided by SAP to create modern, RESTful applications with web based UIs - especially focused for sure on SAP UI5.
Google delivers a lot of information on this technology, by simply searching for "SAP RAP" and of course useful sources to get in touch with it, are as follows:

- [Official documentation](https://help.sap.com/viewer/923180ddb98240829d935862025004d6/Cloud/en-US/289477a81eec4d4e84c0302fb6835035.html?q=abap%20restful%20programming)
- [Blog Post by Sony Sukumar Kattoor as overview](https://blogs.sap.com/2019/05/23/sap-cloud-platform-abap-restful-programming-model-rap-for-beginners/)
- [Almost every post by André Fischer](https://people.sap.com/andre.fischer)
- [...and also Florian Wahl](https://people.sap.com/florian.wahl)

In very short terms explained:
In former Days, SAP logic was encapsulated by Business Objects, build out of Function Modules and Function Groups. But without any consistency in naming and functionality, so a lot of experience was needed, to find the right FM for the right task - if such one even existed!
Since S/4HANA, we have new **first class citizens** - and these are CDS Views! With Core Data Service Views, SAP invented a wrapper for a lot of Application Server Side logic hidden in Function Module with ABAP on how all the Data of a Business Object belong together - not very much "Code-Pushdown" as SAP preaches it since the first days of SAP HANA. All this changed with CDS, but these are Database **VIEWS** and as in every other database like Oracle or MS SQL, Views are read-only.
Based on these CDS Views, SAP redesigns the existing Business Objects to make them also easily consumeable via OData and with this, also for SAP UI5.
![Levels of RAP](images/RAP_overview_0.png)

The foundation for a Business Object is now a CDS View (or a [CDS View Entity which is the successor for CDS Views with ABAP Platform 2020](https://blogs.sap.com/2020/09/02/a-new-generation-of-cds-views-cds-view-entities/)).
These Views are connected to a Behavior Definition, which defines the possible actions and a Behavior Implementation, which implements the logic. Out of this, we define a Service Definition, which lists the exposed entities and at least, we enter our protocol we want to use, i.e. OData V2 or OData V4.

![Elements of a RAP BO](images/RAP_overview.png)

## Getting the Products

This example should be a demo on how to bring cloud and on-Prem together, so for this, we need another system to connect to. The easiest way are the demo system provided by SAP via the [SAP API Business Hub](https://api.sap.com/).
Select here the SAP S/4HANA Cloud - perhaps an account registration before may be required for you.

![SAP API Business Hub for S/4HANA Cloud](images/API_Business_Hub.png)

On the next page we search for *product* and take a closer look, at the probably best fitting service according to description:

![Find the product-service](images/API_Business_Hub_Product_01.png)

Here we find everything we need to get our product information. We can also test the API Calls directly and also create Code Snippets for consuming this Service in multiple, different programming languages.

![Product Service Overview](images/API_Business_Hub_Product_02.png)

## Create Table

At first step, we have to think about what we need, for a simple product rating and create a database table based on these identified requirements.

```abap
@EndUserText.label : 'Product-Rating'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zlc_prodrate_999 {
  key client      : abap.clnt not null;
  key rating_uuid : sysuuid_x16 not null;
  forename        : abap.char(40);
  surname         : abap.char(40);
  email           : abap.char(60);
  product         : abap.char(40);
  rating          : abap.int1;
}
```

## Create Business Object

### Create CDS Root View

After creating the table, just right click it and select **New Data Definition** to create a CDS Root View, based on our Database.

![use CDS Wizard for DB Table](images/cds_rating_00.png)

The next steps are "as always":

![Define View Name](images/cds_rating_01.png)

![Select Template](images/cds_rating_02.png)

The result should look like this:

```abap
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
```

### Create Behavior Definition

Now, we need to make our BO "intelligent". First Step for this, is creating a Behavior Definition - again with some wizard support via right click on the DDLS and select **New Behavior Definition**. For sure we'll use **Implementation Type: Managed** because we don't want loose time with implementing all the coding by ourself.

![BD Wizard](images/BD_00.png)

We define a very simple one and with our next step, we'll implement the Behavior Implementation, which is currently commented out.

```abap
managed; // implementation in class zbp_lc_i_prodrating_999 unique;

define behavior for ZLC_I_ProdRating_999 alias prod_rating
persistent table zlc_prodrate_999
lock master

{
  create;
  update;
  delete;

  field ( numbering : managed ) rating_uuid;
}
```

`field ( numbering : managed ) rating_uuid;` is needed, that the GUIDs are created automatically and the developer doesn't need to care about :-) .

### Create Behavior Implementation

And again, we use the wizard to create out Behavior Implementation and use the before suggested name.

![Create Behavior Implementation](images/BI_00.png)

Simple activating the Behavior Implementation is at the moment everything, that needs to be done.

After the creation of the implementation, we need to comment in the class name in the Behavior Definition.

```abap
managed implementation in class zbp_lc_i_prodrating_999 unique;
```

### Create the Service Definition

First time after a while, we don't have an ultra easy wizard :-( - but it's ok.
Simple create a Service Definition by finding the right button in the context-menu.

![Create Service Definition](images/SD_00.png)

The work, is very easy: with the command `expose`, we describe what entities should be exposed to our service - well, Rocket-Science!

```abap
@EndUserText.label: 'Service Definition for Product Rating'
define service ZLC_I_ProductRating_999 {
  expose ZLC_I_ProdRating_999;
}
```

### Create the Service Binding

The complete logic is contained in the CDS View Entity and the corresponding Behavior Definition and Implementation.
The Service Definition exposes all relevant and needed entities.
The last open point to define, is how the data can be consumed - in detail: Which protocol?
This is done via the Service Binding, and therefore one has to be created.

![Create Service Binding](images/SB_00.png)

A Service Binding brings a Service Definition and a protocol together and creates and Endpoint out of these information, for a later consumption by third party tools.

![Service Binding Definition](images/SB_01.png)

![Service Binding Endpoint](images/SB_02.png)

Clicking the **Preview...**-Button opens a browser windows and shows a first preview of our App - not that sexy and not fully functional so far, because of the missing annotations.

![Fiori-Preview](images/fiori_00.png)

### Define Metadata-Annotations

In this scenario, we use the capabilities of Fiori-Elements, but this is based on annotations and for this, we need to add them to our CDS Entity.

In general, we have three posibilities:

- Define them via UI-Tools like WebIDE in a separate Annotations.xml
- Write them inline, directly into the used CDS View
- Create a separate Metadata-Extension-Object (MDE) on ABAP-Level

We will use the MDE - a little bit more work, but better to maintain in a bigger project.

Right-Click on the CDS DDLS and select "New Metadata Extension" from context-menu.

![Create MDE](images/MDE_00.png)

We select the same name as for our CDS View - just make it simple.

![MDE Wizard](images/MDE_01.png)

Before we can start with the MDE, we first need to allow this on CDS level by adding the Annotation `@Metadata.allowExtensions: true`.

Defining annotations is again a special snowflake, where a developer can invest a lot of time - in this example it is strapped down to a minimum!

```abap
@Metadata.layer: #CUSTOMER

@UI: {
  headerInfo: { typeName: 'Product Rating', typeNamePlural: 'Product Rating'  } }

@Search.searchable: true
annotate view ZLC_I_ProdRating_999 with
{

  @UI.facet: [ {
      id: 'idCollection',
      type: #COLLECTION,
      label: 'Product Rating',
      position: 10
    },
    {
      id: 'idIdentification',
      parentId: 'idCollection',
      type: #IDENTIFICATION_REFERENCE,
      label: 'General Information',
      position: 10
    } ]

    //ZLC_I_ProdRating_999
  @UI.hidden: false
  rating_uuid;

  @UI:{
    lineItem: [{
      position: 10,
      importance: #HIGH,
      type: #STANDARD,
      label: 'Käse'
    }],
    identification: [{
        position: 10,
        label: 'Forename'
    }]
  }
  @Search.defaultSearchElement: true
  forename;

  @UI:{
  lineItem: [{
    position: 20,
    importance: #HIGH,
    type: #STANDARD,
    label: 'Surname'
  }],
  identification: [{
    position: 20,
    label: 'Surname'
  }]
  }
  @Search.defaultSearchElement: true
  surname;

  @UI:{
  lineItem: [{
    position: 30,
    type: #STANDARD,
    label: 'E-Mail'
  }],
  identification: [{
    position: 30,
    label: 'E-Mail'
  }]
  }
  email;

  @UI:{
    lineItem: [{
      position: 40,
      type: #STANDARD,
      label: 'Product'
    }],
    identification: [{
      position: 40,
      label: 'Product'
   }]
  }
  product;

  @UI:{
      lineItem: [{
        position: 50,
        type: #STANDARD,
        label: 'Rating'
      }],
      identification: [{
        position: 50,
        label: 'Rating'
      }]
  }
  rating;
}
```

## Consume OData-Service

### Get the Metadata

For consumption of the products, we have to go back, to [SAP API Business Hub](https://api.sap.com/) and our selected product-service. Click on [**Details**](https://api.sap.com/api/API_PRODUCT_SRV/overview) and then **Download API Specification** and select **EDMX** for Downloading the Service Metadata.

![Metadata Download](images/download_edmx.png)

### Create OData Consumption Model

As next step, we have to tell our development, what to consume, by creating a Service Consumption Model.

![Create Consumption Model](images/cds_custom_01.png)

In our case, we consume OData.

![Select Consumption Mode](images/cds_custom_02.png)

...and for this, we need to upload our XML / EDMX.

![Upload Metadata](images/cds_custom_03.png)

From all the provided entities, we only need the products.

![Select entities](images/cds_custom_04.png)

As a result, the wizard creates three objects.

- Service Definition for exposing via some "Proxy"
- A Data Definition for referencing to the Entity-Properties
- And at last, the Behavior Definition - this is needed for the Service Definition
  
![Created Development Artifacts](images/cds_custom_05.png)

## Create a Custom Entity

First, we have to create a so called CDS Custom Entity. This is this coolest way, to combine CDS and classical ABAP.
In the step before, the wizard created an abstract entity for us, where we find the complete definition of the product entity. We only need a subset of the fields.

```abap
/********** GENERATED on 09/16/2020 at 11:34:37 by CB0000000122**************/
 @OData.entitySet.name: 'A_Product' 
 @OData.entityType.name: 'A_ProductType' 
 define root abstract entity ZZ_LC_A_PRODUCT { 
 key Product : abap.char( 40 ) ; 
 @Odata.property.valueControl: 'ProductType_vc' 
 ProductType : abap.char( 4 ) ; 
 ProductType_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CrossPlantStatus_vc' 
 CrossPlantStatus : abap.char( 2 ) ; 
 CrossPlantStatus_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CrossPlantStatusValidityDat_vc' 
 CrossPlantStatusValidityDate : RAP_CP_ODATA_V2_EDM_DATETIME ; 
 CrossPlantStatusValidityDat_vc : RAP_CP_ODATA_VALUE_CONTROL ;
 ...
```

So once again: we create a CDS View, but this time with some other keywords:
- `define custom entity` - yeah! As said: we want to create a custom entity
- `@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_LC_PRODUCTS_999'` - the query and the logic, is implemented in the entered class

```abap
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
```

This class has to be created afterwards, to make it running. And this class needs to implement the interface `if_rap_query_provider`.
Ok - here we have to implement some coding, which can be found in the GitHub-Repository in the class `ZCL_CE_LC_PRODUCTS_999`.

## Extend the CDS View

Now we have to bring our both entities together. This can be done via a simple adaption of out Product-Rating-View.

```abap
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
```

And also our metadata has to be adapted, by defining the search help for product. Just add the following lines, right about your "product".

```abap
  @Consumption.valueHelpDefinition: [{
    entity: { name: 'ZZ_CE_PRODUCT',
              element: 'Product' } }]
  product;
```

## Build your first BO with RAP-Generator (optional)

coming soon...
