@isTest
global class RetrieveTrackerStatus_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global RetrieveTrackerStatus_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
      
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"nbsapdpo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion": "BUSO001","echoKey":""},"nbsmsgo":{"version":"","sysErrTxt":"","nbrUserMsgs":"0","nbrUserErrs":"0"},"awp035o":{"cifKey":"ABASSM 004","trackStat":"ARKCDxiqbsmyglenftph","recordCount":"6","trackerRecord": [{"trackerDate": "20120704","trackerUserId": "","trackerAction": "DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20111031","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate": "20111031","trackerUserId": "","trackerAction": "DISPATCH","trackerPrevId": "abjj180"},{"trackerDate":"20111031","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20041122","trackerUserId":"","trackerAction":"DISPATCHED","trackerPrevId":"INTERNET"},{"trackerDate":"20041122","trackerUserId":"","trackerAction":"CAPTURE REGISTRATION INFORMATION","trackerPrevId":""}]}}');     
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