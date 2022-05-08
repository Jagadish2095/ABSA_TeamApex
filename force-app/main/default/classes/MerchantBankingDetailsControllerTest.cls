@isTest
public class MerchantBankingDetailsControllerTest {

    static testMethod void testCheckBankAccount(){
        Boolean testResult = MerchantBankingDetailsController.checkBankAccount('4048075451', '632005', 'Cheque');
        System.assertEquals(false, testResult);
    }

    static testMethod void testGetSelectOptions(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<String> testList = MerchantBankingDetailsController.getSelectOptions(testDataFactory.testPaymentPlan, 'Account_Type__c');
        System.assertNotEquals(null, testList);
    }

    static testMethod void testSubmitPaymentPlanDetail(){
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        MerchantBankingDetailsController.submitPaymentPlanDetail(testOpportunity.Id, '1573017159', 'Cheque', 'NEDBANK', '157342', 'PHUMULANI MALL TEMBIS (157342)', 'Cheque - 1573017159', 'Merchant Product', 'New', 'Personal Bank');
        Payment_Plan__c testPPInsert = [SELECT Id FROM Payment_Plan__c];
        System.debug('testPPInsert: ' + testPPInsert);
        System.assertNotEquals(null, testPPInsert);

        MerchantBankingDetailsController.submitPaymentPlanDetail(testOpportunity.Id, '1573017159', 'Cheque', 'NEDBANK', '157342', 'PHUMULANI MALL TEMBIS (157342)', 'Cheque - 1573017159', 'Merchant Product', 'New', 'Personal Bank');
        Payment_Plan__c testPPUpdate = [SELECT Id FROM Payment_Plan__c];
        System.debug('testPPUpdate: ' + testPPUpdate);
        System.assertEquals(testPPInsert.Id, testPPUpdate.Id);
    }

    static testMethod void testGetBankAccountDetails(){
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Map<String, Payment_Plan__c> paymentPlanMap  = MerchantBankingDetailsController.getBankAccountDetails(testOpportunity.Id, 'Will Safe Custody Fee');
        System.assertNotEquals(null, paymentPlanMap);
    }

    static testMethod void testGetApplication(){
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Application__c application  = MerchantBankingDetailsController.getApplication(testOpportunity.Id);
        System.assertNotEquals(null, application);
    }
}