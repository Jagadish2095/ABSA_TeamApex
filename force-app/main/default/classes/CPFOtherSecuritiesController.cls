/**
 * @description       :Controller for CPFOtherSecurities component
 * @author            :Tinashe/Rajesh
 * @last modified on  : 2021-07-09
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-08      Initial Version
**/
public class CPFOtherSecuritiesController{
/**
* @description Method to get Application_Security_CPF__c rec based on securityclass
* @author  | 2021-06-08 
* @param oppId 
* @param securityclass 
* @return LIST<Application_Security_CPF__c> 
**/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getSecurityofferedRec(Id oppId,String securityclass){
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
List<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other','Other security',securityclass);
return securityofferedList;
}

/**
* @description Method to insert Application_Security_CPF__c of type other and new category
* @author  | 2021-06-08
* @param recId
* @param securitycessionslst
* @return list<Application_Security_CPF__c>
**/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertNewSecurityCessionsCpfRec(Id recId, List<Application_Security_CPF__c> securitycessionslst){
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if (appPrdctCpf != null){

    List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other','Other security','New');
if (!dellist.isEmpty()){
delete dellist;
}
for (Application_Security_CPF__c securityobj : securitycessionslst){
securityobj.Id = null;
securityobj.Application_Product_CPF__c = appPrdctCpf.Id;
securityobj.Category__c = 'Other';
securityobj.Type__c='Other security';
securityobj.Security_Class__c = 'New';
}
insert securitycessionslst;

}
return securitycessionslst;
} catch (Exception e){
system.debug(e.getMessage());
return null;
}
}

/**
* @description Added by Rajesh to get Existing Securities
* @author  | 2021-06-08
* @param oppId
* @return LIST<Application_Security_CPF__c>
**/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getExistingSecurityofferedRec(Id oppId){
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Other','Existing');
return securityofferedList;
}

/**
* @description Added by Rajesh for inserting Existing Securities
* @author  | 2021-06-08
* @param recId
* @param securitycessionslst
* @return list<Application_Security_CPF__c>
**/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertExistingSecurityCessionsCpfRec(Id recId, List<Application_Security_CPF__c> securitycessionslst){
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if (appPrdctCpf != null){

    List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other','Other security','Existing');
    // new ApplicationSecurityCPFSelector().selectByAppPrdctId(appPrdctCpf.Id, 'Other');
if (!dellist.isEmpty()){
delete dellist;
}
for (Application_Security_CPF__c securityobj : securitycessionslst){
securityobj.Id = null;
securityobj.Application_Product_CPF__c = appPrdctCpf.Id;
securityobj.Category__c = 'Other';
securityobj.Type__c='Other security';
securityobj.Security_Class__c = 'Existing';

}
insert securitycessionslst;

}
system.debug('securitycessionslist' + securitycessionslst);
return securitycessionslst;
} catch (Exception e){
system.debug(e.getMessage());
return null;
}
}


}