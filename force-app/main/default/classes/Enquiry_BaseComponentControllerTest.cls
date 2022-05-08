/**
* @description
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@isTest
public with sharing class Enquiry_BaseComponentControllerTest {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-27
    **/
    @isTest
    static void closeCaseTest() {
        Account testAccount = new Account();
        testAccount.firstName = 'ICM';
        testAccount.lastName = 'ICM';
        testAccount.Active_Email__c = 'ICM@asd.com';
        testAccount.lastName = 'ICM';
        Insert testAccount;

        Case testCase = new Case();
        testCase.Type = 'ICM';
        testCase.Accountid = testAccount.Id;
        testCase.Origin = 'SHIP';
        testCase.Status = 'New';
        testCase.Type = 'ICM';
        testCase.Type__c = 'Service Request';
        Insert testCase;

        Test.startTest();

        Enquiry_BaseComponentController.closeCase(testCase.Id);

        Test.stopTest();

        System.assertEquals('Closed', [SELECT Status FROM Case WHERE id = :testCase.Id].Status, 'closeCaseTest');
    }
}