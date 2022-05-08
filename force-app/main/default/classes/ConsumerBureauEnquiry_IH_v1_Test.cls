/**  * Test class for ConsumerBureauEnquiry_IH_v1
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date December 2020
 *
 **/
@IsTest
public class ConsumerBureauEnquiry_IH_v1_Test {
	private static final String POSITIVE_RESPONSE_BODY = ConsumerBureauEnquiry_Resp_IB_v1.getStringDummyResponse();
    
	@TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ConsumerBureauEnquiry_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest
    public static void testConsumerBureauEnquiry(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        String apppcceid = '000000409796';
        
        Test.startTest();
        String testResponse = JSON.serialize(ConsumerBureauEnquiry_IH_v1.consumerBureauEnquiry(apppcceid));
        Test.stopTest();
        
        System.assert(testResponse.contains(apppcceid));
    }
}