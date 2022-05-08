@IsTest
private class CreateOpportunity_ApiRest_v1_Test{
    
    @isTest static void testCreateOpportunitiesRestPositive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreateGetInvolvedPartyMock(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT, StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        User user = [select Id, BRID__c from User where BRID__c != null and IsActive = true limit 1];
        //user.BRID__c = 'TEST00001';
        //update user;
        
        Test.startTest();
        //Account Does Not Exist
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
        
        beanInstance.adviserBRID=user.BRID__c;
        System.debug('beanInstance.adviserBRID #'+beanInstance.adviserBRID);
        
        // Call the method to test
        String response = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
        System.debug('response 1:' + response);
        
        
        String status1;
        System.JSONParser parser = System.JSON.createParser(response);
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')){
                parser.nextToken();
                status1 = parser.getText();
                break;
            }
        }
        //System.assertEquals(StringConstants.STATUS_CODE_200, status1);
        System.assertEquals(StringConstants.STATUS_CODE_200,status1) ;
        //Account Exists
        /*String responseExists = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
        System.debug('responseExists' + responseExists);
        String status2;
        System.JSONParser parser2 = System.JSON.createParser(responseExists);
        while(parser2.nextToken() != null){
            if((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && (parser2.getText() == 'status')){
                parser2.nextToken();
                status2 = parser2.getText();
                break;
            }
        }
        System.assertEquals(StringConstants.STATUS_CODE_200, status2); */
        
        Test.stopTest();
    }
    
    //Invalid parameters negative test
    @isTest static void testCreateOpportunitiesRestNegativeInvalidParams(){
        
        /*User user = [select Id, BRID__c from User where Id = :UserInfo.getUserId() and BRID__c!=null];
        // user.BRID__c = 'TEST00001';
        update user;*/
        
        Test.startTest();
        
        CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
        beanInstance.adviserBRID = '';
        
        String response = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
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
    @isTest static void testCreateOpportunitiesRestNegativeInvalidHeaders(){
        
        /*User user = [select Id, BRID__c from User where Id = :UserInfo.getUserId() and BRID__c!=null];
        // user.BRID__c = 'TEST00001';
        update user;*/
        
        Test.startTest();
        
        CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
        
        String response = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
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
    
    //Invalid BRID Number
    @isTest static void testCreateOpportunitiesRestNegativeInvalidBridNumber(){
        
        User user = [select Id, BRID__c from User where Id = :UserInfo.getUserId() ];
        user.BRID__c = 'InvBRID01';
        update user;
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
        //beanInstance.adviserBRID = 'TEST00001';
        
        // Call the method to test
        String response = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
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
        System.assertEquals(StringConstants.STATUS_CODE_406, status);
        
        Test.stopTest();
    }
    
    @isTest static void testCreateOpportunitiesValidationError(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/createOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        RestContext.request = request;
        
        CreateOpportunity_Req_IB_v1 beanInstance = new CreateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
        beanInstance.clientFirstName = null;
        
        // Call the method to test
        String response = CreateOpportunity_ApiRest_v1.createOpportunity(beanInstance);
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
        System.assertEquals(StringConstants.STATUS_CODE_400, status);
        
        Test.stopTest();
    }
}