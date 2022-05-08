/*
 * MLStatementOnDemandControllerTest class for MLStatementOnDemandController
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-03
 * @W-
 */

@isTest
public class MLStatementOnDemandControllerTest {
    @testSetup
    static void setup() {
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        Account acc = new Account();
        acc.name = 'test acc';
        acc.CIF__c = 'HJKLL';
        insert acc;

        Contact testContact = new Contact(LastName = 'Test contact', Email = 'Test@test.com');
        insert testContact;

        Case cse = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = acc.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email__c = 'test@test.com',
            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
            Subject = 'test',
            Description = 'test',
            Expectation_of_the_Customer__c = 'test',
            Incident_Date__c = date.today(),
            Type__c = 'Type__c',
            Out_Of_SLA_Reason__c = 'Account Closed',
            Out_Of_SLA_Comments__c = 'Out_Of_SLA_Comments__c'
        );
        insert cse;

        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ MLRetrieveOnDemandStatement_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @isTest
    static void getStatementOnDemandPositiveTest() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLRetrieveOnDemandStatement_v1';
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Case cse = [SELECT Id FROM Case WHERE Subject = 'test' LIMIT 1];

        Test.startTest();
        String status = MLStatementOnDemandController.getStatementOnDemand(23, 3, '8057676092', 'test@absa.africa', cse.Id, 'MLOnDemandStatements', 'test');
        System.assertEquals('success', status);
        Test.stopTest();
    }

    @isTest
    static void getStatementOnDemandNegativeTest() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLRetrieveOnDemandStatement_v1';
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.NEGATIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Case cse = [SELECT Id FROM Case WHERE Subject = 'test' LIMIT 1];

        Test.startTest();
        String status = MLStatementOnDemandController.getStatementOnDemand(23, 3, '8057676092', 'test@absa.africa', cse.Id, 'MLOnDemandStatements', 'test');
        System.assertNotEquals('success', status);
        Test.stopTest();
    }

    @IsTest
    static void caseStatusUpdateTest() {
        Case cse = [SELECT Id FROM Case WHERE Subject = 'test' LIMIT 1];
        Test.startTest();
        String status = MLStatementOnDemandController.caseStatusUpdate(cse.Id);
        System.assertEquals('success', status);
        Test.stopTest();
    }

    @IsTest
    static void caseStatusUpdateExceptionTest() {
        Case cse = [SELECT Id FROM Case WHERE Subject = 'test' LIMIT 1];
        cse.Type__c = null;
        cse.Out_Of_SLA_Reason__c = null;
        cse.Out_Of_SLA_Comments__c = null;
        update cse;

        Test.startTest();
        String status = MLStatementOnDemandController.caseStatusUpdate(cse.Id);
        System.assertNotEquals('success', status);
        Test.stopTest();
    }
}