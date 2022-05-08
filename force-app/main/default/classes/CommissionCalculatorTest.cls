/**
* Test class for CommissionCalculator
* @author  Kyle Alexander
* @created 2018-07-09
*/

@IsTest
public class CommissionCalculatorTest {
    public static testMethod void testCommissionCalculatorPositiveValidValues(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Test.startTest();

        CommissionCalculator.CommissionRequest commissionRequest = new CommissionCalculator.CommissionRequest();
        commissionRequest.opportunityId = testDataFactory.testOpportunity.Id;
        commissionRequest.dateOfBirth = testDataFactory.testAccount.PersonBirthdate;
        commissionRequest.dateOfCommencement = Date.valueOf('2018-07-09');
        commissionRequest.executorFeePremium = 100.50;
        commissionRequest.estateBridgingPremium = 50.25;
        commissionRequest.familyFuneralPremium = 30.00;
        commissionRequest.policyFee = 10.00;

        List<CommissionCalculator.CommissionRequest> requests = new List<CommissionCalculator.CommissionRequest>();
        requests.add(commissionRequest);

        CommissionCalculator.calculateCommission(requests);

        Test.stopTest();
    }
    
    public static testMethod void testCommissionCalculatorPositiveInvalidValues(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Test.startTest();

        CommissionCalculator.CommissionRequest commissionRequest = new CommissionCalculator.CommissionRequest();
        commissionRequest.opportunityId = testDataFactory.testOpportunity.Id;
        commissionRequest.dateOfBirth = testDataFactory.testAccount.PersonBirthdate;
        commissionRequest.dateOfCommencement = Date.valueOf('2018-07-09');
        commissionRequest.executorFeePremium = null;
        commissionRequest.estateBridgingPremium = null;
        commissionRequest.familyFuneralPremium = null;
        commissionRequest.policyFee = null;

        List<CommissionCalculator.CommissionRequest> requests = new List<CommissionCalculator.CommissionRequest>();
        requests.add(commissionRequest);

        CommissionCalculator.calculateCommission(requests);

        Test.stopTest();
    }
}