/**
 * @description Extension Controller for CPFSecurityCessions & CPFSecurityCessionsExisting Component
 * @author Diksha Wasekar : Absa 
 * @version v1.0
 * @since   2021-1-02
 *
 */
public class CPFSecurityCessionsCon {

/**
*  @description Method to get Application_Security_CPF__c
*  @param oppId
*  @return List<Application_Security_CPF__c>
*/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getSecurityofferedRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'Security Cession');
return securityofferedList;
}

/**
*  @description Method to insert Application_Security_CPF__c
*  @param recId
*  @param securitycessionslst
*  @return List<Application_Security_CPF__c>
*/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertNewSecurityCessionsCpfRec(Id recId,List<Application_Security_CPF__c> securitycessionslst) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if(appPrdctCpf!=null){
List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'Security Cession');
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Security_CPF__c securityobj : securitycessionslst) {
securityobj.Id= null;
securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
securityobj.Category__c='Security Cession';
securityobj.Security_Class__c ='New';
}
insert securitycessionslst;
}
return securitycessionslst;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}
//Added by Rajesh for Existing Securities Start
/**
*  @description Method to insert Application_Security_CPF__c for Existing Type 
*  @param oppId
*  @return List<Application_Security_CPF__c>
*/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getExistingSecurityofferedRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'Security Cession Existing');
return securityofferedList;
}

/**
*  @description Method to insert Application_Security_CPF__c for Existing Type 
*  @param recId
*  @param securitycessionslst
*  @return List<Application_Security_CPF__c>
*/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertExistingSecurityCessionsCpfRec(Id recId,List<Application_Security_CPF__c> securitycessionslst) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if(appPrdctCpf!=null){
List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'Security Cession Existing');
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Security_CPF__c securityobj : securitycessionslst) {
securityobj.Id= null;
securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
securityobj.Category__c='Security Cession Existing';
securityobj.Security_Class__c ='Existing';
}
insert securitycessionslst;
}
system.debug('securitycessionslist'+securitycessionslst);
return securitycessionslst;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}
//Added by Rajesh for Existing Securities End

}