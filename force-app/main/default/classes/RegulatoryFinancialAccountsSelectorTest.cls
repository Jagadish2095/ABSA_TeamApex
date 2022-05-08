/**
 * @description       : Selector Layer for Regulatory_Financial_Account__c objects
 * @author            : Tracy de Bruin - CloudSmiths
 * @last modified on  : 2021-11-09
 * @last modified by  :Tracy de Bruin - CloudSmiths
**/

@isTest 
public class RegulatoryFinancialAccountsSelectorTest {
    /**
    * @description 
    * @author Tracy de Bruin - CloudSmiths
    **/
	@TestSetup
    static void makeData(){
        
        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
        Regulatory_Financial_Account__c productRecord = new Regulatory_Financial_Account__c();
        productRecord.account__c = pricingTestDataFactory.account.Id;
        productRecord.Account_Number__c = '1234567890';
        productRecord.Product_Type__c = 'CO';
        insert productRecord;
        
    }

    @isTest
    private static void testSelectById() {        
        Regulatory_Financial_Account__c regulatoryFinancialAccount = [SELECT Id FROM Regulatory_Financial_Account__c LIMIT 1];
        Set<Id> IdSet = new Set<Id>();
        IdSet.add(regulatoryFinancialAccount.Id);
        List<Regulatory_Financial_Account__c> regulatoryFinancialAccountLst = new RegulatoryFinancialAccountsSelector().selectById(IdSet);
        System.assertEquals(regulatoryFinancialAccountLst.size(), 1);
    }

    @isTest
    private static void testSelectByParentProductId() {
        Regulatory_Financial_Account__c regulatoryFinancialAccount = [SELECT Id, Account__c FROM Regulatory_Financial_Account__c LIMIT 1];
        List<Regulatory_Financial_Account__c> regulatoryFinancialAccountLst = new RegulatoryFinancialAccountsSelector().selectByAccountId(regulatoryFinancialAccount.Account__c);
        System.assert(regulatoryFinancialAccountLst.size() > 0); 
    }
}