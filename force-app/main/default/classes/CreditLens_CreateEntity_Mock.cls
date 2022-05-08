/**
 * @description       : Mock class for CreditLens Create Entity callout
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 2021-11-09
 * @last modified by  : Tawanda M.
**/
global class CreditLens_CreateEntity_Mock implements HttpCalloutMock {
    String responseType;
    
    /**
    * @description Constructor for different responses
    * @author Tawanda M. | 2021-11-09 
    * @param type 
    **/
    global CreditLens_CreateEntity_Mock(String type){
        this.responseType = type;
    }

    /** Method to respond to API call during test
    * @description 
    * @author Tawanda M. | 2021-11-09 
    * @param req 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(responseType == 'Passed'){
            String body = '{"payLoad":[{"EntityId":35}],"status":{}}';
            res.setBody(body);
            res.setStatusCode(200);
        }
        else{
            String body = '{}';
            res.setBody(body);
            res.setStatusCode(500);
        }
        return res;
    }
}