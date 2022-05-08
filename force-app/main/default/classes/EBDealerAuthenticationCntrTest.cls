/**
@description controller test class for EBDealerAuthenticationCntr
@author manideep kenche
@created 2021/10/21
@work W-014039
*/
@isTest
public class EBDealerAuthenticationCntrTest {
    
    
    
    @IsTest
    static void getDealerInfoPositive() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AuthenticateDealer_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AuthenticateDealer_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        String response = EBDealerAuthenticationCntr.getDealerInfo('0000513119','ab0131R');
        AuthenticateDealer_Resp_IB_v1 responseBean = (AuthenticateDealer_Resp_IB_v1)JSON.deserialize(response,AuthenticateDealer_Resp_IB_v1.class);
        System.assertEquals('Y',responseBean.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.ZAPPROVED_IND);
        Test.stopTest();
    }
    
    
    @IsTest
    static void getDealerInfoNegative() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AuthenticateDealer_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AuthenticateDealer_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_NEGATIVE
            )
        );
        
        Test.startTest();
        String response = EBDealerAuthenticationCntr.getDealerInfo('0000500024','ab0131R');
        AuthenticateDealer_Resp_IB_v1 responseBean = (AuthenticateDealer_Resp_IB_v1)JSON.deserialize(response,AuthenticateDealer_Resp_IB_v1.class);
        System.assertEquals('N',responseBean.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.ZAPPROVED_IND);
        Test.stopTest();
    }
    
    
    @isTest
    static void getContractInfoTestMethod(){
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ BAPISFAccntDescr_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                BAPISFAccntDescr_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        
        String response = EBDealerAuthenticationCntr.getContractInfo('00090274692','ab0131R');
        BAPISFAccntDescr_Resp_IB_v1 responseBean = (BAPISFAccntDescr_Resp_IB_v1)JSON.deserialize(response,BAPISFAccntDescr_Resp_IB_v1.class);
        System.assertEquals(200,responseBean.statusCode);
        Test.stopTest();
    }
    
    
    @isTest
    static void getCustomerInfoTestMethod(){
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ CIgetClientDetailsV12_IH_v1.INTEGRATION_SERVICE_NAME }
        );
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                CIgetClientDetailsV12_IH_v1_Test.POSITIVE_RESPONSE_BODY
            )
        );
        Test.startTest();
        String response = EBDealerAuthenticationCntr.getCustomerInfo('BATESW 002','77094917');
        CIgetClientDetailsV12_Resp_IB_v1 responseBean = (CIgetClientDetailsV12_Resp_IB_v1)JSON.deserialize(response,CIgetClientDetailsV12_Resp_IB_v1.class);
        System.assert(responseBean!=null,'response not received');
        Test.stopTest();
    }
}