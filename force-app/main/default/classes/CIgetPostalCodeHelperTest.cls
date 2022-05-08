/*
Controller Test Class For CIgetPostalCodeHelper class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class CIgetPostalCodeHelperTest {
    //public static final String QUERY_RESPONSE = '{"CIgetPostalCodeV1Response":{"nbsaplo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":[]},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":[],"nbrUserMsgs":"0","nbrUserErrs":"0"},"cib603do":{"lastSearchPos":"RANDBURGUIT5","nbrEntsRetrieved":"15","tableEntry":[{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2125","suburbName":"RANDBURG","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURG"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT03"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT05"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT10","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT10"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT17","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT17"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT24","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT24"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT3"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGEXT5"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT03"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT05"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT10","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT10"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT17","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT17"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT24","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT24"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT3","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT3"},{"noStreetDelivery":"Y","streetPostCode":"2194","postBoxCode":"2194","suburbName":"RANDBURGEXT5","townOrCityName":"RANDBURG","provinceName":"GAUT","uniqueName":"RANDBURGUIT5"}]}}}';

    @isTest
    public static void getPostalCodeDetailsTest(){
		String area = 'FAERIE GLEN';
        Test.startTest();
        List<Map<String, Object>> errorText = CIgetPostalCodeHelper.getPostalCodeDetails(area);
        System.assert(errorText != null, 'Test Working');
        Test.stopTest();
    }
}