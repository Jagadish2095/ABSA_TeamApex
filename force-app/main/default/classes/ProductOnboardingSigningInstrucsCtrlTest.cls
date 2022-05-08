/*
Controller Test Class For ProductOnboardingSigningInstructionsCtrl class
*
* @author  Tinashe Mutsungi Shoko : Jordiflash
* @version v2.0
* @since   2020-04-02
*/
@isTest
public with sharing class ProductOnboardingSigningInstrucsCtrlTest {
    @isTest
    public static void ProductOnboardingSigningInstrucsCtrlTest(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        OpportunityLineItem oppLineItem = ProductOnboardingSigningInstructionsCtrl.getOpportunityProduct(testDataFactory.testOpportunity.Id);
        System.assertNotEquals(null, oppLineItem);
        Test.stopTest();
    }
}