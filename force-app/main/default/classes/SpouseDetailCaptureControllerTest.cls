/**
 * @description       : Test Class For Spouse Detail Controller
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-06-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-10   almas.aleem@absa.africa   Initial Version
 * 2.0 2021-06-10
 **/
@isTest
public class SpouseDetailCaptureControllerTest{
	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@testSetup
	static void createTestData(){
		List<Account> accounts = new List<Account>();
		Account account = new Account();
		account.FirstName = 'Spouse Account';
		account.LastName = 'Spouse Account';
		account.Client_Type__c = 'Sole Trader';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.ID_Number__pc = '6410080035087';
		account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
		accounts.add(account);

		Account spouseAcc = new Account();
		spouseAcc.FirstName = 'Spouse Account';
		spouseAcc.LastName = 'Spouse Account';
		spouseAcc.Sic = '36798';
		spouseAcc.AccountNumber = '0';
		spouseAcc.ID_Number__pc = '7211190142089';
		spouseAcc.ID_Type__c = 'SA Identity Document';
		spouseAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
		accounts.add(spouseAcc);
		insert accounts;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp Onboarding 1';
		opp.CloseDate = Date.today();
		opp.StageName = 'New';
		opp.AccountId = account.Id;
		//opp.Spouse_Account_Id__c = spouseAcc.Id;
		insert opp;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;
		insert app;


		List<Application_Profile__c> appProfList = new List<Application_Profile__c>();
		Application_Profile__c appProf = new Application_Profile__c();
		appProf.Client_CIF_Code__c = account.CIF__c;
		appProf.Client_Name__c = account.Name;
		appProf.Application__c = app.Id;
		appProf.Applicant_Type__c = 'Spouse';
		appProf.Related_to_Client_ID_or_Reg_Number__c = account.Registration_Number__c;
		appProfList.add(appProf);

		appProf = new Application_Profile__c();
		appProf.Applicant_Type__c = null;
		appProf.Client_CIF_Code__c = 'AABK   007';
		appProf.Client_Name__c = account.Name;
		appProf.Application__c = app.Id;
		appProf.Related_to_Client_ID_or_Reg_Number__c = account.Registration_Number__c;
		appProfList.add(appProf);


		insert appProfList;
	}

	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testGetSpouseAccountNoSpouse(){
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
        
       
		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.getSpouseAccount(opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, spouseAcc, 'Account Found!');
	}

	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testGetSpouseAccountWithSpouse(){
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
		Account acc = [SELECT Id
		               FROM Account
		               WHERE Id_Number__pc = '7211190142089'];
		opp.Spouse_Account_Id__c = acc.Id;
		update opp;
        
         


		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.getSpouseAccount(opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, spouseAcc, 'Account Found!');
	}


	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testDelinkSpouseAccount(){
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
		Account acc = [SELECT Id
		               FROM Account
		               WHERE Id_Number__pc = '7211190142089'];
		opp.Spouse_Account_Id__c = acc.Id;
		update opp;

		String spouseAccStringNoAccId = '{"accId":"' + acc.Id + '","dateOfBirth":"1964-10-08","firstName":"SUSAN-ANN","idPassNum":"6410087735087","idType":"SA Identity Document","isSpouseContributing":true,"isUnderDebtCounselling":false,"lastName":"CLEMANS","oppId":"' + opp.Id + '"}';

		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.delinkSpouseAccount(spouseAccStringNoAccId, opp.id);
		Test.stopTest();

		System.assertNotEquals(null, spouseAcc, 'Account Delink!');
	}

	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testOppTriggerHandlerChanges(){

		Account acc = [SELECT Id
		               FROM Account
		               WHERE Id_Number__pc = '7211190142089'];
		acc.ExecutionLayerRequestID__c = acc.Id;
		update acc;

		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
        


		String spouseAccStringNoAccId = '{"accId":"' + acc.Id + '","dateOfBirth":"1964-10-08","firstName":"SUSAN-ANN","idPassNum":"6410087735087","idType":"SA Identity Document","isSpouseContributing":true,"isUnderDebtCounselling":false,"lastName":"CLEMANS","oppId":"' + opp.Id + '"}';

		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.delinkSpouseAccount(spouseAccStringNoAccId, opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, opp, 'Opp Found!');
	}

	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testOppTriggerHandlerChangesClosedOpp(){

		Account acc = [SELECT Id
		               FROM Account
		               WHERE Id_Number__pc = '7211190142089'];
		acc.ExecutionLayerRequestID__c = acc.Id;
		update acc;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp Onboarding 1';
		opp.CloseDate = Date.today();
		opp.StageName = 'Closed';
		opp.QA_Complex_Approval_Status__c = 'Submitted';
		opp.AccountId = acc.Id;
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Credit_Onboarding').getRecordTypeId();
		opp.Spouse_Account_Id__c = acc.Id;
		opp.VC_Application_Number__c = 'RBB12345678';
		insert opp;
		System.assertNotEquals(null, opp, 'Opp Found!');
	}
    
    	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testSaveSpouseAccountWithAccId(){
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
		Account acc = [SELECT Id
		               FROM Account
		               WHERE Id_Number__pc = '7211190142089'];
		String spouseAccString = '{"accId":"' + acc.Id + '","dateOfBirth":"1964-10-08","firstName":"SUSAN-ANN","idPassNum":"7211190142089","idType":"SA Identity Document","isSpouseContributing":true,"isUnderDebtCounselling":false,"lastName":"CLEMANS","oppId":"' + opp.Id + '"}';

        Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;
		insert app;
        
		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.saveSpouseAccount(spouseAccString, opp.id);
		Test.stopTest();

		System.assertNotEquals(null, spouseAcc, 'Account Found!');
	}

	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-10
	 **/
	@isTest
	public static void testSaveSpouseAccountNoAccId(){
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c
		                   FROM Opportunity
		                   LIMIT 1];
        /*
        Account acc = [Select id from Account where id =:opp.Spouse_Account_Id__c ];
        
        if(acc != Null){
            acc.CIF__c = 'ABC  1234';
            update acc;
        } */
        List<Application__c> appc  = [Select id from Application__c where Opportunity__c =: opp.id  ];
        system.debug('appc record'+appc);
        /*Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;
		insert app; */
        
		Application_Profile__c appProf = new Application_Profile__c();
		appProf.Client_CIF_Code__c = 'TEST   123';
		appProf.Client_Name__c = 'SUSAN-ANN CLEMANS';
		appProf.Application__c = appc[0].Id;
		appProf.Applicant_Type__c = 'Spouse';
		appProf.Related_to_Client_ID_or_Reg_Number__c = '6410087735087';

		insert appProf;
        
        
		String spouseAccStringNoAccId = '{"accId":"","dateOfBirth":"1964-10-08","firstName":"SUSAN-ANN","idPassNum":"6410087735087","idType":"SA Identity Document","isSpouseContributing":true,"isUnderDebtCounselling":false,"lastName":"CLEMANS","oppId":"' + opp.Id + '"}';

		Test.startTest();
		SolePropSpouseDetailCaptureController.SpouseAccount spouseAcc = SolePropSpouseDetailCaptureController.saveSpouseAccount(spouseAccStringNoAccId, opp.id);
		Test.stopTest();

		System.assertNotEquals(null, spouseAcc, 'Account Found!');
	}

}