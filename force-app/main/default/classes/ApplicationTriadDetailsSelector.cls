/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Application_Triad__c objects
 *
 * @author  Almas Aleem :Absa
 * @since   2020-09-15
 */
public class ApplicationTriadDetailsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	public Schema.SObjectType getSObjectType() {
		return Application_Triad_Detail__c.sObjectType;
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Application_Triad_Detail__c.Id,
			Application_Triad_Detail__c.Month__c,
			Application_Triad_Detail__c.Highest_Limit__c
		};
	}

	//MANDATORY ABSTRACT METHODS - END
	////Custom Selectors
	/**
	 * Method to retrieve an Application_Triad__c based on its application Id
	 *
	 * @param applicationId The Id of the Application__c record
	 * @return List of Application_Triad_Detail__c The application record
	 **/
	public List<Application_Triad_Detail__c> getDetailByApplicationTriadID(Id applicationTriadId) {
		return (List<Application_Triad_Detail__c>)  Database.query(
			newQueryFactory().
			selectField('Average_Balance__c').
			selectField('Credit_Turnover__c').
			selectField('Debit_Turnover__c').
			selectField('Maximum_Balance__c').
			selectField('Minimum_Balance__c').
			selectField('Risk_Grade__c').
			selectField('Total_Limit__c').
			selectField('Returned_Items_Value_Cheques_value__c').
			selectField('Returned_Items_Value_Savings_value__c').
			setCondition('Application_Triad__c =:applicationTriadId').
			toSOQL()
		);
	}

	/**
	 * Method to retrieve an Application_Triad__c based on its application Id
	 *
	 * @param applicationId The Id of the Application__c record
	 * @return List of Application_Triad_Detail__c The application record
	 **/
	public List<Application_Triad_Detail__c> getDetailsByApplicationTriadID(Id applicationTriadId) {
		return (List<Application_Triad_Detail__c>) Database.query(
			newQueryFactory().
			selectField('Number_of_Cheque_Accounts__c').
			selectField('Days_in_Credit__c').
			selectField('Days_in_Debit__c').
			selectField('Days_In_Excess__c').
			selectField('Number_of_Cheque_RD_Events_value__c').
			selectField('Number_of_Savings_RD_Events_value__c').
			selectField('Number_of_Cheque_RD_Events__c').
			selectField('Number_of_Savings_RD_Events__c').
			selectField('Number_of_Debits_Cheques__c').
			selectField('Number_of_Debits_Deposits__c').
			setCondition('Application_Triad__c =:applicationTriadId').toSOQL()
		);
	}
}