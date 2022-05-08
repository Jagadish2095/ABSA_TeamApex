/*
* Description Test Integration Handler for cclistcombibrandsforpreferredproductv1 Service
* @author  André Pietersen
* @since   2021-02-07
*/
@isTest 
public class CClistCombiBrandsForPrefProdV1IH_v1_Test {

     public static final String POSITIVE_RESPONSE_BODY = '{"wsd_CClistCombiBrandsForPreferredProductV1Response": {        "nbsapdpo": {            "returnCode": "0",            "reasonCode": "0",            "serviceVersion": "BUSO001"        },        "nbsmsgo": {            "nbrUserMsgs": "0",            "nbrUserErrs": "0",            "msgEntry": {                "msgClass": null,                "msgCode": null,                "msgErrInd": null,                "msgTxt": null            }        },        "ccp306o": {            "prodRetrvdInd": "Y",            "nbrBrandRet": "14",            "prdBrandDetails": {                "prdBrandLst": [                    {                        "brandNbr": "2147",                        "brandSeq": "1",                        "brandType": "DM",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2812",                        "brandSeq": "2",                        "brandType": "VA",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2324",                        "brandSeq": "5",                        "brandType": "BC",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2498",                        "brandSeq": "6",                        "brandType": "BK",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2826",                        "brandSeq": "7",                        "brandType": "ZD",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2830",                        "brandSeq": "8",                        "brandType": "ZH",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2630",                        "brandSeq": "9",                        "brandType": "BW",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2698",                        "brandSeq": "11",                        "brandType": "PG",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2699",                        "brandSeq": "12",                        "brandType": "PP",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2629",                        "brandSeq": "14",                        "brandType": "BU",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2141",                        "brandSeq": "15",                        "brandType": "DP",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2159",                        "brandSeq": "17",                        "brandType": "FF",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2618",                        "brandSeq": "18",                        "brandType": "BF",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2847",                        "brandSeq": "19",                        "brandType": "YD",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    }                ]            }        }    }}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistCombiBrandsForPrefProdV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testCombiCardPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CClistCombiBrandForPrefProdV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CClistCombiBrandForPrefProdV1_Resp_IB_v1 callHandlerMethod() {
        CClistCombiBrandsForPrefProdV1_Req_IB_v1 dummyReqBean = CClistCombiBrandsForPrefProdV1_Req_IB_v1.createDummyRequest();
        CClistCombiBrandForPrefProdV1_Resp_IB_v1 responseBean = CClistCombiBrandsForPrefProdV1_IH_v1.cclistcombibrandsforpreferredproduct(dummyReqBean);
        system.debug('this is my res'+responseBean);
        CClistCombiBrandsForPrefProdV1_IU_v1.mapRequestFields('CQ','CQ' ,'C');
        return responseBean;
    }

}