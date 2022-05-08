/**
* @description caseoutcomescreen Lightning component Apex Controller Class
* @author manideep kenche
* @created 2021/09/28
* @work W-012127
*/
public class CaseOutcomeScreenController {
    
/*** 
* @description adding casecomments to case
* @param caseId
* @param commentBody
* @return caseComment object
*/
    @AuraEnabled
    public static CaseComment addCaseComment(String caseId, String commentBody) {
        CaseComment caseComment = new CaseComment(ParentId=caseId, CommentBody=commentBody);
        insert caseComment;
        return caseComment;        
    }
/*** 
* @description transfer case to another queue
* @param caseId
* @param queueName
*/
    @AuraEnabled
    public static void transferCase( String caseId , String queueName ) {
        
        if(queueName == Label.First_Party_Fraud){
            
            CaseTransferActionExt.transferCase('Early Risk Detection 1st Party Fraud', '1st Party Fraud', caseId);
            
        } else  if(queueName == Label.Complaints_EB_Collections){
            
            CaseTransferActionExt.transferCase('Everyday Banking - Collections', 'Early risk detection- Possible fraud detection', caseId);
            
        }
        List<Group> groupList = new GroupsSelector().selectByNameAndType(queueName,'Queue');
        
        //Get Current Case
        List<Case> caseList = new CasesSelector().selectById(new Set<Id>{caseId});
        if(groupList.size() > 0 && caseList.size() == 1){
            
            caseList[0].OwnerId = groupList[0].Id;
            update caseList;
        }    
    }
/*** 
* @description create reminder for 3rd party fraud
* @param caseId
* @param dateFromCalendar
*/
    @AuraEnabled
    public static void createReminder(String caseId, DateTime dateFromCalendar) {
        
        List<Case> caseList = new CasesSelector().selectByIdWithCustomerInfo(new Set<String>{
            caseId 
                });
        
        Task newTask = new Task(Description = 'Call '+caseList[0].ClientName__c+' regarding Case number ' +caseList[0].CaseNumber,
                                Priority = 'High',
                                Status = 'Scheduled',
                                Subject = 'Call',
                                IsReminderSet = true,
                                Type='Call',
                                WhatId = caseId,
                                ReminderDateTime = dateFromCalendar
                               );
        insert newTask;
    }
/*** 
* @description check due date 3rd party fraud
* @param caseId
* @return boolean
*/
    @AuraEnabled
    public static boolean checkDueDate(String caseId){
        Date mydate;
        String sdate;
        boolean status = false;
        list<Task> getTask = [select id,ReminderDateTime,WhatId from Task where WhatId =: caseId ORDER BY LastModifiedById DESC];
       
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        DateTime reminderDate = getTask[0].ReminderDateTime;
        myDate = date.newinstance(reminderDate.year(), reminderDate.month(), reminderDate.day());
        sdate = String.valueOf(myDate);
        if(todaysDateStr >= sdate){
            status = true;
            return status;
        }else{
            return status;
        }
    }
/*** 
* @description pauseCaseAndCreateReminder 3rd party fraud
* @param caseId
*/
    @AuraEnabled
    public static void pauseCaseAndCreateReminder(String caseId) {
       
        CaseTransferActionExt.transferCase('Early Risk detection - PFD Case Escalated to Fraud', 'Early Risk Detection Holding Case', caseId);
        
    }
    
}