@IsTest
public class SFUpdateOpportunity_ApiRest_v1_Test {
    
    @isTest static void testUpdateOpportunitieHappyPath(){
       
        Test.startTest();
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/UpdateOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
             
        RestContext.request = request;
        
        
        SalesForceUpdateOpportunity_Req_IB_v1 beanInstance = new SalesForceUpdateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequest();
       
        System.debug('Lead Number:' + beanInstance.leadNumber);
        
        // Call the method to test
        String response = SalesForceUpdateOpportunity_ApiRest_v1.UpdateOpportunity(beanInstance);
        System.debug('response 1:' + response);

         
    }
    
    @isTest static void testUpdateOpportunitiesInvalidStatus(){
       
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/UpdateOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        RestContext.request = request;
        
        SalesForceUpdateOpportunity_Req_IB_v1 beanInstance = new SalesForceUpdateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequestInvalidStatus();
        
        System.debug('Lead Number:' + beanInstance.leadNumber);
        
        // Call the method to test
        String response = SalesForceUpdateOpportunity_ApiRest_v1.UpdateOpportunity(beanInstance);
        System.debug('response 1:' + response);

         
    }
    
    @isTest static void testUpdateOpportunitiesRequiredFields(){
       
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/UpdateOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        RestContext.request = request;
        
        SalesForceUpdateOpportunity_Req_IB_v1 beanInstance = new SalesForceUpdateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequestRequiredFields();
        
        System.debug('Lead Number:' + beanInstance.leadNumber);
        
        // Call the method to test
        String response = SalesForceUpdateOpportunity_ApiRest_v1.UpdateOpportunity(beanInstance);
        System.debug('response 1:' + response);

         
    }
    
    @isTest static void testUpdateOpportunitiesOpportunityAlreadyExist(){
       
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/UpdateOpportunity/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        RestContext.request = request;
        
        SalesForceUpdateOpportunity_Req_IB_v1 beanInstance = new SalesForceUpdateOpportunity_Req_IB_v1();
        beanInstance.createDummyRequestOpportunityAlreadyExist();
        
        System.debug('Lead Number:' + beanInstance.leadNumber);
        
        // Call the method to test
        String response = SalesForceUpdateOpportunity_ApiRest_v1.UpdateOpportunity(beanInstance);
        System.debug('response 1:' + response);

         
    }
    
    @isTest static void testUpdateOpportunitiesThrowException(){
       
        Test.startTest();
        
        SalesForceUpdateOpportunity_Req_IB_v1 beanInstance = new SalesForceUpdateOpportunity_Req_IB_v1();
        beanInstance.leadNumber = null;
        beanInstance.comments = null;
        
        System.debug('Lead Number:' + beanInstance.leadNumber);
        
        // Call the method to test
        String response = SalesForceUpdateOpportunity_ApiRest_v1.UpdateOpportunity(beanInstance);
        System.debug('response 1:' + response);

         
    }




}