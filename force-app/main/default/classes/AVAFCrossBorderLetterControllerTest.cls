/*
 * AVAFCrossBorderLetterControllerTest class for AVAFCrossBorderLetterController
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-17
 * @W-006962
 */

@IsTest
public class AVAFCrossBorderLetterControllerTest {
    @isTest
    static void sendCrossBorderLetterTest() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFCrossBorderLetter_v1';
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        AVAFCrossBorderLetter_Req_IB_v1 dummyBean = AVAFCrossBorderLetter_Req_IB_v1.createDummyRequest();
        Test.startTest();
        AVAFCrossBorderLetter_Resp_IB_v1 responseBean = AVAFCrossBorderLetterController.sendCrossBorderLetter(
            dummyBean.accountNumber,
            dummyBean.userEmail,
            dummyBean.userIdNumber,
            dummyBean.userName,
            dummyBean.userSurname,
            dummyBean.driverName,
            dummyBean.driverIdNumber,
            dummyBean.periodStart,
            dummyBean.periodEnd
        );
        Test.stopTest();
    }
}