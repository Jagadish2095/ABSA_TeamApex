/*
* Test Class for DBS_Dashboard_Populate_Controller and DBS_Dashboard_Inbound_Service classes
* @author Mhlangano Khumalo
* @created date 2019-05-12
*/  
@isTest
public class DBS_Dashboard_Test {   
    @testSetup 
    static void setup() { 
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken', 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBbGJpZSIsInJvbGUiOiJhZG1pbiwgdXNlciIsImV4cCI6MTU2NTI0NTQ4MH0.gxfNHxfvOCf2LOb9tP5k2mxEDRiVsgV8BWvVYmFbrw0JX2zRGesHDFTWn0nEBJn3Ym7GiCAQ3z7leRtqsKsSWw');  
        
        //create robot data 
        Robot_Data_Retrieval__c robotData = new Robot_Data_Retrieval__c(Name='948601');
        insert robotData;
        
        //create robot action
        Robot_Data_Action__c robotAction = new Robot_Data_Action__c(Queue_Item_ID__c='948601', Action_Type__c='Notes');
        insert robotAction;  
        
        //create robot monitoring data 
        DBS_Monitoring_Robots__c robotMon = new DBS_Monitoring_Robots__c(BotName__c='bpp0101');
        insert robotMon;
        
        //create robot monitoring result
        DBS_Monitoring_Result__c robotMonRes = new DBS_Monitoring_Result__c(result__c='bpp0101');
        insert robotMonRes;
        
        Test.setCreatedDate(robotData.Id, DateTime.now().addMonths(-6)); 
        Test.setCreatedDate(robotAction.Id, DateTime.now().addMonths(-6));
        Test.setCreatedDate(robotMonRes.Id, DateTime.now().addMonths(-6));
        
        
        Integration_API__c jitterBitApi = new Integration_API__c(Name='Jitterbit2',Client_ID__c='e33caff9-53d8-43ad-8b2a-d5531aae3c06',Base_URL__c='https://absa.jitterbit.eu/JBUAT/v1.0/dsg',Environment__c='Production');
        insert jitterBitApi;
        
        Integration_API__c jitterBitApi1 = new Integration_API__c(Name='Jitterbit',Client_ID__c='e33caff9-53d8-43ad-8b2a-d5531aae3c06',Base_URL__c='https://absa.jitterbit.eu/JBUAT/v1.0/dsg',Environment__c='Production');
        insert jitterBitApi1;        
        
        Integration_API__c intApi = new Integration_API__c(Name = 'Api Manager',Base_URL__c='https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/abbot/services/abbot-work-queue-item-management', Client_ID__c='13186907-69bc-4b2a-a0e5-bfccb4ea326d',Client_Secret__c='mK8uT2bC2yK7sF8rF0tE5nR0pV5dK6yL2bE5eY5bW4fL0oJ7iJ',Environment__c=''); //rakesh changed from Development to null 
        insert intApi ;
        
        List<Integration_Service__c> intService = new List<Integration_Service__c>();
        intService.add(new Integration_Service__c(Name='DBS DIVE Authorise Jitterbit', Content_Type__c='application/json', Method__c='POST', Password__c='abcd12345', URL_Extension__c='/clients/auth_positive', Username__c='d_absa/abc1234@545fdaf', Integration_API_ID__c=jitterBitApi.id));
        intService.add(new Integration_Service__c(Name = 'Get Abbot Queue Item', Content_Type__c='application/json',Method__c='GET',URL_Extension__c='/abbot/abbot-work-queue-item-management', Username__c='d_absa/abc1234',Integration_API_ID__c=jitterBitApi.id)); 
        intService.add(new Integration_Service__c(Name = 'Create Abbot Queue Item', Content_Type__c='application/json',Method__c='POST',URL_Extension__c='/abbot/abbot-work-queue-item-management', Username__c='d_absa/abc1234',Integration_API_ID__c=jitterBitApi.id));

		intService.add(new Integration_Service__c(Name = 'DIVEAuthToken', Content_Type__c='application/json',Method__c='POST',URL_Extension__c='https://absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/auth/token', Username__c='salesforce', Password__c='P@ssword01'));
		
        insert intService;
        
      
    
    }
    public static void pointToDev(){
        Integration_API__c credsObj = [select id ,Environment__c from Integration_API__c where name ='Jitterbit2'];
        credsObj.Environment__c ='';//rakesh changed from Development to null
        update credsObj;
    }
    
    /**************************************************************************************************
    **********************************Get Rest Response Test ******************************************
    ***************************************************************************************************/    
    @isTest   
    static void positiveTest_GetRestResponse(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('12');
        System.assertEquals('Success', response.get('api_status'));            
        System.AssertEquals(7, response.size());
        Test.stopTest();
    }

    @isTest   
    static void negativeTest_GetRestResponse1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('21');
        System.assertEquals('Failure', response.get('api_status'));
        System.AssertEquals(2, response.size());
        Test.stopTest();
    }  

    @isTest   
    static void negativeTest_GetRestResponse2(){ //ntegrationServiceCheck.IsEmpty()
        list<Integration_Service__c> integrationServiceCheck = [Select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];  
        delete integrationServiceCheck;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('00001');
        System.assertEquals('Failure', response.get('api_status'));
        System.AssertEquals(2, response.size());
        Test.stopTest();
    }
    @isTest 
    static void negativeTest_GetRestResponse3(){ //httpResponse.getStatusCode() == 401
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('95476');
        System.assertEquals('Unauthorized', response.get('api_status'));            
        
        Test.stopTest();
    } 
    @isTest   
    static void negativeTest_GetRestResponse4(){
        DBS_Dashboard_Test.pointToDev();        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('12');
        System.assertEquals('Success', response.get('api_status'));            
        Test.stopTest();
    }     
    
    @isTest   
    static void negativeTest_GetRestResponse5(){ // pointing to dev, platform cache null
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken', '');  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('12');
        //System.assertEquals('Failure', response.get('api_status')); 
		System.assertEquals('Success', response.get('api_status'));              
        Test.stopTest();
    }      
    @isTest   
    static void negativeTest_GetRestResponse6(){ // pointing to prod Timeout  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('59580612');
        //System.assertEquals('Timeout', response.get('api_status'));  
        Test.stopTest(); 
    } 
    @isTest   
    static void negativeTest_GetRestResponse7(){ // pointing to prod timeout 
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                 
        
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getRestResponse('703058689');
        
        Test.stopTest();  
    }      
 /**************************************************************************************************
    **********************************Post To Inbound Service Test ************************************
    ***************************************************************************************************/     
    @isTest   
    static void positiveTest_PostToInboundService(){
        Test.startTest();
        
        String profileMessage = '{"queueIdEnt": 948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","profile_data": {"registered_telephone_banking": "NO","e_statement_emails": {"0": "a@absa.co.za","1": "g@absa.co.za"},"cust_poa": "General","cust_client_code": "PIERIDO001","poa_id": "5502175079086","registered_notify_me": "YES","registered_rewards": "NO","cust_dob": "24","access_account_type": "fixed d","password_status": "LOCKED","sim_hold_cell_no": "07830977721","cell_number": "0823437847","rvn_email": "swapnil.velunde@absa.co.za","cust_name": "Riefaat Baderdien","inter_acc_fund_transfer_limit": "R13000","total_card_limit": "R56000","stop_order_limit": "R2000","payment_to_benif_limit": "R8000","pos_purchase_limit": "R50000","pin_status": "ACTIVE","poa_surname": "JULES","registered_aol_banking": "YES","registered_mobile_banking": "NO","service_status": "ACTIVE", "poa_first_names": "NOLE","cust_surname": "test","estatement_registration": "2017/03/24","cust_id": "9608087659083","cash_with_draw_limit": "R6000","future_dated_pay_limit": "R3000"}}';       
        
        List<String> response = DBS_Dashboard_Populate_Controller.postToInboundService(profileMessage); //Need to populate 'profileMessage' to cover inbound service                     
        //System.AssertEquals(1, response.size());
        Test.stopTest();
    }  
    @isTest   
    static void positiveTest_PostToInboundService1(){ //Negative test
        String profileMessage = '{""queueIdEnt": 948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","profile_data": {"registered_telephone_banking": "NO","e_statement_emails": {"0": "a@absa.co.za","1": "g@absa.co.za"},"cust_poa": "General","cust_client_code": "PIERIDO001","poa_id": "5502175079086","registered_notify_me": "YES","registered_rewards": "NO","cust_dob": "24","access_account_type": "fixed d","password_status": "LOCKED","sim_hold_cell_no": "07830977721","cell_number": "0823437847","rvn_email": "swapnil.velunde@absa.co.za","cust_name": "Riefaat Baderdien","inter_acc_fund_transfer_limit": "R13000","total_card_limit": "R56000","stop_order_limit": "R2000","payment_to_benif_limit": "R8000","pos_purchase_limit": "R50000","pin_status": "ACTIVE","poa_surname": "JULES","registered_aol_banking": "YES","registered_mobile_banking": "NO","service_status": "ACTIVE", "poa_first_names": "NOLE","cust_surname": "test","estatement_registration": "2017/03/24","cust_id": "9608087659083","cash_with_draw_limit": "R6000","future_dated_pay_limit": "R3000"}}';       
        try {            
            List<String> response = DBS_Dashboard_Populate_Controller.postToInboundService(profileMessage);                               
            throw new CalloutException( 'Error message' );  
        }catch(Exception e){
        }
    }  
      
    /**************************************************************************************************
    **********************************Post Queue Item Test ********************************************
    ***************************************************************************************************/     
    @isTest   
    static void positiveTest_PostQueueItem(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('9608087659083', '0000000');              
        System.debug(' ------------------------------------- '+response);
        //Validate callout returned the 3 response attributes required in front end.              
        // recheck System.AssertEquals(3, response.size());
        Test.stopTest();
    }  
 @isTest 
    static void negativeTest_PostQueueItem1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('1234567890', '0000000'); 
        System.AssertEquals(2, response.size());                           
        Test.stopTest();
    }  
@isTest 
    static void negativeTest_PostQueueItem2(){ //integrationServiceCheck.IsEmpty()
        List<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'Authorise Jitterbit'];       
        delete integrationServiceCheck ;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('1234567890', '0000000'); 
        System.AssertEquals(2, response.size());                           
        Test.stopTest();
    }    
    @isTest 
    static void negativeTest_PostQueueItem3(){ //integrationServiceCheck.IsEmpty()
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('6666666666',  '0000000'); 
        //System.AssertEquals(2, response.size());                           
        Test.stopTest();
    } 
    @isTest   
    static void positiveTest_PostQueueItem5(){ // pointing to dev
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('5008087659083', '0000000');              
        
        //Validate callout returned the 3 response attributes required in front end.              
        //System.AssertEquals(2, response.size());
        Test.stopTest();
    }   
    @isTest 
    static void negativeTest_PostQueueItem6(){ // 408 unauth
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('87234567890', '0000000'); 
        System.AssertEquals(2, response.size());                            
        Test.stopTest();
    }      
    
    @isTest   
    static void positiveTest_PostQueueItem7(){ // pointing to dev, remove platform cache
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken', '');  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('5008087659083', '0000000');                     
        Test.stopTest();
    }    
    
    @isTest   
    static void positiveTest_PostQueueItem8(){ // pointing to dev, keyValue null
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());                
        List<String> response = DBS_Dashboard_Populate_Controller.postQueueItem('5008087659083', '');                     
        Test.stopTest();
    }   

    /**************************************************************************************************
    ************************************Save Profile **************************************************
    ***************************************************************************************************/             
    public static testMethod void  postMessageProfileTest(){  
        String JsonResponse='{"queueIdEnt": 948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Business Exception:","profile_data": {"registered_telephone_banking": "NO","e_statement_emails": {"0": "a@absa.co.za","1": "g@absa.co.za"},"cust_poa": "General","cust_client_code": "PIERIDO001","poa_id": "5502175079086","registered_notify_me": "YES","registered_rewards": "NO","cust_dob": "24","access_account_type": "fixed d","password_status": "LOCKED","sim_hold_cell_no": "07830977721","cell_number": "0823437847","rvn_email": "swapnil.velunde@absa.co.za","cust_name": "Riefaat Baderdien","inter_acc_fund_transfer_limit": "R13000","total_card_limit": "R56000","stop_order_limit": "R2000","payment_to_benif_limit": "R8000","pos_purchase_limit": "R50000","pin_status": "ACTIVE","poa_surname": "JULES","registered_aol_banking": "YES","registered_mobile_banking": "NO","service_status": "ACTIVE", "poa_first_names": "NOLE","cust_surname": "test","estatement_registration": "2017/03/24","cust_id": "9608087659083","cash_with_draw_limit": "R6000","future_dated_pay_limit": "R3000"}}';
        Test.startTest();          
        DBS_Dashboard_Inbound_Service.PostMessage(JsonResponse);
        Test.stopTest();       
    }

    static testMethod void  postMessageDebitTest(){      
        String JsonResponse='{"queueIdEnt":948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","debit_orders": {"0":{"amount":"10000,00","action_date":"20190206","external_user_ref":"ABSA BANK SALARY"}}}';
        Test.StartTest();    
        DBS_Dashboard_Inbound_Service.PostMessage(JsonResponse);
        Test.stopTest();
    }
    static testMethod void  postMessageTransactionTest(){         
        String JsonResponse='{"queueIdEnt":948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","recent_transactions":{"0":{"date":"2017-07-19","description":"000 SUCCESSFUL PAYMENT","reference_number":"NompiTest2","requested_amount":"R250 000.00","payment_channel":"INTERNET","time":"15:51:23"}}}';
        Test.startTest();
        DBS_Dashboard_Inbound_Service.PostMessage(JsonResponse);
        Test.stopTest();
    }
    static testMethod void  postMessageCallTest(){          
        //String JsonResponse='{"queueIdEnt":948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","call_history":{"0" :{"record_date":"26032019","recorded_by":"bpu0078","details":"Sim hold released for user 002. Update client app so that new beneficiary could be added","record_time":"09.35.24","recorded_by_name":"Albie","recorded_by_surname":"le Grange"}}}'; 
        String JsonResponse='{"queueIdEnt":948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","call_history":{"0" :{"record_date":"26032019","recorded_by":"bpu0078","details":"Sim hold released for user 002. Update client app so that new beneficiary could be added","record_time":"09.35.24","recorded_by_name":"Albie","recorded_by_surname":"le Grange"}},"iip_transactions": {"0": {"created_date": "2019-10-10","status_notes": "R","target_account":  "000000000000000070161534","created_time": "15.07.20","source_account": "4047939793"}}}';
        Test.startTest();   
        DBS_Dashboard_Inbound_Service.PostMessage(JsonResponse);
        Test.stopTest();
    } 
    static testMethod void  postMessageSimHoldsTest(){  
        String JsonResponse='{"queueIdEnt":948601,"keyValue": "9608087659083","status_code": 1,"tag": "retrieving_ims","access_account": "2049667415","exceptionReasonTag": "Null","sim_holds":{"0" :{"record_date":"26032019","recorded_by":"bpu0078","details":"Sim hold released for user 002. Update client app so that new beneficiary could be added","record_time":"09.35.24","recorded_by_name":"Albie","recorded_by_surname":"le Grange"}}}';
        Test.startTest();
        DBS_Dashboard_Inbound_Service.PostMessage(JsonResponse);
        Test.stopTest();
    }  
    
    /**************************************************************************************************
    ***************************************Save Notes Post*********************************************
    ***************************************************************************************************/    
    @isTest   
    static void positiveTest_SaveNotesPost(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response()); 
        
        String noteObj = '{"keyValue": "9608087659083","queueItemId":"1234567890", "notes":"Posistive test for notes","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }                    
@isTest   
    static void NegativeTest_SaveNotesPost1(){        
        list<Integration_Service__c> dbsJitterbitTokenCheck = [select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];        
        delete dbsJitterbitTokenCheck;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response()); 
        
        String noteObj = '{"keyValue": "9608087659083","queueItemId":"1234567890", "notes":"Test","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }           
    @isTest   
    static void NegativeTest_SaveNotesPost2(){        
        list<Integration_Service__c> dbsJitterbitTokenCheck = [select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];        
        delete dbsJitterbitTokenCheck;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response()); 
        
        String noteObj = '{"keyValue": "9608087659083","queueItemId":"1234567890", "notes":"Test","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }           
    @isTest   
    static void NegativeTest_SaveNotesPost3(){ // else if (httpResponse.getStatusCode() == 401 ) {      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        String noteObj = '{"keyValue": "negativeTest1SaveNotesPost","queueItemId":"1234567890", "notes":"negativeTest1SaveNotesPost","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }      
    @isTest   
    static void NegativeTest_SaveNotesPost4(){ //throw new CalloutException( httpResponse.getBody() );          
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        String noteObj = '{"keyValue": "0000000","queueItemId":"1234567890", "notes":"500 Error test save notes negative test","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }          
    @isTest   
    static void PositiveTest_SaveNotesPost5(){ //Pointing to dev
        
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        String noteObj = '{"keyValue": "9608087659083","queueItemId":"1234567890", "notes":"Posistive test for notes","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }   
    @isTest   
    static void NegativeTest_SaveNotesPost6(){ // else if (httpResponse.getStatusCode() == 401 ) {      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        String noteObj = '{"keyValue": "notes408","queueItemId":"1234567890", "notes":"notes408","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }  
    @isTest   
    static void PositiveTest_SaveNotesPost6(){ //Pointing to dev, remove dev platform cache
        
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken','');          
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        String noteObj = '{"keyValue": "9608087659083","queueItemId":"1234567890", "notes":"Posistive test for notes","accessAccountNumber":"0000000"}';
        List<String> response = DBS_Dashboard_Populate_Controller.saveNotesPost(noteObj);              
        Test.stopTest();
    }      
    
    static testMethod void testMethodsNegative(){  
        Robot_Data_Action__c insertAction = new Robot_Data_Action__c(Queue_Item_ID__c = '5768545', Action_Type__c = 'Sim Hold Release');
        insert insertAction;
        String simholdAction = '{"sObjectType":"Robot_Data_Action__c", "Queue_Item_ID__c":"5768545","Robot_Item_Exception_Reason__c":"","Robot_Item_Status__c":"","JSON__c":"", "Access_Account_Number__c":"", "Action_Type__c": "Sim Hold Release"}';
        
        List<String> getAction = DBS_Dashboard_Populate_Controller.processRobotDataAction('5768545',simholdAction, 'get');
    }
    /**************************************************************************************************
    *************************************Save Post SimHold*********************************************
    ***************************************************************************************************/ 
    @isTest   
    static void PositiveTest_postSimHold(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'PositiveTestSimHold');              
        Test.stopTest();
    }        
         
    @isTest   
    static void NegativeTest_postSimHold1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'NegativeScenarioSimHold1');              
        Test.stopTest();
    }   
    @isTest   
    static void NegativeTest_postSimHold2(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'NegativeScenarioSimHold2');              
        Test.stopTest();
    }      
    @isTest   
    static void NegativeTest_postSimHold3(){
        list<Integration_Service__c> dbsJitterbitTokenCheck = [select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];        
        delete dbsJitterbitTokenCheck; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'PositiveTestSimHold');              
        Test.stopTest();
    }  
    @isTest   
    static void NegativeTest_postSimHold4(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'NegativeScenarioSimHold4');              
        Test.stopTest();
    }      
    @isTest   
    static void PositiveTest_postSimHold5(){ //Post simhold pointin to dev
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'PositiveTestSimHoldPointingToDev');              
        Test.stopTest();
    }    
    
    @isTest   
    static void PositiveTest_postSimHold7(){ //Post simhold pointin to dev, platform cache empty
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken','');  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postSimHold('000000', 'test', '0732269090', 'PositiveTestSimHoldPointingToDev');              
        Test.stopTest();
    }    

    //IIP Rakesh
    /**************************************************************************************************
    *************************************Save Post IIP*********************************************
    ***************************************************************************************************/ 
    @isTest   
    static void PositiveTest_postIIPRelease(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        List<String> response = DBS_Dashboard_Populate_Controller.postIIPHold('{"iip_action": "R","user_number": "ab12345","created_date" : "2019-10-10",  "created_time":"20:10:01", "source_account": "123456789", "amount" : "225.00", "status_notes" : "testNotes", "target_account":"123456"}');              
        Test.stopTest();
    } 

    /**************************************************************************************************
    *************************************getActionRestResponse*****************************************
    ***************************************************************************************************/         
    @isTest   
    static void PositiveTest_getActionRestResponse(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199105');              
        Test.stopTest();
    }            
    @isTest   
    static void Negative_getActionRestResponse1(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199106');              
        Test.stopTest();
    }  
    @isTest   
    static void Negative_getActionRestResponse2(){        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199107');              
        Test.stopTest();
    }       
    @isTest   
    static void Negative_getActionRestResponse3(){
        list<Integration_Service__c> dbsJitterbitTokenCheck = [select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];       
        delete dbsJitterbitTokenCheck;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199107');              
        Test.stopTest();
    }              
    
    @isTest   
    static void Negative_getActionRestResponse4(){ //pointing to dev
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199105');              
        Test.stopTest();
    }  
    @isTest   
    static void Negative_getActionRestResponse5(){ //pointing to dev, platform cache null
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken', '');  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199105');              
        Test.stopTest();
    }  
    
    @isTest   
    static void NegativeTest_getActionRestResponse6(){//Unauth request        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());         
        Map<String,String> response = DBS_Dashboard_Populate_Controller.getActionRestResponse('199118');               
        Test.stopTest();
    }
    

    /**************************************************************************************************
    *************************************postReverseDebitOrder*****************************************
    ***************************************************************************************************/         
    @isTest   
    static void positiveTest_postReverseDebitOrder(){//Prod test        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        String debitObj = '{"keyValue": "4834945","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);              
        Test.stopTest();
    } 
    @isTest  
    static void positiveTest_postReverseDebitOrder1(){//Positive test, pointing to dev
        DBS_Dashboard_Test.pointToDev(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        String debitObj = '{"keyValue": "getDebitOrderResponseBody_Positive_Test","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);              
        Test.stopTest();
    }    
    @isTest  
    static void PositiveTest_postReverseDebitOrder3(){//Unauthorized        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        String debitObj = '{"keyValue": "getDebitOrderResponseBody_Negative_Test401","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);              
        Test.stopTest();
    }   
    @isTest  
    static void PositiveTest_postReverseDebitOrder4(){//Timeout        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        String debitObj = '{"keyValue": "getDebitOrderResponseBody_Negative_Test408","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);              
        Test.stopTest();
    }  
    
    @isTest   
    static void PositiveTest_postReverseDebitOrder5(){//Prod test, No Authorise Jitterbit
        list<Integration_Service__c> dbsJitterbitTokenCheck = [select Name from Integration_Service__c where Name = 'Authorise Jitterbit'];       
        delete dbsJitterbitTokenCheck;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        String debitObj = '{"keyValue": "4834945","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);              
        Test.stopTest();
    }  
    
    @isTest   
    static void PositiveTest_postReverseDebitOrder6(){ //Reverse Debit Order pointing to dev, platform cache empty
        DBS_Dashboard_Test.pointToDev(); 
        
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        orgCache.put('devToken','');  
        
        Test.startTest();
        String debitObj = '{"keyValue": "4834945","debitUserSeq": "test" ,"debitAmount": "12", "debitActionDate": "test", "debitType": "test", "debitReasonForReversal": "test","accessAccountNumber": "test"}';
        List<String> response = DBS_Dashboard_Populate_Controller.postReverseDebitOrder(debitObj);    
        Test.stopTest();
    }     
    
    static testMethod void testMethods(){                 
        //test processRobotDataAction
        String simholdAction = '{"sObjectType":"Robot_Data_Action__c", "Queue_Item_ID__c":"5768544","Robot_Item_Exception_Reason__c":"","Robot_Item_Status__c":"","JSON__c":"", "Access_Account_Number__c":"", "Action_Type__c": "Sim Hold Release"}';
        List<String> upsertAction = DBS_Dashboard_Populate_Controller.processRobotDataAction('processRobotData',simholdAction, 'upsert');
        
        List<String> errorAction = DBS_Dashboard_Populate_Controller.processRobotDataAction('processRobotData','test', 'get');
        
        
        //Positive flow.
        DBS_Dashboard_Populate_Controller.createQueueItemRecord('1234567890123');
        Robot_Data_Retrieval__c create_data = [select id , Name from Robot_Data_Retrieval__c where name =: '1234567890123'];          
        //Check Queue Item record was created
        //System.assertEquals(create_data.name, '1234567890123');
        
        //Simulate AbBot populating the profile_data
        String profile_json = '{"registered_telephone_banking" :"NO","e_statement_emails" :"{0=a@absa.co.za, 1=g@absa.co.za}","cust_poa" :"General","cust_client_code" :"PIERIDO001","poa_id" :"5502175079086","registered_notify_me" :"YES","registered_rewards" :"NO","cust_dob" :"24","access_account_type" :"fixed d","password_status" :"LOCKED","sim_hold_cell_no" :"07830977721","cell_number" :"0823437847","rvn_email" :"swapnil.velunde@absa.co.za","cust_name" :"Riefaat Baderdien","inter_acc_fund_transfer_limit" :"R13000","total_card_limit" :"R56000","stop_order_limit" :"R2000","payment_to_benif_limit" :"R8000","pos_purchase_limit" :"R50000","pin_status" :"ACTIVE","poa_surname" :"JULES","registered_aol_banking" :"YES","registered_mobile_banking" :"NO","service_status" :"ACTIVE","poa_first_names" :"NOLE","cust_surname" :"","estatement_registration" :"2017/03/24","cust_id" :"9608087659083","cash_with_draw_limit" :"R6000","future_dated_pay_limit" :"R3000"}';        
        create_data.Profile_JSON__c = profile_json;
        update create_data;
        
        List<Robot_Data_Retrieval__c> get_data = DBS_Dashboard_Populate_Controller.getDataFromObject('1234567890123');
        //Check object data is retrieved
        //System.assertEquals(get_data[0].name, '1234567890123');    
        
        Profile prof = [Select Id from Profile where name = 'System Administrator'];
        User u = new User(ProfileId = prof.Id, Username = 'dbs_dashboard_test@test.co.za',Alias = 'batman',Email='dbs_dashboard_test@test.co.za',EmailEncodingKey='UTF-8',Firstname='Bruce',Lastname='Wayne', LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago',AB_Number__c='0000');                       
        insert u;
        System.debug(' ---- '+u);
        User usr = [select name,AB_Number__c from User where Username =: 'dbs_dashboard_test@test.co.za'];   
        System.debug(' ----- '+usr);
        System.runas(u) {
            String abNumber = DBS_Dashboard_Populate_Controller.getUserId();
            
            String testAbNum1 = DBS_Dashboard_Inbound_Service.getUserId();
            //System.assertEquals(usr.Name,testAbNum1);       
            
            DBS_Dashboard_Populate_Controller.saveUserInfo(true); 

            //System.assertEquals(usr.AB_Number__c ,testAbNum.AB_Number__c  );  
            
            DBS_Dashboard_Populate_Controller.getUserInfo();  
        }
        
        List<Robot_Data_Retrieval__c> robotData = DBS_Dashboard_Inbound_Service.getDataRowAndPopulateFrontend(true, '948601');
        //Validate Method returned data
        Robot_Data_Retrieval__c getRobotDate = [select name from Robot_Data_Retrieval__c where name =: '948601'];
        //System.assertEquals(robotData[0].Name, '948601');

        Test.StartTest();
        DBS_Dashboard_DeleteRobotData sh1 = new DBS_Dashboard_DeleteRobotData();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Delete robot data', sch, sh1); 
        Test.stopTest();         
    } 
    static testMethod void testMethods1(){  
        User u = [select id, AB_Number__c,BRID__c from User where id = :UserInfo.getUserId()];
        u.AB_Number__c = null;
        update u;
        String abNumber1 = DBS_Dashboard_Populate_Controller.getUserId();
        try{
            DBS_Dashboard_Populate_Controller.saveUserInfo(false); 
        }catch(Exception e){}
        
        Test.StartTest();
        DBS_Dashboard_DeleteRobotActions sh1 = new DBS_Dashboard_DeleteRobotActions();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Delete robot actions', sch, sh1); 
        Test.stopTest();          
    }
    //started from here for monitoring
      static testMethod void testBotMonitoringPostDev(){  //pointing to DEV
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = '';
        update integrationInfo;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        DBS_Dashboard_Monitoring_POST sh2 = new DBS_Dashboard_Monitoring_POST();
        String sch2 = '0 0 23 * * ?'; 
        system.schedule('Monitoring Post', sch2, sh2); 
        Test.stopTest();   
    }
    
    static testMethod void testBotMonitoringPostProd(){  //pointing to DEV
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = 'Production';
        update integrationInfo;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        DBS_Dashboard_Monitoring_POST sh2 = new DBS_Dashboard_Monitoring_POST();
        String sch2 = '0 0 23 * * ?'; 
        system.schedule('Monitoring Post', sch2, sh2); 
        Test.stopTest();   
    }
    
    static testMethod void testBotMonitoringRetriveDev(){  //Retrive Dev
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = '';
        update integrationInfo;
        DBS_Monitoring_Robots__c dbsMonBots = new DBS_Monitoring_Robots__c();
        dbsMonBots.BotName__c = 'bpp123';
        dbsMonBots.QueueId__c = '1234567';
        dbsMonBots.Status__c = 4;
        upsert dbsMonBots;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        DBS_Dashboard_Monitoring_Retrieve sh1 = new DBS_Dashboard_Monitoring_Retrieve();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Monitoring Retrieve', sch, sh1); 
        Test.stopTest();   
    }
    static testMethod void testBotMonitoringRetriveProd(){  //Retrive Prod
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = 'Production';
        update integrationInfo;
        DBS_Monitoring_Robots__c dbsMonBots = new DBS_Monitoring_Robots__c();
        dbsMonBots.BotName__c = 'bpp123';
        dbsMonBots.QueueId__c = '1234567';
        dbsMonBots.Status__c = 4;
        upsert dbsMonBots;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());  
        DBS_Dashboard_Monitoring_Retrieve sh1 = new DBS_Dashboard_Monitoring_Retrieve();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Monitoring Retrieve', sch, sh1); 
        Test.stopTest();   
    }
    static testMethod void testBotMonitoringRetriveProd1(){         
         Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
         integrationInfo.Environment__c = 'Production';
         update integrationInfo;          
         Integer percentageOfBotsRunning = 30;             
         Test.StartTest();
         Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());            
         DBS_Dashboard_Monitoring_Retrieve sh2 = new DBS_Dashboard_Monitoring_Retrieve();         
         String sch2 = '0 0 23 * * ?'; 
         system.schedule('Monitoring Retrive', sch2, sh2);        
         Test.stopTest(); 
    }
    
        static testMethod void testBotMonitoringRetriveProd2(){         
         Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
         integrationInfo.Environment__c = 'Production';
         update integrationInfo;          
         Integer percentageOfBotsRunning = 30;             
         Test.StartTest();
         Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());            
         DBS_Dashboard_Monitoring_POST sh2 = new DBS_Dashboard_Monitoring_POST();         
         String sch2 = '0 0 23 * * ?'; 
         system.schedule('Monitoring Retrive', sch2, sh2);        
         Test.stopTest(); 
    }
    
    @isTest   
    static void positiveTest_PostRetrive(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());     
        List<DBS_Monitoring_Result__c> response = DBS_Dashboard_Monitoring_POST.retrieveFromDB('2019-09-01 10:08:12');       
        Test.stopTest();
    }   
    
     @isTest   
    static void positiveTest_PostRetriveDev(){ //Pointing to Dev
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = '';
        update integrationInfo;
        DBS_Monitoring_Robots__c dbsMonBots = new DBS_Monitoring_Robots__c();
        dbsMonBots.BotName__c = 'bpp123';
        dbsMonBots.QueueId__c = '1234567';
        dbsMonBots.Status__c = 4;
        upsert dbsMonBots;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());     
        List<DBS_Monitoring_Result__c> response = DBS_Dashboard_Monitoring_POST.retrieveFromDB('2019-09-01 10:08:12');       
        Test.stopTest();
    }   
    
     @isTest   
    static void positiveTest_PostRetriveProd(){ //Pointing to Prod
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = 'Production';
        update integrationInfo;
        DBS_Monitoring_Robots__c dbsMonBots = new DBS_Monitoring_Robots__c();
        dbsMonBots.BotName__c = 'bpp123';
        dbsMonBots.QueueId__c = '1234567';
        dbsMonBots.Status__c = 4;
        upsert dbsMonBots;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());     
        List<DBS_Monitoring_Result__c> response = DBS_Dashboard_Monitoring_POST.retrieveFromDB('2019-09-01 10:08:12');       
        Test.stopTest();
    }   
     @isTest   
    static void positiveTest_PostRetriveProdNotFour(){ //Pointing to Prod
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit'];  
        integrationInfo.Environment__c = 'Production';
        update integrationInfo;       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());     
        List<DBS_Monitoring_Result__c> response = DBS_Dashboard_Monitoring_POST.retrieveFromDB('2019-09-01 10:08:12');       
        Test.stopTest();
    }   
    
    
     @isTest   
    static void positiveTest_MonitoringData(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DBS_Dashboard_Mock_Response());     
        List<DBS_Monitoring_Result__c> response = DBS_Dashboard_Monitoring_POST.getMonitoringData();       
        Test.stopTest();
    }   
    
      static testMethod void testMethodsDelMonRes(){  
        User u = [select id, AB_Number__c,BRID__c from User where id = :UserInfo.getUserId()];
        u.AB_Number__c = null;
        update u;
        String abNumber1 = DBS_Dashboard_Populate_Controller.getUserId();
        try{
            DBS_Dashboard_Populate_Controller.saveUserInfo(false); 
        }catch(Exception e){}
          
        //Validate Method returned data
        DBS_Monitoring_Result__c getRobotRes = [select id from DBS_Monitoring_Result__c];
        Test.StartTest();
        DBS_Dashboard_DeleteMonitorResults sh1 = new DBS_Dashboard_DeleteMonitorResults();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Delete robot monitoring result', sch, sh1); 
        Test.stopTest();          
    }
    //Ended monitoring
}