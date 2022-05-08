/*
 * Test for DocumentsGenerateControler
 * Tinashe M Shoko 21-05-2020
 * W-003951, W-004228, W-004229
 *
 */
@isTest
public class DocumentsGenerateControlerTest{
	static testMethod void testgetDocumentSelectOptions(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = testDataFactory.testOpportunity;
		Account testAccount = testDataFactory.testAccount;
		test.startTest();
		System.assert(DocumentsGenerateControler.getDocumentSelectOptions('Type__c') != null, 'we should have a value');
		test.stopTest();
	}

	static testMethod void generateDocumentNow(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = testDataFactory.testOpportunity;
		Account testAccount = testDataFactory.testAccount;
		test.startTest();
		DocumentsGenerateControler.generateDocumentNow(opp.Id, 'FAIS Disclosure');
		List<String> ss = DocumentsGenerateControler.getDocumentGenerationOption(opp.Id);
		system.assert(ss != null, 'generateDocumentNow');
		test.stopTest();
	}

	static testMethod void testgenerateNewDocument(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = testDataFactory.testOpportunity;
		Account testAccount = testDataFactory.testAccount;
		test.startTest();
		DocumentsGenerateControler.generateDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		System.assert(DocumentsGenerateControler.generateContentRequest('fileName', 'templateId', 'ecmType', 'cifNum', 'accNum', 'xmlTemplate') != null);
		System.assert(DocumentsGenerateControler.checkCASAValidity(opp.Id) != null);
		test.stopTest();
	}

	static testMethod void testNFFE(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Opportunity opp = testDataFactory.testOpportunity;
		Account testAccount = testDataFactory.testAccount;
		test.startTest();
		testAccount.Identify_the_account_holder_type__c = 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding';
		update testAccount;
		DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		testAccount.Identify_the_account_holder_type__c = 'Financial Institution (FI)';
		update testAccount;
		DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		testAccount.Identify_the_account_holder_type__c = 'Direct Reporting Non Financial Entity';
		update testAccount;
		DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		testAccount.Identify_the_account_holder_type__c = 'Non Reportable Persons';
		update testAccount;
		Map<String, String> ss = DocumentsGenerateControler.generateNewDocument(opp.Id, 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation');
		system.assert(ss != null, 'generateNewDocument');
		test.stopTest();
	}
}