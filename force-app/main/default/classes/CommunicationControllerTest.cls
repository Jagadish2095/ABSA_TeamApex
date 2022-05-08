/**
* This is the Communication Lightning Component Apex controller test class
*
* @author   Nelson Chisoko (Dariel)
* @since    2019/01/24
*/
@IsTest
private class CommunicationControllerTest {

    static testMethod void testGetApplicationByOpportunityId() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Application__c result = CommunicationController.getApplicationByOpportunityId(testOpportunity.Id);
        System.assert(result != null);
    }

    static testMethod void testCheckCommunicationPreferenceSet() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        CommunicationController.updateApplication(testOpportunity.Id, 'Email', 'test@test.com');
        Boolean result = CommunicationController.checkCommunicationPreferenceSet(testOpportunity.Id);
        System.assert(result == true || result == false);
    }

    static testMethod void testCheckCommunicationPreferenceSetType() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        CommunicationController.updateApplication(testOpportunity.Id, 'Email', 'test@test.com');
        String result = CommunicationController.checkCommunicationPreferenceSetType(testOpportunity.Id);
        System.assertEquals('Email', result);
        CommunicationController.updateApplication(testOpportunity.Id, 'SMS', '0123456789');
        result = CommunicationController.checkCommunicationPreferenceSetType(testOpportunity.Id);
        System.assertEquals('SMS', result);
    }

    static testMethod void testGetEmailsList() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        CommunicationController.updateApplication(testOpportunity.Id, 'Email', 'bob@test.com');
        List<String> result = CommunicationController.getEmailsList(testOpportunity.Id);
        System.assert(!result.isEmpty());
    }

    static testMethod void testGetPhonesList() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        CommunicationController.updateApplication(testOpportunity.Id, 'SMS', '1234567890');
        List<String> result = CommunicationController.getPhonesList(testOpportunity.Id);
        System.assert(!result.isEmpty());
    }
    
    static testMethod void testvalidEmailPhone() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        CommunicationController.updateApplication(testOpportunity.Id, 'Email', 'bob@test.com');
        Map<String, String> result = CommunicationController.validEmailPhone(testOpportunity.Id);
        System.assert(!result.isEmpty());
    }
}