/**
 * @description       : Test class for ApplicationExposureSelector class
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-12
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-09   Himani Joshi   Initial Version
 * * @update Englarmerdge Mongwe
 * @dateUpdated 2020-10-26
 * Added Test case for getApplicationExposureByClientName, getApplicationExposureProduct,
 * getApplicationExposureProductTypeTotal, getAllApplicationExposureSummary Methods
 * 
**/

@IsTest
private class ApplicationExposureSelectorTest {
    @testSetup static void createData() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    @IsTest public static void testGetSObjects() {
        Test.startTest();
        System.assert(new ApplicationExposureSelector().getSObjectType() != null);
        System.assert(new ApplicationExposureSelector().getSObjectFieldList() != null);
        Test.stopTest();
    }

    @IsTest public static  void testGetApplicationExposure() {
        Application__c app =[SELECT Id FROM Application__c LIMIT 1];
        String clientCode ='AABK 007';
        Test.startTest();
        System.assert(new ApplicationExposureSelector().getApplicationExposure(clientCode,app.Id) != null);
        Test.stopTest();
    }

    @IsTest public static void testGetAllOtherApplicationExposure() {
        Application__c app = [SELECT Id FROM Application__c LIMIT 1];
        Test.startTest();
        System.assert(new ApplicationExposureSelector().getAllApplicationExposure(app.Id) != null);
        System.assert(new ApplicationExposureSelector().getApplicationExposureProduct(app.Id) != null);
        System.assert(new ApplicationExposureSelector().getApplicationExposureProductTypeTotal(app.Id) != null);
        System.assert(new ApplicationExposureSelector().getAllApplicationExposureSummary(app.Id) != null);
        Test.stopTest();
    }

    @IsTest public static void testGetApplicationExposureByClientName() {
        Application__c app = [SELECT Id FROM Application__c LIMIT 1];
        String clientName ='REBELLO001';
        Test.startTest();
        System.assert(new ApplicationExposureSelector().getApplicationExposureByClientName(clientName, app.Id) != null);
        Test.stopTest();
    }
}