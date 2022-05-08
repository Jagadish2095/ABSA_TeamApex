/*
 Controller Test Class For OnboardingIndividualDetailsController class for Deployment
 *
 * @author  Tracy de Bruin : Cloudsmiths 
 * @version v1.0
 * @since   2020-03-02
 */
@isTest
public class OnboardingIndividualDetailsContrTest{
	@testSetup
	static void dataCreation(){
		Account account = new Account(Name = 'Test Account');
		account.UBO_ParentAccountWrapper__c = '[{"Type":"PrivateCompany","ShareholderCount":4,"Shareholder":"LONDANICOAL(PTY)LTD","recordId":"0015r00000HvTN3AAN","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"CentralBankorRegulator","ShareholderCount":3,"Shareholder":"PINEAPPLECENTRALBANKANDREG","roles":"Director;IndividualwithAuthoritytoAct;Shareholder/Controller","relatedAccountId":"0015r00000HJk9qAAD","recordId":"a005r000001uMlTAAU","primaryEntityId":"0015r00000HvTN3AAN","ParentShareholding":20.00,"parentAccountId":"0015r00000HvTN3AAN","idType":"RegistrationNumber","Controllinginterest":20.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FANTAFANTA","roles":"Director;Shareholder/Controller;ContactPerson","relatedAccountId":"0035r00000EccagAAB","recordId":"07k5r000004DDDBAA4","primaryEntityId":"0015r00000HJk9qAAD","ParentShareholding":60.00,"parentAccountId":"0015r00000HJk9qAAD","idType":"SAIdentityDocument","Controllinginterest":12.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"Account"}]';
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
        update pb;

        List<Document_Template__c> dtList = new List<Document_Template__c>();
        dtList.add(new Document_Template__c(Name='HANIS Certificate',Document_Type__c='HANIS Certificate',ECM_Filing_Date_Metadata__c=true,
        ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
        ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
        ECM_Account_Number_Metadata__c=true));
        dtList.add(new Document_Template__c(Name='CPB Certificate',Document_Type__c='CPB Certificate',ECM_Filing_Date_Metadata__c=true,
        ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
        ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
        ECM_Account_Number_Metadata__c=true));
        dtList.add(new Document_Template__c(Name='Experian Certificate',Document_Type__c='Experian Certificate',ECM_Filing_Date_Metadata__c=true,
        ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
        ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
        ECM_Account_Number_Metadata__c=true));
        upsert dtList;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String>{StringConstants.HANIS_VALIDATE, StringConstants.CPB_VALIDATE, 'ECM Authenication Path', 'ECM Add Path'});
	}

	@isTest
	public static void callGetLoggedInUserDetails(){
		System.assertNotEquals('', null);
		Test.startTest();
		OnboardingIndividualDetailsController.getLoggedInUserDetails();
		Test.stopTest();
	}

	@isTest
	public static void callHanisService(){
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
		String respHanisStr = OnboardingIndividualDetailsController.callHanisService('7707077777087');
		System.assertNotEquals(null, respHanisStr);
		Test.stopTest();
	}

	@isTest
	public static void callCPBService(){
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
		String respCPBStr = OnboardingIndividualDetailsController.callCPBService('7707077777087', 'BURGER');
		System.assertNotEquals(null, respCPBStr);
		Test.stopTest();
	}

	@isTest
	public static void callCreateIndividualProspect(){
		HanisValidate_Mock_ApiRest hanisMock = new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING);
		CPBValidate_Mock_ApiRest cpbMock = new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING);
		String respHanisStr = hanisMock.respond(null).getBody();
		String respCPBStr = cpbMock.respond(null).getBody();

        Test.startTest();
		String accId = OnboardingIndividualDetailsController.CreateIndividualProspect(respHanisStr, respCPBStr, null, 'Individual', 'New to Bank Onboarding', null, '' , true, true);
		System.assertNotEquals(null, accId);
		System.assertNotEquals(0, [select count()
		                           from address__c
		                           where account__c = :accId]);
		Test.stopTest();
	}

	@isTest
	public static void callCreateSolePropProspect(){
		HanisValidate_Mock_ApiRest hanisMock = new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING);
		CPBValidate_Mock_ApiRest cpbMock = new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING);
		String respHanisStr = hanisMock.respond(null).getBody();
		String respCPBStr = cpbMock.respond(null).getBody();

        Test.startTest();
		String accId = OnboardingIndividualDetailsController.CreateIndividualProspect(respHanisStr, respCPBStr, null, 'SOLE TRADER', 'New to Bank Onboarding', null, '', false, false);
		System.assertNotEquals(null, accId);
		System.assertNotEquals(0, [select count()
		                           from address__c
		                           where account__c = :accId]);
		Test.stopTest();
	}

	@isTest
	public static void callCreateOnboardingOpportunity(){
		Test.startTest();
		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		//W-005355 : Anka Ganta : 2020-07-09
		account.Country_of_Incorporation__c = 'South Africa';
		account.Client_Group__c = 'Non Individual';
		account.CASA_Reference_Number__c = '12233';
		account.CASA_Screening_Status__c = 'Cancelled';
		account.CIF__c = '';
		account.Countries_Traded_With__c = 'South Africa';
		account.Source_of_Income__c = 'Donation';
		account.UBO_ParentAccountWrapper__c = '[{"Type":"PrivateCompany","ShareholderCount":4,"Shareholder":"LONDANICOAL(PTY)LTD","recordId":"0015r00000HvTN3AAN","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"CentralBankorRegulator","ShareholderCount":3,"Shareholder":"PINEAPPLECENTRALBANKANDREG","roles":"Director;IndividualwithAuthoritytoAct;Shareholder/Controller","relatedAccountId":"0015r00000HJk9qAAD","recordId":"a005r000001uMlTAAU","primaryEntityId":"0015r00000HvTN3AAN","ParentShareholding":20.00,"parentAccountId":"0015r00000HvTN3AAN","idType":"RegistrationNumber","Controllinginterest":20.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FANTAFANTA","roles":"Director;Shareholder/Controller;ContactPerson","relatedAccountId":"0035r00000EccagAAB","recordId":"07k5r000004DDDBAA4","primaryEntityId":"0015r00000HJk9qAAD","ParentShareholding":60.00,"parentAccountId":"0015r00000HJk9qAAD","idType":"SAIdentityDocument","Controllinginterest":12.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"Account"}]';
		insert account;
		String oppId = OnboardingIndividualDetailsController.CreateOnboardingOpportunity(account.Id, null);
       // String oppId2 = OnboardingIndividualDetailsController.CreateCPFOnboardingOpportunity(account.Id);
      
        Boolean updateLiteOpportunity = OnboardingIndividualDetailsController.updateLiteOpportunity(oppId);
		String updateDocumentPlaceholdersTest = OnboardingIndividualDetailsController.updateDocumentPlaceholders(account.id, oppId);
		System.assertNotEquals(null, oppId);
		Test.stopTest();
	}

	/* Prashant Jain and Tinashe Shoko: 20200312: New test method for Merchant Onboarding */
	@isTest
	public static void callCreateMerchantOnboardingOpportunity(){
		Test.startTest();
		Account account = [SELECT Id
		                   FROM Account
		                   where Name = 'Test Account'
		                   LIMIT 1];
		String oppId = OnboardingIndividualDetailsController.CreateMerchantOnboardingOpportunity(account.Id);
        //Setting Up sales Process Type
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'New Credit Product (Business Banking)',
            Sales_Process__c = 'Credit Onboarding',
            Opportunity_Record_Type__c = 'Credit Onboarding',
            Request_Name__c = 'New Credit Product (Business Banking)');
        insert salesProcessType;
		Account newAccount = new Account();
		newAccount.Name = 'Test';
		String accId = OnboardingIndividualDetailsController.createIndividualProspectLimitedData(newAccount, true, 'New to Bank Onboarding' ,false);
		List<String> pkList = OnboardingIndividualDetailsController.getOccupationLevelAndEmployerSectorPicklist('Opportunity', 'StageName');
		List<User> userList = OnboardingIndividualDetailsController.getPortfolioManagerlist();
		string loggedProf = OnboardingIndividualDetailsController.getloggedinUserProfileName();
		String indRecType = OnboardingIndividualDetailsController.getIndividualProspectRecordTypeId();
		String creditOppId = OnboardingIndividualDetailsController.CreateCreditOnboardingOpportunity(newAccount.Id, 'New to Bank Onboarding');
        String cafoppId = OnboardingIndividualDetailsController.CreateCAFOnboardingOpportunity(account.Id,'New to Bank Onboarding');
        String cpfoppId = OnboardingIndividualDetailsController.CreateCPFOnboardingOpportunity(account.Id);

		//String spm = OnboardingIndividualDetailsController.createNewSPMOpportunity(newAccount.Id , 'selectedPm');
		System.assertNotEquals(null, oppId);
		Test.stopTest();
	}

	/* Prashant Jain and Tinashe Shoko: 20200312: New test method for Merchant Onboarding */
	@isTest
	public static void callcreateNewSPMOpportunity(){
		Test.startTest();
		Account account = [SELECT Id
		                   FROM Account
		                   where Name = 'Test Account'
		                   LIMIT 1];
		 Product2 prod = new Product2(Name = 'SPM Equity Product', Family = 'SPM', ProductCode = '1234');
		insert prod;
		
		String oppId = OnboardingIndividualDetailsController.createNewSPMOpportunity(account.Id, '');

		Account newAccount = new Account();
		newAccount.Name = 'Test';
		String accId = OnboardingIndividualDetailsController.createIndividualProspectLimitedData(newAccount, true, 'New to Bank Onboarding',false);
		List<String> pkList = OnboardingIndividualDetailsController.getOccupationLevelAndEmployerSectorPicklist('Opportunity', 'StageName');
		List<User> userList = OnboardingIndividualDetailsController.getPortfolioManagerlist();
		string loggedProf = OnboardingIndividualDetailsController.getloggedinUserProfileName();
		String indRecType = OnboardingIndividualDetailsController.getIndividualProspectRecordTypeId();
		//String spm = OnboardingIndividualDetailsController.createNewSPMOpportunity(newAccount.Id , 'selectedPm');
		System.assertNotEquals(null, oppId);
		Test.stopTest();
	}
}