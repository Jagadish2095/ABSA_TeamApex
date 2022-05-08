/**
 * @description       : Selector class for Application_Scoring__c sObject
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-08
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-08   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
**/

public class ApplicationScoringSelector extends fflib_SObjectSelector{

    
    /**
    * @description Method to retrieve the sObjectType
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType() {
        return Application_Scoring__c.sObjectType;
    }
    
    public override String getOrderBy() {
        return 'CreatedDate DESC';
    }
    
    
    /**
    * @description Method to retrieve the list of fields on the sObject
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Scoring__c.Id,
            Application_Scoring__c.Application_Number__c,
            Application_Scoring__c.LastModifiedDate
        };
    }

    /**
    * @description Method to retrieve Application_Scoring__c records
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @param appScoringId 
    * @return List<Application_Scoring__c> 
    **/
    public List<Application_Scoring__c> selectById(Id appScoringId){
        return Database.query(
            newQueryFactory()
			.selectField('Id')
			.setCondition('Id =: appScoringId')
			.toSOQL()
        );
    }

    
    /**
    * @description Method to retrieve Application_Scoring__c records
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @param opportunityId 
    * @param stage 
    * @return List<Application_Scoring__c> 
    **/
    public List<Application_Scoring__c> selectByOpportunityId(Id opportunityId, String stage){
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Stage__c')
            .selectField('PreapprReprocessLowerLmtInd__c')
            .selectField('SpouseDetailsRequiredInd__c')
            .selectField('PaprPreapprInd__c')
            .selectField('LastModifiedDate')
            .selectField('MIAERequired__c')
			.setCondition('Application_Number__r.Opportunity__c =: opportunityId AND Stage__c =:stage')
			.toSOQL()
        );
    }
	
   
    /**
    * @description Method to retrieve Application_Scoring__c records for Borrowing Capacity
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @param opportunityId 
    * @return List<Application_Scoring__c> 
    **/
    public List<Application_Scoring__c> selectLatestByOpportunityId(Id opportunityId){
        return Database.query(
            newQueryFactory()
			.selectField('Id')
			.setCondition('Application_Number__r.Opportunity__c =: opportunityId')
            .setLimit(1)
			.toSOQL()
        );
    }
    
    
    /**
    * @description Method to retrieve Application_Scoring__c records for Borrowing Capacity
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-08 
    * @param opportunityId 
    * @return List<Application_Scoring__c> 
    **/
    public List<Application_Scoring__c> selectBorrowingCapacityByOpportunityId(Id opportunityId){
        String borrowingCapacityCondition = 'Application_Number__r.Opportunity__c =: opportunityId AND (Ceiling_Limit__c <> null OR Potential_Ordinary_Credit__c <> null OR Residual_Unsecured_Borrowing_Capacity__c <> null OR Net_Existing_ASV__c <> null OR Specific_ASV_Available__c <> null OR ASV_Offered__c <> null OR Residual_Borrowing_Capacity_on_FTO__c <> null OR BE_Net_Worth__c <> null OR Residual_Borrowing_Capacity_after_BENW__c <> null OR Principal_Net_Worth__c <> null OR Residual_Borrowing_Capacity_after_PNW__c <> null OR ASV_Shortfall_Amount_after_Tolerance__c <> null)';
        return Database.query(
            newQueryFactory()
			.selectField('Id')
			.selectField('Application_Number__c')
			.selectField('Ceiling_Limit__c')
			.selectField('Potential_Ordinary_Credit__c')
			.selectField('Residual_Unsecured_Borrowing_Capacity__c')
			.selectField('Net_Existing_ASV__c')
			.selectField('Specific_ASV_Available__c')
			.selectField('ASV_Offered__c')
			.selectField('Residual_Borrowing_Capacity_on_FTO__c')
			.selectField('BE_Net_Worth__c')
			.selectField('Residual_Borrowing_Capacity_after_BENW__c')
			.selectField('Principal_Net_Worth__c')
			.selectField('Residual_Borrowing_Capacity_after_PNW__c')
			.selectField('ASV_Shortfall_Amount_after_Tolerance__c')
			.setCondition(borrowingCapacityCondition)
			.toSOQL()
        );
    }
}