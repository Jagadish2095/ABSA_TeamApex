/**
 * @description       : Controller for  CPFConditions Tab
 * @author            :Saranya
 * @last modified on  : 2021-07-29
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
public class CPFConditionsTabSectionscntrlr {
/**
 * @description 
 * @author  | 2021-06-07 
 * @param oppId 
 * @return Application_Product_CPF__c 
 **/
@AuraEnabled
public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
return appPrdctCpf;     

} 
/**
* @description 
* @author  | 2021-06-07 
* @param oppId 
* @return LIST<Application_Contract_Clause__c> 
**/
@AuraEnabled
public static LIST<Application_Contract_Clause__c> getAppContractClauseRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Contract_Clause__c> appConClausecList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Lease');
return appConClausecList;     

} 
/**
* @description 
* @author  | 2021-06-07 
* @param recId 
* @param objData 
* @return Application_Product_CPF__c 
**/
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpfinsertAppContract(Id recId,String objData) {
appProductcpf responseBean=new appProductcpf ();
responseBean= (appProductcpf)JSON.deserialize(objData,appProductcpf.class);

Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
appPrdctCpf.Obligor_incorporated_outside_of_SA__c=responseBean.ObligorincorpoutsideofSA;
appPrdctCpf.Environmental_permits__c=responseBean.Environmentalpermits;
appPrdctCpf.Financial_assistance__c=responseBean.Financialassistance;
appPrdctCpf.Electrical_compliance_certificate__c=responseBean.Electricalcompliancecertificate;
appPrdctCpf.Newly_formed_company__c=responseBean.Newlyformedcompany;
appPrdctCpf.Borrowers_contribution_toward_acquisiti__c=responseBean.Borrowersconvalue;
appPrdctCpf.Purchase_price__c=responseBean.purchasepricevalue;
appPrdctCpf.Pre_let__c=responseBean.Preletval;
appPrdctCpf.Restraint_against_free_alienation_notari__c=responseBean.Restraintagainstfreeval;
appPrdctCpf.Pre_let_review__c=responseBean.Preletreviewval;
appPrdctCpf.Performance_Guarantees__c=responseBean.performanceguaramtees;
appPrdctCpf.Is_Section_82_Certificate__c=responseBean.sectioncerti;
appPrdctCpf.Is_Bank_Contractor_Insurance_Company__c=responseBean.bankcontractorsorinsurancecomp;
appPrdctCpf.Is_Confirmation_From_Architect__c=responseBean.confirmationfrmarchitect;
appPrdctCpf.Is_Structural_Integrity_Certificate__c=responseBean.structuralintegritycerti;
appPrdctCpf.Is_Confirmation_Mech_Elec_Design__c=responseBean.confirmationmechelec;
appPrdctCpf.Is_Fire_Design__c=responseBean.firedesign;
appPrdctCpf.Is_Sufficient_Budget__c=responseBean.sufficientbudget;
appPrdctCpf.Is_Professional_Certificate__c=responseBean.professionalcerti;
appPrdctCpf.Payment_Made_Amount__c=responseBean.valueofpaymade;
appPrdctCpf.Property_description__c=responseBean.propertyDescriptionId;
update appPrdctCpf;
List<Application_Contract_Clause__c> dellist = new  List<Application_Contract_Clause__c>();
dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Lease');
//[select id,name,Description__c,Type__c,Category__c,Application_Product_CPF__c from Application_Contract_Clause__c where Application_Product_CPF__c =: appPrdctCpf.Id];
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Contract_Clause__c finobj : responseBean.leaselist) {
finobj.Id= null;
finobj.Application_Product_CPF__c=appPrdctCpf.Id;
finobj.Type__c='Lease';
finobj.Category__c='CPF Application';
}
insert responseBean.leaselist;

}
return appPrdctCpf;     
}catch(Exception e){
system.debug(e.getMessage());
return null;
} 
}
/**
* @description 
* @author  | 2021-06-07 
* @param recId 
* @param NotariallyTiedConsolidation 
* @param property1val 
* @param property2val 
* @return Application_Product_CPF__c 
**/
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpfNorarially(Id recId,string NotariallyTiedConsolidation,string property1val,string property2val) {
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
appPrdctCpf.Notarially_Tied_Consolidation__c=NotariallyTiedConsolidation;
appPrdctCpf.Property_1__c=property1val;
appPrdctCpf.Property_2__c=property2val;
update appPrdctCpf;

}
return appPrdctCpf;     
}catch(Exception e){
system.debug(e.getMessage());
return null;
} 
}

//

/**
* @description 
* @author  | 2021-06-07 
* @param recId 
* @param furtherlist 
* @return Application_Product_CPF__c 
**/
@AuraEnabled
public static Application_Product_CPF__c furtherAppPrdctcpfinsertAppContract(Id recId,List<Application_Contract_Clause__c> furtherlist) {
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
List<Application_Contract_Clause__c> dellist = new  List<Application_Contract_Clause__c>();
dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Further Condition Precedent');
// [select id,name,Description__c,Type__c,Category__c,Application_Product_CPF__c from Application_Contract_Clause__c where Application_Product_CPF__c =: appPrdctCpf.Id AND Type__c='Further Condition Precedent' ORDER BY Name ASC];
if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
delete dellist;
}
for(Application_Contract_Clause__c finobj : furtherlist) {
finobj.Id= null;
finobj.Application_Product_CPF__c=appPrdctCpf.Id;
finobj.Type__c='Further Condition Precedent';
finobj.Category__c='CPF Application';
}
insert furtherlist;

}
return appPrdctCpf;     
}catch(Exception e){
system.debug(e.getMessage());
return null;
} 
}

/**
* @description 
* @author  | 2021-06-07 
* @param oppId 
* @return LIST<Application_Contract_Clause__c> 
**/
@AuraEnabled
public static LIST<Application_Contract_Clause__c> getAppContractClauseRecForFurtherCond(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Contract_Clause__c> appConClausecList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Further Condition Precedent');
// [Select id,Name,Description__c,Type__c,Category__c,Application_Product_CPF__c from Application_Contract_Clause__c where Application_Product_CPF__r.id=:appPrdctCpf.Id AND Type__c='Further Condition Precedent' ORDER BY Name ASC];
return appConClausecList;     

} 

/**
* @description 
* @author  | 2021-06-07 
* @param recId 
* @param speciallist 
* @return Application_Product_CPF__c 
**/
@AuraEnabled
public static Application_Product_CPF__c specialAppPrdctcpfinsertAppContract(Id recId,List<Application_Contract_Clause__c> speciallist) {
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
List<Application_Contract_Clause__c> dellist = new  List<Application_Contract_Clause__c>();
dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Special Condition');
//[select id,name,Description__c,Type__c,Category__c,Application_Product_CPF__c from Application_Contract_Clause__c where Application_Product_CPF__c =: appPrdctCpf.Id AND Type__c='Special Condition' ORDER BY Name ASC];
if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
delete dellist;
}
for(Application_Contract_Clause__c finobj : speciallist) {
finobj.Id= null;
finobj.Application_Product_CPF__c=appPrdctCpf.Id;
finobj.Type__c='Special Condition';
finobj.Category__c='CPF Application';
}
insert speciallist;

}
return appPrdctCpf;     
}catch(Exception e){
system.debug(e.getMessage());
return null;
} 
}


/**
* @description 
* @author  | 2021-06-07 
* @param oppId 
* @return LIST<Application_Contract_Clause__c> 
**/
@AuraEnabled
public static LIST<Application_Contract_Clause__c> getAppContractClauseRecForSpecialCond(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Contract_Clause__c> appConClausecList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Special Condition');
//[Select id,Name,Description__c,Type__c,Category__c,Application_Product_CPF__c from Application_Contract_Clause__c where Application_Product_CPF__r.id=:appPrdctCpf.Id AND Type__c='Special Condition' ORDER BY Name ASC];
return appConClausecList;     

} 
/**
* @description 
* @author  | 2021-06-07 
* @param oppId 
* @return List<OpportunityLineItem> 
**/
@AuraEnabled
public static List<OpportunityLineItem> getprodName(Id oppId) {
List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
return opplineitemlst;     
}
/** @description Wrapper Class To Map the response from json
*/
public class appProductcpf{
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String ObligorincorpoutsideofSA {get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Environmentalpermits{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Financialassistance{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Electricalcompliancecertificate{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Newlyformedcompany{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public Decimal Borrowersconvalue{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public Decimal purchasepricevalue{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Preletval{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Preletreviewval{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String Restraintagainstfreeval{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public List<Application_Contract_Clause__c> leaselist{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String performanceguaramtees{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String sectioncerti{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String bankcontractorsorinsurancecomp{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String confirmationfrmarchitect{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String structuralintegritycerti{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String confirmationmechelec{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String firedesign{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String sufficientbudget{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public String professionalcerti{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
@auraEnabled public Decimal valueofpaymade{get;set;}
/** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/

@auraEnabled public String propertyDescriptionId{get;set;}
}


}