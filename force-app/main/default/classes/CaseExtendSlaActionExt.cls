/**
* Apex controller class for the Aura bundle ExtendSLA.
* Allow a user extend the predefined SLA
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-
*
**/
public without sharing class CaseExtendSlaActionExt {
    
    /*
* Get the Case record with SLA Information
* 
* @param recId - Case Id
* @return Case record
*/
    @AuraEnabled
    public static Case getCaseRecord(String recId){
        try{
            List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1 );
            
            if(caseRecord.size() > 0){
                caseRecord[0].SLA_Extension_Reason__c = '';
                return caseRecord[0];
            }else{
                return null;
            }
        }Catch(Exception ex){
            throw new AuraHandledException(ex.getMessage()); 
        } 
    } 
    
    /*
* Get the Case record with SLA Information
* 
* @param recId - Case Id
* @param reason - extension reason
* @param newSLADate - new
* @param isApprovalReq - Case Id

*/    
    @AuraEnabled
    public static void extendExternalSLA(String recId, String reason, DateTime newSLADate, Boolean isApprovalReq )
    {

        List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1 );
        // Check if the current owner is a queue or current owner is not the logged in User, if yes,throw error for NBFS Case Record Type
        if(!String.valueOf( caseRecord[0].OwnerId ).startsWith('005') && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
                    System.debug('You cannot Extend a Case. Please change the Case Owner.');
                    throw new AuraHandledException('You cannot Extend a Case. Please change the Case Owner.');
        }
        else if(caseRecord[0].OwnerId != UserInfo.getUserId() && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
              System.debug('You cannot Extend a Case. Please change the Case Owner.');
              throw new AuraHandledException('You cannot Extend a Case.');
        }
        else if(caseRecord[0].ClosedDate != null && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
            System.debug('The Case is already closed.');
              throw new AuraHandledException('The Case is already closed.');
        }
        
        if(caseRecord[0].SLA_Extension_Approval_Required__c == True)
        {
            Try
            {
                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments(reason);
                req1.setObjectId(recId);
                
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
                
                // Verify the result
                System.assert(result.isSuccess());
                Approval.UnlockResult lrList = Approval.unlock(caseRecord[0], TRUE);
                
            }catch(DmlException ex){
                //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
                String msg = '';
                //Get All DML Messages
                for (Integer i = 0; i < ex.getNumDml(); i++) {
                    //Get Validation Rule & Trigger Error Messages
                    msg =+ ex.getDmlMessage(i) +  '\n' ;
                }
                //throw DML exception message
                throw new AuraHandledException(msg);
                
            } catch (Exception ex){
                throw new AuraHandledException(ex.getMessage()); 
            }      
        } 
    }
    
    /*
* Calculate the new SLA dates based on the SLA EXtension Time Measure and Units
* 
* @param recId - Case Id
* @param reason - extension reason
* @param extensionQuantity - extension unit
* @param extensionMeasure - extension time measure
* @param extensionDate - extension date picker
* @return Boolean
*/        
    @AuraEnabled
    public static Boolean calculateNewSlaDate(String recId, String reason, String extensionQuantity, String extensionMeasure, DateTime extensionDate)
    {       
        Boolean approvalRequired = false;
        List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1 );
        DateTime externalSLADate;
        DateTime warningSLADate;
        
         // Check if the current owner is a queue, if yes,throw error for NBFS Case Record Type
        if(!String.valueOf( caseRecord[0].OwnerId ).startsWith('005') && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
                    System.debug('You cannot Classify a Case. Please change the Case Owner.');
                    throw new AuraHandledException('You cannot Extend a Case. Please change the Case Owner.');
        }
        else if(caseRecord[0].OwnerId != UserInfo.getUserId() && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
              System.debug('You cannot Extend a Case. Please change the Case Owner.');
              throw new AuraHandledException('You cannot Extend a Case.');
        }
        else if(caseRecord[0].ClosedDate != null && (caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution' || caseRecord[0].RecordType.Name == 'Short Term Complaint')){
            System.debug('The Case is already closed.');
              throw new AuraHandledException('The Case is already closed.');
        }
        if(extensionDate != null)
        {
            externalSLADate = extensionDate;
            warningSLADate = BusinessHours.add(caseRecord[0].BusinessHoursId, externalSLADate, -1);
        }
        else if (extensionQuantity != null && extensionMeasure != null)
        {
            //Calculate new SLA End Date            
            String timeMeasure = extensionMeasure;
            Integer timeUnits = Integer.valueOf(extensionQuantity);
            
            //hours in milliseconds
            if(timeMeasure.contains('Hour')){
                timeUnits = timeUnits * 60 * 60 * 1000;
            }else if(timeMeasure.contains('Day')){
                timeUnits = timeUnits * 8; //8 hour day
                timeUnits = timeUnits * 60 * 60 * 1000;
            }else if(timeMeasure.contains('Week')){
                timeUnits = timeUnits * 40; //5 day week at 8 hours per day
                timeUnits = timeUnits * 60 * 60 * 1000;
            }
            
            Integer warningTime = 0;
            
            //If SLA is 1 hour use 30min as warning else 60min
            if(timeUnits == (60 * 60 * 1000)){
                warningTime = 30 * 60 * 1000; //30min
            }else if(timeUnits > (60 * 60 * 1000)){
                warningTime = 60 * 60 * 1000; //60min
            }
            //This should be the Team Classifications SLA dates
            externalSLADate = BusinessHours.add(caseRecord[0].BusinessHoursId,caseRecord[0].External_SLA_End_Date__c, timeUnits);
            warningSLADate = BusinessHours.add(caseRecord[0].BusinessHoursId, externalSLADate, ( warningTime * -1));
        }
        
        if(externalSLADate != null)
        {
            if(externalSLADate > caseRecord[0].Max_SLA_Extension_Date__c || caseRecord[0].Max_SLA_Extension_Date__c == null)
            {
                approvalRequired = true;
                caseRecord[0].SLA_Extension_Approval_Required__c = true;
                caseRecord[0].Extended_Warning_SLA_End_Date__c = warningSLADate;
                caseRecord[0].Extended_SLA_End_Date__c = externalSLADate;

            }
            else
            {
                approvalRequired = false;
                caseRecord[0].External_SLA_Warning_Date__c = warningSLADate;
                caseRecord[0].External_SLA_End_Date__c = externalSLADate;

                caseRecord[0].Internal_SLA_Warning_Date__c = warningSLADate - 1;
                caseRecord[0].Internal_SLA_End_Date__c = externalSLADate - 1;
                caseRecord[0].SLA_Extended__c = true;
            }
            caseRecord[0].SLA_Extension_Reason__c = reason;
            //Added by Mbuyiseni Mbhokane : requirement from Short term insurance
            if(caseRecord[0].RecordType.Name == 'Short Term Complaint'){
                caseRecord[0].SLA_Extension_Quantity__c = Decimal.valueOf(extensionQuantity);
                caseRecord[0].SLA_Extension_Time_Measure__c = extensionMeasure;
            }
            update caseRecord[0];
        }
        return approvalRequired;
    }
    /*
* See if there ia an existing approval process in place
* 
* @param recId - Case Id
* @return Boolean
*/        
    @AuraEnabled
    public static Boolean approvalProccessChecks(String recId)
    {
        Boolean approvalProcessInProgress;
        List<ProcessInstance> existingApprovalRequest = new List<ProcessInstance> ();
        
        //Existing/Pending Approval?
        existingApprovalRequest = [
            Select Id, TargetObjectId, isDeleted, Status,
            (
                Select Id, ProcessInstanceId, ActorId, Actor.Name, StepStatus, Comments 
                From StepsAndWorkItems
                Where 
                StepStatus = 'Pending'  and
                isDeleted = false 
                Order By 
                Createddate Desc
                Limit 1
            )
            From ProcessInstance
            Where
            isDeleted = false and
            TargetObjectId = :recId and
            Status = 'Pending'
            Order By 
            Createddate Desc
            Limit 1
        ];
        
        if(existingApprovalRequest.isEmpty())
        {
            approvalProcessInProgress =  false;
        }
        else
        {
            approvalProcessInProgress = true;
        }
        return approvalProcessInProgress;
    } 
    
    /*Sive Kula - Get the List of holidays*/
    @AuraEnabled
    public static List<String> getHolidays(){
        //Get Case record
        List<String> listOfHolidays = new List<String>();
        
        try{
            List<Holiday> holidays = [select Id, Name, ActivityDate FROM Holiday];
            
            if(holidays.size() > 0){
                
                for(Holiday h :holidays){
                    listOfHolidays.add(String.valueOf(h.ActivityDate));
                }
            }
        }Catch(Exception ex){
            System.debug('There was an error getting the Holidays - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage()); 
        } 
        return listOfHolidays;
    }
    
    // uplaod documents for extend SLA in NBFS by kalyani
    @AuraEnabled
    public static string updateContentDocument(String caseId, String contentDocumentId) {
        system.debug('cdl2');
        ContentDocumentLink cdl= [select Id,LinkedEntityId,ContentDocumentId,Sharetype from ContentDocumentLink where ContentDocumentId =: contentDocumentId limit 1];
        ContentDocumentLink cdl2 =cdl.clone();
        cdl2.LinkedEntityId =caseId;
        cdl2.Sharetype = 'V';
        upsert cdl2;
        system.debug('cdl2'+cdl2);
        return 'success';
    } 
    
}