/**
* Apex Integration Mock response class for WQacknowledgeDocumentsV1 Complaint Integration service
* @author  Anka Ganta : Absa
* @since   2020-04-24
*
**/
@isTest
global class WQacknowledgeDocumentsV1_ApiRest implements HttpCalloutMock{
   Private String typeTest;
    global WQacknowledgeDocumentsV1_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }

    global HttpResponse respond(HttpRequest request){
        //Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            String sampleResponse = '{"WQacknowledgeDocumentsV1Response": {"nbsapdpo": {"version": "APLO003","returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001" }, "wqp132o": { "msgNo": "0","msg": "DOCUMENTS MODIFIED SUCCESSFULLY"} }}';
            response.setBody(sampleResponse);
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}