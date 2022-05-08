/**
 * @description       :
 * @author            :
 * @group             :
 * @last modified on  : 09-04-2021
 * @last modified by  : Taras Kuliievych
**/
@isTest
public class CC_ContentService_IH_v1Test {
    /**
    * @description
    * @author
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CC_ContentService_IH_v1.GENERATE_CONTENT_PATH});
    }

    /**
    * @description
    * @author
    **/
    @isTest
    public static void shouldGenerateDocument() {
        CC_GenerateContentRequest exampleCC_GenerateContentRequest = CC_GenerateContentRequest.getExample();
        exampleCC_GenerateContentRequest.addContentParam('key', 'value');
        exampleCC_GenerateContentRequest.addParams(new List<CC_GenerateContentRequest.ContentStoreParams>());
        JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
        authResponse.token = '127168272819';
        CC_GenerateContentResponse res = CC_GenerateContentResponse.getExample();
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
        mock.addResponse(JSON.serialize(authResponse));
        mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        CC_GenerateContentResponse response = CC_ContentService_IH_v1.generateContent(CC_GenerateContentRequest.getExample());
        System.assert(response != null);
        Test.stopTest();
    }

    /**
    * @description
    * @author
    **/
    public class CC_ContentService_IH_v1_Mock_ApiRest implements HttpCalloutMock {
        /**
        * @description
        * @author
        **/
        public String body { get; set; }

        /**
        * @description
        * @author
        **/
        public CC_ContentService_IH_v1_Mock_ApiRest() {}

        /**
        * @description
        * @author
        * @param body
        **/
        public CC_ContentService_IH_v1_Mock_ApiRest(String body) {
            this.body = body;
        }

        /**
        * @description
        * @author
        * @param request
        * @return response
        **/
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
}