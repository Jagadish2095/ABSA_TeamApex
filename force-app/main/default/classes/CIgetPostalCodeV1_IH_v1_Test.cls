/*
 * Test Integration Handler Bean for CIgetPostalCodeV1 Service
 * @author Prudence Shirindzi
 * @created 2020-10-05
 */
@isTest
public class CIgetPostalCodeV1_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"CIgetPostalCodeV1Response":{"nbsaplo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":[]},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":[],"nbrUserMsgs":"0","nbrUserErrs":"0"},"cib603do":{"lastSearchPos":"RANDBURGUIT5","nbrEntsRetrieved":"15","tableEntry":[{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2125","suburbName":"RANDBURG","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURG"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT03"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT05"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT10","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT10"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT17","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT17"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT24","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT24"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT3"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT5"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT03"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT05"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT10","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT10"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT17","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT17"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT24","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT24"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT3"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT5"}]}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIgetPostalCodeV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CIgetPostalCodeV1_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }

    private static CIgetPostalCodeV1_Resp_IB_v1 callHandlerMethod() {
        
        CIgetPostalCodeV1_Req_IB_v1 dummyBean = CIgetPostalCodeV1_Req_IB_v1.CreateDummyRequest();
        CIgetPostalCodeV1_Resp_IB_v1 responseBean = CIgetPostalCodeV1_IH_v1.CIgetPostalCodeV1(dummyBean);

        return responseBean;
    }

    
}