/*
 * Test Class for AvafDebitOrderDetailsController
 * @author Jason Quevauvilliers
 * @created 2020-11-25
 */
@IsTest
public class AvafDebitOrderDetailsControllerTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{
                AvafGetDebitOrderDetails_IH_v1.INTEGRATION_SERVICE_NAME,
                AvafGetBankDetails_IH_v1.INTEGRATION_SERVICE_NAME,
                AvafGetPartner_IH_v1.INTEGRATION_SERVICE_NAME,
                AvafAddBankDetails_IH_v1.INTEGRATION_SERVICE_NAME,
                AvafChangeDebitOrder_IH_v1.INTEGRATION_SERVICE_NAME
            }
        );
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CHECK_DIGIT_VERIFICATION });
    }

    @isTest
    static void testAvafGetDebitOrderDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AvafGetDebitOrderDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AvafGetDebitOrderDetails_Req_IB_v1 req = AvafGetDebitOrderDetails_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AvafGetDebitOrderDetails_Resp_IB_v1 respBean = AvafDebitOrderDetailsController.DebitOrderDetails(req.BAPI_SF_DO_DETAILS[0].I_ACCOUNT);
        Test.stopTest();

        System.assertEquals(200, respBean.statusCode);
    }

    @isTest
    static void testAvafGetPartner() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AvafGetPartner_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AvafGetPartner_Req_IB_v1 req = AvafGetPartner_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AvafGetPartner_Resp_IB_v1 respBean = AvafDebitOrderDetailsController.PartnerDetails(req.BAPI_SF_PARTNER_GET.I_ACCOUNT);
        Test.stopTest();

        System.assertEquals(200, respBean.statusCode);
    }

    @isTest
    static void testUpdateDebitOrderDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AvafChangeDebitOrder_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AvafChangeDebitOrder_Req_IB_v1 req = AvafChangeDebitOrder_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AvafChangeDebitOrder_Resp_IB_v1 respBean = AvafDebitOrderDetailsController.UpdateDebitOrderDetails(
            req.I_ACCOUNT,
            req.BAPI_SF_DO_CHG[0].ZDEBIT_ORDER,
            req.BAPI_SF_DO_CHG[0].ZCOLDAY,
            req.BAPI_SF_DO_CHG[0].ZCOLSTARTDATE,
            req.BAPI_SF_DO_CHG[0].ZCOLENDDATE,
            req.BAPI_SF_DO_CHG[0].ZCOLAMOUNT,
            req.BAPI_SF_DO_CHG[0].ZCOLBANKID,
            req.BAPI_SF_DO_CHG[0].ZBANK_ACC
        );
        Test.stopTest();

        System.assertEquals(200, respBean.statusCode);
    }

    @IsTest
    static void testAvafGetPartnerBankingDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AvafGetBankDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AvafGetBankDetails_Req_IB_v1 req = AvafGetBankDetails_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AvafGetBankDetails_Resp_IB_v1 responseBean = AvafDebitOrderDetailsController.getPartnerBankingDetails(req.BAPI_BUPA_BANKDETAILS_GET.BUSINESSPARTNER);
        Test.stopTest();

        System.assertEquals(200, responseBean.statusCode);
    }

    @IsTest
    static void testCheckDigitVerification() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CheckDigitVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        CheckDigitVerification_Req_IB_v1 req = new CheckDigitVerification_Req_IB_v1();
        req.createDummyRequest();

        Test.startTest();
        CheckDigitVerification_Resp_IB_v1 responseBean = AvafDebitOrderDetailsController.validateBankingDetails(
            req.accountNumber,
            req.branchCode,
            req.accountType
        );
        Test.stopTest();

        System.assertEquals(200, responseBean.statusCode);
    }

    @IsTest
    static void testAvafAddBankDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, AvafAddBankDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AvafAddBankDetails_Req_IB_v1 dummyBean = AvafAddBankDetails_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AvafAddBankDetails_Resp_IB_v1 responseBean = AvafDebitOrderDetailsController.addPartnerBankingDetails(
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BUSINESSPARTNER,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_ACCT,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_KEY,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.CTRL_KEY
        );
        Test.stopTest();

        System.assertEquals(200, responseBean.statusCode);
    }
}