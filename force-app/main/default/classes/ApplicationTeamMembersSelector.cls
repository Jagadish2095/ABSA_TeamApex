/**
* @description Apex Enterprise Design Patters
* Selector layer for Application_Fees__c objects
*
* @author  Diksha Wasekar
* @since   04/14/2021
*/
public class ApplicationTeamMembersSelector extends fflib_SObjectSelector {

/**
* @description Method to retrieve the sObjectType
*
* @return  Schema.SObjectType  The sObjectType
*/
public Schema.SObjectType getSObjectType() {
return Application_Team_Member__c.sObjectType;
}
/**
*@description Method to retrieve the list of fields on the sObject
*
* @return  List<Schema.SObjectField>   The list of sObjectFields
*/
public List<Schema.SObjectField> getSObjectFieldList() {
return new List<Schema.SObjectField>{
Application_Team_Member__c.Id,
Application_Team_Member__c.Application_Product_CPF__c
};
}

/**
* @description 
* @author  | 2021-06-07 
* @param ApplicationPrdctId 
* @param Type 
* @param Category 
* @return List<Application_Team_Member__c> 
**/
public  List<Application_Team_Member__c> selectteamMemberwithtypeandCategory(Id ApplicationPrdctId,string Type,string Category) {
return Database.query(
newQueryFactory().
selectField('Id').
selectField('Name').
selectField('Category__c').
selectField('Application_Product_CPF__c').
selectField('Member_Name__c').
selectField('Type__c').
setCondition('Application_Product_CPF__c  =:ApplicationPrdctId AND Type__c =: Type AND Category__c =:Category' ).
toSOQL()
);
}

}