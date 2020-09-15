# Live-Coding Session

The aim of this Session, is to show how fast you can develop solutions with RAP and Steampunk, that would normally cost you days!

# Table of Contents
- [Live-Coding Session](#live-coding-session)
- [Table of Contents](#table-of-contents)
  - [Our Scenario <a name="scenario"></a>](#our-scenario-)
  - [What's RAP? <a name="whats_rap"></a>](#whats-rap-)
  - [Getting the Products <a name="products"></a>](#getting-the-products-)
  - [Create Table <a name="create_table"></a>](#create-table-)
  - [Create a Custom Entity <a name="create_custom_entity"></a>](#create-a-custom-entity-)
  - [Consume OData-Service <a name="consume_odata"></a>](#consume-odata-service-)
  - [Build your first BO with RAP-Generator <a name="rap_generator"></a>](#build-your-first-bo-with-rap-generator-)
  - [Describe your Fiori-App <a name="describe_fiori_app"></a>](#describe-your-fiori-app-)

## Our Scenario <a name="scenario"></a>

In a short time, we want to build a simple application, where a customer can rank a product. But to make it more exotic and show the strength of the cloud, our product list is not on the same system, but somewhere else and has to be consumed via OData.

## What's RAP? <a name="whats_rap"></a>

The ABAP RESTful Programming Model is the newest way and technology provided by SAP to create modern, RESTful applications with web based UIs - especially focused for sure on SAP UI5.
Google delivers a lot of information on this technology, by simply searching for "SAP RAP" and of course useful sources to get in touch with it, are as follows:

* [Official documentation](https://help.sap.com/viewer/923180ddb98240829d935862025004d6/Cloud/en-US/289477a81eec4d4e84c0302fb6835035.html?q=abap%20restful%20programming)
* [Blog Post by Sony Sukumar Kattoor as overview](https://blogs.sap.com/2019/05/23/sap-cloud-platform-abap-restful-programming-model-rap-for-beginners/)
* [Almost every post by André Fischer](https://people.sap.com/andre.fischer)
* [...and also Florian Wahl](https://people.sap.com/florian.wahl)

In very short terms explained:
In former Days, SAP logic was encapsulated by Business Objects, build out of Function Modules and Function Groups. But without any consistency in naming and functionality, so a lot of experience was needed, to find the right FM for the right task - if such one even existed!
Since S/4HANA, we have new **first class citizens** - and these are CDS Views! With Core Data Service Views, SAP invented a wrapper for a lot of Application Server Side logic hidden in Function Module with ABAP on how all the Data of a Business Object belong together - not very much "Code-Pushdown" as SAP preaches it since the first days of SAP HANA. All this changed with CDS, but these are Database **VIEWS** and as in every other database like Oracle or MS SQL, Views are read-only.
Based on these CDS Views, SAP redesigns the existing Business Objects to make them also easily consumeable via OData and with this, also for SAP UI5.
![Levels of RAP](images/RAP_overview_0.png)

The foundation for a Business Object is now a CDS View (or a [CDS View Entity which is the successor for CDS Views with ABAP Platform 2020](https://blogs.sap.com/2020/09/02/a-new-generation-of-cds-views-cds-view-entities/)).
These Views are connected to a Behavior Definition, which defines the possible actions and a Behavior Implementation, which implements the logic. Out of this, we define a Service Definition, which lists the exposed entities and at least, we enter our protocol we want to use, i.e. OData V2 or OData V4.
![Elements of a RAP BO](images/RAP_overview.png)

## Getting the Products <a name="products"></a>

## Create Table <a name="create_table"></a>

## Create a Custom Entity <a name="create_custom_entity"></a>

## Consume OData-Service <a name="consume_odata"></a>

## Build your first BO with RAP-Generator <a name="rap_generator"></a>

## Describe your Fiori-App <a name="describe_fiori_app"></a>
