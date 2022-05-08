/**
 *
 * @author  Naveen
 * @since   2021-09-07
 * @description  Dsp_CaseAuraListCtlr
**/
public with sharing class Aic_CaseAuraListCtrl {
     /**
        * @comment : method returns case divided into queues
        * @description  getCasesFromQueues is called on init
        * @return QueuedCases
        *
        * */
    @AuraEnabled
    public static QueuedCases getCasesFromQueues() {
        if (Case.SObjectType.getDescribe().isAccessible()) {
            QueuedCases casesFromQueue = new QueuedCases();
            Aic_CaseAuraListCtrl cSel = new Aic_CaseAuraListCtrl();
            casesFromQueue.ntbCases = cSel.selectCasesByQueueName('FIC New to Bank (NTB)');
            casesFromQueue.verificationCases = cSel.selectCasesByQueueName('Verification AIC');
            casesFromQueue.awaitingDocumentsCases = cSel.selectCasesByQueueName('Awaiting Documents AIC');
            casesFromQueue.productManagerCases = cSel.selectCasesByQueueName('Product Manager AIC');
            casesFromQueue.voiceOutboundCases = cSel.selectCasesByQueueName('Outbound AIC');
            casesFromQueue.unassignedCases = cSel.selectCasesByQueueName('Unassigned AIC');
            casesFromQueue.junkCases = cSel.selectCasesByQueueName('Junk AIC');
            casesFromQueue.archivedCases = cSel.selectCasesByQueueName('Archive AIC');
            casesFromQueue.assignedCases = cSel.selectCasesByQueueName('Assigned AIC');
            return casesFromQueue;
        } else {
            return null;
        }
    }

    /**
   * @comment : getCasFromParticularQueue returns cases from particular queue
   * @description  getCasFromParticularQueue is called from tab
   * @return List<Case>
   * @param queueName
   *@param searchKeyWord
   * */
    @AuraEnabled
    public static List<Case> getCasFromParticularQueue(String queueName, String searchKeyWord) {
        Aic_CaseAuraListCtrl cSel = new Aic_CaseAuraListCtrl();

        if (Case.SObjectType.getDescribe().isAccessible()) {
            if (queueName == 'My Cases') {
                return null;//cSel.selectIsOpenByOwnerAndSearchKeyWordByAccount(userinfo.getUserId(),searchKeyWord);
            } else {
                return cSel.selectCasesByQueueNameAndKeyWord(queueName,searchKeyWord );
            }
        } else {
            return null;
        }
    }

    /**
    * @comment : findCases returning case which is not divided into queues
    * @description : findCases is called from global search
    * @return Case[]
    * @param searchKeyWord
    * */
    @AuraEnabled
    public static Case[] findCases(String searchKeyWord) {
        if (Case.SObjectType.getDescribe().isAccessible() && String.isNotBlank(searchKeyWord)) {
            return new Aic_CaseAuraListCtrl().selectCasesByKeyWord(searchKeyWord);
        } else {
            return null;
        }
    }

    /**
        * @comment : findCases returning case which is not divided into queues
        * @description : findCases is called from global search
        * @return Case[]
        * @param searchKeyWord
        * */
    @AuraEnabled
    public static Case[] findArchiveCases(String searchKeyWord) {
        if (Case.SObjectType.getDescribe().isAccessible()) {
            return  new Aic_CaseAuraListCtrl().selectCasesByQueueNameAndKeyWord('Archive AIC',searchKeyWord );
        } else {
            return null;
        }
    }

    /**
    * @comment : isSuperUser to check permision set is assigned or not
    * @description  assignToUser is called when user click in start processing case
    * @return boolean
    * */
    @AuraEnabled
    public static boolean isSuperUser() {
        boolean checkSuperUser = false;
        if (user.SObjectType.getDescribe().isAccessible()) {
            list<PermissionSetAssignment> prassignment = [SELECT Id, PermissionSet.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() and PermissionSet.Name = 'Aic_Super_User'];
            if (!prassignment.isempty()) {
                checkSuperUser = true;
            }
        }
        return checkSuperUser;
    }
    
    /**
	 * @description selectCasesByQueueName description
	 *
	 * @param queuename (string): queuename
	 * @description
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectCasesByQueueName(string queuename) {
		return Database.query(
			new CasesSelector().newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
            	.selectField('Origin')
            	.selectField('Description')
                .selectField('CIF_Custom__c')
                .selectField('Customer_Type__c')
                .selectField('Surname__c')
                .selectField('Age1__c')  
                .selectField('Type')
                .selectField('Comments__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition('Owner_Queue_Name__c = :queuename')
				.toSOQL()
		);
	}
    
    /**
	 * @description get case based on userId
	 * @param queuename
	 * @param searchKeyWord
	 * @return List<Case>
	 **/
	public List<Case> selectCasesByQueueNameAndKeyWord(string queuename, String searchKeyWord) {
		String quw = queuename;
		return Database.query(
			new CasesSelector().newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
            	.selectField('Origin')
            	.selectField('Description')
                .selectField('CIF_Custom__c')
                .selectField('Customer_Type__c')
                .selectField('Surname__c')
                .selectField('Age1__c')  
                .selectField('Type')
                .selectField('Comments__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition(
					'Owner_Queue_Name__c =: queuename   AND (CaseNumber Like  \'%' +
					searchKeyWord +
					'%\' OR Status LIKE \'%' +
					searchKeyWord +
					'%\' OR CIF__c LIKE \'%' +
					searchKeyWord +
					'%\')'
				)
				.toSOQL()
		);
	}
    
    /**
	 * @description get case based on userId
	 * @param searchKeyWord
	 * @return List<Case>
	 **/

	public List<Case> selectCasesByKeyWord(String searchKeyWord) {
		return Database.query(
			new CasesSelector().newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
            	.selectField('Origin')
            	.selectField('Description')
                .selectField('CIF_Custom__c')
                .selectField('Customer_Type__c')
                .selectField('Surname__c')
                .selectField('Age1__c')  
                .selectField('Type')
                .selectField('Comments__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition(
					'(CaseNumber Like  \'%' +
					searchKeyWord +
					'%\' OR Status LIKE \'%' +
					searchKeyWord +
					'%\' OR CIF__c LIKE \'%' +
					searchKeyWord +
					'%\')'
				)
				.toSOQL()
		);
	}
    
    
/**
 *
 *
 *  @description  QueuedCases
**/
    public Class QueuedCases {
        @auraEnabled public List<Case> verificationCases;
        @auraEnabled public List<Case> awaitingDocumentsCases;
        @auraEnabled public List<Case> productManagerCases;
        @auraEnabled public List<Case> voiceOutboundCases;
        @auraEnabled public List<Case> ntbCases;
        @auraEnabled public List<Case> junkCases;
        @auraEnabled public List<Case> unassignedCases;
        @auraEnabled public List<Case> archivedCases;
        @auraEnabled public List<Case> assignedCases;

    }

}