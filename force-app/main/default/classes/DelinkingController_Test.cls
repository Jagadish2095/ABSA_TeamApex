@IsTest
public class DelinkingController_Test {

    @TestSetup
    static void makeData(){
        List<String> servicesNames = new List<String> {CQgetChargesDetailsMaintV9_IH_v1.CQ_GET_CHARGES_DETAILS_MAINT_V9, CQgetValueBundleOptionsV3_IH_v1.CQ_GET_VALUE_BUNDLE_OPTIONS_V3, CQupdateChargesDetailsV12_IH_v1.CQ_UPDATE_CHARGES_DETAILS_V12, 'CIgetAcctLinkedToClientCodeV3'};
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, servicesNames);

    }
    
    @IsTest
    public static void testCqGetChargesDetailsPositive() {
        
        String responseBody = JSON.serialize(CQgetChargesDetailsMaintV9_Resp_IB_v1.dummyResponse());
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        CQgetChargesDetailsMaintV9_Req_IB_v1 dummyRequest = CQgetChargesDetailsMaintV9_Req_IB_v1.createDummyRequest();

        Test.startTest();
        CQgetChargesDetailsMaintV9_Resp_IB_v1 testResponseBeean = DelinkingController.cqGetChargesDetails('12345');
        Test.stopTest();

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(200);
        CQgetChargesDetailsMaintV9_Resp_IB_v1 unusedResponse = CQgetChargesDetailsMaintV9_IU_v1.mapResponseFields(response);
        CQgetChargesDetailsMaintV9_Resp_IB_v1 failedResponse = CQgetChargesDetailsMaintV9_IU_v1.mapFailedResponseFields('OK', 200, 'OK');


        System.assertEquals(200, testResponseBeean.statusCode);
    }

    @IsTest
    public static void testCqGetChargesDetailsNegative() {
        try{
            CQgetChargesDetailsMaintV9_Resp_IB_v1 testResponseBean = DelinkingController.cqGetChargesDetails(null);
        }
        catch(Exception ex){
            system.assert(String.isNotBlank(ex.getMessage()));
        }
    }

    @isTest
    static void testCqGetValueBandleOptions(){
        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = new CQgetValueBundleOptionsV3_Resp_IB_v1();

        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O CQS044O = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O();
        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA CQS044O_OUTPUT_AREA = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA();
        CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE SCHEME_CODE_TABLE = new CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE();
        SCHEME_CODE_TABLE.CBP_PRICING_SCHEME_CODE = 'pricingSchemeCode';
        
        CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE = new List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE>{SCHEME_CODE_TABLE};
        CQS044O.CQS044O_OUTPUT_AREA = CQS044O_OUTPUT_AREA;
        responseBean.CQS044O = CQS044O;

        CQgetValueBundleOptionsV3_Req_IB_v1 fakeRequest = new CQgetValueBundleOptionsV3_Req_IB_v1();
    
        String responseBody = JSON.serialize(responseBean);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> testResponseBeean = DelinkingController.cqGetValueBandleOptions('12345');
        Test.stopTest();

        system.assertEquals('pricingSchemeCode', testResponseBeean[0].CBP_PRICING_SCHEME_CODE);
    }

    @IsTest
    static void testCqGetValueBandleOptionsNegative() {
        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = new CQgetValueBundleOptionsV3_Resp_IB_v1();

        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O CQS044O = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O();
        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA CQS044O_OUTPUT_AREA = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3 NBSMSGO3 = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3_internal NBSMSGO3_internal = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3_internal();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY NBNMSGO3_MSG_ENTRY = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();

        NBNMSGO3_MSG_ENTRY.NBNMSGO3_MSG_TXT = 'test';
        NBSMSGO3_internal.NBNMSGO3_MSG_ENTRY = new List<CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>{NBNMSGO3_MSG_ENTRY};
        NBSMSGO3.NBSMSGO3 = NBSMSGO3_internal;        
        // CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE = null;
        CQS044O.CQS044O_OUTPUT_AREA = CQS044O_OUTPUT_AREA;
        responseBean.CQS044O = CQS044O;
        responseBean.NBSMSGO3 = NBSMSGO3;

        CQgetValueBundleOptionsV3_Req_IB_v1 fakeRequest = new CQgetValueBundleOptionsV3_Req_IB_v1();
    
        String responseBody = JSON.serialize(responseBean);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        try {
            List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> testResponseBean = DelinkingController.cqGetValueBandleOptions('12345');
            System.debug('testResponseBean' + JSON.serialize(testResponseBean));
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }
        Test.stopTest();
    } 

    @isTest
    static void testUpdateChargesDetails(){

        CQgetChargesDetailsMaintV9_Resp_IB_v1 dummyResponse = CQgetChargesDetailsMaintV9_Resp_IB_v1.dummyResponse();
        Map<String, Object> cqs4450_output_area = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dummyResponse.CQS445O.CQS445O_OUTPUT_AREA));
        
        Map<Object, Object> outputAreaMap = new Map<Object, Object>();
        for (String key : cqs4450_output_area.keySet()) {
            outputAreaMap.put(key, cqs4450_output_area.get(key));
        }
        
        Map<Object, Object> cashChargeMap = new Map<Object, Object> {
            'CQS445O_CSHCRG_DEP_AMT' => '0',
            'CQS445O_CSHCRG_PERC' => '0'
        };
        Map<Object, Object> cashDepMap = new Map<Object, Object> {
            'CQS445O_CSHCRG_BASE_FEE' => '0',
            'CQS445O_CASH_DEP_FEE_TYPE' => '0',
            'CQS445O_CSHCRG_MCDF_FEE' => '0'
        };
        Map<Object, Object> mgtcrgBarierMap = new Map<Object, Object> {
            'CQS445O_MGTCRG_NBR_DBT_TRAN' => '0',
            'CQS445O_MGTCRG_MNTH_FEE' => '0'
        };

        CQupdateChargesDetailsV12_Req_IB_v1 dummyRequest = new CQupdateChargesDetailsV12_Req_IB_v1();
        Map<String, Object> requestFieldsValues = new Map<String, Object>{'CQS446I_ACCOUNT_NBR'=>'77.21842588',
                                                                            'CQS446I_MANDATE_NUMBER'=>'41.8568809',
                                                                            'CQS446I_CBP_SCHEME_CODE'=>'pukb',
                                                                            'CQS446I_CBP_SCHEME_START'=>'17.50446832',
                                                                            'CQS446I_SCHEME_RSET_DESC'=>'text description',
                                                                            'CQS446I_NEXT_CHRG_CAP_DATE'=>'33562341',
                                                                            'CQS446I_CSHCRG' => new List<Object>{cashChargeMap},
                                                                            'CQS446I_CSHDEP_DETAIL' => new List<Object>{cashDepMap},
                                                                            'CQS446I_MGTCRG_BARRIER' => new List<Object>{mgtcrgBarierMap},
                                                                            'CQS446I_CHARGE_FREQ' => 'M',
                                                                            'CQS445O_OUTPUT_AREA' => outputAreaMap
                                                                        };

        String responseBody = JSON.serialize(CQupdateChargesDetailsV12_Resp_IB_v1.dummyResponse());
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        CQupdateChargesDetailsV12_Resp_IB_v1 testResponseBean = DelinkingController.updateChargesDetails(requestFieldsValues);
        Test.stopTest();

        system.assertEquals(200, testResponseBean.statusCode);
        
    }

    @isTest
    static void testUpdateChargesDetailsNegative(){
        
        Map<String, Object> requestFieldsValues = new Map<String, Object>{'CQS446I_ACCOUNT_NBR'=>'77.21842588',
                                                                            'CQS446I_MANDATE_NUMBER'=>'41.8568809',
                                                                            'CQS446I_CBP_SCHEME_CODE'=>'pukb',
                                                                            'CQS446I_CBP_SCHEME_START'=>'17.50446832',
                                                                            'CQS446I_SCHEME_RSET_DESC'=>'text description',
                                                                            'CQS446I_NEXT_CHRG_CAP_DATE'=>'33562341',
                                                                            'CQS446I_CSHCRG' => new List<Object>{null},
                                                                            'CQS446I_CSHDEP_DETAIL' => new List<Object>{null},
                                                                            'CQS446I_MGTCRG_BARRIER' => new List<Object>{null}};

        Test.setMock(HttpCalloutMock.class, new CQcalloutMock('{"errorMessage":"test"}', 500));

        try{
            CQupdateChargesDetailsV12_Resp_IB_v1 testResponseBean = DelinkingController.updateChargesDetails(requestFieldsValues);
        }
        catch(Exception ex){
            system.assert(String.isNotBlank(ex.getMessage()));
        }


        
    }

    @isTest
    static void testUpdateChargesDetailsException(){

        try{
            CQupdateChargesDetailsV12_Resp_IB_v1 testResponseBean = DelinkingController.updateChargesDetails(null);
        }
        catch(Exception ex){
            system.assert(String.isNotBlank(ex.getMessage()));
        }
    }

    @isTest
    static void testChequeAccountNumbers(){
        CIgetAcctLinkedToClientCodeV3_Req_IB_v1 fakeRequest = CIgetAcctLinkedToClientCodeV3_Req_IB_v1.createDummyRequest();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 fakeResponse = CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.dummyResponse();
        String responseBody = JSON.serialize(getAcctLinkedToClientCodeDummyResponse());
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        List<Object> testResponseBean = DelinkingController.getChequeAccountNumbers('12345');
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
        	List<Object> testResponseBean = DelinkingController.getChequeAccountNumbers('12345');
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }
        Test.stopTest();        
    }

    public static CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 getAcctLinkedToClientCodeDummyResponse() {

        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1();

        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Cip047o cip047o = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Cip047o();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable outpuTableItem = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable();
        outpuTableItem.productType = 'CQ';
        cip047o.outputTable = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable>{outpuTableItem};
        responseBean.cip047o = cip047o;
    
        return responseBean;
    }    
}