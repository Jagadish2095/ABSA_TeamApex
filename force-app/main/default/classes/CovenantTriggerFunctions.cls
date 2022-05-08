/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-05
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-22   muvhuso.nekhubvi@absa.africa   Initial Version
**/
public class CovenantTriggerFunctions {

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param newCovenantRecords 
    **/
    public static void updateCaseServiceTypeInfoBeforeInsert(List<Covenant__c> newCovenantRecords) {
         //Add all Service Types to a set
        for(Covenant__c eachCovenant : newCovenantRecords) {
            if(eachCovenant.Frequency__c == 'Annually'){
            	//eachCovenant.Due_date__c = eachCovenant.Report_Date__c + 365;
                eachCovenant.Due_date__c = eachCovenant.Date_Covenant_Captured__c.addMonths(12);
            	eachCovenant.Notification_date__c = eachCovenant.Due_date__c - 5;
                eachCovenant.Post_Due_Date_Notification__c = eachCovenant.Due_date__c.addDays(1);
            }else if(eachCovenant.Frequency__c == 'Quarterly'){
           		//eachCovenant.Due_date__c = eachCovenant.Report_Date__c + 92;
           		eachCovenant.Due_date__c = eachCovenant.Date_Covenant_Captured__c.addMonths(3);
            	eachCovenant.Notification_date__c = eachCovenant.Due_date__c - 5;
                eachCovenant.Post_Due_Date_Notification__c = eachCovenant.Due_date__c.addDays(1);
        	}else if(eachCovenant.Frequency__c == 'Monthly'){
            	//eachCovenant.Due_date__c = eachCovenant.Report_Date__c + 30;
                eachCovenant.Due_date__c = eachCovenant.Date_Covenant_Captured__c.addMonths(1);
            	eachCovenant.Notification_date__c = eachCovenant.Due_date__c - 5;
                eachCovenant.Post_Due_Date_Notification__c = eachCovenant.Due_date__c.addDays(1);

        	}else if(eachCovenant.Frequency__c == 'Bi-Annually'){
            	//eachCovenant.Due_date__c = eachCovenant.Report_Date__c + 183;
                eachCovenant.Due_date__c = eachCovenant.Report_Date__c.addMonths(6);
            	eachCovenant.Notification_date__c = eachCovenant.Due_date__c - 5;
                eachCovenant.Post_Due_Date_Notification__c = eachCovenant.Due_date__c.addDays(1);

            }
        }
    }

     /**
     * @description 
     * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
     * @param newCovenantRecords 
     * @param oldCovenantRecords 
     **/
     public static void updateCovenantBeforeUpdate(List<Covenant__c> newCovenantRecords , List<Covenant__c> oldCovenantRecords) {

        for(Covenant__c eachOldCovenant : oldCovenantRecords) {
            if(eachOldCovenant.Fields_Editable__c){
                for(Covenant__c eachNewCovenant : newCovenantRecords) {
                    eachNewCovenant.Account_Number__c = eachOldCovenant.Account_Number__c;
                    eachNewCovenant.Additional_information__c = eachOldCovenant.Additional_information__c;
                    eachNewCovenant.Area_Manager_Coverage__c = eachOldCovenant.Area_Manager_Coverage__c;
                    eachNewCovenant.CPF__c = eachOldCovenant.CPF__c;
                    eachNewCovenant.Credit_Application_Type__c = eachOldCovenant.Credit_Application_Type__c;
                    eachNewCovenant.Date_Covenant_Captured__c = eachOldCovenant.Date_Covenant_Captured__c;
                    eachNewCovenant.Due_date__c = eachOldCovenant.Due_date__c; 
                    eachNewCovenant.Information_required_to_measure_covenant__c = eachOldCovenant.Information_required_to_measure_covenant__c;
                    eachNewCovenant.Notification_date__c = eachOldCovenant.Notification_date__c;
                    eachNewCovenant.Reason__c = eachOldCovenant.Reason__c;
                    eachNewCovenant.Regions__c = eachOldCovenant.Regions__c;
                    eachNewCovenant.Report_Date__c = eachOldCovenant.Report_Date__c;
                    eachNewCovenant.Required_level__c = eachOldCovenant.Required_level__c;
                    eachNewCovenant.Site__c = eachOldCovenant.Site__c;
                    eachNewCovenant.Status__c = eachOldCovenant.Status__c;
                    eachNewCovenant.WebICA_Application_Number__c = eachOldCovenant.WebICA_Application_Number__c;
                }
            }else{
                CovenantTriggerFunctions.updateCaseServiceTypeInfoBeforeInsert(newCovenantRecords);
            }
            
            	
        }
    }
    
    // MNEKHUBVI: 20200627

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param covenantId 
    * @param flag 
    **/
    public static void createTask(Id covenantId , String flag){
         List<ProcessInstance> instances = [SELECT Id,TargetObjectId,(SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance Where TargetObjectId =:covenantId];
        String approverComments;
        for(ProcessInstance pi:instances){
        	for (ProcessInstanceStep step : pi.Steps) {
                if(step.StepStatus == 'Approved') {
                      approverComments = step.Comments;
                 }
                else if(step.StepStatus == 'Rejected'){
                	   approverComments = step.Comments;
            }
          }
        }
        List<Covenant__c> covenantReq = [Select Id , Name ,Frequency__c , Account__c , OwnerId , Due_date__c , Notification_date__c from Covenant__c where Id =:covenantId LIMIT 1];
        if(flag == 'Create'){
            createTaskFutureCallout(covenantReq[0].Name,covenantReq[0].Account__c,covenantReq[0].OwnerId,covenantReq[0].Due_date__c  , covenantReq[0].Notification_date__c);
        }else{
            if(covenantReq[0].Frequency__c == 'Annually'){
            	covenantReq[0].Due_date__c = covenantReq[0].Due_date__c.addMonths(12);
            	covenantReq[0].Notification_date__c = covenantReq[0].Notification_date__c - 5;
                createTaskFutureCallout(covenantReq[0].Name,covenantReq[0].Account__c,covenantReq[0].OwnerId,covenantReq[0].Due_date__c  , covenantReq[0].Notification_date__c);
                updateCovenantFutureCallout(covenantReq[0].Id , covenantReq[0].Due_date__c , covenantReq[0].Notification_date__c  , flag ,approverComments);  

            }else if(covenantReq[0].Frequency__c == 'Quarterly'){
           		covenantReq[0].Due_date__c = covenantReq[0].Due_date__c.addMonths(3);
            	covenantReq[0].Notification_date__c = covenantReq[0].Notification_date__c - 5;
                createTaskFutureCallout(covenantReq[0].Name,covenantReq[0].Account__c,covenantReq[0].OwnerId,covenantReq[0].Due_date__c  , covenantReq[0].Notification_date__c);
                updateCovenantFutureCallout(covenantReq[0].Id , covenantReq[0].Due_date__c , covenantReq[0].Notification_date__c  , flag ,approverComments);  


        	}else if(covenantReq[0].Frequency__c == 'Monthly'){
            	covenantReq[0].Due_date__c = covenantReq[0].Due_date__c.addMonths(1);
            	covenantReq[0].Notification_date__c = covenantReq[0].Notification_date__c - 5;
                createTaskFutureCallout(covenantReq[0].Name,covenantReq[0].Account__c,covenantReq[0].OwnerId,covenantReq[0].Due_date__c  , covenantReq[0].Notification_date__c);
                updateCovenantFutureCallout(covenantReq[0].Id , covenantReq[0].Due_date__c , covenantReq[0].Notification_date__c  , flag ,approverComments);  
        	}else if(covenantReq[0].Frequency__c == 'Bi-Annually'){
            	covenantReq[0].Due_date__c = covenantReq[0].Due_date__c.addMonths(6);
            	covenantReq[0].Notification_date__c = covenantReq[0].Notification_date__c - 5;
                createTaskFutureCallout(covenantReq[0].Name,covenantReq[0].Account__c,covenantReq[0].OwnerId,covenantReq[0].Due_date__c  , covenantReq[0].Notification_date__c);
                updateCovenantFutureCallout(covenantReq[0].Id , covenantReq[0].Due_date__c , covenantReq[0].Notification_date__c  , flag ,approverComments);  
            }

        }
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param covenantId 
    * @param accountId 
    **/
    public static void completeTask(String covenantId , String accountId){
        String covenantString = 'Covenant#' + covenantId;
        System.debug('Covenant Number ' + covenantString);
        List<Task> tasks = new TasksSelector().selectBySubject(covenantString , accountId);
        if(tasks != null && tasks.size() > 0){
            updateTaskFutureCallout(tasks[0].Id);
        }
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param name 
    * @param accountId 
    * @param ownerId 
    * @param dueDate 
    * @param notificationDate 
    **/
    @future(callout=true)
    public static void createTaskFutureCallout (String name,String accountId , String ownerId, Date dueDate, Date notificationDate) {
            Task tsk = new Task();
			tsk.Subject = 'Covenant#' + name;
            tsk.Covenant_Number__c = name;
			tsk.Status = 'Scheduled';
			tsk.Priority = 'Normal';
			tsk.WhatId = accountId;
			tsk.OwnerId = ownerId;
            tsk.ActivityDate = dueDate;
            tsk.IsReminderSet = true;
            tsk.ReminderDateTime = notificationDate;
			insert tsk;
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param taskId 
    **/
     @future(callout=true)
    public static void updateTaskFutureCallout (String taskId) {
            Task tsk = new Task(Id=taskId);
			tsk.Status = 'Completed';
			update tsk;
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-22 
    * @param covenantId 
    * @param dueDate 
    * @param notificationDate 
    * @param flag 
    * @param comments 
    **/
     @future(callout=true)
    public static void updateCovenantFutureCallout (Id covenantId , Date dueDate , Date notificationDate,string flag ,String comments){
        Covenant__c covenant = new Covenant__c(Id = covenantId);
        covenant.AMC_Comments__c = comments;
        if(flag == 'update'){
            covenant.Due_date__c = dueDate;
            covenant.Notification_date__c = notificationDate;
        }else{
            covenant.Status__c = 'CLOSE';
        }

        update covenant;
    }

}