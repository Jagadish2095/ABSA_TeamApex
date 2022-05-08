@isTest
global class sales_MockResponse  implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonBody = req.getBody();
        
        if(req.getEndpoint().contains('/auth/token')){  
            //Login Posive Test
            res.setBody(auth_pos);  
            res.setStatusCode(200);           
        }  else	if(jsonBody.contains('posLogin_abhm512')){   
            //Login Posive Test
            res.setBody(login_pos);  
            res.setStatusCode(200);           
        } else if(jsonBody.contains('read_time_out')){ 
             //Catch block for all 'Catch' scripts
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Read timeout');
            throw e;
        }        
        return res;
    }
    public static final string auth_pos  = '{"access_token": "eyJhbGciOiJIUzUxMiJ9..."}';  
    
    public static final string login_pos  = '{"userId":"abhm512","agentId":"7011","payload":"{\"id\":\"7011\",\"agentId\":\"7011\",\"agentStatus\":\"READY\",\"auxCode\":\"0\",\"eventType\":\"acdAddressLoggedOn\",\"disconnectConn\":\"\",\"activeConnections\":[]}","errors":false,"errorList":[]}';
    public static final string login_net  = '{"errorCode": 401, "message": "Not authorised"}';       
    
}