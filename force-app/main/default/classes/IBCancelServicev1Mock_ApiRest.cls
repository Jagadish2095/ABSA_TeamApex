/*
* Mock ApiRest Bean for IBCancelServicev1 Service
* @author Lulu Rankwe
* @created 05/05/2020
*/
global class IBCancelServicev1Mock_ApiRest implements HttpCalloutMock {

    Private String typeTest;

    public IBCancelServicev1Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"IBcancelServiceV1Response": {"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "0","nbrUserErrs": "0"}}}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }



}