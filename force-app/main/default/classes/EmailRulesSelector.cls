/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Email_Rule__c object
 *
 * @author  Rudolf Niehaus - CloudSmiths
 * @since   2018-07-19
 */
public class EmailRulesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Email_Rule__c.sObjectType;
	}

	/**
	 * @description getSObjectFieldList description
	 * @return Return List<Schema.SObjectField> : Return Email_Rule__c
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Email_Rule__c.Id,
			Email_Rule__c.Name,
			Email_Rule__c.Active__c,
			Email_Rule__c.From_Criteria__c,
			Email_Rule__c.From_Operator__c,
			Email_Rule__c.Subject_Criteria__c,
			Email_Rule__c.Subject_Operator__c,
			Email_Rule__c.Description_Criteria__c,
			Email_Rule__c.Description_Operator__c,
			Email_Rule__c.Logical_Operators__c,
			Email_Rule__c.Retention_Period_Hrs__c,
			Email_Rule__c.Default_Email_Rule__c,
			Email_Rule__c.Trigger_Count__c,
			Email_Rule__c.Reference_Type__c,
			Email_Rule__c.Email_Rule_Template__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	//override the sort method to sort by Order__c field
	/**
	 * @description getOrderBy description
	 * @return Return String : Return String
	 */
	public override String getOrderBy() {
		return 'Order__c ASC';
	}
	//get cases by id's
	/**
	 * @description selectById description
	 * @param idSet (Set<Id>) : idSet
	 * @return Return List<Email_Rule__c> : Return List<Email_Rule__c>
	 */
	public List<Email_Rule__c> selectById(Set<Id> idSet) {
		return (List<Email_Rule__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	//CUSTOM SELECTORS - START
	/**
	 * Return Email_Rule__c by Id's with many-2-may parent ids
	 * Custom selector USING the Base class queryFactory
	 * @description selectByIdWithRelatedInfo description
	 * @param idSet (Set<Id>) : idSet
	 * @param recordLimit (Integer) : recordLimit
	 * @return Return List<Email_Rule__c> : Return List<Email_Rule__c>
	 */
	public List<Email_Rule__c> selectByIdWithRelatedInfo(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Route_To_Queue__c')
				.selectField('Route_To_Queue__r.Name')
				.selectField('Service_Type__c')
				.selectField('Service_Level__c')
				.selectField('sd_Communication_Plan__c')
				.selectField('Route_To_Queue__r.Name')
				.selectField('RecordType.DeveloperName')
				.setCondition('Id IN :idSet And Active__c = true')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * Return the default rule for per shared email
	 * @description selectSharedEmailDefaultWithRelatedInfo description
	 * @param ruleId (Id) : ruleId
	 * @return Return List<Email_Rule__c> : Return List<Email_Rule__c>
	 */
	public List<Email_Rule__c> selectSharedEmailDefaultWithRelatedInfo(Id ruleId) {
		return Database.query(
			newQueryFactory(true)
				.selectField('Route_To_Queue__c')
				.selectField('Route_To_Queue__r.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Service_Level__c')
				.selectField('sd_Communication_Plan__c')
				.setCondition('Id = :ruleId And Active__c = true')
				.setLimit(1)
				.toSOQL()
		);
	}
	/**
	 * Return the org wide default rule for all shared emails
	 * @description selectOrgWideDefaultWithRelatedInfo description
	 * @return Return List<Email_Rule__c> : Return List<Email_Rule__c>
	 */
	public List<Email_Rule__c> selectOrgWideDefaultWithRelatedInfo() {
		return Database.query(
			newQueryFactory(true)
				.selectField('Route_To_Queue__c')
				.selectField('Route_To_Queue__r.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Service_Level__c')
				.selectField('sd_Communication_Plan__c')
				.setCondition('Org_Wide_Default_Rule__c = true And Active__c = true')
				.setLimit(1)
				.toSOQL()
		);
	}

	/**
	 * Return the org wide default rule for all shared emails
	 *
	 * @description selectByExternalCaseReference description
	 * @return Return List<Email_Rule__c> : Return List<Email_Rule__c>
	 */
	public List<Email_Rule__c> selectByExternalCaseReference() {
		return Database.query(newQueryFactory(true).setCondition('Detect_External_Case_Reference__c = true And Active__c = true').setLimit(1).toSOQL());
	}
	//CUSTOM SELECTORS - END
}