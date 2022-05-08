/**
 * @description
 * @author  Taras Kuliievych
 * @since 2021-08-08
**/
@isTest
public class Enquiry_CurrentProductsControllerTest {

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-05-21
    */
    @TestSetup
    static void makeData(){
        List<String> servicesNames = new List<String> {CQgetChargesDetailsMaintV9_IH_v1.CQ_GET_CHARGES_DETAILS_MAINT_V9, CQgetValueBundleOptionsV3_IH_v1.CQ_GET_VALUE_BUNDLE_OPTIONS_V3, CQupdateChargesDetailsV12_IH_v1.CQ_UPDATE_CHARGES_DETAILS_V12, 'CIgetAcctLinkedToClientCodeV3'};
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, servicesNames);

    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-05-21
    */
    @isTest
    static void testChequeAccountNumbers(){
        CIgetAcctLinkedToClientCodeV3_Req_IB_v1 fakeRequest = CIgetAcctLinkedToClientCodeV3_Req_IB_v1.createDummyRequest();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 fakeResponse = CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.dummyResponse();
        String responseBody = JSON.serialize(fakeResponse);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        List<Object> testResponseBean = Enquiry_CurrentProductsController.getClientAccountNumbers('12345');
        Test.stopTest();
        Boolean result = false;

        for(Object item : testResponseBean){
            CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable table = (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable) item;
            if(table.productType == 'CQ'){
                result = true;
                break;
            }
        }

        system.assert(result);
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-05-21
    */
    @isTest
    static void testChequeAccountNumbersWithMessage(){
        CIgetAcctLinkedToClientCodeV3_Req_IB_v1 fakeRequest = CIgetAcctLinkedToClientCodeV3_Req_IB_v1.createDummyRequest();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 fakeResponse = CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.dummyResponse();
        fakeResponse.message = 'test message';

        String responseBody = JSON.serialize(fakeResponse);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();

        try {
        	List<Object> testResponseBean = Enquiry_CurrentProductsController.getClientAccountNumbers('12345');
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-05-21
    */
    @isTest
    static void testChequeAccountNumbersNegative() {

        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1();

        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.cip047o cip047o = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.cip047o();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.nbsmsgo3();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry msgEntry = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry();
        msgEntry.msgTxt = 'test';
        nbsmsgo3.msgEntry = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry>{msgEntry};
        responseBean.cip047o = cip047o;
        responseBean.nbsmsgo3 = nbsmsgo3;

        String responseBody = JSON.serialize(responseBean);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();

        try {
        	List<Object> testResponseBean = Enquiry_CurrentProductsController.getClientAccountNumbers('12345');
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }

        Test.stopTest();
    }
}