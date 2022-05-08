// @author Himani Joshi: 03-09-2020
@IsTest
public class MerchantMCCHighRiskCheckTest {
    static testMethod void testGetHighRiskMCCs() {
        Test.startTest();
        System.assertNotEquals(null, MerchantMCCHighRiskCheck.getHighRiskMCCs());
        Test.stopTest();
    }
}