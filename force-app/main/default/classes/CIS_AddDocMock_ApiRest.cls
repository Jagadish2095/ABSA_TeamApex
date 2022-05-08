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
global class CIS_AddDocMock_ApiRest implements HttpCalloutMock {
    Private String typeTest;

    /**
    * @description
    * @param typeTest
    **/
    global CIS_AddDocMock_ApiRest (final String typeTest)
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
        response.setBody('{"AddResult":{"Status":"OK","Detail":""},"Pid":"CISBISON_SIT Ent_ProofOfId B5C40FB9383D40059B45BD6C4F48DE74","OcrDocResults":null}');
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