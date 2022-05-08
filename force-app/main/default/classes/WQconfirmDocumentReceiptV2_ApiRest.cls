/**
* Apex Integration Mock response class for WQconfirmDocumentReceiptV2 Integration service
* @author  Anka Ganta : Absa
* @since   2020-04-24
*
**/

@isTest
global class WQconfirmDocumentReceiptV2_ApiRest implements HttpCalloutMock{
  Private String typeTest;
    global WQconfirmDocumentReceiptV2_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }

    global HttpResponse respond(HttpRequest request){
        //Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            String sampleResponse = '{"WQconfirmDocumentReceiptV2Response": {"nbsapdpo": {"version": "APLO003", "returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"wqp131o": {"msgNo": "0","msg": "modified successfully"}}}';
            response.setBody(sampleResponse);
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}