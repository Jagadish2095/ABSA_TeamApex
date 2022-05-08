/*
*Test Integration Handler for MBcomplEpSpaymentV4 Service
* @author Lulu Rankwe
* @created 2020-03-06
*/
@isTest
public class MBcomplEpSpaymentV4_IH_v1_Test {
    
    @isTest static void validateMBcomplEpSpaymentPositive() 
    {  
        MBcomplEpSpaymentV4_Req_IB_v1 dummyBean = new MBcomplEpSpaymentV4_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        MBcomplEpSpaymentV4_Resp_IB_v1 dummyBeanResp = MBcomplEpSpaymentV4_Resp_IB_v1.dummyResponse();
        
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.MB_COMPL_EPS_PAYMENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();       
        MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.mBcomplEpSpaymentV4('80003705DB');
        System.assertEquals(200, singleresponse.statusCode);
        Test.stopTest();
        
    }

    @isTest static void validateMBcomplEpSpaymentNegative()
    {               
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        Test.startTest();
        
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean = MBcomplEpSpaymentV4_IH_v1.mBcomplEpSpaymentV4('');
        System.assertNotEquals(null,responseBean);
        System.debug('responseBean negative: '+ responseBean);
        Test.stopTest();
    } 
    
    
    @isTest static void validatePayBeneficiaryPositive() 
    {  
        MBcomplEpSpaymentV4_Req_IB_v1 dummyBean = new MBcomplEpSpaymentV4_Req_IB_v1();
        dummyBean.createDummyRequest();      
        MBcomplEpSpaymentV4_Resp_IB_v1 dummyBeanResp = MBcomplEpSpaymentV4_Resp_IB_v1.dummyResponse();
        
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.MB_COMPL_EPS_PAYMENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();       
        MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.payBeneficiary('80003705DB','1');
        System.assertEquals(200, singleresponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest static void validatePayBeneficiaryNegative()
    {               
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        Test.startTest();
        
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean = MBcomplEpSpaymentV4_IH_v1.payBeneficiary('','');
        System.assertNotEquals(null,responseBean);
        System.debug('responseBean negative: '+ responseBean);
        Test.stopTest();
    } 


}