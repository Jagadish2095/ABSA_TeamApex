/**
 * @description Test Class for Locate Call Controller
 *
 * @author  Englarmerge Mongwe
 * @version v1.0n
 * @since   2021-01-08
 * @UserStory W-007000
 *
 */

@IsTest
public class LocateCallControllerTest {

    /**
     * @description data creation for test methods
     * @author englarmerdge.mongwe@absa.africa | 2021-06-08
    **/
    @TestSetup
    public static void dataCreation() {
        Account testAccount = new Account();
        testAccount.Registration_Number__c = null;
        testAccount.Company_Registration_Number__c = null;
		testAccount.CASA_Reference_Number__c = '1712994';
		testAccount.CASA_Risk_Status__c = 'Low';
		testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		testAccount.CASA_Screening_Status__c = 'Approved';
		testAccount.CASA_Analyst_Comments__c = '30406';
		testAccount.Name = 'EXPERIAN';
		testAccount.Client_Type__c = 'Company';
		testAccount.Phone = '0114453322';
		testAccount.CIF__c = 'AFIFTAP001';
		testAccount.Date_Established__c = System.today();
        insert testAccount;

        //Opportunity
        Opportunity testOpportunity = new Opportunity();
		testOpportunity.Name = 'Cheque Credit Onboarding';
		testOpportunity.AccountId = testAccount.Id;
		testOpportunity.Spouse_Account_Id__c = String.valueOf(testAccount.Id);
		testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId();
		testOpportunity.StageName = 'New';
		testOpportunity.CloseDate = Date.today()+10;
		testOpportunity.Illustrative_Decision__c = true;
		insert testOpportunity;

		//Application__c
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testOpportunity.Id;
		testApplication.Preferred_Communication_Method__c = 'test@absa.africa';
		testApplication.Preferred_SMS__c = '1111111';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Products_And_Services__c = 'NotifyMe';
		insert testApplication;

        Id appId = testApplication.Id;

        Application_Principal__c testAppPrinc = new Application_Principal__c();
		testAppPrinc.Application__c = appId;
        testAppPrinc.Principal_Shareholder_Name__c = 'SOUTH AFRICAN COMPENSATORS (PTY) LTD';
		testAppPrinc.Casa_Reference__c = '12345';
		testAppPrinc.Casa_Result__c = 'Approved';
		testAppPrinc.CIF__c = 'AFIFTAP003';
		testAppPrinc.Controlling_Interest__c = 10;
		testAppPrinc.Id_Number__c = null;
		testAppPrinc.Main__c = true;
        insert testAppPrinc;

        List<Application_Profile__c> testAppProfList = new List<Application_Profile__c>();
		Application_Profile__c testAppProf = new Application_Profile__c();
        testAppProf.Application__c = appId;
		testAppProf.Applicant_Type__c = 'Main Applicant';
		testAppProf.Client_Name__c = testAccount.Name;
		testAppProf.Client_CIF_Code__c = testAccount.CIF__c;
		testAppProf.Related_to_Client_ID_or_Reg_Number__c = testAccount.Registration_Number__c;
        testAppProfList.Add(testAppProf);

        testAppProf = new Application_Profile__c();
		testAppProf.Application__c = appId;
		testAppProf.Applicant_Type__c = 'Principal';
		testAppProf.Client_Name__c = testAppPrinc.Principal_Shareholder_Name__c;
		testAppProf.Client_CIF_Code__c = testAppPrinc.CIF__c;
		testAppProf.Related_to_Client_ID_or_Reg_Number__c = testAppPrinc.Id_Number__c;
		testAppProfList.Add(testAppProf);
        insert testAppProfList;

        IntegrationTestDataFactory.insertIntegrationSettings(BusinessTrace_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{BusinessTrace_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(PowerCurveNewApplication_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{PowerCurveNewApplication_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(PowerCurveUpdateApplication_IH_v1.INTEGRATION_SERVICE_NAME, new List<String>{PowerCurveUpdateApplication_IH_v1.INTEGRATION_SERVICE_NAME});
    }

 	/**
 	 * @description test all use cases for Locate Call Controller
 	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
 	**/
	@IsTest
 	public static void testAllLocateMethods() {
        BusinessTrace_IH_v1_Test.businessTraceTestMock();
        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        Application_Principal__c prin = [SELECT Id, Principal_Shareholder_Name__c FROM Application_Principal__c LIMIT 1];

        String kIMNumberDetail = '[{"CompanyName":"'+ acc.Name +'","KIMNumberOrNoMatch":"5835437"},{"CompanyName":"'+ prin.Principal_Shareholder_Name__c +'","KIMNumberOrNoMatch":"'+ prin.Principal_Shareholder_Name__c +'"}]';

        Test.startTest();
        LocateCallController.LocateCall lccList = new LocateCallController.LocateCall();
        System.assert((LocateCallController.getBusinessTraceData(opp.Id) != null), true);
        System.assert((LocateCallController.saveBusinessTraceData(opp.Id, KIMNumberDetail) == null), true);
        Test.stopTest();
    }
}