/**
 * @description       : Test Class for the Selector layer for ProductContactSignatoryRelationship__c objects
 * @author            : Tinashe M Shoko
 * @last modified on  : 2021-09-07
 * @last modified by  : Manish.battu@absa.africa
**/
@IsTest
public with sharing class ProdContactSignatoryRelshipsSelectorTest {
    @IsTest static void testSelectById() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        System.assertNotEquals(null, new ProductContactSignatoryRelshipsSelector().selectByAccountContactRelationshipId(testDatafactory.testAccountContactRelation.Id));
        System.assertNotEquals(null, new ProductContactSignatoryRelshipsSelector().selectByPrimaryAccountId(testDatafactory.testAccount.Id));
        System.assertNotEquals(null, new ProductContactSignatoryRelshipsSelector().selectByOpportunityProductId(testDatafactory.testOppLineItem.Id));
        System.assertNotEquals(null, new ProductContactSignatoryRelshipsSelector().selectByPrimaryAccountIds(new Set<Id>{testDatafactory.testAccount.Id}));
        test.stopTest();
    }
}