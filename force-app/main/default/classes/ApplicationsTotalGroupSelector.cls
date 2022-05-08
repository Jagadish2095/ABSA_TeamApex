/**
 * @description       : Selector class for Application Exposure Total Group
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-10   Englarmerdge Mongwe   Initial Version
**/

public class ApplicationsTotalGroupSelector  extends fflib_SObjectSelector {
    /**
    * @description : Method to get the sobject type
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType(){
        return Application_Exposure_Total_Group__c.sObjectType;
    }

    /**
    * @description : Method to get the sobject fields
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Exposure_Total_Group__c.Id,
            Application_Exposure_Total_Group__c.Application__c,
            Application_Exposure_Total_Group__c.Client_Name__c,
            Application_Exposure_Total_Group__c.Client_Code__c,
            Application_Exposure_Total_Group__c.TGAE__c,
            Application_Exposure_Total_Group__c.TGBE__c,
            Application_Exposure_Total_Group__c.TGE__c,
            Application_Exposure_Total_Group__c.TGIE__c,
            Application_Exposure_Total_Group__c.TGOE__c,
            Application_Exposure_Total_Group__c.Primary_Client_of_Group__c,
            Application_Exposure_Total_Group__c.Ultimate_Primary_Client__c,
            Application_Exposure_Total_Group__c.Overall_Control_Branch__c,
            Application_Exposure_Total_Group__c.Control_Branch__c,
            Application_Exposure_Total_Group__c.LastModifiedDate
        };
    }

    /**
    * @description : Method to get All Applications TotalGroup
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param applicationId 
    * @return List<Application_Exposure_Total_Group__c> 
    **/
    public List<Application_Exposure_Total_Group__c> getAllApplicationsTotalGroup(Id applicationId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Client_Name__c').
            selectField('Client_Code__c').
            selectField('Application_Total_Group__c').
            selectField('Branch_code__c').
            selectField('Business_Segment__c').
            selectField('Business_Sub_Segment__c').
            selectField('Control_Branch__c').
            selectField('Existing_Franchisor_Type_Code__c').
            selectField('Exposure_Policy_Indicator__c').
            selectField('Overall_Control_Branch__c').
            selectField('Overall_Control_Branch_Code__c').
            selectField('Primary_Client_of_Group__c').
            selectField('TGAE__c').
            selectField('TGBE__c').
            selectField('TGE__c').
            selectField('TGIE__c').
            selectField('TGOE__c').
            selectField('Ultimate_Primary_Client__c').
            selectField('LastModifiedDate').
            setCondition('Application__c =: applicationId').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
    * @description : Method to get All Applications TotalGroup using applicationId and grouptype
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param applicationId 
    * @param groupType 
    * @return List<Application_Exposure_Total_Group__c> 
    **/
    public List<Application_Exposure_Total_Group__c> getApplicationTotalGroup(Id applicationId, String groupType) {
       return Database.query(
           newQueryFactory().
           setCondition('Application__c =: applicationId AND Application_Total_Group__c =:groupType').
           toSOQL()
        );
    }

	/**
	* @description : Method to get application exposure total group using application Id and group type
	* @author Englarmerdge Mongwe | 2021-06-10 
	* @param applicationId 
	* @param groupType 
	* @return List<Application_Exposure_Total_Group__c> 
	**/
	public List<Application_Exposure_Total_Group__c> getApplicationTotalGroupbyGrpType(Id applicationId, String groupType) {
       return Database.query(
           newQueryFactory().
           selectField('Id').
            selectField('Application__c').
            selectField('TGAE__c').
            selectField('TGBE__c').
            selectField('TGE__c').
            selectField('TGIE__c').
            selectField('TGOE__c').
           setCondition('Application__c =: applicationId AND Application_Total_Group__c =:groupType').
           toSOQL()
        );
    }

    /**
    * @description : Method to get application exposure total group using application Id and group type
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param applicationId 
    * @param groupType 
    * @return List<Application_Exposure_Total_Group__c> 
    **/
    public List<Application_Exposure_Total_Group__c> getApplicationTotalGroupbyGrpTypeList(Id applicationId, List<String> groupType) {
       return Database.query(
           newQueryFactory().
           selectField('Id').
            selectField('Application__c').
            selectField('TGAE__c').
            selectField('TGBE__c').
            selectField('TGE__c').
            selectField('TGIE__c').
            selectField('TGOE__c').
            selectField('Overall_Control_Branch_Code__c').
            selectField('Exposure_Policy_Indicator__c').
            selectField('Requested_Franchise_Code__c').
            selectField('Existing_Franchisor_Type_Code__c').
            selectField('Existing_Franchise_Name__c').
            selectField('RequestedFranchiseName__c').
            selectField('Business_Segment__c').
            selectField('Business_Sub_Segment__c').
            selectField('Exposure_Policy_Indicator__c').
            selectField('Application_Total_Group__c').
            selectField('Client_Code__c').
           setCondition('Application__c =: applicationId AND Application_Total_Group__c IN:groupType').
           toSOQL()
        );
    }

    /**
    * @description : Method to get application exposure total group using application Id ,client code and group type
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param applicationId 
    * @param ClientCode 
    * @param groupType 
    * @return List<Application_Exposure_Total_Group__c> 
    **/
    public List<Application_Exposure_Total_Group__c> getApplicationTotalGroupbyGrpTypeClientCode(Id applicationId,String ClientCode, String groupType) {
       return Database.query(
           newQueryFactory().
           selectField('Id').
            selectField('Overall_Control_Branch_Code__c').
            selectField('Exposure_Policy_Indicator__c').
            selectField('Requested_Franchise_Code__c').
            selectField('Existing_Franchisor_Type_Code__c').
            selectField('Existing_Franchise_Name__c').
            selectField('RequestedFranchiseName__c').
            selectField('Business_Segment__c').
            selectField('Business_Sub_Segment__c').
            selectField('Exposure_Policy_Indicator__c').
           setCondition('Application__c =: applicationId and Client_Code__c =:ClientCode AND Application_Total_Group__c =:groupType').
           toSOQL()
        );
    }

    /**
    * @description : Method to get application exposure total group using application Id and clientcode
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param ClientCode 
    * @param applicationId 
    * @return List<Application_Exposure_Total_Group__c> 
    **/
    public List<Application_Exposure_Total_Group__c> getApplicationTotalGroupByClientCode(String ClientCode,Id applicationId) {
         return Database.query(
             newQueryFactory().
             setCondition('Application__c =: applicationId AND Client_Code__c =:ClientCode').
             toSOQL()
          );
    }

    
    /**
    * @description : Method to get CMS fields using applicationId and mainApplicantClientCode
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param applicationId 
    * @param mainApplicantClientCode 
    * @return Application_Exposure_Total_Group__c 
    **/
    public Application_Exposure_Total_Group__c getCMSFields(Id applicationId,String mainApplicantClientCode) {
       return Database.query(
           newQueryFactory().
           selectField('Application__c').
           selectField('Id').
           selectField('Branch_code__c').
           selectField('Overall_Control_Branch_Code__c').
           selectField('Business_Segment__c').
           selectField('Business_Sub_Segment__c').
           selectField('Existing_Franchisor_Type_Code__c').
           selectField('Ultimate_Primary_Client__c').
           selectField('Exposure_Policy_Indicator__c').
           setCondition('Application__c =: applicationId AND Overall_Control_Branch_Code__c != \' \''+' AND Client_Code__c=\''+mainApplicantClientCode+'\'').
           setLimit(1).
           toSOQL()
        );
    }
}