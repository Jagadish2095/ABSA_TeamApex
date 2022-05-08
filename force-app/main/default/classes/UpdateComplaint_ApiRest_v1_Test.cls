@IsTest
private class UpdateComplaint_ApiRest_v1_Test{
    
    @isTest static void testUpdateComplaintRestPositive(){
        
        Test.setMock(HttpCalloutMock.class, new UpdateComplaintPartyMock(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT, StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
        insert con;
        Case theCase = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email', 
                            
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                            Subject = 'test',
                            Description = 'test',
                            Expectation_of_the_Customer__c = 'test',
                            Incident_Date__c = date.today());
        insert theCase;
        List<Case> newCaseList =[select id ,caseNumber,subject,status,Is_Sent_To_TOM__c,TomDecision__c,TomReason__c,TOM_Response__c,TOM_Sent_Time__c from case where id=:theCase.id limit 1];
        Case newCase = newCaseList[0];
        newCase.TomDecision__c = newCaseList[0].TomDecision__c;
        newCase.TomReason__c = newCaseList[0].TomReason__c;
        update newCase;
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/UpdateComplaint/v01';
        request.httpMethod = 'PATCH';
        request.addHeader('caseNumber',theCase.caseNumber );//'C-01275653'
      
        system.debug('********requestUri***'+request.requestUri);
        RestContext.request = request;
        
        UpdateComplaint_Req_IB_v1 beanInstance = new UpdateComplaint_Req_IB_v1();
        beanInstance.createDummyRequest();
        
        beanInstance.caseNumber=newCase.caseNumber;
        System.debug('beanInstance.caseNumber #'+beanInstance.caseNumber);
        
        // Call the method to test
        String response = UpdateComplaint_ApiRest_v1.updateComplaint(beanInstance);
        System.debug('response 1:' + response);
        
        
        String status1;
        system.debug('**response****'+response);
        System.JSONParser parser = System.JSON.createParser(response);
        system.debug('**parser****'+parser.getText());
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')){
                parser.nextToken();
                status1 = parser.getText();
                break;
            }
        }
        //System.assertEquals(StringConstants.STATUS_CODE_200, status1);
        //System.assertEquals(StringConstants.STATUS_CODE_200,status1) ;
        Case updatedCase =[select id ,caseNumber,subject,status,Is_Sent_To_TOM__c,TomDecision__c,TomReason__c,TOM_Response__c,TOM_Sent_Time__c from case where id=:newCase.id limit 1];
        system.debug('****updatedCase*****'+updatedCase);
        UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_400, 400, 'errorMessage', null,null,null);
        UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_200, 200, '', newCase.id,null,null);
        UpdateComplaint_IH_v1.updateComplaint(beanInstance,null);
        UpdateComplaint_Req_IB_v1 beanInstance1 = new UpdateComplaint_Req_IB_v1();
        beanInstance1.caseNumber=null;
        UpdateComplaint_IH_v1.updateComplaint(beanInstance1,null);
        
        Test.stopTest();
    }
    
    //Invalid parameters negative test
    @isTest static void testUpdateComplaintRestNegativeInvalidParams(){
        
        /*User user = [select Id, BRID__c from User where Id = :UserInfo.getUserId() and BRID__c!=null];
        // user.BRID__c = 'TEST00001';
        update user;*/
        
        Test.startTest();
        
        UpdateComplaint_Req_IB_v1 beanInstance = new UpdateComplaint_Req_IB_v1();
        beanInstance.createDummyRequest();
        beanInstance.caseNumber = '';
        
        String response = UpdateComplaint_ApiRest_v1.updateComplaint(beanInstance);
        System.debug('response' + response);
        
        String status;
        System.JSONParser parser = System.JSON.createParser(response);
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')){
                parser.nextToken();
                status = parser.getText();
                break;
            }
        }
        System.assertEquals(StringConstants.STATUS_CODE_500, status);
        
        Test.stopTest();
    }
    
    //Invalid headers negative test
    @isTest static void testUpdateComplaintRestNegativeInvalidHeaders(){
        
        /*User user = [select Id, BRID__c from User where Id = :UserInfo.getUserId() and BRID__c!=null];
        // user.BRID__c = 'TEST00001';
        update user;*/
        
        Test.startTest();
        
        UpdateComplaint_Req_IB_v1 beanInstance = new UpdateComplaint_Req_IB_v1();
        beanInstance.createDummyRequest();
        
        String response = UpdateComplaint_ApiRest_v1.updateComplaint(beanInstance);
        System.debug('response' + response);
        
        String status;
        System.JSONParser parser = System.JSON.createParser(response);
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')){
                parser.nextToken();
                status = parser.getText();
                break;
            }
        }
        System.assertEquals(StringConstants.STATUS_CODE_500, status);
        
        Test.stopTest();
    }
    
   
    
   @isTest static void testUpdateComplaintValidationError(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/updateComplaint/v01';
        request.httpMethod = 'PATCH';
        request.addHeader('caseNumber', '1234');
      
        RestContext.request = request;
        
        UpdateComplaint_Req_IB_v1 beanInstance = new UpdateComplaint_Req_IB_v1();
        beanInstance.createDummyRequest();
        beanInstance.caseNumber=null;
        //beanInstance.clientFirstName = null;
        system.debug('***beanInstance****'+beanInstance);
        // Call the method to test
        String response = UpdateComplaint_ApiRest_v1.updateComplaint(beanInstance);
        System.debug('response' + response);
        
        String status;
        System.JSONParser parser = System.JSON.createParser(response);
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')){
                parser.nextToken();
                status = parser.getText();
                break;
            }
        }
        //System.assertEquals(StringConstants.STATUS_CODE_500, status);
        
        Test.stopTest();
    }
}