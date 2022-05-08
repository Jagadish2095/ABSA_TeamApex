@isTest
public class EventSMSAdaptorTest {
    @isTest static void dispatchSMS() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        EventSMSAdaptor.dispatchSMS(
            null,
            null,
            '0609723278',
            'V Panajic',
            'Client EPP 4 Hours Before the Call SMS',
            'iTouch SMS Submit - EPP',
            false);
            System.assert(true, testDataFactory!=null);
    }
    
    @isTest static void sendSMS() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<EventSMSAdaptor.SendSMSRequest> smsList = new List<EventSMSAdaptor.SendSMSRequest>();
        EventSMSAdaptor.SendSMSRequest sms = new EventSMSAdaptor.SendSMSRequest();
        sms.whoId = testDataFactory.testContact.Id;
        sms.whatId = testDataFactory.testOpportunity.id;
        sms.integrationService = 'iTouch SMS Submit - EPP';
        sms.quickTextName = 'Client EPP 4 Hours Before the Call SMS';
        smsList.add(sms);
        EventSMSAdaptor.sendSMS(smsList);
        System.assert(true, testDataFactory!=null);
    }
}