@isTest
public class BankCodesUpdateCTRLTest {

    public static testMethod void testUpdateRegistrationCase()
    { 
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'Declined',
                                Origin = 'Email',
                                Account = account,
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Type__c = 'Dispute Debit Order',
                                Description = 'test',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Reference_Number__c = 'REG-1213',
                                Incident_Date__c = date.today());
        insert caseRec;
      
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{ "caseId": "REG-171", "success": true, "status": "UPDATED"}'));
        
        Test.startTest();
        
        string responseBean = BankCodesUpdateCTRL.SendRegistrationCaseToDigital(caseRec.Id);
        
      //  System.assert(responseBean.contains('Please Close the Case before Submitting!'));
       // System.assert(responseBean);
        Test.stopTest();
        
    }
      public static testMethod void testUpdateRequestCase()
    { 
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'Case Closed',
                                Origin = 'Email',
                                AccountId = account.id,
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Type__c = 'Full general report',
                                Description = 'test',
                                sd_Service_Group__c = 'Bank Codes',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Reference_Number__c = 'BCFGR462',
                                Incident_Date__c = date.today());
        insert caseRec;
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{"statusCode":200,"status":null,"message":null,"Fault":null,"success":true,"status":"OK","caseId":"BCFGR462"}'));
        
        Test.startTest();
       // caseRec.Status = 'Closed';
        //update caseRec;
        string responseBean = BankCodesUpdateCTRL.SendRequestCaseToDigital(caseRec.Id);
        // System.assert (responseBean);
       //  System.assert(responseBean.contains('Please Close the Case before Submitting!'));
        Test.stopTest();
    }
      public static testMethod void testUpdateRequestCase2()
    { 
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'In Progress',
                                Origin = 'Email',
                                AccountId = account.id,
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Type__c = 'Full general report',
                                Description = 'test',
                                sd_Service_Group__c = 'Bank Codes',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Reference_Number__c = 'BCFGR462',
                                Incident_Date__c = date.today());
        insert caseRec;
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{"statusCode":200,"status":null,"message":null,"Fault":null,"success":true,"status":"OK","caseId":"BCFGR462"}'));
        
        Test.startTest();
       // caseRec.Status = 'Closed';
        //update caseRec;
        string responseBean = BankCodesUpdateCTRL.SendRequestCaseToDigital(caseRec.Id);
        // System.assert (responseBean);
         System.assert(responseBean.contains('Please Close the Case before Submitting!'));
        Test.stopTest();
    }
}