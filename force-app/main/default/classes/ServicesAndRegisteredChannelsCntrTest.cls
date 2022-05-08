/**
 * @description ServicesAndRegisteredChannelsCntrTest for testing ServicesAndChannelsController class
 * @author  Humbelani Denge
 * @since   2020-11-04
 * @W-006015
 */
@isTest
public class ServicesAndRegisteredChannelsCntrTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.GET_CLIENT_DETAILS });
    }

    @IsTest
    static void getClientDetails() {
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING));

        Test.startTest();

        Map<String, Boolean> response = ServicesAndRegisteredChannelsCntr.getClientDetails('BALDID 001', '0', '0');
        System.assertEquals(true, response.get('isResponseSuccess'));

        Test.stopTest();
    }
}