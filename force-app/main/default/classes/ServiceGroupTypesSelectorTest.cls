/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-06-14
 * @last modified by  : sive.kula@absa.africa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-05-27   Sandeep Golla   Initial Version
**/

@isTest
private class ServiceGroupTypesSelectorTest {

    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        Service_Type__c tstServT = new Service_Type__c();
        insert tstServT;

        Service_Group__c tstServQ = new Service_Group__c();
        insert tstServQ;

        Service_Level__c tstServL = new Service_Level__c();
        tstServL.Default_Service_Level__c = true;
        insert tstServL;

        Service_Group_Type__c tstServQT = new Service_Group_Type__c();
        tstServQT.Service_type__c = tstServT.Id;
        tstServQT.Service_Group__c = tstServQ.Id;
        tstServQT.Service_Level__c = tstServL.Id;
        tstServQT.Flow__c = 'XDS_Only';
        insert tstServQT;
    }

    @isTest
    private static void testSelectById() {
        Service_Group_Type__c tstServQT = [SELECT Id FROM Service_Group_Type__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstServQT.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectById(tstSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void testSelectByServiceTypeId() {
        Service_Type__c tstServT = [SELECT Id FROM Service_Type__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstServT.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceTypeId(tstSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void testSelectByServiceTypeIdWithParentFields() {
        Service_Type__c tstServT = [SELECT Id FROM Service_Type__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstServT.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceTypeIdWithParentFields(tstSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void testSelectByServiceTypeWithGroupAndServiceInfo() {
        Service_Type__c tstServT = [SELECT Id FROM Service_Type__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstServT.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceTypeWithGroupAndServiceInfo(idSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void selectByServiceTypeAndServiceGroupWithRelatedInfo() {
        Service_Type__c tstServT = [SELECT Id FROM Service_Type__c LIMIT 1];
        Service_Group__c tstServQ = [SELECT Id FROM Service_Group__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceTypeAndServiceGroupWithRelatedInfo(tstServQ.Id, tstServT.Id);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void selectByServiceGroupWithServiceLevelInfo() {
        Service_Group__c tstServQ = [SELECT Id FROM Service_Group__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstServQ.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceGroupWithServiceLevelInfo(idSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void selectByServiceGroupWithServiceLevelInfoForManual() {
        Service_Group__c tstServQ = [SELECT Id FROM Service_Group__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstServQ.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceGroupWithServiceLevelInfoForManual(idSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void selectByServiceGroupWithGroupAndServiceInfo() {
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];


        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstServQ.Id);
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceGroupWithGroupAndServiceInfo(idSet);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);

    }
    @isTest
    private static void testgetServiceTypeWithServiceGroupAndServiceLimitInfoForOnboarding() {
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];

        List<String> serviceGroups = new List<String>();
        serviceGroups.add(tstServQ.Name);

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.getServiceTypeWithServiceGroupAndServiceLimitInfoForOnboarding(true, 'test', serviceGroups);
        Test.stopTest();
        System.assertNotEquals(grps.size(), 10);
    }

    @isTest
    private static void testgetServiceTypeWithServiceGroupAndServiceLimitInfo() {
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];

        List<String> serviceGroups = new List<String>();
        serviceGroups.add(tstServQ.Name);

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.getServiceTypeWithServiceGroupAndServiceLimitInfo(true, 'test', serviceGroups);
        Test.stopTest();
        System.assertNotEquals(grps.size(), 10);
    }

    @isTest
    private static void testselectByServiceGrpTypeId() {
        Service_Group_Type__c tstServQT = [SELECT Id FROM Service_Group_Type__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        Service_Group_Type__c grp = sqs.selectByServiceGrpTypeId(tstServQT.Id);
        Test.stopTest();
        System.assertNotEquals(grp.Id, null);
    }

    @isTest
    private static void testselectByLeadProductBusinessUnitNames() {
        Set<String> bunames = new Set<String>();
        bunames.add('testUnit');

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByLeadProductBusinessUnitNames(bunames);
        Test.stopTest();
        System.assertNotEquals(grps.size(), 10);
    }

    @isTest
    private static void testselectByServiceGroupNameAndServiceTypeName() {
        Service_Type__c tstServT = [SELECT Id, Name FROM Service_Type__c LIMIT 1];
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.selectByServiceGroupNameAndServiceTypeName(tstServQ.Name, tstServT.Name);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void testgetProductsByServiceGroupId() {
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];

        ServiceGroupTypesSelector sqs = new ServiceGroupTypesSelector();
        Test.startTest();
        List<Service_Group_Type__c> grps = sqs.getProductsByServiceGroupId(tstServQ.Id);
        Test.stopTest();
        System.assertEquals(grps.size(), 1);
    }

    @isTest
    private static void selectByServiceGroupNamesWithServiceTypeAndServiceLevel() {
        Service_Group__c tstServQ = [SELECT Id, Name FROM Service_Group__c LIMIT 1];

        Set<String> serviceGroupNames = new Set<String>();
        serviceGroupNames.add(tstServQ.Name);

        Test.startTest();
            List<Service_Group_Type__c> sgt = new ServiceGroupTypesSelector().selectByServiceGroupNamesWithServiceTypeAndServiceLevel( serviceGroupNames );
        Test.stopTest();

        System.assertEquals(sgt.size(), 1);
    }
}