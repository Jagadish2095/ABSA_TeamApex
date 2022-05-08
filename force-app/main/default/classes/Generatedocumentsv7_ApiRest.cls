/**
* Apex Integration Mock response class for Generatedocumentsv7 Complaint Integration service
* @author  Anka Ganta : Absa
* @since   2020-04-23
*
**/
@isTest
global class Generatedocumentsv7_ApiRest implements HttpCalloutMock{
    Private String typeTest;
    Private String messageNo;
    Private String DocNo;
    global Generatedocumentsv7_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    global Generatedocumentsv7_ApiRest(final String typeTest, final string messageNo , final String DocNo){
        this.DocNo = DocNo;
        this.typeTest = typeTest;
        this.messageNo = messageNo;
    }

    global HttpResponse respond(HttpRequest request){
        //Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String sampleResponse;
        if(typeTest == StringConstants.POSITIVE_STRING){
            if(messageNo == null || DocNo == null) {
                sampleResponse = '{"Envelope": {"Body": { "GetDocsResponse": {"DocNo": "7","VersionNo": "112", "msgNo": "0","msg": "Success","documentation": [{ "docCode": "000001", "docDesc": "ID"},{"docCode": "000004","docDesc": "PROOF OF RES. ADDR(ELECTR./PHYSICAL" }, {"docCode": "000053","docDesc": "CONSENT MANAGEMENT"},{"docCode": "000054", "docDesc": "CREDIT AGREEMENT" } ] }}}}';
            }else if(messageNo != '0' && DocNo != '0'){
                sampleResponse = '{"Envelope": {"Body": { "GetDocsResponse": {"DocNo": "7","VersionNo": "112", "msgNo": "2","msg": "Success","documentation": [{ "docCode": "000001", "docDesc": "ID"},{"docCode": "000004","docDesc": "PROOF OF RES. ADDR(ELECTR./PHYSICAL" }, {"docCode": "000053","docDesc": "CONSENT MANAGEMENT"},{"docCode": "000054", "docDesc": "CREDIT AGREEMENT" } ] }}}}';
            }else if(messageNo == '0' && DocNo == '0'){
                sampleResponse = '{"Envelope": {"Body": { "GetDocsResponse": {"DocNo": "0","VersionNo": "112", "msgNo": "0","msg": "Success","documentation": [{ "docCode": "000001", "docDesc": "ID"},{"docCode": "000004","docDesc": "PROOF OF RES. ADDR(ELECTR./PHYSICAL" }, {"docCode": "000053","docDesc": "CONSENT MANAGEMENT"},{"docCode": "000054", "docDesc": "CREDIT AGREEMENT" } ] }}}}';
            }else if(messageNo != '0' && DocNo == '0'){
                sampleResponse = '{"Envelope": {"Body": { "GetDocsResponse": {"DocNo": "0","VersionNo": "112", "msgNo": "2","msg": "Success","documentation": [{ "docCode": "000001", "docDesc": "ID"},{"docCode": "000004","docDesc": "PROOF OF RES. ADDR(ELECTR./PHYSICAL" }, {"docCode": "000053","docDesc": "CONSENT MANAGEMENT"},{"docCode": "000054", "docDesc": "CREDIT AGREEMENT" } ] }}}}';
            }
            response.setBody(sampleResponse);
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}