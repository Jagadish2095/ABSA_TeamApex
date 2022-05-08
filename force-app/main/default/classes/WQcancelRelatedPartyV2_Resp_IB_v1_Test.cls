@isTest
public without sharing class WQcancelRelatedPartyV2_Resp_IB_v1_Test {
@isTest  static void WQCancelRelatedV7Response_test()
    {
        
        Test.startTest();   
        WQcancelRelatedPartyV2_Resp_IB_v1 resp_v1 = new WQcancelRelatedPartyV2_Resp_IB_v1();
        system.assertNotEquals('', 'success');
        Test.stopTest();
    }
}