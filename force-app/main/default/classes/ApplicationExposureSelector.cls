/**
 * @description       : Selector class for Application Exposure object
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-09   Himani Joshi   Initial Version
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-10-01
 * Added getApplicationExposureByClientName Method
*/


public class ApplicationExposureSelector extends fflib_SObjectSelector {

    
    /**
    * @description : Method which returns the sobject type
    * @author Himani Joshi | 2021-06-09 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType() {
        return Application_Exposure__c.sObjectType;
    }

    /**
    * @description : Method which gets the sobject fields
    * @author Himani Joshi | 2021-06-09 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Exposure__c.Id,
            Application_Exposure__c.Application__c,
            Application_Exposure__c.Arrears__c,
            Application_Exposure__c.Client_Code__c,
            Application_Exposure__c.Client_Name__c,
            Application_Exposure__c.Excess__c,
            Application_Exposure__c.Exposure__c,
            Application_Exposure__c.Exposure_Data_Type__c,
            Application_Exposure__c.Installment__c,
            Application_Exposure__c.Liability__c,
            Application_Exposure__c.Limit__c,
            Application_Exposure__c.Product__c,
            Application_Exposure__c.subIndicator__c,
            Application_Exposure__c.LastModifiedDate,
            Application_Exposure__c.Exposure_Data_Type_Order__c
        };
	}

    /**
    * @description : Method which order by Client_Name__c,Client_Code__c,Exposure_Data_Type_Order__c
    * @author Himani Joshi | 2021-06-09 
    * @return String 
    **/
    public override String getOrderBy() {
        return 'Client_Name__c,Client_Code__c,Exposure_Data_Type_Order__c';
    }

    /**
    * @description : Method which gets application exposures using clientcode and applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param clientCode 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getApplicationExposure(string clientCode,Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Client_Code__c =: clientCode AND Application__c =:applicationId')
            .toSOQL()
        );
    }

    /**
    * @description : Method which gets all the application Exposures using applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getAllApplicationExposure(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Application__c =:applicationId')
            .toSOQL()
        );
    }

    /**
    * @description : Method which gets all the application Exposures product using applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getApplicationExposureProduct(Id applicationId) {
        String dataType = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        return Database.query(
            newQueryFactory()
            .setCondition('Application__c =:applicationId AND Exposure_Data_Type__c =:dataType')
            .toSOQL()
        );
    }

    /**
    * @description : Method which gets all the application Exposures product type total using applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getApplicationExposureProductTypeTotal(Id applicationId) {
        String dataType = 'Product Type Total';// StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT_TYPE_TOTAL;
        return Database.query(
            newQueryFactory()
            .setCondition('Application__c =:applicationId AND Exposure_Data_Type__c =:dataType')
            .toSOQL()
        );
    }

    /**
    * @description : Method which gets all the application Exposure summary using applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getAllApplicationExposureSummary(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Client_Code__c != null AND Application__c =:applicationId')
            .toSOQL()
        );
    }

    /**
    * @description : Method which gets all the application Exposures using clientName and applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param clientName 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getApplicationExposureByClientName(string clientName, Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Client_Name__c =: clientName AND Application__c =:applicationId AND Client_Code__c = null')
            .toSOQL()
        );
    }
    
	 /**
    * @description : Method which gets all the application Exposures using clientName and applicationId
    * @author Himani Joshi | 2021-06-09 
    * @param clientName 
    * @param applicationId 
    * @return List<Application_Exposure__c> 
    **/
    public List<Application_Exposure__c> getApplicationExposureByClientNameLike(string clientName, Id applicationId) {
        String searchString = '%' + clientName + '%';
        return Database.query(
            newQueryFactory()
            .setCondition('Client_Name__c LIKE: searchString AND Application__c =:applicationId AND Client_Code__c = null')
            .toSOQL()
        );
    }
}