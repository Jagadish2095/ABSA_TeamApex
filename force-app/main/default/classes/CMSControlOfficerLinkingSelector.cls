/**
*@description this class used as selector object : CMS_Control_Officer_Linking__c
*Apex Class CMSControlOfficerLinkingSelector
* @author  Anka Ganta : Absa
* @version v1.0
* @since   2020-01-31
*
*/
public class CMSControlOfficerLinkingSelector extends fflib_SObjectSelector{
    
    /** 
    * @description get sObject type
    * @return Schema.SObjectType
    */
    public Schema.SObjectType getSObjectType(){
        return CMS_Control_Officer_Linking__c.sObjectType;
    }
    
    /** 
    * @description get sObject type
    * @return List<Schema.SObjectField>
    */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            CMS_Control_Officer_Linking__c.Id,
                CMS_Control_Officer_Linking__c.OwnerId,
                CMS_Control_Officer_Linking__c.Control_Officer_Type__c,
                CMS_Control_Officer_Linking__c.Control_Officer_Number__c,
                CMS_Control_Officer_Linking__c.Branch_Region_Site__c,
                CMS_Control_Officer_Linking__c.Group_or_Individual__c,
                CMS_Control_Officer_Linking__c.Captured_by_Employee__c,
                CMS_Control_Officer_Linking__c.Overall_Site_Code__c,
                CMS_Control_Officer_Linking__c.Business_Segment_Indicator__c,
                CMS_Control_Officer_Linking__c.Business_Sub_Segment_Indicator__c,
                CMS_Control_Officer_Linking__c.Banking_Sector__c,
                CMS_Control_Officer_Linking__c.Franchise_Sector__c,
                CMS_Control_Officer_Linking__c.Opportunity__c   
                
                };
    }
    
    
    /** 
    * @description get all the cms records 
    * @param oppId
    * @return List<CMS_Control_Officer_Linking__c>
    */
        
     public List<CMS_Control_Officer_Linking__c> cmsRecsRelatedToOpp(String oppId) {
        
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('OwnerId').
            selectField('Control_Officer_Type__c').
            selectField('Control_Officer_Number__c').
            selectField('Branch_Region_Site__c').
            selectField('Group_or_Individual__c').
            selectField('Captured_by_Employee__c').
            selectField('Overall_Site_Code__c').
            selectField('Business_Segment_Indicator__c').
            selectField('Business_Sub_Segment_Indicator__c').
            selectField('Banking_Sector__c').
            selectField('Franchise_Sector__c').
            selectField('Opportunity__c').
            setCondition('Opportunity__c = :oppId').
            toSOQL()
        );
        
    } 
    
    /** 
    * @description get all the cms records selected
    * @param contOffcIds
    * @return List<CMS_Control_Officer_Linking__c>
    */
    public List<CMS_Control_Officer_Linking__c> selectByIds(Set<String> contOffcIds) {
        
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('OwnerId').
            selectField('Control_Officer_Type__c').
            selectField('Control_Officer_Number__c').
            selectField('Branch_Region_Site__c').
            selectField('Group_or_Individual__c').
            selectField('Captured_by_Employee__c').
            selectField('Overall_Site_Code__c').
            selectField('Business_Segment_Indicator__c').
            selectField('Business_Sub_Segment_Indicator__c').
            selectField('Banking_Sector__c').
            selectField('Franchise_Sector__c').
            selectField('Opportunity__c').
            setCondition('Id IN :contOffcIds').
            toSOQL()
        );
    }
}