@IsTest
public class CQupdateChargesDetailsV12_Test {
    
    public static void testCQupdateChargesDetails(Boolean insertIntegrationSettings, Integer statusCode, Boolean isErrorResponse) {
        
        if (insertIntegrationSettings) {
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {CQupdateChargesDetailsV12_IH_v1.CQ_UPDATE_CHARGES_DETAILS_V12});
        }

        String errorMessage = 'Test Error Message';

        String responseBody = '{"errorMessage" : "' + errorMessage + '"}';

        if (!isErrorResponse) {
            responseBody = JSON.serialize(CQupdateChargesDetailsV12_Resp_IB_v1.dummyResponse());
        }
    
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, statusCode));

        Test.startTest();
        try {
            Map<CQupdateChargesDetailsV12_Resp_IB_v1, List<Sys_Log_Integration__c>> response = CQupdateChargesDetailsV12_IH_v1.callToCQupdateChargesDetailsV12(generateRequestFieldsValues());

            if (insertIntegrationSettings) {
                System.assertEquals(statusCode, new List<CQupdateChargesDetailsV12_Resp_IB_v1> (response.keySet())[0].statusCode);
            } else {
                System.assertEquals(500, new List<CQupdateChargesDetailsV12_Resp_IB_v1> (response.keySet())[0].statusCode);    
            }

        } catch (Exception e) {
            System.assertEquals(errorMessage, e.getMessage());
        }
        Test.stopTest();
        
    }

    @IsTest
    public static void testCQupdateChargesDetailsPositive() {
        testCQupdateChargesDetails(true, 200, false);
    }

    @IsTest
    public static void testCQupdateChargesDetailsNegative() {
        testCQupdateChargesDetails(false, 200, false);
    }

    @IsTest 
    public static void testCQupdateChargesDetailsStatusFailed() {
        testCQupdateChargesDetails(true, 500, false);
    }

    @isTest 
    public static void testCQupdateChargesDetailsBadResponse() {
        testCQupdateChargesDetails(true, 200, true);
    }

    @IsTest 
    public static void testCQupdateChargesDetails_Req() {
        CQupdateChargesDetailsV12_Req_IB_v1 request = new CQupdateChargesDetailsV12_Req_IB_v1();
    }

    static Map<String, Object> generateRequestFieldsValues() {

        //Used response from CQgetChargesDetailsV9
        CQgetChargesDetailsMaintV9_Resp_IB_v1 getChargesDetailsDummyResponse = CQgetChargesDetailsMaintV9_Resp_IB_v1.dummyResponse();

        Map<String, Object> cqs4450_output_area = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(getChargesDetailsDummyResponse.CQS445O.CQS445O_OUTPUT_AREA));
        
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
                    
        return requestFieldsValues;
    }
}