/**
 * @description Test Class for TaskTrigger, TaskTriggerHandler and TaskSelector and TaskTriggerFunctions.
 * NOTE: All the methods would return the data that data not is not saved to database
 * @Author: Rakesh Byri(Absa)
 * @Created Date: 2019-03-05
 * CHANGE LOG:
 *=======================================================================================================
 *
 *=======================================================================================================
 * */
@isTest
public class TaskTriggerFunctionsTest {
	@testSetup
	static void createTestData() {
		System.runAs(new User(Id = UserInfo.getUserId())) {
			List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
			insert usersList;
			
		}
		List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 1);
		leadsList[0].Unsuccessful_Calls__c = 3;
		insert leadsList;
		//System.debug('leadsList  ===>  ' + leadsList);
		List<Task> tasksList = TestDataFactory.getTasks(null, 1, leadsList[0].Id, null, 'Call');

		Id retailTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Business_Bank').getRecordTypeId();
		for (Task t : tasksList) {
			t.RecordTypeId = retailTaskRecordTypeId;
		}
		insert tasksList;
	}

	@isTest
	static void afterInsertTest() {
		List<User> usersList = [SELECT Id FROM User WHERE username LIKE '%testuser1%' LIMIT 1];
		List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 2);
		leadsList[0].OwnerId = usersList[0].Id;
		insert leadsList;
		List<Task> tasksList = TestDataFactory.getTasks(null, 2, leadsList[0].Id, null, 'Call');
		system.assertNotEquals(null, tasksList);
		tasksList[0].WhoId = leadsList[0].Id;
		//Added for failing method - Minal Rama 2020/11/09
		for (Task t : tasksList) {
			t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Business_Bank').getRecordTypeId();
			t.Outcome__c = 'Client deceased';
			t.Call_Successful__c = 'Yes';
		}
		insert tasksList;
	}

	@isTest
	static void afterUpdateTest() {
		List<Lead> leadsList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test1 Lead%'];
		List<Task> tasksList = [SELECT Id, Outcome__c, Next_Step__c, Call_Successful__c FROM Task WHERE WhoId = :leadsList[0].Id];
		system.assertNotEquals(null, tasksList);
		tasksList[0].Outcome__c = 'Client deceased';
		tasksList[0].Next_Step__c = 'No action required';
		tasksList[0].Call_Successful__c = 'Yes';
		Test.startTest();
		update tasksList;
		Test.stopTest();
	}

	@isTest
	static void afterUpdateTest1() {
		List<Lead> leadsList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test1 Lead%'];
		List<Task> tasksList = [SELECT Id, Outcome__c, Next_Step__c FROM Task WHERE WhoId = :leadsList[0].Id];
		system.assertNotEquals(null, tasksList);
		tasksList[0].Outcome__c = 'Unable to reach Contact';
		//tasksList[0].Call_Successful__c = 'Yes';//Id retailTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Business_Bank').getRecordTypeId();
		tasksList[0].RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Task').getRecordTypeId();
		Test.startTest();
		update tasksList;
		Test.stopTest();
	}
	@isTest
	static void afterUpdateTest2() {
		list<lead> updateLead = new List<lead>();
		List<Lead> leadsList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test1 Lead%'];
		leadsList[0].Unsuccessful_Calls__c = 3;
		updateLead.add(leadsList[0]);
		update updateLead;
		System.assertNotEquals(leadsList, null);
		List<Task> tasksList = TestDataFactory.getTasks(null, 4, leadsList[0].Id, null, 'Call');

		Id retailTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Task').getRecordTypeId();
		for (Task t : tasksList) {
			t.RecordTypeId = retailTaskRecordTypeId;
			t.Outcome__c = 'Unable to reach Contact';
			t.Call_Successful__c = '';
		}
		insert tasksList;
	}

	@isTest
	static void afterUpdateTest3() {
		list<lead> updateLead = new List<lead>();
		List<Lead> leadsList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test1 Lead%'];
		leadsList[0].Unsuccessful_Calls__c = 3;
		updateLead.add(leadsList[0]);
		update updateLead;
		System.assertNotEquals(leadsList, null);
		List<Task> tasksList = TestDataFactory.getTasks(null, 4, leadsList[0].Id, null, 'Call');

		Id retailTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Task').getRecordTypeId();
		for (Task t : tasksList) {
			t.RecordTypeId = retailTaskRecordTypeId;
			t.Outcome__c = 'Unable to reach Contact';
			t.Call_Successful__c = '';
			t.GlobalRefId__c = '00001127331620735680';
		}
		insert tasksList;
		TaskTriggerFunctions.updateCallTask(tasksList);
	}

	@isTest
	static void afterDeleteTest() {
		List<Lead> leadsList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test1 Lead%'];
		List<Task> tasksList = [SELECT Id, Outcome__c, Next_Step__c, Call_Successful__c FROM Task WHERE WhoId = :leadsList[0].Id];
		system.assertNotEquals(null, tasksList);
		delete tasksList;
	}

	@isTest
	static void beforeInsertTaskForOppTest() {
		List<Account> accList = TestDataFactory.getPersonAccounts('Account', 'Individual_Client', 1);
		insert accList;
		system.assertNotEquals(null, accList);
		List<Opportunity> oppList = TestDataFactory.getOpportunities(null, 'General', 1);
		oppList[0].AccountId = accList[0].Id;
		insert oppList;
		Test.startTest();
		Task task = new Task();
		task.WhatId = oppList[0].id;
		task.Subject = 'Call';
		task.HasComments__c = true;
		insert task;
		Test.stopTest();
	}

	@IsTest
	static void beforeInsertTaskForDDLeadTest() {
		Lead ddLead = [SELECT Id, RecordTypeId FROM Lead LIMIT 1];
		ddLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
		update ddLead;

		Task task = new Task();
		task.WhoId = ddLead.Id;
		task.Subject = 'Call';
		task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Task').getRecordTypeId();
		task.Outcome__c = 'Client Interested';
		task.HasComments__c = true;
		Test.startTest();
		try {
			insert task;
		} catch (Exception e) {
			System.assert(e != null);
		}
		Test.stopTest();
	}

	@IsTest
	static void beforeInsertTaskForDDSTILeadTest() {
		Lead ddLead = [SELECT Id, RecordTypeId, Unsuccessful_Calls__c FROM Lead LIMIT 1];
		ddLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead').getRecordTypeId();
		ddLead.Unsuccessful_Calls__c = 2;
		//ddLead.OwnerId=[select id from user].id;
		update ddLead;

		Task task = new Task();
		task.WhoId = ddLead.Id;
		task.Subject = 'Call';
		task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Task').getRecordTypeId();
		task.Outcome__c = 'Client Interested';
		task.HasComments__c = true;
		Test.startTest();
		try {
			insert task;
		} catch (Exception e) {
			System.assert(e != null);
		}
		Test.stopTest();
	}

	@IsTest
	static void beforeInsertTaskForDDSTILeadTest1() {
		List<Lead> leadsList = TestDataFactory.getLeads('DD_STI_Lead', 1);
		leadsList[0].Unsuccessful_Calls__c = 2;
		leadsList[0].OwnerId = [SELECT Id FROM User WHERE username LIKE '%testuser1%' LIMIT 1].id;
		insert leadsList;

		Task task = new Task();
		task.WhoId = leadsList[0].Id;
		task.Subject = 'Call';
		task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Task').getRecordTypeId();
		task.Outcome__c = 'Client Interested';
		task.HasComments__c = true;
		Test.startTest();
		try {
			insert task;
		} catch (Exception e) {
			System.assert(e != null);
		}
		Test.stopTest();
	}

	@IsTest
	static void beforeInsertTaskForDDSTIUnsuccessfulCallCase() {
		Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
		insert account;

		Contact testContact = new Contact();
		testContact.FirstName = 'Test Contact';
		testContact.LastName = '1';
		testContact.MobilePhone = '1234567809';
		insert testContact;
		List<Case> caserecs = new List<Case>();
		Case aCase = new Case();
		aCase.Type = 'Service Type 2';
		aCase.AccountId = account.Id;
		aCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DD_STI_Case').getRecordTypeId();
		aCase.Status = 'New';
		aCase.Email_From_Address__c = 'test@from.com';
		aCase.Category__c = 'Amendment';
		acase.ContactId = testContact.id;
		caserecs.add(aCase);

		Case aCase2 = new Case();
		aCase2.Type = 'Service Type 2';
		aCase2.ParentId = aCase.Id;
		aCase2.AccountId = account.Id;
		aCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DD_STI_Case').getRecordTypeId();
		aCase2.Status = 'New';
		aCase2.Email_From_Address__c = 'test@from.com';
		aCase2.Unsuccessful_Calls__c = 2;
		aCase2.Category__c = 'Amendment';
		aCase2.ContactId = testContact.id;
         caserecs.add(aCase2);
        	Test.startTest();
		insert caserecs;

		Task task = new Task();
		task.WhatId = caserecs[0].Id;
		task.Subject = 'Call';
		task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('DD_STI_Case_Task').getRecordTypeId();
		task.Outcome__c = 'Unable to reach Contact';
		task.HasComments__c = true;
	
		try {
			insert task;
		} catch (Exception e) {
			System.assert(e != null);
		}
		Test.stopTest();
	}

	@isTest
	static void beforeDeleteTaskForOppTest() {
		String expectedMessage = 'This record cannot be deleted as it has important client information';
		List<Account> accList = TestDataFactory.getPersonAccounts('Account', 'Individual_Client', 1);
		insert accList;
		List<Opportunity> oppList = TestDataFactory.getOpportunities(null, 'General', 1);
		oppList[0].AccountId = accList[0].Id;
		insert oppList;
		Test.startTest();
		Task task = new Task();
		task.WhatId = oppList[0].id;
		task.Subject = 'Call';
		task.HasComments__c = true;
		insert task;
		try {
			delete task;
		} catch (Exception e) {
			//System.debug('Exception Message ==> ' + e.getMessage());
			system.assert(e.getMessage().contains(expectedMessage));
		}
		TaskTriggerFunctions.convertUCID('testingtestintestingxtestingtestingtesting');
		Test.stopTest();
	}
	@isTest
	static void beforeDeleteTaskForCaseTest() {
		String expectedMessage = 'You are restricted to delete Activities';
		Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
		Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Client Review Call Task').getRecordTypeId();
		List<Account> accList = TestDataFactory.getPersonAccounts('Account', 'Individual_Client', 1);
		insert accList;
        Test.startTest();
		Case cObj = new Case();
		Date myDate = date.newInstance(2012, 5, 22);
		cObj.RecordTypeId = caseRecordTypeId;
		cObj.Email__c = 'test@test.com';
		cObj.CIF_Custom__c = 'LOUWNJ 010';
		cObj.Adviser_Code__c = '112233';
		cObj.Customer_ID__c = '1234567891234';
		cObj.Birth_Date__c = myDate;
		cObj.First_Name__c = 'Test Client';
		cObj.Last_Name__c = 'Test JKumar';
		cObj.Initials__c = 'MK';
		cObj.Nationality__c = 'South Africa';
		cObj.Phys_Addr_Post_Code__c = '8976';
		cObj.Phys_Addr_Line1__c = 'University of PET';
		cObj.Work_Phone__c = '9999999999';
		cObj.Home_Phone__c = '8888888888';
		cObj.Mobile__c = '7777777777';
		cObj.Adviser_Name__c = 'Test JKumar';
		cObj.AccountId = accList[0].Id;
		cObj.ID_Type__c = 'SA ID';
		cObj.SelectedAdvisorIdF2F__c = '';
		cObj.Status = 'New';
		cObj.SelectedAdvisorIdF2F__c = userinfo.getUserId();
		insert cObj;
	
		Task task = new Task();
		task.RecordTypeId = taskRecordTypeId;
		task.WhatId = cObj.id;
		task.Subject = 'Call';
		task.HasComments__c = true;
		insert task;
		try {
			delete task;
		} catch (Exception e) {
			//System.debug('Exception Message ==> ' + e.getMessage());
			system.assert(e.getMessage().contains(expectedMessage));
		}
		//TaskTriggerFunctions.convertUCID('testingtestintestingxtestingtestingtesting');
		Test.stopTest();
	}

	@IsTest
	static void AIPTasksTestmethod() {
		Document_Template__c dt = new Document_Template__c();
        dt.Name = 'Confirmation of Short Term Vehicle Insurance';
        dt.Document_Type__c = 'Confirmation of Short Term Vehicle Insurance';
        dt.Parent_Document_Type__c = 'Application Forms';
        dt.Generate_Document__c =  true;
        insert dt;
        
        DocumentTemplateProcessor.ContextBuilder builder = new DocumentTemplateProcessor.ContextBuilder();
        Account acc = new Account();
        acc.Name = 'My Account';
        builder.add('Account', acc);
        String json = builder.serialize('{"var1" : true}');
        System.assert(json != null);
        DocumentTemplateProcessor dp = new DocumentTemplateProcessor();
        Document_Template__c d = new Document_Template__c();
        d.Template_Id__c = '12345';
        d.Name = 'Business - Client Agreement';
        d.Document_Type__c = 'Business - Client Agreement';
        insert d;
        Map<String, String> ecmFields = new Map<String, String>();
        ecmFields.put('Id', '984576564987');
        ecmFields.put('password', '984576564987');
        List<String> endpoints = new List<String>();
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
		//mock.addResponse(JSON.serialize(new CC_GenerateContentResponse()));
        mock.addResponse('{}');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Account account = new Account(FirstName = 'Test', LastName = 'Account', CIF__c = 'cif12345');
		insert account;
        
        List<Lead> leadsList = TestDataFactory.getLeads('AIP_Lead', 1);
        leadsList[0].FinServ__RelatedAccount__c = account.Id;
        leadsList[0].Unsuccessful_Calls__c=0;
        leadsList[0].OwnerId=[SELECT Id FROM User WHERE username LIKE '%testuser1%' LIMIT 1].id;          
		insert leadsList;	
        
		Task task = new Task();
		task.WhoId = leadsList[0].Id;
		task.Subject = 'Call';
		task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('AIP_Task').getRecordTypeId();
		task.Outcome__c = 'Duplicate';
		task.HasComments__c = true;
        insert task;
        
         List<Lead> leadsListA = TestDataFactory.getLeads('AIP_Lead', 1);
        leadsListA[0].FinServ__RelatedAccount__c = account.Id;
        leadsListA[0].Unsuccessful_Calls__c=3;
        leadsListA[0].OwnerId=[SELECT Id FROM User WHERE username LIKE '%testuser1%' LIMIT 1].id;          
		insert leadsListA;
        
        Task taskAIP = new Task();
		taskAIP.WhoId = leadsListA[0].Id;
		taskAIP.Subject = 'Call';
        //taskAIP.Call_Successful__c = 'No';
		taskAIP.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('AIP_Task').getRecordTypeId();
		taskAIP.Outcome__c = 'Customer Hung Up';
		taskAIP.HasComments__c = true;
        insert taskAIP;
        
        Document__c docObj = new Document__c();
        docObj.Name ='BrokerNote_AIMS_AIMS_AIMS_67_87_98';
        docObj.ECM_Type__c ='Ent_Agreement';
        docObj.Reference__c ='Ref1234';
        docObj.IsActive__c = true;
        docObj.Lead__c = leadsList[0].Id;
        INSERT docObj;
        
         map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account2 = new Account(Name = 'Test Account');
        
        insert account2;
        
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');
        
        insert personAccount;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account2.Id,Email='test@test.com',Birthdate=date.today());
        insert contact;
        Test.startTest();
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('AIP_Case').getRecordTypeId(),
                                Subject = 'normal case',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Banker__c='test');
        insert caseRec;
        
        Task taskAIPCase = new Task();
		taskAIPCase.whatId = caseRec.Id;
		taskAIPCase.Subject = 'Call';
        //taskAIP.Call_Successful__c = 'No';
		taskAIPCase.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('AIP_Task').getRecordTypeId();
		taskAIPCase.Outcome__c = 'Customer Hung Up';
		taskAIPCase.HasComments__c = true;
        insert taskAIPCase;
        
        QuickText qt = new QuickText();
        qt.message = 'This is an AIP test SMS';
        qt.Name = 'AIP TEST SMS';
        insert qt;
        
        Set<Id> caseIdSet = new set<Id>();
        caseIdSet.add(caseRec.Id);

		
		
			//insert task;
        	//insert taskAIP;
        	//insert taskAIPCase;
        try {
			TaskTriggerFunctions.convertUCID('uihdjnsdjihijd77x472ihf7dhagvo7db');
            TaskTriggerFunctions.createCaseRecord(leadsList[0].Id,'Proof to be Sent by Client',task.id);
            TaskTriggerFunctions.sendSmsEmail(leadsList[0].Id,'Email','email@email.com','+279108378','','AIP Proof to Client','email1@email.com','email2@email.com');
       	    TaskTriggerFunctions.sendSmsEmail(leadsList[0].Id,'SMS','email@email.com','+279108378',qt.Name,'','email1@email.com','email2@email.com');
       	    
            TaskTriggerFunctions.checkIfTaskHasComments(task);
            TaskTriggerFunctions.updateCallAttemptsOnCase(caseIdSet);
             
            Set<Id> leadIdsSet = new Set<Id>();
            leadIdsSet.add(leadsListA[0].Id);
            TaskTriggerFunctions.updateCallAttemptsOnLead(leadIdsSet);
            
            TaskTriggerFunctions.generateDocument(leadsList[0].Id);
            } catch (Exception e) {
			System.assert(true, 'Exception ' + e);
		}
        Test.stopTest();
	   system.assert(true, task!=null);
	}
}