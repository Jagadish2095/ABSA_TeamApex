/** 
 * @description Mock class for bcmssavecase Service
 * @author: Jaco de Lange
 * @Date: 2021-03-30
*/
@isTest
    global class CAFUpdateCaseMock_ApiRest implements HttpCalloutMock {
    Private String typeTest;
    /** 
 * @description Mock class for bcmssavecase Service
 * @author: Jaco de Lange
 * @Date: 2021-03-30
 * @param typeTest
*/
    public CAFUpdateCaseMock_ApiRest(final String typeTest){
            this.typeTest = typeTest;
        }
      /** 
 * @description Mock class for bcmssavecase Service
 * @author: Jaco de Lange
 * @Date: 2021-03-30
 * @param request
 * @return
*/  

        global HTTPResponse respond (HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"SaveCase":{"theCase":{"ReferenceNumber": "ClaimNo:849207:BCMS-SOAP","DefinitionId": "BB5C18CF-D806-440F-8110-443445D717B4","DefinitionVersion": "1","Data":"PENsYWltc0RPYz48SW5kaXZpZHVhbD48SWROdW1iZXI+NjQwNTAxNTA2MzA4OTwvSWROdW1iZXI+PEZpcnN0TmFtZXM+R0lGVCBDSElLV0FNQTwvRmlyc3ROYW1lcz48U3VybmFtZT5BQlNBIFRFU1Q8L1N1cm5hbWU+PENpZktleT5EVUJFR0MgMDAyPC9DaWZLZXk+PC9JbmRpdmlkdWFsPjwvQ2xhaW1zRE9jPg==","Status": "QueuedForProcessing","Created": "2020-07-01T13:03:21.629+02:00","Updated": "2020-07-07T14:58:18.623", "DisplayName": "Personal Loan Application for E2E","FreeTextTag": "VERYHL 001"},"savedBy": "BCMS SOAP"}}');
            
            if(typeTest == StringConstants.POSITIVE_STRING){
                response.setStatusCode(200);
            }else if(typeTest == StringConstants.NEGATIVE_STRING){
                response.setStatusCode(400);
            }
            return response; 
        }    
}