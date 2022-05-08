/**
 * @description Test class for ApplicationFinancialAccountSelector
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-17
 **/
@IsTest
public class ApplicationFinancialAccountSelectorTest{
    /**
     * @description dataCreation description
     *
     */
    @testSetup
    public static void dataCreation(){
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
     * @description testGetSObjectType description
     *
     */
    @isTest
    public static void testGetSObjectType(){
        System.assert(new ApplicationFinancialAccountSelector().getSObjectType() != null);
    }

    @isTest
    static void testGetSObjectFieldList(){
        System.assert(new ApplicationFinancialAccountSelector().getSObjectFieldList() != null);
    }

    @isTest
    static void testSelectByIdSet(){
        Application__c app = [SELECT Id, Name
                              FROM Application__c
                              WHERE SurnameSignature__c = 'Rob Van Wyk'
                              LIMIT 1];
        Application_Financial_Account__c appFin = new ApplicationFinancialAccountSelector().selectByApplicationId(app.Id)[0];
        Set<ID> idSet = new Set<ID>();
        idSet.add(appFin.Id);
        System.assert(new ApplicationFinancialAccountSelector().selectByIdSet(idSet) != null);
    }

    @isTest
    static void testSelectByApplicationId(){
        Application__c app = [SELECT Id, Name
                              FROM Application__c
                              WHERE SurnameSignature__c = 'Rob Van Wyk'
                              LIMIT 1];
        System.assert(new ApplicationFinancialAccountSelector().selectByApplicationId(app.Id) != null);
    }

    @isTest
    static void testSelectApplicationFinancialById(){
        Application__c app = [SELECT Id, Name
                              FROM Application__c
                              WHERE SurnameSignature__c = 'Rob Van Wyk'
                              LIMIT 1];
        Application_Financial_Account__c appFinAcc = new ApplicationFinancialAccountSelector().selectByApplicationId(app.Id)[0];
        System.assert(new ApplicationFinancialAccountSelector().selectApplicationFinancialById(appFinAcc.Id) != null);
    }

    @isTest
    static void testSelectAppFinAccByAppPrdctCpf(){
        Application__c app = [SELECT Id, Name
                              FROM Application__c where SurnameSignature__c = 'Rob Van Wyk'
                              LIMIT 1];
        Application_Product_CPF__c appPrdctcpf = new Application_Product_CPF__c();
        appPrdctcpf.Application__c = app.Id;
        insert appPrdctcpf;
        Application_Financial_Account__c appFinAcc = [SELECT Id, Name
                              FROM Application_Financial_Account__c
                              LIMIT 1];
        appFinAcc.Application_Product_CPF__c = appPrdctcpf.Id;
        update appFinAcc;
        list<Application_Financial_Account__c> lappfinAccList = new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctcpf.Id);
        System.assert(new ApplicationFinancialAccountSelector().selectByApplicationIdEBR(app.Id, 'Test External Relation') != null, 'not null');
    }
}