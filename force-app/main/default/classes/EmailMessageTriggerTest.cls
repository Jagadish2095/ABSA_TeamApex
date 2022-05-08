/**
* Test Class for EmailMessageTrigger and EmailMessageTriggerFunctions
*
**/

@IsTest public with sharing class EmailMessageTriggerTest {
	 /*
     * Purpose : Method to create test data
     */
   @testSetup
    static void dataCreation(){
       
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        User ownerId =[Select id from user where Isactive = true and profileId ='00e1r000001zvFKAAY' limit 1];
        ownerId.HasLogin__c = false;
        Update ownerId;
 
        OmniChannelQue__mdt Que = [Select MasterLabel, sd_Original_Service_QueueId__c from OmniChannelQue__mdt Limit 1];
        
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id caseServiceRequestRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(); 

        Case caseRec = new Case(RecordTypeId = caseServiceRequestRecordTypeId, Communication_Method__c = 'Email', Status = 'In Progress', Origin = 'Email', AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', OwnerId = ownerId.Id, sd_Original_Service_Queue__c =Que.MasterLabel
                                 );
        insert caseRec;
        
         //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = caseRec.Id; 
        email.ThreadIdentifier = '12323232';
        insert email;
    }
    
     //Method to test
    static testMethod void testEmailMessage() {
  
        EmailMessage EmailMessageRecord = [SELECT Id FROM EmailMessage LIMIT 1];
        Test.startTest();
        
        try  {
            delete EmailMessageRecord;
        } catch (Exception ex) {
             System.assert(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 'message=' + ex.getMessage());
        }

        Test.stopTest();
    } 
}