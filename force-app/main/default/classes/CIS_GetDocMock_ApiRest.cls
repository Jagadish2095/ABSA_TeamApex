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
global class  CIS_GetDocMock_ApiRest implements HttpCalloutMock{
	Private String typeTest;

    /**
    * @description
    * @param typeTest
    **/
    global CIS_GetDocMock_ApiRest (final String typeTest)
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
        response.setBody('{"GetResult":{"Status":"OK","Detail":""},"MetaData":{"ItemType":"Ent_ProofOfId","PID":"CISBISON_SIT Ent_ProofOfId B5C40FB9383D40059B45BD6C4F48DE74","CreationDate":"","LastModifiedDate":"","Creator":"","Fields":[{"Name":"IdNr","Type":null,"Size":null,"Nullable":null,"Unique":null,"Description":null,"Value":"TD-2020-04-06T14-TS9"},{"Name":"CIFNr","Type":null,"Size":null,"Nullable":null,"Unique":null,"Description":null,"Value":"RICHARD036"},{"Name":"Creator","Type":null,"Size":null,"Nullable":null,"Unique":null,"Description":null,"Value":"svc-ecmldap-uat"}]},"Content":{"FileName":"Mohammed Junaid U.pdf","MimeType":"application/pdf","Data":"String"}}');
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