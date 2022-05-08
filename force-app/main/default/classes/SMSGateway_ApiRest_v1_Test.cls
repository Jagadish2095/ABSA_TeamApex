@IsTest
public class SMSGateway_ApiRest_v1_Test {
    
    @isTest static void testSmsReplyRestPositive(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Replies&MessageReference=300001139374&PhoneNumber=+27821234567&SourceNumber=+2782007000260543&CreateTime=2004/04/05 12:20:01&MessageText=It is me&UserReference=ABC123&Flags=&OriginalText=Who Is It';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsReplyRestNegative(){
        
        Test.startTest();
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsReplyRestNoReference(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Replies&PhoneNumber=+27821234567&SourceNumber=+2782007000260543&CreateTime=2004/04/05 12:20:01&MessageText=It is me&UserReference=ABC123&Flags=&OriginalText=Who Is It';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsReplyRestNoMsgText(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Replies&MessageReference=300001139374&PhoneNumber=+27821234567&SourceNumber=+2782007000260543&CreateTime=2004/04/05 12:20:01&UserReference=ABC123&Flags=&OriginalText=Who Is It';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsReplyRestNoTask(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        RestContext.request = request;
        String myString = 'Type=Replies&MessageReference=300001139374&PhoneNumber=+27821234567&SourceNumber=+2782007000260543&CreateTime=2004/04/05 12:20:01&MessageText=It is me&UserReference=ABC123&Flags=&OriginalText=Who Is It';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsNotificationRestPositive(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Notification&Status=16&StatusDescription=Confirmed&MessageReference=300001139374&PhoneNumber=+27821234567&CreateTime=2017/02/05 13:20:04&ScheduledTime=2017/02/05 13:22:00&SubmitTime=2017/02/05 13:21:59&ConfirmTime=2017/02/05 13:22:00&FinalTime=2017/02/05 14:16:55&UserReference=DEF1234&MessageText=Test Message 123';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsNotificationRestNoTask(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        RestContext.request = request;
        String myString = 'Type=Notification&Status=3&StatusDescription=Confirmed&MessageReference=300001139374&PhoneNumber=+27821234567&CreateTime=2017/02/05 13:20:04&ScheduledTime=2017/02/05 13:22:00&SubmitTime=2017/02/05 13:21:59&ConfirmTime=2017/02/05 13:22:00&FinalTime=2017/02/05 14:16:55&UserReference=DEF1234&MessageText=Test Message 123';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsNotificationRestNoReference(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Notification&Status=3&StatusDescription=Confirmed&PhoneNumber=+27821234567&CreateTime=2017/02/05 13:20:04&ScheduledTime=2017/02/05 13:22:00&SubmitTime=2017/02/05 13:21:59&ConfirmTime=2017/02/05 13:22:00&FinalTime=2017/02/05 14:16:55&UserReference=DEF1234&MessageText=Test Message 123';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
    
    @isTest static void testSmsNotificationRestNoStatusDescription(){
        
        Test.startTest();
        
        RestRequest request = new RestRequest();
        //Use the current base url - this is done to send headers with the request
        request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/iTouch/Reply/v01';
        request.httpMethod = 'POST';
        request.addHeader('transactionId', '1234');
        request.addHeader('initiator', 'John');
        request.addHeader('sender', 'Test System');
        
        Task testTask = new Task();
        testTask.Subject = 'Test';
        testTask.Message_Reference__c = '300001139374';
        insert testTask;
        
        RestContext.request = request;
        String myString = 'Type=Notification&Status=3&MessageReference=300001139374&PhoneNumber=+27821234567&CreateTime=2017/02/05 13:20:04&ScheduledTime=2017/02/05 13:22:00&SubmitTime=2017/02/05 13:21:59&ConfirmTime=2017/02/05 13:22:00&FinalTime=2017/02/05 14:16:55&UserReference=DEF1234&MessageText=Test Message 123';
        RestContext.request.requestBody = Blob.valueof(myString);
        
        // Call the method to test
        String response = SMSGateway_ApiRest_v1.smsInbound();
        System.debug('response :' + response);
        Test.stopTest();
    }
}