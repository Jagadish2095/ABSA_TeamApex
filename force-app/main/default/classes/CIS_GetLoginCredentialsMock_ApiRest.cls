/**
 * @description       :
 * @author            : Mohammed Junaid
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   05-25-2021   Mohammed Junaid   Initial Version
**/
@isTest
global class  CIS_GetLoginCredentialsMock_ApiRest implements HttpCalloutMock{
	Private String typeTest;
    /**
    * @description
    * @param typeTest
    **/
    global CIS_GetLoginCredentialsMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }

    /**
    * @description
    * @param request
    * @return HTTPResponse
    **/
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
        response.setBody('{"LoginResult":{"Status":"OK","Detail":""},"Token":"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTUxMiIsInR5cCI6IkpXVCJ9.eyJhZnMiOiJndGVzdF9jIiwiYWljX2FjbCI6Imd0ZXN0X2MiLCJhbF9hY2wiOiJndGVzdF9jIiwiYXZhZl9hY2wiOiJndGVzdF9jIiwiZGNfYWNsIjoiZ3Rlc3RfYyIsImRlZmF1bHQiOiJndGVzdF9jIiwiZG05X2FjbCI6Imd0ZXN0X2MiLCJlc3RhdGVfZGVmYXVsdCI6Imd0ZXN0X2MiLCJmaWNhX2FjbCI6Imd0ZXN0X2MiLCJmcmkiOiJndGVzdF9jIiwiZ3Rlc3QiOiJndGVzdF9jIiwiaG9tZWxvYW5fYWNsIjoiZ3Rlc3RfYyIsImtodWxhX2RlZmF1bHQiOiJndGVzdF9jIiwibmV0ZnlpYWNsIjoiZ3Rlc3RfYyIsIm9oc2FfYWNsIjoiZ3Rlc3RfYyIsInBtcF9hY2wiOiJndGVzdF9jIiwicmV3YXJkc19hY2wiOiJndGVzdF9jIiwidGVzdGFjbF85MjIyMDIwIjoiZ3Rlc3RfYyIsIndlZSI6Imd0ZXN0X2MiLCJreWNfYWNsIjpbImt5Y19jIiwia3ljX3IiXSwiayI6Imd0ZXN0X2MiLCJ1c2VybmFtZSI6InN2Yy1lY21sZGFwLXVhdCIsImRhdGFzdG9yZSI6ImVjbXVhdCIsImV4cCI6MTYyMTkyODE4OSwiaXNzIjoiY2hhbm5lbGludGVncmF0aW9uc2VydmljZS5hYnNhLmFmcmljYSIsImF1ZCI6ImNoYW5uZWxpbnRlZ3JhdGlvbnNlcnZpY2UuYWJzYS5hZnJpY2EifQ.noQis6ZB97gBHSjZ4jJpMIGIA5piMUwhoQufCRIrDIDw6hBPZ09dyLiXcUF5ceC5KKoImSjG9qqk8Ilw0PvoPg"}');
    	response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING)
        {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS)
        {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response;
    }
}