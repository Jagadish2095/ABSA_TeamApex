@isTest
global class CIupdJointPByClientCodeV7Mock_ApiRest implements HttpCalloutMock{
	Private String typeTest;
    /**
    * @description
    * @param typeTest
    **/
    global CIupdJointPByClientCodeV7Mock_ApiRest(final String typeTest)
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
        response.setBody('{"ciupdJointParticipantsByClientCodeV7Response": {"nbsapdpo": {"version": null,"returnCode": 0,"reasonCode": 0,"serviceVersion": "BUSO006","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": 0,"nbrUserErrs": 0,"msgEntry": null},"cib033o": {"errorTable": [{"errorCode": 0,"errorMessage": null},{"errorCode": 0,"errorMessage": null}]}}}');
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