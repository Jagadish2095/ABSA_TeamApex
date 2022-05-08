/**
* @description       :Test class for SalesProcessTypesSelector
* @author            : Saurabh
* @last modified on  : 2021-06-11
* @last modified by  : Saurabh
* Modifications Log
* Ver   Date         Author    Modification
* 1.0   2021-06-11   Saurabh   Initial Version
**/
@isTest
public with sharing class SalesProcessTypesSelectorTest {
    @isTest
    static  void testGetSObjectType() {
        test.startTest();
        System.assert(new SalesProcessTypesSelector().getSObjectType() != null);
        test.stopTest();
    }
    @isTest
    static void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new SalesProcessTypesSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    @isTest
    static void testAllMethods() {
        test.startTest();
        Set<Id> idSet = new Set<Id>();
        //Inserting a test Record not sure if test factory exists
          Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'Onboard New Product Everyday Banking Test',
            Sales_Process__c = 'Physical Channels Process',
            Opportunity_Record_Type__c = 'Credit Onboarding',
            Request_Name__c = 'New Credit Product');
        insert salesProcessType;
        idSet.add(salesProcessType.Id);
        System.assert(new SalesProcessTypesSelector().selectById(idSet) != null);
        System.assert(new SalesProcessTypesSelector().selectByRequestName('New Credit Product') != null);
        test.stopTest();
    }
    
}