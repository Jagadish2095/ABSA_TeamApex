/**
 *
 * @author  Kamil Rega
 * @since   2021-05-10
 *  @description  Fic_CaseAuraListCtlr
**/
public with sharing class Fic_CaseAuraListCtlr {
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
            CasesSelector cSel = new CasesSelector();
            casesFromQueue.ntbCases = cSel.selectCasesByQueueName('FIC New to Bank (NTB)');
            casesFromQueue.ntpCases = cSel.selectCasesByQueueName('FIC New to Product (NTP)');
            casesFromQueue.maintenanceCases = cSel.selectCasesByQueueName('FIC Maintenance');
            casesFromQueue.referralCases = cSel.selectCasesByQueueName('FIC Referral');
            casesFromQueue.disputeCases = cSel.selectCasesByQueueName('FIC Dispute');
            casesFromQueue.remediationCases = cSel.selectCasesByQueueName('FIC Remediation');
            casesFromQueue.newRequestCases = cSel.selectCasesByQueueName('New Request');
            casesFromQueue.unassignedCases = cSel.selectCasesByQueueName('Unassigned');
            casesFromQueue.awaitingDocumentsCases = cSel.selectCasesByQueueName('Awaiting Documents');
            casesFromQueue.archivedCases = cSel.selectCasesByQueueName('Archive');
            casesFromQueue.assignedCases = cSel.selectCasesByQueueName('Assigned');
            casesFromQueue.voiceInboundCases = cSel.selectCasesByQueueName('FIC Voice Queue inbound');
            casesFromQueue.voiceOutboundCases = cSel.selectCasesByQueueName('FIC Voice Queue Outbound');
            casesFromQueue.userCases = cSel.selectIsOpenByOwnerByAccount(userinfo.getUserId());
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
        CasesSelector cSel = new CasesSelector();

        if (Case.SObjectType.getDescribe().isAccessible()) {
            if (queueName == 'My Cases') {
                return cSel.selectIsOpenByOwnerAndSearchKeyWordByAccount(userinfo.getUserId(),searchKeyWord);
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
        if (Case.SObjectType.getDescribe().isAccessible()) {
            return new CasesSelector().selectCasesByKeyWord(searchKeyWord);
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
            return  new CasesSelector().selectCasesByQueueNameAndKeyWord('Archive',searchKeyWord );
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
            list<PermissionSetAssignment> prassignment = [SELECT Id, PermissionSet.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() and PermissionSet.Name = 'Fic_Super_User'];
            if (!prassignment.isempty()) {
                checkSuperUser = true;
            }
        }
        return checkSuperUser;
    }

    /**
    * @comment :update case
    * @description  superUser update case
    * @param caseToChange
    * @param userId
    * */
    @AuraEnabled
    public static void changeCaseOwner(Case caseToChange, String userId) {
        

        caseToChange.OwnerId = userId;
        if (Case.SObjectType.getDescribe().isUpdateable()) {
            update caseToChange;
        }
    }

    /**
    * @comment : assignToUser assign case to user
    * @description : assignToUser is called when user click in start processing case
    * @param caseToAssign
    * */
    @AuraEnabled
    public static void assignToUser(Case caseToAssign) {
        if (Schema.sObjectType.Case.fields.OwnerId.isUpdateable()) {
            caseToAssign.OwnerId = UserInfo.getUserId();
            caseToAssign.FIC_Case_returned_to_queue__c = false;
            caseToAssign.FIC_DateTimeAssignedToCurrentOwner__c = Datetime.now();
            update caseToAssign;
        }
    }
/**
 *
 *
 *  @description  QueuedCases
**/
    public Class QueuedCases {
        @auraEnabled public List<Case> ntbCases;
        @auraEnabled public List<Case> ntpCases;
        @auraEnabled public List<Case> maintenanceCases;
        @auraEnabled public List<Case> referralCases;
        @auraEnabled public List<Case> disputeCases;
        @auraEnabled public List<Case> remediationCases;
        @auraEnabled public List<Case> newRequestCases;
        @auraEnabled public List<Case> unassignedCases;
        @auraEnabled public List<Case> awaitingDocumentsCases;
        @auraEnabled public List<Case> archivedCases;
        @auraEnabled public List<Case> assignedCases;
        @auraEnabled public List<Case> userCases;
        @auraEnabled public List<Case> voiceInboundCases;
        @auraEnabled public List<Case> voiceOutboundCases;

    }

}