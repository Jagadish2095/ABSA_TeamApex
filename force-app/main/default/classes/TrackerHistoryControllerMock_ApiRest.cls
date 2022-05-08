@isTest
global class TrackerHistoryControllerMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    public TrackerHistoryControllerMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        if(request.getEndpoint().contains('Retrieve Tracker Status Wills')){
           
            String body = '{"nbsapdpo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":""},"nbsmsgo":{"version":"","sysErrTxt":"","nbrUserMsgs":"0","nbrUserErrs":"0"},"awp035o":{"cifKey":"ABASSM 004","trackStat":"ARKCDxiqbsMyglenFtph","recordCount":"28","trackerRecord":[{"trackerDate":"20190307","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190306","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190301","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190301","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190301","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190301","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190227","trackerUserId":"usr112","trackerAction":"FILED","trackerPrevId":"usr333"},{"trackerDate":"20190227","trackerUserId":"usr112","trackerAction":"FILED","trackerPrevId":"usr333"},{"trackerDate":"20190222","trackerUserId":"usr112","trackerAction":"REGISTER","trackerPrevId":"usr333"},{"trackerDate":"20190222","trackerUserId":"usr112","trackerAction":"REGISTER","trackerPrevId":"usr333"},{"trackerDate":"20190207","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190207","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190207","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190207","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190207","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190206","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190206","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190201","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190201","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190201","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190201","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20190129","trackerUserId":"","trackerAction":"FILED","trackerPrevId":"usr112"},{"trackerDate":"20120704","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20111031","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20111031","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20111031","trackerUserId":"","trackerAction":"DISPATCH","trackerPrevId":"abjj180"},{"trackerDate":"20041122","trackerUserId":"","trackerAction":"DISPATCHED","trackerPrevId":"INTERNET"},{"trackerDate":"20041122","trackerUserId":"","trackerAction":"CAPTURE REGISTRATION INFORMATION","trackerPrevId":""}]}}';
            response.setBody(body);
        }
        return response; 
    }
}