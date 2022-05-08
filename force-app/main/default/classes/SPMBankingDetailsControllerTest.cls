/**
 * @description Test class for Controller for SPMBankingDetails
 *
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-06-11
 * @params banking info
 */
@isTest
public class SPMBankingDetailsControllerTest {
	@isTest
	public static void testGetSelectOptions() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account account = new Account();
		account.Name = 'Test Account';
		// account.SPM_Platform_Type__c='Absa Life';
		insert account;
		Account account1 = new Account();
		account1.Name = 'Test Account1';
		account.SPM_Platform_Type__c = 'Absa Life';
		insert account1;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;
		Opportunity testOpp2 = new Opportunity();
		testOpp2.Name = 'Test Opp Onboarding 2';
		testOpp2.CloseDate = Date.today();
		testOpp2.StageName = 'New';
		testOpp2.AccountId = account1.Id;
		insert testOpp2;
		//Application__c
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testOpp.Id;
		testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		testApplication.Preferred_SMS__c = '065892600';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Application_Status__c = 'Pending'; // Tinashe W-004373
		testApplication.Products_And_Services__c = 'NotifyMe';
		insert testApplication;
		Application__c testApplication1 = new Application__c();
		testApplication1.Opportunity__c = testOpp2.Id;
		testApplication1.Application_Status__c = 'Pending'; // Tinashe W-004373
		insert testApplication1;
		Payment_Plan__c testPaymentPlan = new Payment_Plan__c();
		testPaymentPlan.Application__c = testApplication.Id;
		testPaymentPlan.Account_Number__c = '1573017159';
		testPaymentPlan.Account_Type__c = 'Cheque';
		testPaymentPlan.Bank_Name__c = 'NEDBANK';
		testPaymentPlan.Branch_Code__c = Integer.valueOf('157342');
		testPaymentPlan.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
		testPaymentPlan.Name = 'Cheque - 1573017159';
		testPaymentPlan.BIC_Code__c = '123445';
		testPaymentPlan.Reference__c = '12345';
		testPaymentPlan.Method__c = 'Debit Order';
		testPaymentPlan.Status__c = 'New';
		testPaymentPlan.Type__c = 'SPM Product';
		testPaymentPlan.Account__c = account.Id;
		insert testPaymentPlan;

		List<String> testList = SPMBankingDetailsController.getSelectOptions(testPaymentPlan, 'Account_Type__c');
		SPMBankingDetailsController.submitPaymentPlanDetail(
			testOpp.Id,
			testPaymentPlan.Account_Number__c,
			testPaymentPlan.Account_Type__c,
			testPaymentPlan.Bank_Name__c,
			string.valueOf(testPaymentPlan.Branch_Code__c),
			testPaymentPlan.Branch_Name__c,
			testPaymentPlan.BIC_Code__c,
			testPaymentPlan.Account_Name__c,
			testPaymentPlan.Name,
			testPaymentPlan.Type__c
		);
		SPMBankingDetailsController.submitPaymentPlanDetail(
			account.Id,
			testPaymentPlan.Account_Number__c,
			testPaymentPlan.Account_Type__c,
			testPaymentPlan.Bank_Name__c,
			string.valueOf(testPaymentPlan.Branch_Code__c),
			testPaymentPlan.Branch_Name__c,
			testPaymentPlan.BIC_Code__c,
			testPaymentPlan.Account_Name__c,
			testPaymentPlan.Name,
			testPaymentPlan.Type__c
		);
		SPMBankingDetailsController.submitPaymentPlanDetail(
			account.Id,
			'1573017159',
			'Cheque',
			'NEDBANK',
			'157342',
			'PHUMULANI MALL TEMBIS (157342)',
			'12334',
			'TEST Cheque Ac',
			'Cheque - 1573017159',
			'SPM Product'
		);
		SPMBankingDetailsController.submitPaymentPlanDetail(
			account1.Id,
			'1573017159',
			'Cheque',
			'NEDBANK',
			'157342',
			'PHUMULANI MALL TEMBIS (157342)',
			'12334',
			'TEST Cheque Ac',
			'Cheque - 1573017159',
			'SPM Product'
		);
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);
		SPMBankingDetailsController.getPaymentplanRec(testOpp.Id);
		// SPMBankingDetailsController.getPaymentplanRec(testOpp2.Id);
		SPMBankingDetailsController.getPaymentplanRec(account.Id);
		test.startTest();
		SPMBankingDetailsController.getAccount(testOpp.Id);
		SPMBankingDetailsController.getAccount(account.Id);
		SPMBankingDetailsController.getBankingDetails(testDataFactory.testOpportunity.id);
		test.stopTest();
		system.assertEquals(testPaymentPlan.Id, testPaymentPlan.Id);
	}
	/**
	 * @description test Method that calls methods in apex class
	 *
	 * @params   oppId     The Opportunity Id
	 */
	@isTest
	public static void testPaymentDetails() {
		Account account = new Account();
		account.Name = 'Testtest Account';
		insert account;
		Account account1 = new Account();
		account1.Name = 'Test Account1';
		account1.Client_Group__c = 'Non individual';
		account1.SPM_Platform_Type__c = 'Absa Life';
		account1.Country_of_Registration__c='India';
		insert account1;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;
		Opportunity testOpp2 = new Opportunity();
		testOpp2.Name = 'Test Opp Onboarding 2';
		testOpp2.CloseDate = Date.today();
		testOpp2.StageName = 'New';
		testOpp2.AccountId = account1.Id;
		insert testOpp2;
		Product2 prod = new Product2(Name = 'SPM Equity Product', Family = 'SPM', ProductCode = '19');
		insert prod;
		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		if (prod.Id != null) {
			oli.Product2Id = prod.Id;
		}
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;
		OpportunityLineItem oli1 = new OpportunityLineItem();
		oli1.OpportunityId = testOpp2.Id;
		if (prod.Id != null) {
			oli1.Product2Id = prod.Id;
		}
		oli1.PriceBookEntryid = pricebookEntry.Id;
		oli1.Quantity = 1;
		oli1.TotalPrice = 100;
		insert oli1;
		//Application__c
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testOpp.Id;
		testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		testApplication.Preferred_SMS__c = '065892600';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Application_Status__c = 'Pending';
		testApplication.Products_And_Services__c = 'NotifyMe';
		insert testApplication;

		Application_Product__c appPrdctRec = new Application_Product__c();
		appPrdctRec.Opportunity__c = testOpp.Id;
		appPrdctRec.Opportunity_Product_Id__c = oli.Id;
		list<Application_Product__c> lappPrdctRec = new List<Application_Product__c>();
		lappPrdctRec.add(appPrdctRec);
		insert lappPrdctRec;
		//Application__c
		Application__c testApplication1 = new Application__c();
		testApplication1.Opportunity__c = testOpp2.Id;
		testApplication.Application_Status__c = 'Pending';
		insert testApplication1;

		Application_Product__c appPrdctRec1 = new Application_Product__c();
		appPrdctRec1.Opportunity__c = testOpp2.Id;
		appPrdctRec1.Opportunity_Product_Id__c = oli1.Id;
		insert appPrdctRec1;
		Payment_Plan__c testPaymentPlan = new Payment_Plan__c();
		testPaymentPlan.Application__c = testApplication1.Id;
		testPaymentPlan.Account_Number__c = '1573017159';
		testPaymentPlan.Account_Type__c = 'Cheque';
		testPaymentPlan.Bank_Name__c = 'NEDBANK';
		testPaymentPlan.Branch_Code__c = Integer.valueOf('157342');
		testPaymentPlan.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
		testPaymentPlan.Name = 'Cheque - 1573017159';
		testPaymentPlan.BIC_Code__c = '123445';
		testPaymentPlan.Reference__c = '12345';
		testPaymentPlan.Method__c = 'Debit Order';
		testPaymentPlan.Status__c = 'New';
		testPaymentPlan.Type__c = 'SPM Product';
		testPaymentPlan.Account__c = account1.Id;
		insert testPaymentPlan;
		Integration_API__c intapi = new Integration_API__c();
		intapi.Name = 'Jitterbit2';
		intapi.Client_ID__c = 'e33caff9-53d8-43ad-8b2a-d5531aae3c06';
		intapi.Environment__c = 'Development';
		intapi.Base_URL__c = 'https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api';
		insert intapi;
		Integration_Service__c iservice = new Integration_Service__c();
		iservice.Integration_API_ID__c = intapi.Id;
		iservice.Method__c = 'POST';
		iservice.Name = 'Marble Create Account';
		iservice.URL_Extension__c = '/marble/account';
		iservice.Content_Type__c = 'application/json';
		insert iservice;
		String POSITIVE_RESPONSE_BODY = '{"requestId":"3f3373ce-1a8e-477b-b453-2cef08382d07","partnerID":49,"entityId":174301,"crmEntityTypeId":1,"crmEntityName":"Hisroaccount Hillman03","mobileNumber":"0812246607","email":null,"marbleAccountTypeResponseList":[{"fundId":486975,"portfolioId":160076,"portfolioProductTypeID":1}],"Result":{"status":200,"statusCode":0,"statusMessage":"Marble on-boarding processed successful"}}';
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		SPMBankingDetailsController.submitPaymentPlanDetail(
			testOpp.Id,
			'1573017159',
			'Cheque',
			'NEDBANK',
			'157342',
			'PHUMULANI MALL TEMBIS (157342)',
			'12334',
			'TEST Cheque Ac',
			'Cheque - 1573017159',
			'SPM Product'
		);
		SPMBankingDetailsController.submitPaymentPlanDetail(
			account.Id,
			testPaymentPlan.Account_Number__c,
			testPaymentPlan.Account_Type__c,
			testPaymentPlan.Bank_Name__c,
			string.valueOf(testPaymentPlan.Branch_Code__c),
			testPaymentPlan.Branch_Name__c,
			testPaymentPlan.BIC_Code__c,
			testPaymentPlan.Account_Name__c,
			testPaymentPlan.Name,
			testPaymentPlan.Type__c
		);
		Address__c addreg = new Address__c();
		addreg.Address_Type__c = 'Registered';
		addreg.Account__c = account1.id;
		addreg.Shipping_Street__c = 'street1';
		insert addreg;
		SPMBankingDetailsController.mapRequestFields(testOpp.Id);
		SPMBankingDetailsController.saveadditionalinfo(testOpp.Id, 'firstname', 'trustname', 'absatrust2', 'Absa Trust - Burg Managed (BD)');
		SPMBankingDetailsController.saveadditionalinfo(testOpp.Id, 'firstname', 'trustname', 'absatrust2', 'Absa life');
		SPMBankingDetailsController.marblecreateAccount(testOpp.Id);

		test.startTest();
		SPMBankingDetailsController.marblecreateAccount(testOpp2.Id);
		SPMBankingDetailsController.getAppRec(testOpp.Id);
		test.stopTest();
		system.assertEquals(testApplication.Id, testApplication.Id);
	}
	/**
	 * @description test Method that calls methods in apex class
	 *
	 * @params   oppId     The Opportunity Id
	 */
	@isTest
	public static void testPaymentDetails1() {
		Account account = new Account();
		account.Name = 'Testtest Account';
        account.SPM_Platform_Type__c='Absa Life';
		insert account;
         Account account1 = new Account();
		account1.Name = 'Test Account1';
        account1.Client_Group__c='JOINT AND SEVERAL CLIENT';
        account1.Country_of_Residence__c='India';
        account1.SPM_Platform_Type__c='Absa Life';
		insert account1;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
		insert testOpp;
        Opportunity testOpp2 = new Opportunity();
		testOpp2.Name = 'Test Opp Onboarding 2';
		testOpp2.CloseDate = Date.today();
		testOpp2.StageName = 'New';
		testOpp2.AccountId = account1.Id;
		insert testOpp2;
         Product2 prod = new Product2(Name = 'SPM Equity Product', Family = 'SPM',ProductCode = '19' );
        insert prod;
         Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
         PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = testOpp.Id;
        if(prod.Id != null) {
        oli.Product2Id = prod.Id;
        }
        oli.PriceBookEntryid = pricebookEntry.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 100;
        insert oli;
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.OpportunityId = testOpp2.Id;
        if(prod.Id != null) {
        oli1.Product2Id = prod.Id;
        }
        oli1.PriceBookEntryid = pricebookEntry.Id;
        oli1.Quantity = 1;
        oli1.TotalPrice = 100;
        insert oli1;
		//Application__c
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testOpp.Id;
		testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		testApplication.Preferred_SMS__c = '065892600';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Application_Status__c = 'Pending';
		testApplication.Products_And_Services__c = 'NotifyMe';
		insert testApplication;
        
        Application_Product__c appPrdctRec=new Application_Product__c();
        appPrdctRec.Opportunity__c=testOpp.Id;
        appPrdctRec.Opportunity_Product_Id__c=oli.Id;
        list<Application_Product__c> lappPrdctRec =new list<Application_Product__c>();
        lappPrdctRec.add(appPrdctRec);
         insert lappPrdctRec;
        //Application__c
		Application__c testApplication1 = new Application__c();
		testApplication1.Opportunity__c = testOpp2.Id;
		testApplication.Application_Status__c = 'Pending';
		insert testApplication1;
        
        Application_Product__c appPrdctRec1=new Application_Product__c();
        appPrdctRec1.Opportunity__c=testOpp2.Id;
        appPrdctRec1.Opportunity_Product_Id__c=oli1.Id;
        insert appPrdctRec1;
        Payment_Plan__c testPaymentPlan = new Payment_Plan__c();
		testPaymentPlan.Application__c = testApplication1.Id;
		testPaymentPlan.Account_Number__c = '1573017159';
		testPaymentPlan.Account_Type__c = 'Cheque';
		testPaymentPlan.Bank_Name__c = 'NEDBANK';
		testPaymentPlan.Branch_Code__c = Integer.valueOf('157342');
		testPaymentPlan.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
		testPaymentPlan.Name = 'Cheque - 1573017159';
		testPaymentPlan.BIC_Code__c = '123445';
        testPaymentPlan.Reference__c = '12345';
		testPaymentPlan.Method__c = 'Debit Order';
		testPaymentPlan.Status__c = 'New';
		testPaymentPlan.Type__c = 'SPM Product';
		testPaymentPlan.Account__c = account1.Id;
		insert testPaymentPlan;
         Integration_API__c intapi= new Integration_API__c();
        intapi.Name='Jitterbit2';
        intapi.Client_ID__c='e33caff9-53d8-43ad-8b2a-d5531aae3c06';
        intapi.Environment__c='Development';
        intapi.Base_URL__c='https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api';
        insert intapi;
        Integration_Service__c iservice=new Integration_Service__c();
        iservice.Integration_API_ID__c=intapi.Id;
        iservice.Method__c='POST';
        iservice.Name='Marble Create Account';
        iservice.URL_Extension__c='/marble/account';
        iservice.Content_Type__c='application/json';
        insert iservice;
          String POSITIVE_RESPONSE_BODY = '{"requestId":"3f3373ce-1a8e-477b-b453-2cef08382d07","partnerID":49,"entityId":174301,"crmEntityTypeId":1,"crmEntityName":"Hisroaccount Hillman03","mobileNumber":"0812246607","email":null,"marbleAccountTypeResponseList":[{"fundId":486975,"portfolioId":160076,"portfolioProductTypeID":1}],"Result":{"status":200,"statusCode":0,"statusMessage":"Marble on-boarding processed successful"}}';
			// Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		
        Address__c addreg=new Address__c();
        addreg.Address_Type__c='Postal Address';
        addreg.Account__c=account1.id;
        addreg.Shipping_Street__c='street1';
        insert addreg;
        test.startTest();
        SPMBankingDetailsController.getPaymentplanRec(testOpp.Id);
		SPMBankingDetailsController.mapRequestFields(testOpp.Id);
        
        
        SPMBankingDetailsController.marblecreateAccount(testOpp2.Id);
        test.stopTest();
		system.assertEquals(testApplication.Id, testApplication.Id); 
	}
}