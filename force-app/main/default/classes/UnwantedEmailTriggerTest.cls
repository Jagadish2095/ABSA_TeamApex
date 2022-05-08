/**
* @description Test class for ProfilesSelector
* @since 2019-04-29
**/

@isTest
public class UnwantedEmailTriggerTest {
    
    /*
    * Purpose : Method to create test data
    */
    @testSetup
    static void dataCreation(){
        
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id clientRecordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId(); 
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Unwanted_Email__c testUnwantedEmail = new Unwanted_Email__c();
        testUnwantedEmail.To_Address__c = 'ceo@test.com';
        testUnwantedEmail.Subject__c = 'Testing';
        testUnwantedEmail.From_Address__c = 'test@test.com';    
        testUnwantedEmail.Email_Body__c = 'New email';
        insert testUnwantedEmail;
        
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', 
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
        
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;

    }
    
    @isTest
    private static void testFindClosedCaseByExternalReferenceNo() {
        Unwanted_Email__c unwantedEmail = [SELECT Id, To_Address__c, Subject__c, Convert_To_Case__c, Sender_Name__c, Retention_Period_Hrs__c, From_Address__c, Email_Body__c, Name FROM Unwanted_Email__c LIMIT 1];
        Service_Group__c serviceGroupRecord = [SELECT Id, Name FROM Service_Group__c LIMIT 1 ];
        
        test.startTest();
        unwantedEmail.Convert_To_Case__c = True;
        unwantedEmail.Service_Group_Search__c = serviceGroupRecord.Id;
        update unwantedEmail;
        test.stopTest();
    }
}