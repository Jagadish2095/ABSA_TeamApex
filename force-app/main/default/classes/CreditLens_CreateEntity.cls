/**
 * @description       : Class to create, map and post CL Entity
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 12-08-2021
 * @last modified by  : Tawanda M.
 **/
public class CreditLens_CreateEntity {
    /**
   * @description Custom Exception
   * @author Tawanda M. | 07-20-2021
   **/
    public class entityCreateException extends Exception{}

    /**
   * @description Mapper class to read in JSON from metadata object for entity types
   * @author Tawanda M. | 07-20-2021
   **/
    public class EntityTypeMapper{
        @AuraEnabled
        public String CustomerOneEntityType;
        @AuraEnabled
        public String ClientTypeOnCreditLens;
        @AuraEnabled
        public String EntityTypeNameOnCL;
        @AuraEnabled
        public String FirmType;
    }

  /**
   * @description Method to execute mapping and callout
   * @author Tawanda M. | 10-26-2021
   * @param CIF
   * @return Integer
   **/
  public static Integer createEntity(String CIF) {
      try{        
        //Get relevant account
        List<Account> account = [Select Id, Name, CIF__c, CurrencyIsoCode, Trading_Name__c, Sic, Standard_Industry_SIC_Code__c, Client_Type__c, Place_of_Residence__c from Account where CIF__c =: CIF];
        if(!account.isEmpty()){
          //Check Mappings
          String entityType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CreditLens', 'Client Type', account[0].Client_Type__c, 'Outbound');
          String firmType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CreditLens', 'Firm Type', account[0].Client_Type__c, 'Outbound');
          //Default if not found
          if(entityType == null){
            entityType = '001';
          }

          if(firmType == null){
            firmType = 'PRV';
          }
          else{
            firmType = (firmType == 'Public') ? 'PUB' : 'PRV';
          }
          
          //Check SIC
          String sicCodeTranslated;
          String finalSicCode;
          if(account[0].Sic != null){
            finalSicCode = account[0].Sic;
          }
          else if(account[0].Standard_Industry_SIC_Code__c != null){
            sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Standard Industry SIC Code', (account[0].Standard_Industry_SIC_Code__c), 'Outbound');
            finalSicCode = sicCodeTranslated;
          }
          else{
            throw new entityCreateException('Account with CIF '+CIF+' does not have a valid SIC Code assigned to it.');
          }

          String INTEGRATION_SERVICE_NAME = 'EntityCreate';
          String tradingName = (account[0].Trading_Name__c != null) ? account[0].Trading_Name__c : account[0].Name;
          //TODO: Get field mappings entries from Karien, work with hard coded values for now
          //TODO: Get feedback from adrian about the country code mappings here
          CreditLens_Create_Entity_Req_IB_v1 entityObject = new CreditLens_Create_Entity_Req_IB_v1(entityType, tradingName, 'Commercial', 'Commercial', account[0].Name, account[0].Id, getPlaceOfResidence(account[0].Place_of_Residence__c), 'ZAF', account[0].CIF__c , firmType, 'ZAF', 'ZAR', finalSicCode);
          System.debug(JSON.serialize(entityObject));
          CreditLens_Create_Entity_Resp_IB_v1 responseBean = (CreditLens_Create_Entity_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
          entityObject,
          null,
          INTEGRATION_SERVICE_NAME,
          CreditLens_Create_Entity_Resp_IB_v1.class
          );
          //Check response and return EntityId (responseBean.payload[0].EntityId)
          if(responseBean.statusCode == 200 || responseBean.statusCode == 201){
            return responseBean.payLoad[0].EntityId;
          }
          else if(responseBean.message != null && responseBean.message != ''){
            throw new entityCreateException(responseBean.message);
          }
          else{
            throw new entityCreateException('CreditLens entity creation for CIF number: '+CIF+' has failed.');
          }
        }
        else{
            throw new entityCreateException('There are no accounts on Customer One with this CIF number: '+CIF);
        }
      }
      catch(Exception e){
        throw new entityCreateException(e.getMessage());
      }
  }

  /**
  * @description Get CL mapping for place of residence
  * @author Tawanda M. | 12-02-2021 
  * @param placeOfResidence 
  * @return Integer 
  **/
  public static Integer getPlaceOfResidence(String placeOfResidence){
    switch on placeOfResidence {
      when 'South African Resident' {		
          return 1;
      }	
      when 'Temp Resident' {		
          return 2;
      }
      when 'Nambi/Les/Swazi' {		
          return 3;
      }
      when 'Non - Resident' {		
          return 4;
      }
      when else {		  
          return 1;
      }
    }
  }
}