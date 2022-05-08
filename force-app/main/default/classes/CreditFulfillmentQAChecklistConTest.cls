/**
 * @description CreditFulfillmentQAChecklistConTest Description
 *
 */
@isTest
public class CreditFulfillmentQAChecklistConTest{
	@TestSetup
	static void makeData(){
		Case testCase = new Case();
		//testCase.Queue__c = 'EBSH - Absa Electronic Banking';
		testCase.Subject = 'Support test ';
		testCase.Origin = 'Email';
		testCase.Status = 'New';
		testCase.Priority = 'High';
		testcase.Department__c = 'EBSH';
		testCase.Full_Department__c = 'Absa Electronic Banking Helpdesk';

		insert testCase;

		Case_Checklist_Template__c testTemplate = new Case_Checklist_Template__c(Business_Area__c = 'RSCS', Checklist_Name__c = 'Credit Fulfillment');
		insert testTemplate;

		Case_Checklist_Question__c testQuestion = new Case_Checklist_Question__c(Checklist_Template__c = testTemplate.id, Heading__c = 'Test', Question__c = 'Is the Name of the of the Application the same as what is on the CIF');
		insert testQuestion;

		Case_Checklist__c testChecklist = new Case_Checklist__c(Case_Checklist_Template__c = testTemplate.id, Related_Case__c = testCase.id, Submitted_By__c = UserInfo.getUserId());

		insert testChecklist;
	}

	@isTest
	public static void createcasechecklistTest(){
        Case cs = [Select Id from Case LIMIT 1];
		test.startTest();
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        CreditFulfillmentQAChecklistCon.getcasechecklistRecords(cs.Id);
        Case_Checklist_Question__c qname = [Select Id from Case_Checklist_Question__c LIMIT 1];
        qname.Question__c = 'Was the Card type captured correctly';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the embossed line for the Control Account captured correctly';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Was the embossed line for the User Account captured correctly';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Was the statement delivery option captured correctly on CAMN';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'The additional user card is linked to the correct control/main account';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Was the debit order captured correctly';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Is the delivery instruction correct';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Were the limits captured correctly';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Was memolines placed where applicable';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        qname.Question__c = 'Is the credit approval correct';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.createcasechecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        test.stopTest();
	}

    @isTest
	public static void CreateCaseQAChecklistTest(){
        Case cs = [Select Id from Case LIMIT 1];
        Case_Checklist_Question__c qname = [Select Id from Case_Checklist_Question__c LIMIT 1];
        qname.Question__c = 'Is the Name of the of the Application the same as what is on the CIF(QA)';
        update qname;
		test.startTest();
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the Card type captured correctly(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the embossed line for the Control Account captured correctly(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the embossed line for the User Account captured correctly(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the statement delivery option captured correctly on CAMN(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'The additional user card is linked to the correct control/main account(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was the debit order captured correctly(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Is the delivery instruction correct(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Were the limits captured correctly(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Was memolines placed where applicable(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));

        qname.Question__c = 'Is the credit approval correct(QA)';
        update qname;
        System.assertNotEquals(null,CreditFulfillmentQAChecklistCon.CreateCaseQAChecklist(cs.Id, true, true, true, true, true, true, true, true, true, true, true));
        test.stopTest();
	}
}