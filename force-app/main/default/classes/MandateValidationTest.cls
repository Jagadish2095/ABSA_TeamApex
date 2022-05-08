/**
 * Test class for MandateValidation
 *
 * @author  Rudolf Niehaus : CloudSmiths
 * @since   2020-02-24
 *
 **/
@isTest
public class MandateValidationTest {
    @isTest
    public static void testMandateValidation() {
        Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new List<String>{ StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4 });
        Test.startTest();
        Map<String, String> responseMap = MandateValidation.getMandate('4048009098');
        System.assert(responseMap.get('Surname') != null);
        Test.stopTest();
    }
}