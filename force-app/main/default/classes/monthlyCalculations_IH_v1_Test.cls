/**
 * Test Class for MonthlyCalculations Service
 *
 * @author  Gopi Budaraju (ZA)
 * @version v1.0n
 * @since   2020/09/20
 * @UserStory W:006253
 *
 * @update Englarmerge Mongwe
 * @date 2021-01-07
 * Complete UserStory W:006253
 */
@IsTest
public class monthlyCalculations_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"name":"SEDERKRANS BOERDERY SOUTPANSBERG BK","primaryClientCode":"SBSOUTP001","aggregation":[{"type":"Cheque RD Events_Last 3 Months","total":2},{"type":"Savings RD Events_Last 3 Months","total":2},{"type":"Cheque RD Value","total":2},{"type":"Savings RD Value","total":2},{"type":"Cheque RD Events_Last 6 Months","total":2},{"type":"Savings RD Events_Last 6 Months","total":2},{"type":"Cheque Debits_Last 6 Months","total":2},{"type":"Savings Debits_Last 6 Months","total":2}]}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{monthlyCalculations_IH_v1.INTEGRATION_SERVICE_NAME});
        /*
        Application_Triad__c appTriad=new Application_Triad__c();
        appTriad.Client_Code__c='SBSOUTP001';
        appTriad.Client_Name__c='SEDERKRANS BOERDERY SOUTPANSBERG BK';
        insert appTriad;
        Application_Triad_Detail__c atd=new Application_Triad_Detail__c();
        atd.Application_Triad__c=appTriad.Id;
        atd.Number_of_Cheque_RD_Events_value__c=1;
        insert atd;
*/
    }

     @isTest static void testPositive() {
        // Set mock callout class
        monthlyCalTestMock();

        Test.startTest();
        monthlyCalculations_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    public static void monthlyCalTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static monthlyCalculations_Resp_IB_v1 callHandlerMethod() {
        monthlyCalculations_Req_IB_v1 requestBean = monthlyCalculations_Req_IB_v1.createDummyRequest();
        monthlyCalculations_Resp_IB_v1 responseBean = monthlyCalculations_IH_v1.getmonthlyCalculations(requestBean);
        return responseBean;
    }
}