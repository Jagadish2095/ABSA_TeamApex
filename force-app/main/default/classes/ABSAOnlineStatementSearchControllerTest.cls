/**
 * @description Controller Test Class for Lightning Component ABSAOnlineStatementSearch
 * @updated by Humbelani Denge
 **/
@isTest
private class ABSAOnlineStatementSearchControllerTest {
	@isTest
	static void getCIFValueTest() {
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;
		String clientaccountId = String.valueOf(acc.Id);
		Test.startTest();
		String cif = ABSAOnlineStatementSearchController.getCIFValue(clientaccountId);
		Test.stopTest();
		System.assertEquals('HJKLL', cif, 'Assert Failed');
	}

	@isTest
	static void getAccountDetailsTest() {
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ABSAOnlineStatementSearch_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ABSAOnlineStatementSearch_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		List<Integration_Translation__c> integrationTranslationList = new List<Integration_Translation__c>();
		Integration_Translation__c accountTypeTransaltion1 = new Integration_Translation__c();
		accountTypeTransaltion1.Name = 'ML';
		accountTypeTransaltion1.Internal_Value__c = 'ML';
		accountTypeTransaltion1.External_Value__c = '10';
		accountTypeTransaltion1.System_Name__c = StringConstants.EPS_STRING;
		accountTypeTransaltion1.Value_Type__c = StringConstants.ACCOUNT_TYPE;
		accountTypeTransaltion1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTranslationList.add(accountTypeTransaltion1);

		insert integrationTranslationList;
		Test.startTest();
		ABSAOnlineStatementSearch_Resp_IB_v1 response = ABSAOnlineStatementSearchController.getAccountDetails(
			'798111',
			'ML',
			String.valueOf(System.Today()),
			String.valueOf(System.Today().addDays(30)),
			'' + acc.CIF__c,
			true
		);
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'Assert Failed');
	}

	@isTest
	static void pdfFileServiceTest() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ABSAOnlineStatementDownload_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ABSAOnlineStatementDownload_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;
		String selectedAccNumber = '798111';

		List<Integration_Translation__c> integrationTranslationList = new List<Integration_Translation__c>();
		Integration_Translation__c accountTypeTransaltion = new Integration_Translation__c();
		accountTypeTransaltion.Name = 'CQ';
		accountTypeTransaltion.Internal_Value__c = 'CQ';
		accountTypeTransaltion.External_Value__c = '1';
		accountTypeTransaltion.System_Name__c = StringConstants.EPS_STRING;
		accountTypeTransaltion.Value_Type__c = StringConstants.ACCOUNT_TYPE;
		accountTypeTransaltion.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTranslationList.add(accountTypeTransaltion);

		insert integrationTranslationList;
		String endDate = String.valueOf(System.Today().addDays(30));
		Test.startTest();
		ABSAOnlineStatementDownload_Resp_IB_v1 response = ABSAOnlineStatementSearchController.pdfFileService(
			String.valueOf(acc.Id),
			'TEST00',
			String.valueOf(System.Today()),
			'CQ',
			selectedAccNumber,
			'List-ref',
			true
		);
		Test.stopTest();
		system.assertEquals(200, response.statusCode, 'Assert Failed');
	}

	@isTest
	static void statementDownloadTest() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ABSAOnlineStatementDownload_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ABSAOnlineStatementDownload_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'ZJKLL';
		acc.Client_Type__c = 'Trusts';
		acc.Trust_Number__c = '345234';
		insert acc;

		List<Integration_Translation__c> integrationTranslationList = new List<Integration_Translation__c>();
		Integration_Translation__c accountTypeTransaltion = new Integration_Translation__c();
		accountTypeTransaltion.Name = 'ML';
		accountTypeTransaltion.Internal_Value__c = 'ML';
		accountTypeTransaltion.External_Value__c = '10';
		accountTypeTransaltion.System_Name__c = 'RSD';
		accountTypeTransaltion.Value_Type__c = StringConstants.ACCOUNT_TYPE;
		accountTypeTransaltion.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		integrationTranslationList.add(accountTypeTransaltion);

		insert integrationTranslationList;
		String endDate = String.valueOf(System.Today().addDays(30));
		Test.startTest();
		ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = ABSAOnlineStatementSearchController.statementDownload(
			String.valueOf(acc.Id),
			acc.CIF__c,
			String.valueOf(System.Today()),
			'ML',
			'798111',
			'List-Ref'
		);
		Test.stopTest();
		system.assertEquals(200, responseBean.statusCode, 'Assert Failed');
	}

	@isTest
	static void testWithBlankABnumber() {
		User usr = [SELECT Id FROM User WHERE AB_Number__c = :null AND IsActive = :true LIMIT 1];
		List<String> accList = new List<String>{ '00073552449' };

		System.runAs(usr) {
			Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
					StringConstants.POSITIVE_STRING,
					BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
				)
			);

			String result = ABSAOnlineStatementSearchController.getAccountCategory(accList[0]);
			Test.stopTest();

			System.assert(result.StartsWith('Error:'), 'Assert failed');
		}
	}
}