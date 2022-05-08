/**
 * @author Rajesh Nandigam
 * @since 2021-07-20
 * @description Ecp Leads-service test class
 **/


@isTest
public class EcpLeads_IH_v1_Test {
	 /**
* @since 2021-07-20
* @description Ecp Leads Test class

**/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'ecpLeads'});
    } 
    /**
* @since 2021-07-20
* @description Ecp Leads Test class

**/
    
    @isTest static void testPositive() {
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        String POSITIVE_RESPONSE_BODY = '{"ecpLeads": {"isValid": true,"requestId": "90158987-2bfe-4efe-841d-f79fd56c50d7"}';
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        
        EcpLeads_IH_v1.ECPLeadRequestCall(account.Id,'', '');
        EcpLeads_IH_v1.sendEcpLead(account.Id,'', '');
        EcpLeads_Req_IB_v1.createDummyRequest();
        EcpLeads_Resp_IB_v1.createDummyResponse();
        System.assertEquals(200, 200);
        Test.stopTest();
    }
}