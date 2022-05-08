/**
 * @description       : Selector class for Application Exposure Risk
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-07
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-07   Himani Joshi   Initial Version
**/

public class ApplicationExposureRiskSelector extends fflib_SObjectSelector {
   /**
   * @description : Method which returns the sobject type
   * @author Himani Joshi | 2021-06-07 
   * @return Schema.SObjectType 
   **/
   public Schema.SObjectType getSObjectType(){
      return Application_Exposure_Risk__c.sObjectType;
   }
    
  /**
  * @description : Method which returns the field list
  * @author Himani Joshi | 2021-06-07 
  * @return List<Schema.SObjectField> 
  **/
  public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            
                Application_Exposure_Risk__c.Id
                
                };
      }
     
    /**
    * @description : Method which gets application exposure risks
    * @author Himani Joshi | 2021-06-07 
    * @param clientCode 
    * @param applicationId 
    * @return List<Application_Exposure_Risk__c> 
    **/
    public List<Application_Exposure_Risk__c> getApplicationExposureRisks(string clientCode,Id applicationId) {
      return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Risk_Grade__c').
            selectField('Worst_Risk_Grade__c').
            setCondition('Client_Code__c =: clientCode AND Application__c =:applicationId').
            toSOQL()
        ); 
    }
    /**
    * @description : Method which orders by risk grade
    * @author Himani Joshi | 2021-06-07 
    * @param applicationId 
    * @param clientCodes 
    * @return List<Application_Exposure_Risk__c> 
    **/
    public List<Application_Exposure_Risk__c> orderByRiskGrade(Id applicationId,Set<String>clientCodes) {
        return [SELECT Id, Risk_Grade__c, Client_Name__c,Client_Code__c, LastModifiedDate,Risk_Identifier__c
                FROM Application_Exposure_Risk__c 
                                     WHERE Application__c =: applicationId and Client_Code__c In :clientCodes
                                     ORDER BY Risk_Grade__c DESC];
        
    }
    
   /**
   * @description : Method which orders by sequence number
   * @author Himani Joshi | 2021-06-07 
   * @param applicationId 
   * @param clientCodes 
   * @return List<Application_Exposure_Risk__c> 
   **/
   public List<Application_Exposure_Risk__c> orderBySequenceNumber(Id applicationId,Set<String>clientCodes) {
       return [SELECT Id, Risk_Grade__c, Client_Name__c,Client_Code__c, LastModifiedDate,Business_Rescue_Affected_Party__c,
                Early_Warning_Listing__c,Forensic_Fraud_Indicator__c,In_Business_Rescue__c,In_Liquidation__c,SequenceNumber__c,Worst_Arms_Hold_Code__c,
                Worst_Collection_Risk_Type__c,Worst_risk_PCO__c,Risk_Identifier__c
                                     FROM Application_Exposure_Risk__c 
                                     WHERE Application__c =: applicationId and Client_Code__c IN :clientCodes
                                     ORDER BY SequenceNumber__c DESC];
       
    }
    
     /**
     * @description : Method which gets all exposure risks based on application Id
     * @author Himani Joshi | 2021-06-07 
     * @param applicationId 
     * @return List<Application_Exposure_Risk__c> 
     **/
     public List<Application_Exposure_Risk__c> getAllApplicationExposureRisk(Id applicationId) {
      return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Client_Name__c').
            selectField('Client_Code__c').
            selectField('LastModifiedDate').
            selectField('Business_Rescue_Affected_Party__c').
            selectField('Early_Warning_Listing__c').
            selectField('Forensic_Fraud_Indicator__c').
            selectField('In_Business_Rescue__c').
            selectField('In_Liquidation__c').
            selectField('Risk_Grade__c').
            selectField('Risk_Identifier__c').
            selectField('SequenceNumber__c').
            selectField('Worst_Arms_Hold_Code__c').
            selectField('Worst_Collection_Risk_Type__c').
            selectField('Worst_risk_PCO__c').
            selectField('Worst_Risk_Grade__c').
            selectField('Worst_Risk_Hold__c').
            selectField('Worst_Risk_Collection__c').
            setCondition('Application__c =:applicationId').
            toSOQL()
        ); 
    }
    /**
    * @description : Method to get ExposuresRisk by order by SeqNoWorstHoldCode__c
    * @author Himani Joshi | 2021-07-07 
    * @param applicationId 
    * @param clientCodes 
    * @return List<Application_Exposure_Risk__c> 
    **/
    public List<Application_Exposure_Risk__c> orderByWorstHoldSeqNo(Id applicationId,Set<String>clientCodes) {
       return [SELECT Id, Risk_Grade__c, Client_Name__c,Client_Code__c, LastModifiedDate,Business_Rescue_Affected_Party__c,
                Early_Warning_Listing__c,Forensic_Fraud_Indicator__c,In_Business_Rescue__c,In_Liquidation__c,SeqNoWorstHoldCode__c,Worst_Arms_Hold_Code__c,
                Worst_Collection_Risk_Type__c,Worst_risk_PCO__c,Risk_Identifier__c
                                     FROM Application_Exposure_Risk__c 
                                     WHERE Application__c =: applicationId and Client_Code__c IN :clientCodes
                                     ORDER BY SeqNoWorstHoldCode__c DESC];
       
    }
    /**
    * @description : Method to get Exposure Risk by order by SeqNoWorstHoldCode__c
    * @author Himani Joshi | 2021-07-07 
    * @param applicationId 
    * @param clientCodes 
    * @return List<Application_Exposure_Risk__c> 
    **/
    public List<Application_Exposure_Risk__c> orderByWorstCollectionSeqNo(Id applicationId,Set<String>clientCodes) {
       return [SELECT Id, Risk_Grade__c, Client_Name__c,Client_Code__c, LastModifiedDate,Business_Rescue_Affected_Party__c,
                Early_Warning_Listing__c,Forensic_Fraud_Indicator__c,In_Business_Rescue__c,In_Liquidation__c,SeqNoWorstHoldCode__c,Worst_Arms_Hold_Code__c,
                Worst_Collection_Risk_Type__c,Worst_risk_PCO__c,Risk_Identifier__c,SeqNoWorstColType__c,Worst_Risk_Collection__c
                                     FROM Application_Exposure_Risk__c 
                                     WHERE Application__c =: applicationId and Client_Code__c IN :clientCodes
                                     ORDER BY SeqNoWorstHoldCode__c DESC];
       
    }
   
}