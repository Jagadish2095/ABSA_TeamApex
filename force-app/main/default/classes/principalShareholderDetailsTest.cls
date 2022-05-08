@isTest
public class principalShareholderDetailsTest {
	public static Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	@testSetup
	static void dataCreation() {
		Account account = new Account();
		account.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
		account.Name = 'TEST MR JA & TEST MRS J';
		account.Client_Type__c = 'Joint & Several';
		account.CASA_Reference_Number__c = '1712994';
		account.CASA_Risk_Status__c = 'Low';
		account.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
		account.CASA_Screening_Status__c = 'Approved';
		account.CASA_Analyst_Comments__c = '30406';
		account.CIF__c = 'NAIARA+002';
		account.Country_of_Registration__c = 'South Africa';
		account.Is_the_Client_a_Non_resident__c = false;
		account.Is_the_Client_a_Temporary_Resident__c = false;
		account.Months_Actively_Involved_In_The_Business__c = '300';
		account.Number_Of_YearIn_The_Specific_Industry__c = '15';
        insert account;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
        insert testOpp;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

		Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = testOpp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
        insert oppLineItem;

		Application__c app = new Application__c();
		app.Opportunity__c = testOpp.id;
		app.Highest_Qualification__c = 'The Degree';
		app.Residential_Address__c = '';
		app.Number_Of_YearIn_The_Specific_Industry__c = '';
        app.Months_Actively_Involved_In_The_Business__c = '';
        app.Is_Principal_Shareholder_Info_Correct__c = false;
        insert app;

		Account accountPrs = new Account();
        accountPrs.FirstName = 'Test';
        accountPrs.LastName = 'Contact';
        accountPrs.PersonTitle = 'Mr.';
        accountPrs.CASA_Reference_Number__pc = '1712994';
        accountPrs.CASA_Risk_Status__pc = 'Low';
        accountPrs.CASA_Screening_Date__pc = Date.valueOf('2018-06-30');
        accountPrs.CASA_Screening_Status__pc = 'Approved';
        accountPrs.CASA_Analyst_Comments__pc = '30406';
        accountPrs.Occupation__pc = 'South Africa';
		accountPrs.Income_Source__pc = 'Bonus';
        accountPrs.Occupation_Status__pc = 'Full Time Employed';
        accountPrs.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        accountPrs.Occupation_Category__pc = 'Advertising';
        accountPrs.Communication_Language__pc = 'Afrikaans';
        accountPrs.ID_Type__pc = 'SA Identity Document';
        accountPrs.Nationality__pc = 'South Africa';
        accountPrs.Country_of_Origin__pc = 'South Africa';
        accountPrs.Country_of_Residence__pc = 'South Africa';
        accountPrs.Country_of_Birth__pc = 'South Africa';
        accountPrs.PersonMobilePhone = '0747003747';
        accountPrs.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        accountPrs.ShippingCity = 'CAPE TOWN';
        accountPrs.ShippingCountry = 'South Africa';
        accountPrs.ShippingStreet = '01 PUERTA DEL SOL';
        accountPrs.ShippingPostalCode = '8001';
        accountPrs.BillingCity = 'GROBLERSDAL';
        accountPrs.BillingCountry = 'South Africa';
        accountPrs.BillingStreet = '01 MABOPANE SECTION';
        accountPrs.BillingPostalCode = '1060';
        insert accountPrs;

		Id accountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :accountPrs.Id].PersonContactId;

		AccountContactRelation acr1 = new AccountContactRelation();
		acr1.AccountId = account.Id;
		acr1.ContactId = accountContactId;
		acr1.Roles = 'Contact Person';
		acr1.Share_Percentage__c = 10;
        insert acr1;

		Application_Principal__c appPrin = new Application_Principal__c();
		appPrin.AccConRelId__c = acr1.Id;
		appPrin.Application__c = app.Id;
		appPrin.Casa_Reference__c = acr1.Contact.CASA_Reference_Number__c;
		appPrin.Casa_Result__c = acr1.Contact.CASA_Screening_Status__c;
		appPrin.CIF__c = acr1.Contact.CIF__c;
		appPrin.Controlling_Interest__c = acr1.Share_Percentage__c;
        appPrin.Id_Number__c = acr1.Contact.ID_Number__c;
        appPrin.ID_Type__c = acr1.Contact.ID_Type__c;
		appPrin.Main__c = true;
		appPrin.Is_Part_Of_Application__c = true;
		appPrin.Principal_Shareholder_Name__c = String.valueOf(acr1.Contact.FirstName + ' ' + acr1.Contact.LastName);
        insert appPrin;

		Account accountPrs2 = new Account();
        accountPrs2.FirstName = 'Test';
        accountPrs2.LastName = 'Contact';
        accountPrs2.PersonTitle = 'Mr.';
        accountPrs2.CASA_Reference_Number__pc = '1712994';
        accountPrs2.CASA_Risk_Status__pc = 'Low';
        accountPrs2.CASA_Screening_Date__pc = Date.valueOf('2018-06-30');
        accountPrs2.CASA_Screening_Status__pc = 'Approved';
        accountPrs2.CASA_Analyst_Comments__pc = '30406';
        accountPrs2.Occupation__pc = 'South Africa';
		accountPrs2.Income_Source__pc = 'Bonus';
        accountPrs2.Occupation_Status__pc = 'Full Time Employed';
        accountPrs2.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        accountPrs2.Occupation_Category__pc = 'Advertising';
        accountPrs2.Communication_Language__pc = 'Afrikaans';
        accountPrs2.ID_Type__pc = 'SA Identity Document';
        accountPrs2.Nationality__pc = 'South Africa';
        accountPrs2.Country_of_Origin__pc = 'South Africa';
        accountPrs2.Country_of_Residence__pc = 'South Africa';
        accountPrs2.Country_of_Birth__pc = 'South Africa';
        accountPrs2.PersonMobilePhone = '0747003747';
        accountPrs2.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        accountPrs2.ShippingCity = 'CAPE TOWN';
        accountPrs2.ShippingCountry = 'South Africa';
        accountPrs2.ShippingStreet = '01 PUERTA DEL SOL';
        accountPrs2.ShippingPostalCode = '8001';
        accountPrs2.BillingCity = 'GROBLERSDAL';
        accountPrs2.BillingCountry = 'South Africa';
        accountPrs2.BillingStreet = '01 MABOPANE SECTION';
        accountPrs2.BillingPostalCode = '1060';
		insert accountPrs2;

		accountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :accountPrs2.Id].PersonContactId;

		AccountContactRelation acr2 = new AccountContactRelation();
		acr2.AccountId = account.Id;
		acr2.ContactId = accountContactId;
		acr2.Roles = 'Contact Person';
        acr2.Share_Percentage__c = 5;
        insert acr2;

		Application_Principal__c appPrin2 = new Application_Principal__c();
		appPrin2.AccConRelId__c = acr2.Id;
		appPrin2.Application__c = app.Id;
		appPrin2.Casa_Reference__c = acr2.Contact.CASA_Reference_Number__c;
		appPrin2.Casa_Result__c = acr2.Contact.CASA_Screening_Status__c;
		appPrin2.CIF__c = acr2.Contact.CIF__c;
		appPrin2.Controlling_Interest__c = acr2.Share_Percentage__c;
        appPrin2.Id_Number__c = acr2.Contact.ID_Number__c;
        appPrin2.ID_Type__c = acr2.Contact.ID_Type__c;
		appPrin2.Main__c = false;
		appPrin2.Is_Part_Of_Application__c = true;
		appPrin2.Principal_Shareholder_Name__c = String.valueOf(acr2.Contact.FirstName + ' ' + acr2.Contact.LastName);
        insert appPrin2;

		IntegrationTestDataFactory.insertIntegrationTranslations();
	}

	static testMethod void testAllGetMethods() {
		Map<String,Id> mapIds = getTestInfo();

		Test.startTest();
		System.assertEquals(principalShareholderDetails.getApplication(mapIds?.get('OppId')) != null, true);
		System.assertEquals(principalShareholderDetails.getRelatedParties(mapIds?.get('OppId'), false).isEmpty(), false);
		System.assertEquals(principalShareholderDetails.getSelectedParties(mapIds?.get('AccRel')).isEmpty(), false);
		Test.stopTest();
	}

	static testMethod void testUpdateMethods() {
        Map<String,Id> mapIds = getTestInfo();
		List<Id> selectedIDs = new List<Id>{mapIds?.get('AccMain')};
		List<Id> selNewIDs = new List<Id>{mapIds?.get('AccMain'), mapIds?.get('AccRel')};

        Test.startTest();
        System.assertEquals(principalShareholderDetails.principalCasaScreening(mapIds?.get('OppId')) != null, true);
        System.assertEquals(principalShareholderDetails.updatePrincipals(mapIds?.get('OppId'), selectedIDs, mapIds?.get('AccMain'), true), 'SUCCESS');
		System.assertEquals(principalShareholderDetails.getRelatedParties(mapIds?.get('OppId'), false).isEmpty(), false);
        String result = principalShareholderDetails.updateInformation(mapIds?.get('AccRel'), 'Degree', '664', '3', '12','30', '2021-02-21', true, true);
		System.assertEquals(result, 'Principal Details Updated Successfully!');
		Test.stopTest();
    }

    static Map<String,Id> getTestInfo() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		AccountContactRelation accMain = [SELECT Id FROM AccountContactRelation WHERE Share_Percentage__c = 10 LIMIT 1];
        AccountContactRelation accRel = [SELECT Id FROM AccountContactRelation WHERE Share_Percentage__c = 5 LIMIT 1];

        return new Map<String,Id>{'OppId' => opp.Id,'AccMain' => accMain.Id,'AccRel' => accRel.Id};
    }
}