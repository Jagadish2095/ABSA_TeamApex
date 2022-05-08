/*
Controller Test Class For merchantOnboardingAuthSignatoryCtrl class
*
* @author  Tinashe Mutsungi Shoko : Jordiflash
* @version v2.0
* @since   2020-04-02
*/
@isTest
public class merchantOnboardingAuthSignatoryCtrlTest {
    @isTest 
    public static void merchantOnboardingAuthSignatory(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        OpportunityLineItem oppLineItem = merchantOnboardingAuthSignatoryCtrl.getOpportunityProduct(testDataFactory.testOpportunity.Id);
        merchantOnboardingAuthSignatoryCtrl.getAccountContactRelation(testDataFactory.testOpportunity.Id);
        System.assertNotEquals(null, oppLineItem);
        Test.stopTest();
    } 
    @isTest
	public static void getAccountContactRelationTest() {
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, null)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS, StringConstants.CREATE_CLIENT_CIF }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

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
		insert account;

		//insert related acct;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__pc = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name';
		acctSecondary.LastName = 'Test Last Name';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__pc = '12454';
		acctSecondary.CASA_Screening_Status__pc = 'Matched';
		insert acctSecondary;
		Account acc = [SELECT PersonContactId FROM Account WHERE Id = :acctSecondary.Id];
		Id personContactId = acc.PersonContactId;
		AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
		insert accConRel;
		acrList.add(accConRel);

		System.debug('** acrList: ' + acrList.size());

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);

		System.debug('rpAccounts++' + rpAccounts);

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		testOpp.accountId = account.Id;
		insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');

		insert prod;

		System.debug('prod' + prod.Id);

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

		Test.startTest();
		merchantOnboardingAuthSignatoryCtrl.getAccountContactRelation(testOpp.Id);
        System.assertNotEquals(null, testOpp);
		Test.stopTest();
	}
}