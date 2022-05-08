/**
* @description Test Integration Handler class for AccountSearch Service
* @author Sourabh Yadav
* @created 2021-08-18
*/
@isTest
public class AccountSearch_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AccountSearch_v1';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AccountSearch_IH_v1.INTEGRATION_SERVICE_NAME }
        );    }
    
    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        Test.startTest();
        
        AccountSearch_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
        Test.stopTest();
    }
    
    private static AccountSearch_Resp_IB_v1 callHandlerMethod() {
        AccountSearch_Req_IB_v1 dummyBean = AccountSearch_Req_IB_v1.createDummyRequest();
        AccountSearch_Resp_IB_v1 responseBean = AccountSearch_IH_v1.AccountSearch(dummyBean.AccountsSearchCriteria.creditorAccountLegacyIdentifier);
        return responseBean;
    }
    
}