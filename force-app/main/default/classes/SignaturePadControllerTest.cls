/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-08
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SignaturePadControllerTest {
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-08 
    **/
    @isTest public static void testLoadRelatedData(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Id oppId = testDataFactory.testOpportunity.id;
        Test.startTest();
        SignaturePadController.loadrelatedData(oppId);
        System.assertNotEquals(oppId,null);
        Test.stopTest();
    }
        /**
        * @description 
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-08 
        **/
        @isTest public static void testSaveSignature(){
            
        Address__c add = new Address__c();
        add.Address1__c = '130 Blue Apt';
        add.Address2__c = 'Green Street';
        add.Address3__c = 'Sandton';
        add.Address4__c = 'Gauteng';
        add.Address5__c =  '2001';
            
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testContact.Date_Issued__c  = system.today();
        testDataFactory.testContact.birthDate  = system.today();
        update testDataFactory.testContact;
        Id oppId = testDataFactory.testOpportunity.id;
        Id conId = testDataFactory.testContact.id;
        String conName = testDataFactory.testContact.Name;
        add.Contact__c = conId;
        Insert add;
        String signBody  = 'ggydweyfufd3qyf236he2djwbhdbewqf';
        Test.startTest();
        SignaturePadController.saveSignature(signBody,oppId,conId,conName);
        System.assertNotEquals(oppId,null);
        Test.stopTest();
    }
    
    
    
    
    
    
}