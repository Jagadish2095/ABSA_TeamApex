/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Tasks
 *
 * @author  Rudolf Niehaus - CloudSmiths
 * @since   2018-03-26
 */
public without sharing class TasksSelector extends fflib_SObjectSelector {
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Task.sObjectType;
	}
	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Task.Id,
			Task.Call_Successful__c,
			Task.RecordTypeId,
			Task.WhoId,
			Task.WhatId,
			Task.WhoCount,
			Task.WhatCount,
			Task.Subject,
			Task.ActivityDate,
			Task.Status,
			Task.Priority,
			Task.OwnerId,
			Task.Description,
			Task.AccountId,
			Task.IsClosed,
			Task.CreatedDate,
			Task.Action_Date__c,
			Task.Action_Status__c,
			Task.Communication_Rule_Id__c,
			Task.Communication_Task_Unique_Key__c,
			Task.Is_Merged_Task__c,
			Task.Outcome__c
		};
	}
	//INHERIT FROM BASE CLASS - START
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Task>: Return description
	 */
	public List<Task> selectById(Set<Id> idSet) {
		return (List<Task>) selectSObjectsById(idSet);
	}
	//Override default sort order i.e. CreatedDate
	public override String getOrderBy() {
		return 'Action_Date__c DESC';
	}
	//INHERIT FROM BASE CLASS - STOP
	//CUSTOME METHODS
	/**
	 * Return Tasks by WhatId
	 * @description Custom selector USING the Base class queryFactory
	 *
	 * @param whatIds
	 * @return List<Task>
	 */
	public List<Task> selectByWhatId(Set<Id> whatIds) {
		return (List<Task>) Database.query(newQueryFactory().setCondition('WhatId IN :whatIds').toSOQL());
	}

	/**
	 * @description Return Tasks by Communication Rule Id's, Record type id
	 * and status
	 * @param ruleIds
	 * @param recordTypeId
	 * @param status
	 * @return List<Task>
	 */
	public List<Task> selectByRuleIdsRecordTypeAndStatus(Set<Id> ruleIds, Id recordTypeId, String status) {
		return (List<Task>) Database.query(
			newQueryFactory().setCondition('Communication_Rule_Id__c IN :ruleIds AND recordTypeId = :recordTypeId AND Status = :status').toSOQL()
		);
	}
	/**
	 * Custom selector USING the Base class queryFactory
	 * @description Return Tasks by Status, RecordType and where
	 * the Action_Date__c is <= Now
	 *
	 * @param status
	 * @param recordTypeId
	 * @param actionDate
	 * @return List<Task>
	 */
	public List<Task> selectByStatusAndRecordTypeIdAndActionDate(String status, Id recordTypeId, DateTime actionDate) {
		return (List<Task>) Database.query(
			newQueryFactory().setCondition('Status = :status AND recordTypeId = :recordTypeId AND Action_date__c <= :actionDate').toSOQL()
		);
	}

	/**
	 * @description selectTasksByWhoId description
	 *
	 * @param whoIdList (Set<Id>): whoIdList
	 * @return Return List<Task>: Return description
	 */
	public List<Task> selectTasksByWhoId(Set<Id> whoIdList) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('WhoId')
				.selectField('WhatId')
				.selectField('Call_Successful__c')
				.selectField('Outcome__c') //added by Minal for DD STI
				.selectField('RecordType.Name') //added by Minal for DD STI
				.setCondition('WhoId IN :whoIdList AND TaskSubtype =\'call\'')
				.toSOQL()
		);
	}

	/**
	 * @description selectCallsCountByWhatId description
	 *
	 * @param whatIdList (Set<Id>): whatIdList
	 * @return Return List<AggregateResult>: Return description
	 */
	public List<AggregateResult> selectCallsCountByWhatId(Set<Id> whatIdList) {
		return Database.query('SELECT COUNT(Id) totalCount, WhatId FROM Task WHERE WhatId ' + ' IN: whatIdList Group By WhatId');
	}
	/**
	 * @description selectTasksByWhoIdForMergeLeads description
	 *
	 * @param whoIdList (Set<Id>): whoIdList
	 * @return Return List<Task>: Return description
	 */
	public List<Task> selectTasksByWhoIdForMergeLeads(Set<Id> whoIdList) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('WhoId')
				.selectField('WhatId')
				.setCondition('WhoId IN :whoIdList AND (Status !=\'Completed\' or Status !=\'Cancelled\')')
				.toSOQL()
		);
	}

	/**
	 * @description selectByStatusAndActivityDate description
	 *
	 * @param status1 (String): status1
	 * @param status2 (string): status2
	 * @return Return Database.QueryLocator: Return description
	 */
	public Database.QueryLocator selectByStatusAndActivityDate(String status1, string status2) {
		list<user> activeuser = new List<user>();
		UsersSelector user = new UsersSelector();
		activeuser = user.selectactiveusersById();

		return Database.getQueryLocator(
			newQueryFactory()
				.selectField('Id')
				.selectField('ActivityDate')
				.selectField('Subject')
				.selectField('CreatedDate')
				.selectField('Who.name')
				.selectField('Status')
				.selectField('Owner.Email')
				.selectField('OwnerId')
				.selectField('what.id')
				.selectField('owner.name')
				.selectField('whoid')
				.setCondition('ActivityDate < Today AND Status not in(\'Completed\', \'Cancelled\') And OwnerId in:activeuser')
				.toSOQL()
		);
	}

    /**
	* @description 
	* @author muvhuso.nekhubvi@absa.africa | 2021-06-21 
	* @param accountId
	* @param subjectValue 
	* @return List<Task> 
	**/
	public List<Task> selectBySubject(String accountId,String subjectValue) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Status')
				.selectField('Subject')
				.selectField('WhatId')
				.setCondition('WhatId =: accountId AND Subject =: subjectValue')
				.toSOQL()
		);
	}
}