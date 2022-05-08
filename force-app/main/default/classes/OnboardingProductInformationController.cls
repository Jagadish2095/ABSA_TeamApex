/**
* @description Apex class for OnboardingProductInformation Lightning Component
* @author  Diksha : Absa
* @version v1.0
* @since   2020-02-12
* @update Englarmerdge Mongwe
* @dateUpdated 2020-08-24
* Changed Application_Product_Credit__c to Application_Product__c object
* @update Sipho Mbulawa
* @dateUpdated 2021-01-14
* Removed the jimmyclass method
*/
public class OnboardingProductInformationController {

/**
* @description Method to save all the opportunity products
* @param oppId
* @param productId
* @return Map<String, String>
*/
@AuraEnabled
public static Map<String, String> saveOpportunityLineItem (Id oppId, Id productId){
try{
//deleting of Line items when the replace button is used
//Requested to be included
List<OpportunityLineItem> opp =[Select OpportunityID From OpportunityLineItem WHERE OpportunityId =: oppId];
if(opp.size() > 0){
delete opp;
}

Map<String, String> idsMap = new Map<String, String>();
Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
Application__c application;
Application_Product__c apc;
Application_Product_CPF__c applicationprodCPF; //Added by Diksha 11/23/2020.
OpportunityLineItem opportunityLineItem;
Boolean isError = false;
Product2 selectedProduct = new ProductsSelector().selectById(productId);
List<OpportunityLineItem> listOLI = new List<OpportunityLineItem>();
List<Application_Product__c> listAppPro = new List<Application_Product__c>();
String productName = selectedProduct.Name;

opportunity.Product_Selected_Business_Evolve__c = false;
update opportunity;

system.debug('productName-->'+productName);
If(productName.contains('Package')){
system.debug('In Business Evolve If');


List<Product_Product_Entry__c> allChildProducts = new ProductProductEntriesSelector().selectByParentProductId(productId);

application = new Application__c();
application.Opportunity__c = oppId;

INSERT application;

for(Product_Product_Entry__c childProduct : allChildProducts)  {
opportunityLineItem = new OpportunityLineItem();
opportunityLineItem.OpportunityId = oppId;
opportunityLineItem.Product2Id = childProduct.Related_Product__c;
opportunityLineItem.TotalPrice = 0;
opportunityLineItem.Quantity = 1;
opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(childProduct.Related_Product__c);
listOLI.add(opportunityLineItem);


}

insert listOLI;

For (opportunityLineItem createAppProd: listOLI){
apc = new Application_Product__c();
apc.Opportunity_Product_Id__c  =  createAppProd.Id;
apc.Cash_Flow_Manager__c = TRUE;
apc.Application__c = application.Id;
listAppPro.add(apc);

}

insert listAppPro;

List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
if(userList[0].SiteCode__c != null) {
opportunity.SiteCode__c = userList[0].SiteCode__c;
idsMap.put('userSite', userList[0].SiteCode__c);}
opportunity.SelectedProduct__c = productName;
opportunity.Product_Selected_Business_Evolve__c = TRUE;
update opportunity;
system.debug('opportunity.Product_Selected_Business_Evolve__c--->'+opportunity.Product_Selected_Business_Evolve__c);
}
// T Senkomane: June 2020: If Opportunity is Credit Onboarding then,
// create Applicaiton and Appliction Product
else If (opportunity.RecordType.Name == Label.Credit_Onboarding ) {
application = new Application__c();
application.Opportunity__c = oppId;
INSERT application;

apc = new Application_Product__c();
apc.Opportunity_Product_Id__c = oppId;
apc.Opportunity__c = oppId;
apc.Application__c = application.id;
INSERT apc;
idsMap.put('applicationId', application.Id);
//Set the approval field to Sanctioning for Credit Onboarding
//opportunity.Trigger_Approval_Process__c = 'Sanctioning';
opportunity.Application_Number__c = application.Name;
opportunity.Product_Selected_Business_Evolve__c = false;
update opportunity;
}else if (opportunity.RecordType.Name == 'Credit Maintenance') {
// create Applicaiton and Appliction Product for Credit Covid-19
apc = new Application_Product__c();
apc.Opportunity_Product_Id__c = oppId;
apc.Opportunity__c = oppId;
insert apc;
application = new Application__c();
application.Opportunity__c = oppId;
insert application;
idsMap.put('applicationId', application.Id);
opportunity.Application_Number__c = application.Name;
update opportunity;
}
// PJAIN: 20200403: If Opportunity is Merchant Onboarding then, do not
// create Applicaiton record. Applicaiton and Appliction Product - Merchant
// records will be created after Quote Approval
else if (opportunity.RecordType.Name != Label.Merchant_Onboarding) {
application = new Application__c();
application.Opportunity__c = oppId;
INSERT application;
idsMap.put('applicationId', application.Id);

// Update Opportunity Sales Stage
opportunity.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
//product2 product = [Select id,Name from Product2 where id =: productId limit 1];
Set<Id> idSet = new Set<Id>();
idSet.add(productId); //W-004819 Anka Ganta
ProductsSelector productSel = new ProductsSelector();//W-004819 Anka Ganta
List<Product2> productList = productSel.selectById(idSet);//W-004819 Anka Ganta
if(productList[0].Name != null){//W-004819 Anka Ganta
opportunity.SelectedProduct__c = productList[0].Name; //W-004819 Anka Ganta
}//W-004819 Anka Ganta

}

else {

List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());

if(userList[0].SiteCode__c != null) {
opportunity.SiteCode__c = userList[0].SiteCode__c;
idsMap.put('userSite', userList[0].SiteCode__c);
// Update Opportunity Sales Stage
opportunity.StageName = StringConstants.OPPORTUNITY_STAGE_ACCEPT_QUOTE;

Set<Id> idSet = new Set<Id>();//W-004819 Masechaba Maseli
idSet.add(productId);//W-004819 Masechaba Maseli
ProductsSelector productSel = new ProductsSelector();//W-004819 Masechaba Maseli
List<Product2> productList = productSel.selectById(idSet);//W-004819 Masechaba Maseli
if(productList[0].Name != null) {//W-004819 Masechaba Maseli
opportunity.SelectedProduct__c = productList[0].Name; //W-004819 Masechaba Maseli
}//W-004819 Masechaba Maseli
}
else {
isError = true;
idsMap.put('error', StringConstants.MERCHANT_ERROR_USER_SITE_CODE_NOT_FOUND);
}

}
if(!isError) {
// Insert new Opportunity Product
opportunityLineItem = new OpportunityLineItem();
opportunityLineItem.OpportunityId = oppId;
opportunityLineItem.Product2Id = productId;
opportunityLineItem.TotalPrice = 0;
opportunityLineItem.Quantity = 1;
opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(productId);
if (application != null) {
opportunityLineItem.Application__c = application.Id;
}
insert opportunityLineItem;
idsMap.put('opportunityProductId', opportunityLineItem.Id);
//Added by Diksha for W-7925
if (opportunity.RecordType.Name == Label.CPF_Onboarding) {
applicationprodCPF = new Application_Product_CPF__c();
applicationprodCPF.Opportunity_Product_Id__c=opportunityLineItem.id;
applicationprodCPF.Application__c=application.Id;
insert applicationprodCPF;
idsMap.put('applicationprodcpfId', applicationprodCPF.Id);
//W-01170 Diksha Wasekar added for updating opportunity sub product field with CPF product name
Set<Id> idSet = new Set<Id>();
idSet.add(productId);
ProductsSelector productSel = new ProductsSelector();
List<Product2> productList = productSel.selectById(idSet);
if(productList[0].Name != null) {
opportunity.Sub_Product__c =productList[0].Name;
update opportunity;
}
}

}

return idsMap;

}
catch (Exception e) {
System.debug('OnboardingProductInformationController.saveOpportunityLineItem. Exception: ' + e);
throw new AuraHandledException('Something went wrong: '+ e);
}
}

/**
* @description Method to show products after refresh
* @param oppId
* @return String
*/
@AuraEnabled
public static String getAbsaSite (Id oppId) {

Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
List<User> getUsers = new Usersselector().userwithSiteCode(UserInfo.getUserId());

if(getUsers[0].SiteCode__c != null) {
opportunity.SiteCode__c = getUsers[0].SiteCode__c;
update opportunity;
return opportunity.SiteCode__c;
}
else {
return StringConstants.MERCHANT_ERROR_OPPORTUNITY_SITE_CODE_NOT_FOUND;
}

/*Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
if(opportunity.SiteCode__c != null){
return opportunity.SiteCode__c;
}else{
return StringConstants.MERCHANT_ERROR_OPPORTUNITY_SITE_CODE_NOT_FOUND;
}*/
}

/**
* @description Method to show products after refresh
* @param oppId
* @return OpportunityLineItem
*/
@AuraEnabled
public static OpportunityLineItem getOpportunityLineItem (Id oppId){
/*Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
OpportunityLineItem oli = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
System.debug('testing++'+oli.Product2.Name);
if(oli.Product2.Name != null){
opportunity.SelectedProduct__c = oli.Product2.Name;
}else{
opportunity.SelectedProduct__c = '';
}

update opportunity;

return oli;*/

return new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
}

/** Thulani
* @description Method to Update Illustrative Decision
* @param oppId
* @param illustrativeDecision
*/
@AuraEnabled
public static void updateIllustrativeDecision (Id oppId, Boolean illustrativeDecision) {
Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
try{
if(opportunity != null){
opportunity.Illustrative_Decision__c = illustrativeDecision;
update opportunity;
}
}
catch(Exception ex){
throw new AuraException('Fail to update opprtunity ');
}
}
/**
* @description Method to get opps fields
* @param  recordId
* @return String
*/
@AuraEnabled
public static String getOppsFields(Id recordId){
List<Opportunity> opportunity  = new OpportunitiesSelector().selectByOpportunityId(recordId);
//  return  opportunity;
return '{"CASA_Reference_Number":"'+opportunity[0].CASA_Reference_Number__c+'","CasaRating":"'+opportunity[0].Risk_Rating__c+'"}';
}

/** Added By Himani Joshi
* @description Method to get opp rec
* @param  oppId
* @return Opportunity
*/
@AuraEnabled
public static Opportunity getOpportunity(Id oppId) {
Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
return opportunity;

}
}