/**
*  @description Extension Controller for CPFLimitedUnlimitedSuretyship Component
* @author  Rajesh : Absa
* @version v1.0
* @since   2021-1-02
*/
public class CPFLimitedUnlimitedSuretyship {

/**
*  @description Method to insert list of Application_Security_CPF__c
*  @param recId
*  @param LimitedSuretylistforExisting
*  @param secSectionsforExisting
*  @return list<Application_Security_CPF__c>
*/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertLimitedExistingCpfRec(Id recId,List<Application_Security_CPF__c> LimitedSuretylistforExisting,string secSectionsforExisting) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if(appPrdctCpf!=null){
List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Suretyship',secSectionsforExisting);
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Security_CPF__c securityobj : LimitedSuretylistforExisting) {
securityobj.Id= null;
securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
securityobj.Category__c='Limited Suretyship';
securityobj.Security_Class__c =secSectionsforExisting;
}
insert LimitedSuretylistforExisting;
}
return LimitedSuretylistforExisting;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}

/**
*  @description Method to get list of Application_Security_CPF__c
*  @param oppId
*  @param secSectionsfetch
*  @return list<Application_Security_CPF__c>
*/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getSecurityofferedRec(Id oppId,string secSectionsfetch) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Suretyship',secSectionsfetch);
return securityofferedList;
}
/**
*  @description Method to insert list of Application_Security_CPF__c
*  @param recId
*  @param UnLimitedSuretyshiplistforExisting
*  @param secSectionsforexisting
*  @return list<Application_Security_CPF__c>
*/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertUnlimitedExistingCpfRec(Id recId,List<Application_Security_CPF__c> UnLimitedSuretyshiplistforExisting,string secSectionsforexisting) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if(appPrdctCpf!=null){

List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'UnLimited Suretyship',secSectionsforexisting);
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Security_CPF__c securityobj : UnLimitedSuretyshiplistforExisting) {
securityobj.Id= null;
securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
securityobj.Category__c='UnLimited Suretyship';
securityobj.Security_Class__c =secSectionsforexisting;
}
insert UnLimitedSuretyshiplistforExisting;
}
return UnLimitedSuretyshiplistforExisting;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}

/**
*  @description Method to get list of Application_Security_CPF__c
*  @param oppId
*  @param secSectionsfetch
*  @return list<Application_Security_CPF__c>
*/
@AuraEnabled
public static LIST<Application_Security_CPF__c> getUnlimitedSecurityofferedRec(Id oppId,string secSectionsfetch) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'UnLimited Suretyship',secSectionsfetch);
return securityofferedList;

}

//Added by Diksha 14/4/2021 For New Limited Suretyship
/**
*  @description Method to get list of Application_Security_CPF__c
*  @param recId
*  @param LimitedSuretylistforNew
*  @param secSectionsforNew
*  @param istheSecurityProvideratrust
*  @return list<Application_Security_CPF__c>
*/
@AuraEnabled
public static list<Application_Security_CPF__c> InsertLimitedNewCpfRec(Id recId,List<Application_Security_CPF__c> LimitedSuretylistforNew,
                                                        string secSectionsforNew, string istheSecurityProvideratrust) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
try{
if(appPrdctCpf!=null){

List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Suretyship',secSectionsforNew);
if(!dellist.isEmpty()) {
delete dellist;
}
for(Application_Security_CPF__c securityobj : LimitedSuretylistforNew) {
securityobj.Id= null;
securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
securityobj.Category__c='Limited Suretyship';
securityobj.Security_Class__c =secSectionsforNew;
}
insert LimitedSuretylistforNew;
appPrdctCpf.Is_the_security_provider_a_trust__c=istheSecurityProvideratrust;
update appPrdctCpf;
}
system.debug('LimitedSuretylistforNew'+LimitedSuretylistforNew);
return LimitedSuretylistforNew;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}

}