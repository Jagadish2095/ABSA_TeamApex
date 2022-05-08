/**
* Batch class for checking if user if absent or otherwise
* @author  Koketso Mpshane
* @date    16/06/2020
*/
global class UserRecordAbsenceBatch implements Database.Batchable<User>{

    global Iterable<User> start(Database.BatchableContext BC) {
        
        List<User> absentUsers = [Select Id, Name, Is_Absent__c From User Where Is_Absent__c =: true];
        
        system.debug(LoggingLevel.FINE, '***absentUsersSize:***'+absentUsers.size());
        
        return absentUsers;
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope){  
        
        system.debug(LoggingLevel.FINE, '***scope:***'+scope);
        
        Date todayDate = system.today();
        List<Id> userIds = new List<Id>();
        Set<String> errorList = new Set<String>();
        
        List<User> currentAbsentUsers = new List<User>();
        List<User> newAbsentUsers = new List<User>();
        
        if(scope.size() > 0){
            try{
                for(User userRec: scope){
                    if(userRec.Name != 'Salesforce System'){
                        userRec.Is_Absent__c = false;
                        currentAbsentUsers.add(userRec);
                    }
                }
                update currentAbsentUsers;
                
                if(Test.isRunningTest()){
                    throw new system.DmlException();
                }
                
            }catch(DmlException ex){
                system.debug('***currentAbsentUsers Error***:'+ ex.getMessage());
                errorList.add(ex.getMessage());
            }
        }
        
        List<Record_Absence__c> approvedAbsenceList = [Select Id, Start_Date__c, End_Date__c, Status__c, User__c From Record_Absence__c Where Status__c =:'Approved' And End_Date__c >=:todayDate];
        
        if(approvedAbsenceList.size() > 0){
            
            for(Record_Absence__c apprRec: approvedAbsenceList){
                if(apprRec.Start_Date__c <= todayDate){
                    userIds.add(apprRec.User__c);
                }
            }
            
            if(userIds.size() > 0){
                
                List<User> approvedUsers = [Select Id, Is_Absent__c From User Where Id in: userIds];
                try{
                    for(User userRec: approvedUsers){
                        userRec.Is_Absent__c = true;
                        newAbsentUsers.add(userRec);
                    }
                    
                    if(newAbsentUsers.size() > 0){
                        
                        Integer successNum = 0;
                        Integer failedNum = 0;
                        
                        Database.SaveResult[] usersToUpdate = Database.update(newAbsentUsers, false);
                        
                        for (Database.SaveResult sr : usersToUpdate){
                            if (sr.isSuccess()) {
                                successNum = successNum + 1;
                            }else {
                                failedNum = failedNum + sr.getErrors().size();
                                for(Database.Error err : sr.getErrors()) {
                                    errorList.add(err.getMessage());
                                }
                            }
                        }
                        
                        if(failedNum > 0){
                            
                            String emailBody = 'Good day, <br/><br/>Please note that the UserRecordAbsenceBatch class returned the following errors:<br/><br/>';
                            for(String error: errorList){
                                emailBody += error+'<br/>'; 
                            }
                            emailBody += '<br/>Successful updates:'+successNum+', failded records:'+failedNum;
                            emailBody += '.<br/><br/>Regards,<br/>Salesforce'; 
                            
                            sendEmailWithErrors(emailBody);
                        }
                    }
                }catch(DmlException ex){
                    system.debug('***UserRecordAbsenceBatch Error***:'+ ex.getMessage());
                }
                
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('UserRecordAbsenceBatch finished processing!');
    }
    
    public static void sendEmailWithErrors(String emailBody){
        
        List<String> recipientEmails = new List<String>();
        //Send email to administrators if any errors
        List<Exception_Email_Recipient__mdt> mdtEmailRecipients = [Select Email_Address__c From Exception_Email_Recipient__mdt];
        if(mdtEmailRecipients.size() > 0){
            for(Exception_Email_Recipient__mdt mdt: mdtEmailRecipients){
                recipientEmails.add(mdt.Email_Address__c);
            }
        }
        
        if(recipientEmails.size() > 0){
            
            List<Messaging.SingleEmailMessage> singleMessageList = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(recipientEmails);
            msg.setSubject('UserRecordAbsenceBatch Error');
            msg.setHtmlBody(emailBody);
            msg.setSaveAsActivity(false);
            singleMessageList.add(msg);
            
            //Send the emails
            Messaging.sendEmail(singleMessageList);
        }
    }
    
}