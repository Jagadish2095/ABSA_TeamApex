/**
* @description Test class for OnboardingProductInformationController
* @update Sipho Mbulawa
* @dateUpdated 2021-01-14
* Added the testPackage method on line 391
*/
@isTest
public class OnboardingProductInformationConTest {

@testSetup
static void dataCreation(){
Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
insert prod;

Product2 cpfprod = new Product2(Name = 'CPF Above R5 Million');
insert cpfprod;

Product2 packageProduct = new Product2(Name = 'Cheque Product Package', Family = 'Cheque');
insert packageProduct;

Pricebook2 pb = new Pricebook2();
pb.IsActive=true;
pb.id = Test.getStandardPricebookId();
update pb;

Account acc =new Account();
acc.name='testcreateCif';
acc.Type='Business Prospect Clinet';
acc.CIF__c = 'SACOMPE259';
insert acc;

Opportunity testOpp = new Opportunity();
testOpp.Name = 'Test Opp Onboarding';
testOpp.CloseDate = Date.today();
testOpp.StageName = 'New';
testOpp.Pricebook2Id = Test.getStandardPricebookId();
testOpp.AccountId = acc.id;
insert testOpp;

Opportunity testOpp2 = new Opportunity();
testOpp2.Name = 'Test Credit Onboarding';
testOpp2.CloseDate = Date.today();
testOpp2.StageName = 'New';
testOpp2.Pricebook2Id = Test.getStandardPricebookId();
testOpp2.AccountId = acc.id;
testOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
insert testOpp2;

}

@isTest
public static void testSaveOpportunityLineItemWithPriceBookEntry(){

Opportunity newOrppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
Opportunity newOrppRecord2 = [SELECT Id,Name FROM Opportunity where Name =: 'Test Credit Onboarding'];
Product2    prodRecord=[SELECT Id,Name FROM Product2 LIMIT 1];
PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prodRecord.Id, UnitPrice = 12000, IsActive = true);
insert customPrice;
Test.startTest();
OnboardingProductInformationController.updateIllustrativeDecision (newOrppRecord.Id, TRUE);
String val =OnboardingProductInformationController.getOppsFields(newOrppRecord.Id);
Map<String, String> strmap=OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord2.Id, prodRecord.Id);
//OnboardingProductInformationController.jimmyclass();
Test.stopTest();
}

@isTest
static void testSaveOpportunityLineItemWithoutPriceBookEntry(){
Opportunity newOrppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
Product2 prodRecord=[SELECT Id,Name FROM Product2 LIMIT 1];
Test.startTest();
Map<String, String> strmap =OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
//OnboardingProductInformationController.getOpportunityLineItem(newOrppRecord.Id);
Test.stopTest();
}

@isTest
public static void testSaveOpportunityLineItem(){

Opportunity newOrppRecord = [SELECT Id,Name,RecordTypeId FROM Opportunity LIMIT 1];
newOrppRecord.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();
update newOrppRecord;
List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
userList[0].SiteCode__c = '7128';
update userList;
Product2 prodRecord=[SELECT Id,Name FROM Product2 LIMIT 1];
Test.startTest();
Map<String, String> strmap=OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
Test.stopTest();
}

@isTest
public static void testSaveOpportunityLineItem_Merchant(){
Opportunity newOrppRecord = [SELECT Id,Name,RecordTypeId FROM Opportunity LIMIT 1];
newOrppRecord.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Merchant_Onboarding').getRecordTypeId();
update newOrppRecord;
List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
userList[0].SiteCode__c = '7128';
update userList;
Product2 prodRecord=[SELECT Id,Name FROM Product2 LIMIT 1];
Test.startTest();
Map<String, String> strmap =OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
Test.stopTest();
}

@isTest
static void testSaveOpportunityLineItem_Merchant_NoSiteCode(){
Opportunity newOrppRecord = [SELECT Id,Name,RecordTypeId FROM Opportunity LIMIT 1];
newOrppRecord.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Merchant_Onboarding').getRecordTypeId();
update newOrppRecord;
List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
userList[0].SiteCode__c = null;
update userList;
Product2 prodRecord=[SELECT Id,Name FROM Product2 LIMIT 1];
Test.startTest();
Map<String, String> strmap =OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
Test.stopTest();
}

@isTest
public static void testSaveOpportunityLineItem_CPF(){
Opportunity newOrppRecord = [SELECT Id,Name,RecordTypeId FROM Opportunity LIMIT 1];
newOrppRecord.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('CPF_Onboarding').getRecordTypeId();
update newOrppRecord;
List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
userList[0].SiteCode__c = '7128';
update userList;
Product2 prodRecord=[SELECT Id,Name FROM Product2 where name='CPF Above R5 Million'];
Test.startTest();
Map<String, String> strmap=OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
Test.stopTest();
}

@isTest
public static void testGetAbsaSite(){
List<User> users = new Usersselector().userwithSiteCode(UserInfo.getUserId());
users[0].SiteCode__c = '7128';
update users;
Opportunity newOrppRecord = [SELECT Id,Name, SiteCode__c FROM Opportunity LIMIT 1];
//Assign the opportunity to the user
newOrppRecord.OwnerId =  users[0].Id;
Test.startTest();
String siteCode = OnboardingProductInformationController.getAbsaSite(newOrppRecord.Id);
system.assertNotEquals(null, siteCode);
Test.stopTest();
}

@isTest
public static void testGetAbsaSite_NoSiteCode(){
Opportunity newOrppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
newOrppRecord.SiteCode__c = null;
update newOrppRecord;
Test.startTest();
String siteCode = OnboardingProductInformationController.getAbsaSite(newOrppRecord.Id);
system.assertNotEquals(null, siteCode);
Test.stopTest();
}

//added this method for getOpportunityLineItem method on the controller class
@isTest static void getOpportunityLineItemTest() {
//get Product Onboarding recordType Id
Id productOnbaordingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();
//Create savings product
Product2 savingsProd = new Product2(Name = 'Savings Product', Family = 'Savings');
insert savingsProd;
//Create the pricebook entry for savings
PricebookEntry savingsCustomPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = savingsProd.Id, UnitPrice = 12000, IsActive = true);
insert savingsCustomPrice;
//Get the account record
Account acc = [SELECT Id, Name FROM Account LIMIT 1];
//Create opportunity for Savings
Opportunity testSavingsOpp = new Opportunity();
testSavingsOpp.Name = 'Saving Test Opp Onboarding';
testSavingsOpp.CloseDate = Date.today();
testSavingsOpp.StageName = 'New';
testSavingsOpp.Pricebook2Id = Test.getStandardPricebookId();
testSavingsOpp.AccountId = acc.id;
testSavingsOpp.RecordTypeId = productOnbaordingRecordTypeId;
testSavingsOpp.Control_Officer_Type__c = 'SALES – CONSULTANT';
testSavingsOpp.CheckMandatoryDocuments__c = true;
testSavingsOpp.QA_Complex_Approval_Status__c = 'Approved';
testSavingsOpp.Control_Officer_Number__c = '12343';
insert testSavingsOpp;
//Create the OpportunityLineItems for savings
OpportunityLineItem savingsOppLinItem = new OpportunityLineItem(
OpportunityId = testSavingsOpp.Id,
Quantity = 5,
PricebookEntryId = savingsCustomPrice.Id,
TotalPrice = 5 * savingsCustomPrice.UnitPrice,
Policy_Number__c = '4048345979'
);
insert savingsOppLinItem;

//Change opportunity StageName to Closed

//testSavingsOpp.StageName = 'Closed';
//update testSavingsOpp;

//Get the opportunity record
Opportunity newOrppRecord = [SELECT Id, Name FROM Opportunity LIMIT 1];

//Get the product record
Product2 prodRecord = [SELECT Id,Name FROM Product2 LIMIT 1];

//Create the pricebook entry
PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prodRecord.Id, UnitPrice = 12000, IsActive = true);
insert customPrice;

//Create the OpportunityLineItems
OpportunityLineItem oli = new OpportunityLineItem(
OpportunityId = newOrppRecord.Id,
Quantity = 5,
PricebookEntryId = customPrice.Id,
TotalPrice = 5 * customPrice.UnitPrice,
Policy_Number__c = '4048358221'
);
insert oli;

Test.startTest();
OpportunityLineItem opplinetime=OnboardingProductInformationController.getOpportunityLineItem(newOrppRecord.Id);
system.assertNotEquals(null, opplinetime);
//Cheque Domicile change
//DomicileChange chequeDomicileUpdate = new DomicileChange(newOrppRecord.Id);
//System.enqueueJob(chequeDomicileUpdate);

//Savings Domicile change
//DomicileChange savingsDomicileUpdate = new DomicileChange(testSavingsOpp.Id);
//System.enqueueJob(savingsDomicileUpdate);

Test.stopTest();
}
/*
@isTest static void deleteLockoutPositiveTest(){
//get the created opportunity
Opportunity opportunity = [SELECT Id, Name FROM Opportunity LIMIT 1];

Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CIdeleteFromFICALockoutV1_IH_v1_Test.POSITIVE_RESPONSE_BODY));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIdeleteFromFICALockoutV1_IH_v1.INTEGRATION_SERVICE_NAME});
//IntegrationTestDataFactory.insertIntegrationTranslations();

//call the queueable class
test.startTest();
DelFromFicaLockout deleteFicaLockout = new DelFromFicaLockout(opportunity.Id);
System.enqueueJob(deleteFicaLockout);
test.stopTest();
}

@isTest static void deleteLockoutNegativeTest(){

//get the created opportunity
Opportunity opportunity = [SELECT Id, Name FROM Opportunity LIMIT 1];

Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, '{}'));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIdeleteFromFICALockoutV1_IH_v1.INTEGRATION_SERVICE_NAME});
//IntegrationTestDataFactory.insertIntegrationTranslations();

//call the queueable class
test.startTest();
DelFromFicaLockout deleteFicaLockout = new DelFromFicaLockout(opportunity.Id);
System.enqueueJob(deleteFicaLockout);
test.stopTest();
}
*/

@isTest static void chequeDigitalHoldUpdatePositiveTest(){
//Get the opportunity record
Opportunity newOrppRecord = [SELECT Id, Name FROM Opportunity LIMIT 1];

//Get the product record
Product2 prodRecord = [SELECT Id,Name FROM Product2 LIMIT 1];

//Create the pricebook entry
PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prodRecord.Id, UnitPrice = 12000, IsActive = true);
insert customPrice;

//Create the OpportunityLineItems
OpportunityLineItem oli = new OpportunityLineItem(
OpportunityId = newOrppRecord.Id,
Quantity = 5,
PricebookEntryId = customPrice.Id,
TotalPrice = 5 * customPrice.UnitPrice,
Policy_Number__c = '4048358221'
);
insert oli;

Test.setMock(HttpCalloutMock.class, new CQupdAcctHoldsV4_Mock_Api(StringConstants.POSITIVE_STRING));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_UPDATE_ACCOUNT_HOLDS});

test.startTest();
Map<Opportunity, List<Sys_Log_Integration__c>> digiMapList = DigitalHoldUpdate.digitalHoldUpdateCall(newOrppRecord);
system.assertNotEquals(null, digiMapList);
test.stopTest();
}

@isTest static void savingsDigitalHoldUpdatePositiveTest(){

//get Product Onboarding recordType Id
Id productOnbaordingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();

//Create savings product
Product2 savingsProd = new Product2(Name = 'Savings Product', Family = 'Savings');
insert savingsProd;

//Create the pricebook entry for savings
PricebookEntry savingsCustomPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = savingsProd.Id, UnitPrice = 12000, IsActive = true);
insert savingsCustomPrice;

//Get the account record
Account acc = [SELECT Id, Name FROM Account LIMIT 1];

//Create opportunity for Savings
Opportunity testSavingsOpp = new Opportunity();
testSavingsOpp.Name = 'Saving Test Opp Onboarding';
testSavingsOpp.CloseDate = Date.today();
testSavingsOpp.StageName = 'New';
testSavingsOpp.Pricebook2Id = Test.getStandardPricebookId();
testSavingsOpp.AccountId = acc.id;
testSavingsOpp.RecordTypeId = productOnbaordingRecordTypeId;

insert testSavingsOpp;

//Create the OpportunityLineItems for savings
OpportunityLineItem savingsOppLinItem = new OpportunityLineItem(
OpportunityId = testSavingsOpp.Id,
Quantity = 5,
PricebookEntryId = savingsCustomPrice.Id,
TotalPrice = 5 * savingsCustomPrice.UnitPrice,
Policy_Number__c = '4048345979'
);
insert savingsOppLinItem;

Test.setMock(HttpCalloutMock.class, new SVupdateAccountHoldsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_UPDATE_ACCOUNT_HOLDS});

test.startTest();
Map<Opportunity, List<Sys_Log_Integration__c>> digiMapList = DigitalHoldUpdate.digitalHoldUpdateCall(testSavingsOpp);
system.assertNotEquals(null, digiMapList);
test.stopTest();
}

@isTest static void chequeDomicileChangePositiveTest(){
//Get the opportunity record
Opportunity newOrppRecord = [SELECT Id, Name FROM Opportunity LIMIT 1];

//Get the product record
Product2 prodRecord = [SELECT Id,Name FROM Product2 LIMIT 1];

//Create the pricebook entry
PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prodRecord.Id, UnitPrice = 12000, IsActive = true);
insert customPrice;

//Create the OpportunityLineItems
OpportunityLineItem oli = new OpportunityLineItem(
OpportunityId = newOrppRecord.Id,
Quantity = 5,
PricebookEntryId = customPrice.Id,
TotalPrice = 5 * customPrice.UnitPrice,
Policy_Number__c = '4048358221'
);
insert oli;

Test.setMock(HttpCalloutMock.class, new CqUpdAcctDomicileChangev2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE_STRING});

test.startTest();
Map<Opportunity, List<Sys_Log_Integration__c>> digiMapList = DigitalHoldUpdate.digitalHoldUpdateCall(newOrppRecord);
system.assertNotEquals(null, digiMapList);
test.stopTest();
}

@isTest static void savingsDomicileChangePositiveTest(){
//get Product Onboarding recordType Id
Id productOnbaordingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();

//Create savings product
Product2 savingsProd = new Product2(Name = 'Savings Product', Family = 'Savings');
insert savingsProd;

//Create the pricebook entry for savings
PricebookEntry savingsCustomPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = savingsProd.Id, UnitPrice = 12000, IsActive = true);
insert savingsCustomPrice;

//Get the account record
Account acc = [SELECT Id, Name FROM Account LIMIT 1];

//Create opportunity for Savings
Opportunity testSavingsOpp = new Opportunity();
testSavingsOpp.Name = 'Saving Test Opp Onboarding';
testSavingsOpp.CloseDate = Date.today();
testSavingsOpp.StageName = 'New';
testSavingsOpp.Pricebook2Id = Test.getStandardPricebookId();
testSavingsOpp.AccountId = acc.id;
testSavingsOpp.RecordTypeId = productOnbaordingRecordTypeId;

insert testSavingsOpp;

//Create the OpportunityLineItems for savings
OpportunityLineItem savingsOppLinItem = new OpportunityLineItem(
OpportunityId = testSavingsOpp.Id,
Quantity = 5,
PricebookEntryId = savingsCustomPrice.Id,
TotalPrice = 5 * savingsCustomPrice.UnitPrice,
Policy_Number__c = '4048345979'
);
insert savingsOppLinItem;

Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, SVChangeAccountDomcileBranch_IH_v1_Test.POSITIVE_RESPONSE_BODY));
IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SVChangeAccountDomcileBranch_IH_v1.INTEGRATION_SERVICE_NAME});

test.startTest();
Map<Opportunity, List<Sys_Log_Integration__c>> digiMapList = DigitalHoldUpdate.digitalHoldUpdateCall(testSavingsOpp);
system.assertNotEquals(null, digiMapList);
test.stopTest();
}

@isTest
private static void testPackageProduct(){

test.startTest();
Product2 prodRecord = [SELECT Id,Name FROM Product2 Where Name like '%Package%'];
Opportunity newOrppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
Map<String, String> strmap=OnboardingProductInformationController.saveOpportunityLineItem(newOrppRecord.Id, prodRecord.Id);
system.assertNotEquals(null, strmap);
test.stopTest();
}
}