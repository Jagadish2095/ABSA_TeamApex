/*
 * AVAFPreValidAndSendLetterControllerTest class for AVAFPreValidAndSendLetterController
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-17
 * @W-006962
 */

@isTest
public class AVAFPreValidAndSendLetterControllerTest {
    @isTest
    static void preValidateAccountInfoTest() {
        // Set mock callout class
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFPreValidationService_v1';
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        Test.startTest();
        AVAFPreValidationService_Resp_IB_v1 responseBean = AVAFPreValidAndSendLetterController.preValidateAccountInfo(75666239);
        Test.stopTest();
    }

    @IsTest
    static void caseStatusUpdateTest() {
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        Account acc = new Account();
        acc.name = 'test acc';
        acc.CIF__c = 'HJKLL';
        insert acc;

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
            Incident_Date__c = date.today()
        );
        insert cse;
        Test.startTest();
        AVAFPreValidAndSendLetterController.caseStatusUpdate(cse.Id);
        Test.stopTest();
    }
}