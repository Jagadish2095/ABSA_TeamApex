/**
 * Apex Enterprise Design Patters
 * Selector layer for Application_Lease_CPF__c objects
 *
 * @author  Tinashe Mutsungi Shoko
 * @since   13-01-2021
 */
public class ApplicationLeaseCPFSelector extends fflib_SObjectSelector{
	/**
	 * Method to retrieve the sObjectType
	 *
	 * @return  Schema.SObjectType  The sObjectType
	 */
	public Schema.SObjectType getSObjectType(){

		return Application_Lease_CPF__c.sObjectType;
	}

	/**
	 * Method to retrieve the list of fields on the sObject
	 *
	 * @return  List<Schema.SObjectField>   The list of sObjectFields
	 */
	public List<Schema.SObjectField> getSObjectFieldList(){

		return new List<Schema.SObjectField>{
            Application_Lease_CPF__c.Id, 
            Application_Lease_CPF__c.Application_Product_CPF__c
        };
    }

    /**
     * Method to retrieve Application_Lease_CPF__c records based on an Appliaction Id
     *
     * @param   ApplicationId           The Application Id
     *
     * @return  Application_Lease_CPF__c    Application_Lease_CPF__c record
     */
    public  LIST<Application_Lease_CPF__c> selectByAppId(Id appProductCPFId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Tenant_Name__c').
            selectField('Tenant_until_Date__c').
            selectField('Tenant_from_Date__c').
            selectField('Lease_Area__c').
            selectField('Rent_per_Month__c').
            selectField('Rent_Type__c').
            selectField('Tenant_Escalations__c').
            selectField('Type__c').
            selectField('Other_Lease__c').
            setCondition('Application_Product_CPF__c =:appProductCPFId').
            addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.ASCENDING, true).
            toSOQL()
        );
    }
}