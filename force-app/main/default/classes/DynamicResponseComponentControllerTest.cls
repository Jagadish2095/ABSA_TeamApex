@IsTest
public class DynamicResponseComponentControllerTest {
    
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Bank Codes');
        insert account;
        
        Contact contact = new Contact(LastName='Bank Codes', AccountId = account.Id, Email = 'bc@support.co.za');
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Bank Codes';
        serviceGr.Assign_Record_Type__c = 'Service Request';
        serviceGr.Response_Email_Address__c = 'test@test.com';
        serviceGr.Queue__c = 'Bank Codes';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '24';
        insert serviceGr;
        
        Service_Type__c serviceType = new Service_Type__c();
        serviceType.Name = 'Bank Codes Registration';
        serviceType.Type__c = 'Request';
        serviceType.Subtype__c = 'Bank Codes Registration';
        insert serviceType;
        
        Case caseRec = new Case();
        caseRec.Status = 'New';
        caseRec.Origin = 'Web'; 
        caseRec.AccountId = account.Id;
        caseRec.Response_Body__c = 'lorem ipsum dolom';
        caseRec.Extended_Request_Data__c = 'lorem ipsum dolom';
        caseRec.Subject = 'registration case';
        caseRec.Service_Type_Search__c = serviceType.Id;
        caseRec.Incident_Date__c = date.today();
        caseRec.BusinessHoursId = businessHr.id;
        insert caseRec;
        
      
    }
    static testMethod void getCaseResponse()
    {
        Case newCaseRecord = [SELECT id FROM Case LIMIT 1];
        test.startTest();
        String c = DynamicResponseComponentController.getCaseData(newCaseRecord.Id);
        String c2 = DynamicResponseComponentController.getAllResponseRecords(newCaseRecord.Id);
        System.assertEquals('lorem ipsum dolom', c);
        System.assertEquals('lorem ipsum dolom', c2);
        test.stopTest();
    }
      static testMethod void getCaseNegativeResponse()
    {
        Case newCaseRecord = [SELECT id FROM Case LIMIT 1];
        test.startTest();
        newCaseRecord.Response_Body__c = null;
        newCaseRecord.Extended_Request_Data__c = null; 
        delete newCaseRecord;
        String c = DynamicResponseComponentController.getCaseData(newCaseRecord.Id);
        String c2 = DynamicResponseComponentController.getAllResponseRecords(newCaseRecord.Id);
        System.assertEquals(null, c);
        System.assertEquals(null, c2);
        test.stopTest();
    }
    
}