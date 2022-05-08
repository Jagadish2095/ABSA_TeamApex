/**
 * @description       : Test Class for entity creation in credit lens
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 12-08-2021
 * @last modified by  : Tawanda M.
**/
@isTest
public class CreditLens_CreateEntity_Test {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ 'EntityCreate' }
        );
    }

    @isTest
    public static void testEntityCreationValidAccountWithSic(){
        Account acc = new Account();
        acc.Name = 'Tawanda Testers';
        acc.CIF__c = 'AB997FF';
        acc.Client_Type__c = 'Private Company';
        acc.Sic = '12345';
        Insert acc;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreditLens_CreateEntity_Mock('Passed'));
        Integer entityId = CreditLens_CreateEntity.createEntity(acc.CIF__c);
        System.assertEquals(35, entityId);
        Test.stopTest();
    }

    @isTest
    public static void testEntityCreationValidAccountWithSicMapping(){
        Account acc = new Account();
        acc.Name = 'Tawanda Testers';
        acc.CIF__c = 'AB997FF';
        acc.Client_Type__c = 'Private Company';
        acc.Standard_Industry_SIC_Code__c = 'Activities of attorneys, notaries and conveyancers';
        Insert acc;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreditLens_CreateEntity_Mock('Passed'));
        Integer entityId = CreditLens_CreateEntity.createEntity(acc.CIF__c);
        System.assertEquals(35, entityId);
        Test.stopTest();
    }

    @isTest
    public static void testEntityCreationNoValidAccount(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreditLens_CreateEntity_Mock('Passed'));
        try{
            Integer entityId = CreditLens_CreateEntity.createEntity('imaginary');
            System.assertEquals(35, entityId);
        }
        catch(Exception e){
            System.assertEquals('There are no accounts on Customer One with this CIF number: imaginary', e.getMessage());
        }
        Test.stopTest();
    }
}