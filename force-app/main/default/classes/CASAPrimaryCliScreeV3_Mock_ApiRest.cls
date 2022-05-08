/*
 * Mock ApiRest Bean for CASAPrimaryClientScreeningV3 Service
 * @author Prasanna Patwardhan
 * @created 2019-12-03
 */

global class CASAPrimaryCliScreeV3_Mock_ApiRest implements HttpCalloutMock {
    
      private String typeTest;
   
    global CASAPrimaryCliScreeV3_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

     global HttpResponse respond(HttpRequest request){
        //Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            String sampleResponse = '{"clientTypeGrp":"N","nationality":"SA","cntryOfRes":"SA","sbu":"H","originatingSys":"Y","branch":"0","teller":"Y"}';
            response.setBody(sampleResponse);
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }

}