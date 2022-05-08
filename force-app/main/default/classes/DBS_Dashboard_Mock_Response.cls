@isTest
global class DBS_Dashboard_Mock_Response implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonBody = req.getBody();
            
        if(jsonBody.contains('9608087659083')){  //Positive Test PostQueueItem  
            res.setBody(strPostQuoteItem);  
            res.setStatusCode(200);           
        }else if(jsonBody.contains('1234567890')){ //Negative Test PostQueueItem 
            res.setBody(strPostQuoteItem);  
            res.setStatusCode(500);                   
        }else if(jsonBody.contains('5008087659083')){  //Positive Test PostQueueItem  pointing to dev
            res.setBody(strPostQuoteItem);  
            res.setStatusCode(201);  
            res.setHeader('Location', '0000000');
        }else if(jsonBody.contains('87234567890')){  //negative Test unauth PostQueueItem
            res.setBody(strPostQuoteItem);  
            res.setStatusCode(408);  
        }else if(jsonBody.contains('6666666666')){ //Negative Test PostQueueItem
            res.setBody(strPostQuoteItem);  
            res.setStatusCode(401);                   
        }else if (req.getEndpoint().contains('12')) { // Positive Test GetRestResponse
            res.setBody(getResponseBodyStr);  
            res.setStatusCode(200);                   
        }else if (req.getEndpoint().contains('21')) { // Negative Test GetRestResponse
            res.setBody(getResponseBodyStr);  
            res.setStatusCode(500);      
        }else if (req.getEndpoint().contains('95476')) { // Negative Test GetRestResponse
            res.setBody(getResponseBodyStr);  
            res.setStatusCode(401);      
        }else if(req.getEndpoint().contains('/59580612')){//Negative Test Unauth Test GetRestResponse -----  
            res.setBody(errorMessage);   
            res.setStatusCode(408);             
        }else if(jsonBody.contains('703058689')){//Negative Test timeout Test GetRestResponse  
            res.setBody(errorMessage);  
            res.setStatusCode(408);            
        }   else if (req.getEndpoint().contains('/clients/auth_positive')) { // Positive Test getToken
            res.setBody(getDISBody);  
            res.setStatusCode(200);      
        }else if (req.getEndpoint().contains('/clients/auth_negative')) { // Negative Test getToken
            res.setBody(getDISBody);  
            res.setStatusCode(500);      
        }       
        else if (req.getEndpoint().contains('/clients/auth_negativ401')) { // Negative Test getToken
            res.setBody(getDISBody);  
            res.setStatusCode(401);      
        }
        else if (req.getEndpoint().contains('/clients/auth_negativ408')) { // Negative Test getToken
            res.setBody(getDISBody);  
            res.setStatusCode(408);      
        }
        else if (jsonBody.contains('notes positive test')) { // Positive saveNotes()
            res.setBody(getNotesBody);  
            res.setStatusCode(201);
            res.setHeader('Location', '12345'); 
        }else if (jsonBody.contains('notes negative test')) { // negative saveNotes()
            res.setBody(getNotesBody);  
            res.setStatusCode(500);      
        }else if (jsonBody.contains('notes408')) { // negative saveNotes() 408
            res.setBody(getNotesBody);  
            res.setStatusCode(408);      
        }else if (jsonBody.contains('release simhold positive test')) { // positive releaseSimHold()
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(201);    
            res.setHeader('Location', '0000000');
        }
        //iip test Rakesh
        else if (jsonBody.contains('release iip positive test')) { // positive releaseIIP()
            res.setBody(getIIPBody);  
            res.setStatusCode(201);    
            res.setHeader('Location', '0000000');
        } 
        else if (jsonBody.contains('PositiveTestIIPPointingToDev')) { // positive releaseIIP() pointing to dev
            res.setBody(getIIPBody);  
            res.setStatusCode(200);    
            res.setHeader('Location', '10000'); 
        }
        else if(jsonBody.contains('NegativeScenarioIIPRelease1')) { //Negative releaseIIP
            res.setBody(getIIPBody);  
            res.setStatusCode(401);      
        }
        //
        else if (jsonBody.contains('PositiveTestSimHoldPointingToDev')) { // positive releaseSimHold() pointing to dev
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(200);    
            res.setHeader('Location', '10000'); 
        } else if (jsonBody.contains('release simhold negative test')) { // negative releaseSimHold()
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(500);      
        }  else if (jsonBody.contains('Posistive test for notes')) { //Positive test saveNotesPost
            res.setBody(getSaveNotesBody);  
            res.setStatusCode(200);   
            res.setHeader('Location', '54321');
        } else if(jsonBody.contains('negativeTest1SaveNotesPost')) { //Negative test saveNotesPost
            res.setBody(getSaveNotesBody);  
            res.setStatusCode(401);      
        } else if(jsonBody.contains('500 Error test save notes negative test ')) { //catch saveNotesPost
            res.setBody(getSaveNotesBody);  
            res.setStatusCode(500);      
        }   
        else if(jsonBody.contains('500 Error test save notes negative test ')) { //catch saveNotesPost
            res.setBody(getSaveNotesBody);  
            res.setStatusCode(500);      
        }  
        else if(jsonBody.contains('PositiveTestSimHold')) { //Test postSimHold
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(200);      
        }  
        else if(jsonBody.contains('NegativeScenarioSimHold1')) { //Negative postSimHold
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(401);      
        }   
        else if(jsonBody.contains('NegativeScenarioSimHold2')) { //Negative postSimHold
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(500);      
        }  
        else if(jsonBody.contains('NegativeScenarioSimHold4')) { //Negative postSimHold
            res.setBody(getSimHoldsBody);  
            res.setStatusCode(408);      
        }         
        else if(req.getEndpoint().contains('199105')) { //Positive getSimhold response
            res.setBody(getSimholdResponseBody );  
            res.setStatusCode(200);      
        }    
        else if(req.getEndpoint().contains('199106')) { //Negative1 getSimhold response
            res.setBody(getSimholdResponseBody );  
            res.setStatusCode(401);      
        }    
        else if(req.getEndpoint().contains('199107')) { //Negativ2 getSimhold response
            res.setBody(getSimholdResponseBody );  
            res.setStatusCode(500);      
        } 
        else if(req.getEndpoint().contains('199118')) { //Negative unauth request getActionRestResponse
            res.setBody(errorMessage);  
            res.setStatusCode(408);      
        }        
        else if(jsonBody.contains('getDebitOrderResponseBody_Positive_Test')) { //Positive postReverseDebitOrder 
            res.setBody(getDebitOrderResponseBody);  
            res.setStatusCode(201); 
            res.setHeader('Location', '123456');
        }  
        else if(jsonBody.contains('getDebitOrderResponseBody_Negative_Test401')) { //Negative postReverseDebitOrder 
            res.setBody(errorMessage);  
            res.setStatusCode(401); 
        } 
        else if(jsonBody.contains('getDebitOrderResponseBody_Negative_Test408')) { //Negative postReverseDebitOrder 
            res.setBody(errorMessage);  
            res.setStatusCode(408); 
        } 
        else if(jsonBody.contains('test_Robot')) { //Monitoring Post Response
            res.setBody(monitoringResBody);  
            res.setStatusCode(200); 
        }
        else if(jsonBody.contains('test_Robot')) { //Monitoring Post Response
            res.setBody(monitoringResBody1);  
            res.setStatusCode(400); 
        }
         else if(jsonBody.contains('Robot')) { //monitoringRetriveBody  
            res.setBody(monitoringRetriveBody);  
            res.setStatusCode(200); 
        }
        else if(jsonBody.contains('Robot')) { //monitoringRetriveBodyStaus!=4
            res.setBody(monitoringRetriveStatusBody);  
            res.setStatusCode(200); 
        }
        else if(jsonBody.contains('Robot')) { //monitoringRetriveBodyStaus=4
            res.setBody(monitoringPostResBody);  
            res.setStatusCode(200); 
        }
        else if(jsonBody.contains('Robot')) { //monitoringRetriveBodyStaus!=4
            res.setBody(monitoringPostResBodyNotFour);  
            res.setStatusCode(400); 
        }
        else if(jsonBody.contains('DigitalBankingServices')) { 
            res.setBody(monitoringRetriveStatusBodyNotFour);  
            res.setStatusCode(200); 
        }
        
        else if(jsonBody.contains('password')) { 
            res.setBody(access_token);  
            res.setStatusCode(200); 
        }        
        return res;
    }
    
    public static final string strPostQuoteItem = '{'+       
        '           "queueIdEnt": "973898",'+
        '           "keyValue": "",'+
        '           "attempt": ""'+
        '}';
        
        
    public static final string getResponseBodyStr  = '{\"dat001\":"555",\"dat002\":"555",\"dat003\":"555", \"dat004\":"555", \"dat005\":"555"}'; 
    
    public static final string getDISBody = '{ "username":"d_absa/abcd123","password":"abcd23456","apiid":"e33caff9-53d8-43ad-8b2a-d5531aae3c06"}'; 
    
    public static final string getNotesBody = '{"keyValue": "99999","loaded": "' + date.today() +'","processName": "DBSSVOCP","itemData": "99999","dat001": "Notes test","tag": "added_for_ims_note","createdBy": "'+UserInfo.getName()+'","status": {"code": 1},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}'; 
    
    public static final string getSimHoldsBody = '{"keyValue": "88888","loaded": "' + date.today() +'","processName": "DBSSVOCP","itemData": "release simhold positive test","dat001": "88888","tag": "added_for_sim_hold_release","createdBy": "'+UserInfo.getName()+'","status": {"code": 1},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
       
    //iip body
    public static final string getIIPBody = '{"keyValue": "66666","abbotResource": {"resourceId": 10126},"loaded": "' + date.today() +'","processName": "DBSSVOCP","item_data": "12345678","dat001": "{"iip_action": "R","user_number": "ab12345","created_date" : "2019-10-10",  "created_time":"20:10:01", "source_account": "123456789", "amount" : "225.00", "status_notes" : "testNotes", "target_account":"123456"}","tag": "added_for_iip_Release","createdBy": "abrb1234","status": {"code": 0},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
    //                                            
    
    public static final string getSaveNotesBody = '{"keyValue": "1234567890","loaded": "' + date.today() +'","processName": "DBSSVOCP","item_data": "0000000","dat001": "test","tag": "added_for_ims_note","createdBy": "AB0000","status": {"code": 1},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
    
    public static final string getSimholdResponseBody = '{"exceptionReasonVarchar": "Business Exception: test", "status": {"code": 4}}';
    
    public static final string getDebitOrderResponseBody = '{"exceptionReasonVarchar": "Business Exception: test", "status": {"code": 4}}';
    
    public static final string errorMessage = '{"Message":"An error occurred"}';
    
    public static final string monitoringResBody = '{"queueIdEnt":1326912,"status":{  "code":3},"dat005":"bpu0069"}';
    
    public static final string monitoringResBody1 = '{"queueIdEnt":1326912,"status":{  "code":5},"dat005":"bpu0069"}';
    
    public static final string monitoringRetriveBody = '{"queueIdEnt":1326912,"status":{  "code":4},"dat005":"bpu0069"}';

    public static final string monitoringRetriveStatusBody = '{"queueIdEnt":1326912,"status":{  "code":4},"dat005":"bpu0069"}';
    
    public static final string monitoringRetriveStatusBodyNotFour = '{"dat005":"bpu0078","status":{"code":5},"queueIdEnt":1338418}';
    
    public static final string monitoringPostResBody = '{"queueIdEnt":1326912,"status":{  "code":4},"dat005":"bpu0069"}';
    
    public static final string monitoringPostResBodyNotFour = '{"queueIdEnt":1326912,"status":{  "code":5},"dat005":"bpu0069"}';
    
    public static final string access_token = '{"access_token":"54dsfslfjlskdjfdsfhsfsdfsdfsfesa"}';
                                                                       
}