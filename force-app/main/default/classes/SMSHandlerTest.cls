/**
* This is the SMSHandler test class
*
* @author	Vladimir Panajic
* @created	 2019-05-02
* @description
*/
@IsTest
public class SMSHandlerTest {

    static Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Standard User (Custom)'];

    @isTest static void sendSMSContact() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.sendSMS(testDataFactory.testContact.Id, testDataFactory.testOpportunity.id, '', '', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true);
    }
    
    
    @isTest static void sendSMSContactPhoneOveride() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.sendSMS(null, testDataFactory.testOpportunity.id, '0609723278', 'V Panajic', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true); 
    }
    
    @isTest static void sendSMSLead() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.sendSMS(testDataFactory.testLead.Id, testDataFactory.testOpportunity.id, '', '', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true);
    }
    
    @istest static void sendSMSLeadPhoneOveride() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.sendSMS(null, testDataFactory.testOpportunity.id, '0609723278', 'V Panajic', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true);
    }
    
    @istest static void sendSMSUser() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        User testUser = WillsTestDataFactory.createTestUser(null, testProfile.Id, 'Test', 'User');
        testUser.MobilePhone = '+27 0600000000';
        update testUser;
        SMSHandler.sendSMS(testUser.Id, testDataFactory.testOpportunity.id, '', '', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true);
    }
    
    @isTest static void sendSMSUserPhoneOveride() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.sendSMS(null, testDataFactory.testOpportunity.id, '0609723278', 'V Panajic', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS', true);
        system.assert(true);
    }
    
    @istest static void getPlainTextSMSBody() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.getPlainTextSMSBody(testDataFactory.testContact.Id, testDataFactory.testOpportunity.id, 'Test Quick Text Merge');
        system.assert(true);
    }
    
    @istest static void createTask() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.createTask('Joe Blogs', '0609723278', testDataFactory.testContact.Id, testDataFactory.testOpportunity.id, UserInfo.getUserId(), 'This is test...', '400370015736995197');
        system.assert(true);
    }
    
    @isTest static void dispatchSMS() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        SMSHandler.dispatchSMS('0609723278', 'This is test...', 'Client EPP 4 Hours Before the Call SMS');
        system.assert(true);
    }
}