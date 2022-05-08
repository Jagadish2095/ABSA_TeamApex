@isTest
public class FinancialInformationTriggerTest {
	@testSetup
	public static void FinancialInfoTriggertest() {
		Account ac = new Account();
		ac.Name = 'Test';
		ac.CIF__c = 'CLOSE  001'; //NOZENZO001';
		insert ac;

		Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
		Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();
		Opportunity opp = new Opportunity();
		opp.Name = 'UoW Test Name';
		opp.StageName = 'Open';
		opp.CloseDate = System.today();
		opp.accountid = ac.id;
		opp.RecordTypeId = onboardingrecId;
		insert opp;

		Group testGroup = new Group(Name = 'Credit Support Consultant', Type = 'Queue');
		insert testGroup;

		System.runAs(new User(Id = UserInfo.getUserId())) {
			QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
			insert testQueue;
		}

		List<Group> groupDetail = new GroupsSelector().selectByNameSetAndType(new Set<String>{'Credit Support Consultant'},'Queue');

		Service_Group__c tstServQG = new Service_Group__c();
		tstServQG.Name = 'Financial Capture Group';
		tstServQG.Queue__c = groupDetail[0].id;
		insert tstServQG;

		Service_Type__c tstServT = new Service_Type__c();
		tstServT.name = 'check';
		insert tstServT;

		Service_Group_Type__c tstServQT = new Service_Group_Type__c();
		tstServQT.Service_type__c = tstServT.Id;
		tstServQT.Service_Group__c = tstServQG.Id;
		insert tstServQT;

		Application__c application = new Application__c();
		application.Opportunity__c = opp.Id;
        application.Account__c=ac.id;
		insert application;

		Contact con = new Contact(Title = 'ContactTest', Phone = '87837743123456769', LastName = 'ContactTest');
		insert con;

        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Case cse = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', AccountId = ac.Id, Risk_Management_Centre__c = 'Digital Fraud', Email__c = 'test@test.com', recordTypeId = caseRecordTypeMap.get('Financial_Capture_Request').getRecordTypeId(), Subject = 'test', Description = 'test', Expectation_of_the_Customer__c = 'test', Incident_Date__c = date.today());
		insert cse;

		Financial_Information__c finrec = new Financial_Information__c();
		finrec.Status__c = 'Draft';
		finrec.Account__c = ac.id;
		finrec.Auditor_s_Certificate_Date__c = date.today().adddays(-15);
		finrec.Client_Name__c = 'abcd';
		finrec.Date_Financials_Signed_Client__c = date.today().adddays(-15);
		finrec.Financial_Statement_Qualified_Issue__c = 'YES';
		finrec.Financial_Statement_Type__c = 'Draft';
		finrec.Statement_Date_Year_end__c = date.today().adddays(-15);
		finrec.Year_Selection__c = 'Year1';
		finrec.Status__c = 'Draft';
		finrec.Month_With_Highest_Debit_Balance__c = '02/2021';
		finrec.Month_with_highest_shortfall__c = '02/2021';
		finrec.Intangible_Assets__c = 2000000;
        finrec.Land_Bank__c = 433300;
		finrec.Loans_from_Associates__c = 250000;
		finrec.Loans_from_Principals_Ceded__c = 32000;
		finrec.Loans_from_Principals_Non_Ceded__c = 420000;
		finrec.Loans_to_Principals_Associates__c = 340000;
		finrec.Other_Assets__c = 2000;
		finrec.Other_Current_Assets__c = 12000;
		finrec.Other_Current_Liabilities__c = 20000;
		finrec.Other__c = 25000;
		finrec.Revaluation_Of_Assets__c = 20000;
		finrec.Total_Fixed_Investments_Cash_and_Market__c = 400000;
		finrec.Cash_Marketable_Securities__c = 100000;
		finrec.Property_Plant_Equipment__c = 100000;
		finrec.Shareholders_Funds_Capital_Account__c = 100000;
		insert finrec;

	}

	public static testMethod void FinTriggertest1() {
		Account ac = [SELECT Id FROM Account WHERE Name = 'Test'];
		Financial_Information__c finrec1 = new Financial_Information__c();
        finrec1 = [SELECT Id FROM Financial_Information__c LIMIT 1];
        finrec1.Status__c='Verified Complete';
        update finrec1;
		/*Financial_Information__c finrec1 = new Financial_Information__c();
		finrec1.Status__c = 'Verified Complete';
		finrec1.id = finrec.id;
		finrec.Client_Name__c = 'abcde';
		update finrec1;*/

		//system.debug('checking status $$$$$$' + finrec.Status__c);
	}

	public static testMethod void finTriggertest() {
		Account ac = new Account();
		ac.Name = 'Testing trigger';
		ac.CIF__c = 'CLOSE  002'; //NOZENZO001';
		insert ac;

		Financial_Information__c finrec = new Financial_Information__c();
		finrec.Status__c = 'Draft';
		finrec.Account__c = ac.id;
		finrec.Auditor_s_Certificate_Date__c = date.today().adddays(-15);
		finrec.Client_Name__c = 'abcd';
		finrec.Date_Financials_Signed_Client__c = date.today().adddays(-15);
		finrec.Financial_Statement_Qualified_Issue__c = 'YES';
		finrec.Financial_Statement_Type__c = 'Draft';
		finrec.Statement_Date_Year_end__c = date.today().adddays(-15);
		finrec.Year_Selection__c = 'Year1';
		finrec.Status__c = 'Draft';
		finrec.Month_With_Highest_Debit_Balance__c = '02/2021';
		finrec.Month_with_highest_shortfall__c = '02/2021';
		finrec.Intangible_Assets__c = 2000000;
        finrec.Land_Bank__c = 433300;
		finrec.Loans_from_Associates__c = 250000;
		finrec.Loans_from_Principals_Ceded__c = 32000;
		finrec.Loans_from_Principals_Non_Ceded__c = 420000;
		finrec.Loans_to_Principals_Associates__c = 340000;
		finrec.Other_Assets__c = 2000;
		finrec.Other_Current_Assets__c = 12000;
		finrec.Other_Current_Liabilities__c = 20000;
		finrec.Other__c = 25000;
		finrec.Revaluation_Of_Assets__c = 20000;
		finrec.Total_Fixed_Investments_Cash_and_Market__c = 400000;
        insert finrec;
	}
}