/*
 * PolicyBeneficiaryMaintenanceCntrTest for testing PolicyBeneficiaryMaintenanceCntr class
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-07-10
 * @W-006912
 */
@isTest
public class PolicyBeneficiaryMaintenanceCntrTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ LAListPolicyDetailsByPolicyV7_IH_v1.INTEGRATION_SERVICE_NAME, LAUpdateBeneficiaryDetailsV2_IH_v1.INTEGRATION_SERVICE_NAME, PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME, ContractCaptureBeneficiary_IH_v1.INTEGRATION_SERVICE_NAME, ExergyLogin_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @isTest
    static void getBeneficiaryDetailsTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, LAListPolicyDetailsByPolicyV7_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        Test.startTest();
        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = PolicyBeneficiaryMaintenanceCntr.getBeneficiaryDetails('6440952728', new List<String>{ 'BEN' });
        Test.stopTest();
        System.assertEquals(200, responseBean.statusCode, 'Successful Status Code not received');
    }

    @isTest
    static void LAUpdateBeneficiaryDetailsV2Test() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_LAUpdateBeneficiaryDetailsV2_v1';
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        LAUpdateBeneficiaryDetailsV2_Req_IB_v1 requestBean = LAUpdateBeneficiaryDetailsV2_Req_IB_v1.createDummyRequest();
        Test.startTest();
        LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 responseBean = PolicyBeneficiaryMaintenanceCntr.LAUpdateBeneficiaryDetailsV2(JSON.serialize(requestBean));
        Test.stopTest();
    }

    @isTest
    static void getBeneficiaryDetailsForExergyTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        Test.startTest();
        PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyBeneficiaryMaintenanceCntr.getBeneficiaryDetailsForExergy('6633725447');
        Test.stopTest();
        System.assertEquals(200, responseBean.statusCode, 'Successful Status Code not received');
    }

    @isTest
    static void contractCaptureBeneficiaryTest() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractCaptureBeneficiary_v1';
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        ContractCaptureBeneficiary_Req_IB_v1 requestBean = ContractCaptureBeneficiary_Req_IB_v1.createDummyRequest();
        Test.startTest();
        ContractCaptureBeneficiary_Resp_IB_v1 responseBean = PolicyBeneficiaryMaintenanceCntr.contractCaptureBeneficiary(JSON.serialize(requestBean));
        Test.stopTest();
    }
}