/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-24-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public with sharing class EntityInformationStokvelController {
/**
* @description callScreening
* @return String
* @param accountID
*/
    @AuraEnabled
    public static String callScreening(id accountID){
      
      List<Account> account = [SELECT Client_Group__c, Name, Country_of_Foreign_tax__c, Country_of_Registration__c, Country_of_Incorporation__c FROM account WHERE ID = :accountID  WITH SECURITY_ENFORCED];
      String  clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP,  account[0].Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
      String  nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING,  account[0].Country_of_Foreign_tax__c, StringConstants.OUTBOUND_RECORD_TYPE);
      String  cntryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING,  account[0].Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
      String  cntryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING,  account[0].Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
     
        CASAScreenPrimaryClientV7_Req_IB_v1 requestBean = CASAScreenPrimaryClientV7_Req_IB_v1.GetInstance();  
        requestBean.firstName = '';
        requestBean.surnameComp =  account[0].Name;
        requestBean.idType = '';
        requestBean.idRegNo = '';
        requestBean.clientTypeGrp = clientTypeGrpTranslated;
        requestBean.dob = null;//account.PersonBirthdate;
        requestBean.nationality = nationalityTranslated;
        requestBean.town = '';
        requestBean.territory = '';
        requestBean.cntryOfRes = cntryOfResTranslated;
        requestBean.cntryOfBirth = cntryOfIncorporationTranslated;
        requestBean.registerCity = '';
        requestBean.countryPassport = '';
        requestBean.headofficeTown = '';
        requestBean.headofficeCntry = '';
        requestBean.headofficeOtherCntry1 = '';
        requestBean.headofficeOtherCntry2 = '';
        requestBean.headofficeOtherCntry3 = '';
        requestBean.headofficeOtherCntry4 = '';
        requestBean.headofficeOtherCntry5 = '';
        requestBean.sbu = 'F';
        requestBean.originatingSys = 'BDP';
      //  System.debug('CASA requestBean  '+  JSON.serializePretty( requestBean));
        CASAScreenPrimaryClientV7_Resp_IB_v1 response = CASAScreenPrimaryClientV7_IH_v1.CASAScreenPrimaryClientV7(requestBean);
		
        return JSON.serialize(response);
    }
    
        /**

* @description callScreening
* @return String
* @param developerName
*@param sobjectName
*/
    @AuraEnabled
    public static String getRecordTypeId(String developerName, String sobjectName){
        String recordTypeId = '';
        List<RecordType> newRecordTpeList= [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE DeveloperName =: developerName AND SobjectType =: sobjectName WITH SECURITY_ENFORCED];
        if(!newRecordTpeList.isEmpty()){
            recordTypeId = newRecordTpeList[0].Id;
        }
        return recordTypeId;
    }
    /**
    * @description getTranslationValues
    * @return Map<String,String>
    * @param systemName
    * @param valueType
    * @param direction
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static Map<String,String> getTranslationValues(String systemName, String valueType, String direction, sObject objObject, string objField)
    {
        return BranchFunctions.getValidTranslations(systemName, valueType, direction, objObject, objField);
    }

}