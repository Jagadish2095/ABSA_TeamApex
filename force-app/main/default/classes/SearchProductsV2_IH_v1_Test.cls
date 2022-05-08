/*
* Test Integration Handler for SearchProductsV2 Service
 * @author Jabulani Mashia
 * @created 2020-10-30
*/

@isTest
public class SearchProductsV2_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{     "searchProductsV2ResponseMsg": {"common": {             "messageSuccess": "1",             "messageTimeStamp": "Nov 4, 2020"         },         "searchProductsV2ResponseDto": {             "productCount": "1",             "cifProducts": [                 {                     "oid": "A99923497CCA46989FCB9300D54DA4C1",                     "code": "09010",                     "shortName": "Call Account",                     "longName": "Call Account",                     "description": "The Call Account is a demand account offering clients competitive interest rates.",                     "features": [                         {                             "oid": "7D9058934838489BBF5B1D30B6525B31",                             "code": "int009",                             "shortName": "Internet Banking transfers allow",                             "longName": "Internet Banking transfers allowed Debits and Credits",                             "description": "Electronic Channels Internet banking transfers allowed Debits and Credits",                             "usageValue": "Yes",                             "rules": [                                 {                                     "oid": "4658586EDDC946C8BE3CD144867A3B27","code": "por001",                                     "shortName": "Transfers","longName": "Transfers",                                     "description": "Transfers","usageValue": "within same portfolio",                                     "sortOrder": "0",                                     "createdOn": "2007-10-31+02:00","changedOn": "2007-11-14+02:00"                                 }                             ],"sortOrder": "81",                             "createdOn": "2007-10-31+02:00",                             "changedOn": "2007-10-31+02:00"                         }                     ],                     "rules": [                         {"oid": "D59B74BE060441ADA5593B2E56FF6A03",                             "code": "ct001",                             "shortName": "Client Type","longName": "Client Type",                             "description": "Client Type","usageValue": "N","sortOrder": "0","createdOn": "2007-12-13+02:00","changedOn": "2007-12-13+02:00"                         }                     ],                     "definitionChangedOn": null,                     "createdOn": "2007-07-06+02:00",                     "changedOn": "2007-10-24+02:00",                     "cifShortName": "CALL"                 }             ]         }     } }';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SearchProductsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        SearchProductsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static SearchProductsV2_Resp_IB_v1 callHandlerMethod() {
        
        SearchProductsV2_Req_IB_v1 dummyBean = SearchProductsV2_Req_IB_v1.createDummyRequest();
        SearchProductsV2_Resp_IB_v1 responseBean = SearchProductsV2_IH_v1.SearchProductsV2(dummyBean);
        System.debug(responseBean);

        return responseBean;
    }
}