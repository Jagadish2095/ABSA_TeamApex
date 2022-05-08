/* Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020 
 */
@isTest
public class CQgetAcctHoldsMaintV4_IH_v1_Test {
    
    
    @isTest static void CQgetAcctHoldsMaintV4Positive() {
        // Set mock callout class 
        CQgetAcctHoldsMaintV4_Req_IB_v1 dummyReq = CQgetAcctHoldsMaintV4_Req_IB_v1.createDummy();
        CQgetAcctHoldsMaintV4_Resp_IB_v1 dummyResponseBean = CQgetAcctHoldsMaintV4_Resp_IB_v1.dummyResponse();
        
        Test.setMock(HttpCalloutMock.class, new CQgetAcctHoldsMaintV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_GET_ACCOUNT_HOLDS});
        
        Test.startTest();
        Map<CQgetAcctHoldsMaintV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQgetAcctHoldsMaintV4_IH_v1.callTocqgetacctholdsmaintv4('9050986380');     
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = (new List<CQgetAcctHoldsMaintV4_Resp_IB_v1>(responseMap.keySet()))[0];  
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
        
    }
        @isTest static void CQgetAcctHoldsMaintV4Negetive() {

        Test.setMock(HttpCalloutMock.class, new CQgetAcctHoldsMaintV4_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_GET_ACCOUNT_HOLDS});
        
        Test.startTest();
        Map<CQgetAcctHoldsMaintV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQgetAcctHoldsMaintV4_IH_v1.callTocqgetacctholdsmaintv4('');     
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = (new List<CQgetAcctHoldsMaintV4_Resp_IB_v1>(responseMap.keySet()))[0];  
        system.assertNotEquals(200, responseBean.statusCode);
        Test.stopTest();
        
    }
    @isTest static void CQgetAcctHoldsMaintV4V1NoIntegrationSettings() {
        CQgetAcctHoldsMaintV4_Req_IB_v1 dummyReq = CQgetAcctHoldsMaintV4_Req_IB_v1.createDummy();
        CQgetAcctHoldsMaintV4_Resp_IB_v1 dummyResponseBean = CQgetAcctHoldsMaintV4_Resp_IB_v1.dummyResponse();

        
        Test.startTest();       
        Map<CQgetAcctHoldsMaintV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQgetAcctHoldsMaintV4_IH_v1.callTocqgetacctholdsmaintv4('');     
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = (new List<CQgetAcctHoldsMaintV4_Resp_IB_v1>(responseMap.keySet()))[0];          
        Test.stopTest();
    }
    

  
}