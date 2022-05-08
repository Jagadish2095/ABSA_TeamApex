/**
 * @description Test Class for ControllingInterestsSelector
 *
 * @author  Tracy de Bruin
 * @since   July 2021
 */ 
@isTest 
private class ControllingInterestsSelectorTest {

    @TestSetup
    static void makeData(){
        
        Controlling_Interest__c intrestTest = new Controlling_Interest__c();
        intrestTest.UBO__c = 'Yes';
        intrestTest.Primary_Entity__c = null;
        insert intrestTest;

    }

    @isTest
    private static void testGetByClientType() {   
        Controlling_Interest__c controlIntrRec = [SELECT id, ubo__c, Primary_Entity__c
                                                 FROM Controlling_Interest__c
                                                 LIMIT 1];
        List<Controlling_Interest__c> controllingIntrest = new ControllingInterestsSelector().getByPrimaryAndUBO(controlIntrRec.Primary_Entity__c, controlIntrRec.UBO__c);
        List<Controlling_Interest__c> controllingIntrest2 = new ControllingInterestsSelector().getByPrimary(controlIntrRec.Primary_Entity__c);
        System.assert(controllingIntrest.size() > 0);
    }

}