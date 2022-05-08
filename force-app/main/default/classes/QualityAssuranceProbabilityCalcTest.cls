/**
* Test class for QualityAssuranceProbabilityCalculator
* @author  Kyle Alexander
* @created 2018-07-26
*/

@IsTest
public class QualityAssuranceProbabilityCalcTest {
    public static testMethod void testQualityAssuranceProbabilityCalculatorPositive(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        User user = [select Id, Business_Area__c from User where Id = :UserInfo.getUserId()];
        user.Business_Area__c = 'Virtual Advisor';

        Test.startTest();

        //Successful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Successful');

        //Unsuccessful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Unsuccessful');

        Test.stopTest();
    }

    public static testMethod void testQualityAssuranceProbabilityCalculatorInvalidBusinessArea(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        User user = [select Id, Business_Area__c from User where Id = :UserInfo.getUserId()];
        user.Business_Area__c = 'Not Valid Business Area';

        Test.startTest();

        //Successful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Successful');

        //Unsuccessful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Unsuccessful');

        Test.stopTest();
    }

    public static testMethod void testQualityAssuranceProbabilityCalculatorNullBusinessArea(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        User user = [select Id, Business_Area__c from User where Id = :UserInfo.getUserId()];
        user.Business_Area__c = null;

        Test.startTest();

        //Successful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Successful');

        //Unsuccessful
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(testDataFactory.testOpportunity, user, 'Unsuccessful');

        Test.stopTest();
    }
}