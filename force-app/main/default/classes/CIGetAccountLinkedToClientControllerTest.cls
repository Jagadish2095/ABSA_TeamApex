/**
*@description Controller Test Class For XDS Controller class
*
* @author  Manoj Danthala : Absa
* @version v1.0
* @since   2019-09-24
*/
@isTest
public class CIGetAccountLinkedToClientControllerTest {
    @testSetup
    static void dataCreation() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ BAPISFAccntDescr_IH_v1.INTEGRATION_SERVICE_NAME }
		);
    }

    @isTest
    public static void testCIGetAccount() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc = 'SA Identity Document';
        accountList[0].ID_Number__pc = '8505225522085';
        accountList[0].CIF__c = 'ARENTAL001';
        insert accountList;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
        );

        Test.startTest();
        String responseBean = CIGetAccountLinkedToClientCodeController.getAccountDetails(accountList[0].Id);
        System.assert(responseBean.startsWith('['), 'Assert Failed');
        Test.stopTest();
    }

    @isTest
    public static void testCIGetAccountNoAccountWithId() {
        Test.startTest();
        String responseBean = CIGetAccountLinkedToClientCodeController.getAccountDetails(null);
        System.assert(responseBean.startsWith('Error') , 'Assert Failed');
        Test.stopTest();
    }

    @isTest
    public static void testCIGetAccountNoIntegrationService() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc = 'SA Identity Document';
        accountList[0].ID_Number__pc = '8505225522085';
        accountList[0].CIF__c = 'ARENTAL001';
        insert accountList;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.startTest();
        String responseBean = CIGetAccountLinkedToClientCodeController.getAccountDetails(accountList[0].Id);
        System.assert(responseBean.startsWith('Error'), 'Assert Failed');
        Test.stopTest();
    }

    @isTest
    public static void testEmailNotifications() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        Account account = [SELECT Id FROM Account LIMIT 1];
        EmailTemplate eTemplate = [SELECT Id, Name FROM EmailTemplate LIMIT 1];
        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email_From_Address__c = 'test@ret.com',
            Email__c = 'test@ret.com',
            Incident_Date__c = System.Today(),
            RecordTypeId = caseRecordTypeId,
            Approval_Status__c = 'Approved',
            SLA_Extension_Approval__c = 'Approved',
            Expectation_of_the_Customer__c = 'Testing',
            Awaiting_Status__c = 'Awaiting Customer Documents',
            SLA_Extension_Reason__c = 'This is for testing',
            SLA_Extension_Approval_Required__c = true,
            Deadlock_Reason_Motivation__c = 'Sample test',
            Subject = 'Test',
            Description = 'Test',
            Deadlock_Approval_Required__c = true,
            sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback',
            Type__c = 'Test',
            sd_Email_Template_Case_Classification__c = eTemplate.Name
        );
        insert caseRec;
        caseRec.Out_Of_SLA_Comments__c = 'Testt';
        caseRec.SLA_Pause_Flag__c = true;
        update caseRec;

        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        insert caseList;
        CIGetAccountLinkedToClientCodeController.sendEmailNotifications('1234', '9000', caseRec.Id, 'manoj.danthala@absa.africa', '0745008199', 'SMS');

        System.assertEquals(1, caseList.size(), 'Assert failed');
    }

    @isTest
    public static void testGetAccountDescriptions() {
        String accounts = '["00090274692","00074685337","00074685345"]';

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				BAPISFAccntDescr_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = CIGetAccountLinkedToClientCodeController.getAccountDescriptions(accounts);
		Test.stopTest();

		System.assert(response.startsWith('[{'), 'Assert failed');

    }

}