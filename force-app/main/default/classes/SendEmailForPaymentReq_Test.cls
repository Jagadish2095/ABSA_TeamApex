@isTest
private class SendEmailForPaymentReq_Test {
    
   @isTest
    static void getStatementToDownloadTest(){
    Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.NEGATIVE_STRING));

        String jsonString;
         Account acc = new Account();
       acc.name = 'test acc';
       acc.CIF__c = 'cif007';
       insert acc;
        
        Contact contact = new Contact(LastName='Test contact',Email = 'test@test.com', AccountId = acc.Id);
        insert contact;

          map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
       Case testCase = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                AccountId = acc.Id,
                                ContactId= contact.Id,
                                Email__c = 'test@test.com',
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                SLA_Pause_Flag__c  = true,
                                Expectation_of_the_Customer__c = 'test',
                                Type__c  = 'typeA',
                                 Incident_Date__c = date.today());
        insert testCase;
     
     
        Test.startTest();
        if(testCase != null){
           SendEmailForPaymentReq.sendEmailOnCaseClose(testCase.Id, 'Email@test.com','PaymentRequestClientCommunication' );
           String emailAddress = 'test@gmail.com';
        
        }
        Test.stopTest();
        
    }
}