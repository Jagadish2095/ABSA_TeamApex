/**
 * @description       : This is the Test Class for the ChequeAndOverdraftController
 * @author            : Englarmerdge Mongwe
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Englarmerdge Mongwe   Initial Version
 **/

@isTest
public class ChequeAndOverdraftControllerTest {
	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@testSetup
	public static void dataCreation() {
		ClientDetailsSectionCreditTest.dataCreation();

		IntegrationTestDataFactory.insertIntegrationSettings(ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME,new List<String>{ ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(CQgetOverdraftDetailsV4_IH_v1.INTEGRATION_SERVICE_NAME,new List<String>{ CQgetOverdraftDetailsV4_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(CQgetClientConductV3_IH_v1.INTEGRATION_SERVICE_NAME,new List<String>{ CQgetClientConductV3_IH_v1.INTEGRATION_SERVICE_NAME });

		Encrypt_Decrypt__c setting = Encrypt_Decrypt__c.getOrgDefaults();
		Blob cryptoKey = Crypto.generateAesKey(256);
		setting.Crypto_Key__c = EncodingUtil.base64Encode(cryptoKey);
		insert setting;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testGetLinkedChequeAccounts() {
		Test.startTest();
		System.assert((ChequeAndOverdraftController.getLinkedChequeAccounts(oppData().Id) != null));
		System.assert((ChequeAndOverdraftController.getPickListItems() != null));
		Test.stopTest();
	}
	/**
	 * @description deleteSelectedConductAndFacilityAccount
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testdeleteSelectedConductAndFacilityAccount() {
		Test.startTest();
		System.assert((ChequeAndOverdraftController.deleteSelectedConductAndFacilityAccount(oppData().Id) == true));
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testGetAndSaveClientConductDetailsUpsert() {
		CQgetClientConductV3_IH_v1_Test.conductTestMock();

		Test.startTest();
		System.assert((ChequeAndOverdraftController.getAndSaveClientConductDetails(oppData().Id, codData()) != null));
		addConductData(appData().Id);
		System.assert((ChequeAndOverdraftController.getAndSaveClientConductDetails(oppData().Id, codData()) != null));
		String conduct = 'Additional Conduct';
		System.assert((ChequeAndOverdraftController.getClientConduct(oppData().Id, conduct) != null));
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe| 2021-06-12
	 **/
	@isTest
	public static void testGetChequeAndOverdraftCheque() {
		Test.startTest();
		addOverdraftProduct(oppData().Id, true, true);
		System.assert((ChequeAndOverdraftController.getChequeAndOverdraft(oppData().Id, true) != null));
		addOverdraftProduct(oppData().Id, true, false);
		System.assert((ChequeAndOverdraftController.getChequeAndOverdraft(oppData().Id, false) != null));
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **
	@isTest
	public static void testGetBasicAccountDetailsApi() {
		ChequeServicesOrchestration_IH_v1_Test.orchestrationTestMock();
		User user = [SELECT Id, UserRoleId, SiteCode__c, Supervisor__c, SiteType__c, Division__c FROM User LIMIT 1];

		Test.startTest();
		System.assertEquals(200, ocherCallHandlerMethod(user).statusCode);
		Test.stopTest();
	}*/

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testGetOverdraftDetailsApi() {
		CQgetOverdraftDetailsV4_IH_v1_Test.overdraftTestMock();

		Test.startTest();
		System.assertEquals(200, ovdrtCallHandlerMethod().statusCode);
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testGetClientConductDetailsApi() {
		CQgetClientConductV3_IH_v1_Test.conductTestMock();
		User user = [SELECT Id, UserRoleId, SiteCode__c, SiteType__c, Supervisor__c, Division__c FROM User LIMIT 1];

		Test.startTest();
		System.assertEquals(200, condCallHandlerMethod(user).statusCode);
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe| 2021-06-12
	 **/
	@isTest
	public static void testGetDeleteTempChequeId() {
		Test.startTest();
		addOverdraftProduct(oppData().Id, true, true);
		String objData = ChequeAndOverdraftController.getTempChequeId(oppData().Id, 0);
		System.assert((objData != null));

		if (objData != null) {
			System.debug('itemId: ' + itemId(objData));
			System.assert((ChequeAndOverdraftController.deleteNewChequeTempId(itemId(objData)) != null));
		}
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 **/
	@isTest
	public static void testSaveChequeAndOverdraft() {
		addOverdraftProduct(oppData().Id, false, null);
		String objDataNew = ChequeAndOverdraftController.getTempChequeId(oppData().Id, 0);
		String itemId = itemId(objDataNew);
		String accountNo1 = ChequeAndOverdraftController.encryptDecryptString('4047854674', true);
		String objData =
			'[{"CurChqAndOvrDft":[{"VariableData":[{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"1"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"2"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"3"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"4"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"5"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"6"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"7"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"8"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"9"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"10"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"11"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"12"}],"SecuredByMortgageBond":false,"OverdraftPurpose":"1","OverdraftLimitNewAmount":900000,"LimitType":"Fixed","CampaignCode":"hey","ApplicationProductChild":"a1i3N000000JhDrQAK","AlternativeFundIndicator":false,"AlternativeFundCode":"999","SevRestrictiveHold":"GET-PSTADD, INSOL/LIQU, SIGN-HELD, BAD-DEBT, HIGH RISK, INS, BDH, SEC:NONE","SevEncrytepAccountNumber":"' +
			accountNo1 +
			'","SevCurrentODLimit":"R 0.00","SevAlternativeFundIndicator":"NO","SevAccountTypeCode":"11019","SevAccountType":"Business Growing","SevAccountNameNumber":"Business Growing (1000157283)","SevAccountBalance":"R -6109596.34","ItemId":1,"IsSavedAccount":true,"IsPrimaryConduct":true,"IsDeleteAccount":false,"IsAdditionalConduct":false,"Id":"a1i3N000000JhDqQAK"}]},{"NewChqAndOvrDft":[{"VariableData":[{"MaxDate":"2022-01-23","MinDate":"2021-01-24","VariableDate":"2021-02-01","VariableAmount":"50000.00","Id":"1"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","VariableDate":"2021-02-16","VariableAmount":"50000.00","Id":"2"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"3"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"4"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"5"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"6"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"7"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"8"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"9"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"10"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"11"},{"MaxDate":"2022-01-23","MinDate":"2021-01-24","Id":"12"}],"TempAccountNumber":"0000000917","SecuredByMortgageBond":false,"OverdraftPurpose":"2","OverdraftLimitNewAmount":100000,"LimitType":"Variable","CampaignCode":"yup","ApplicationProductChild":"a1i3N000000JhDCQA0","AlternativeFundIndicator":false,"AlternativeFundCode":"002","ItemId":1,"Id":"' +
			itemId +
			'","ChequeProductType":"11016"}]}]';
		//String objData1 = '[{"CurChqAndOvrDft":[{"VariableData":[{"VariableDate":"2020-10-01","VariableAmount":10000,"Id":"1"},{"VariableDate":"2020-09-15","VariableAmount":10000,"Id":"2"},{"VariableDate":"2020-09-30","VariableAmount":10000,"Id":"3"},{"Id":"4"},{"Id":"5"},{"Id":"6"},{"Id":"7"},{"Id":"8"},{"Id":"9"},{"Id":"10"},{"Id":"11"},{"Id":"12"}],"SecuredByMortgageBond":false,"OverdraftPurpose":"2","OverdraftLimitNewAmount":"100000","LimitType":"Variable","CampaignCode":"567","AlternativeFundIndicator":true,"AlternativeFundCode":"jerr","SevRestrictiveHold":"DIGITAL-HLD, HIGH RISK, SEC:NONE","SevFacilityReviewDate":"0","SevExpiryDate":"0","SevEncrytepAccountNumber":"' + accountNo1 + '","SevCurrentODLimit":"R 0","SevBranchCode":"5920","SevAlternativeFundIndicator":"YES","SevAlternativeFundCode":"","SevAccountType":"CLASSIC BUSINESS ACCOUNT","SevAccountNameNumber":"Household Bills (**** 9487)","SevAccountBalance":"R 0","ItemId":1}]},{"NewChqAndOvrDft":[{"VariableData":[{"Id":"1"},{"Id":"2"},{"Id":"3"},{"Id":"4"},{"Id":"5"},{"Id":"6"},{"Id":"7"},{"Id":"8"},{"Id":"9"},{"Id":"10"},{"Id":"11"},{"Id":"12"}],"TempAccountNumber":"CHQ-0000000249","SecuredByMortgageBond":true,"ReductionFrequency":"Bi-weekly","ReductionDate":"2020-09-15","ReductionAmount":100000,"OverdraftPurposeOther":"rtretret","OverdraftPurpose":"99","OverdraftLimitNewAmount":5656254,"OnceOffDate":"2020-09-01","OnceOffAmount":100000,"LimitType":"Reducing - Once Off And Recurring","CampaignCode":"erer","ApplicationProductChild":"'+ itemId +'","AlternativeFundIndicator":true,"AlternativeFundCode":"yup","ItemNum":1,"Id":"'+ itemId +'","ChequeProductType":"BUSINESS ESSENTIALS ACCOUNT"}]}]';
		//String objData = '[{"NewChqAndOvrDft":[{"VariableData":[{"VariableDate":"2020-10-01","VariableAmount":10000,"Id":"1"},{"VariableDate":"2020-09-15","VariableAmount":10000,"Id":"2"},{"VariableDate":"2020-09-30","VariableAmount":10000,"Id":"3"},{"Id":"4"},{"Id":"5"},{"Id":"6"},{"Id":"7"},{"Id":"8"},{"Id":"9"},{"Id":"10"},{"Id":"11"},{"Id":"12"}],"SecuredByMortgageBond":false,"OverdraftPurpose":"2","OverdraftLimitNewAmount":"100000","LimitType":"Variable","CampaignCode":"567","AlternativeFundIndicator":true,"AlternativeFundCode":"jerr","SevRestrictiveHold":"DIGITAL-HLD, HIGH RISK, SEC:NONE","SevFacilityReviewDate":"0","SevExpiryDate":"0","SevEncrytepAccountNumber":"' + accountNo1 + '","SevCurrentODLimit":"R 0","SevBranchCode":"5920","SevAlternativeFundIndicator":"YES","SevAlternativeFundCode":"","SevAccountType":"CLASSIC BUSINESS ACCOUNT","SevAccountNameNumber":"Household Bills (**** 9487)","SevAccountBalance":"R 0","ItemId":1}]},{"NewChqAndOvrDft":[{"VariableData":[{"Id":"1"},{"Id":"2"},{"Id":"3"},{"Id":"4"},{"Id":"5"},{"Id":"6"},{"Id":"7"},{"Id":"8"},{"Id":"9"},{"Id":"10"},{"Id":"11"},{"Id":"12"}],"TempAccountNumber":"CHQ-0000000249","SecuredByMortgageBond":true,"ReductionFrequency":"Bi-weekly","ReductionDate":"2020-09-15","ReductionAmount":100000,"OverdraftPurposeOther":"rtretret","OverdraftPurpose":"99","OverdraftLimitNewAmount":5656254,"OnceOffDate":"2020-09-01","OnceOffAmount":100000,"LimitType":"Reducing - Once Off And Recurring","CampaignCode":"erer","ApplicationProductChild":"'+ itemId +'","AlternativeFundIndicator":true,"AlternativeFundCode":"yup","ItemNum":1,"Id":"'+ itemId +'","ChequeProductType":"BUSINESS ESSENTIALS ACCOUNT"}]}]';
		List<Map<String, String>> variableData;

		Test.startTest();
		ChequeAndOverdraftController.Overdraft ovd = new ChequeAndOverdraftController.Overdraft(
			'Testing1',
			false,
			'Testing2',
			'Testing3',
			'Testing4',
			0.00,
			Date.today(),
			0.00,
			'Testing5',
			'Testing6',
			0.00,
			Date.today(),
			'Testing7',
			'Testing8',
			true,
			'Testing9',
			variableData
		);
		Map<String, String> mapObj = ChequeAndOverdraftController.saveChequeAndOverdraft(oppData().Id, objData);
		System.debug('mapObj::: ' + mapObj);
		System.assert(!mapObj.isEmpty());
		Test.stopTest();
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @param oppId
	 * @param addParent
	 * @param isCurrCheque
	 **/
	private static void addOverdraftProduct(String oppId, Boolean addParent, Boolean isCurrCheque) {
		Application_Product__c apc = new Application_Product__c();
		apc.Opportunity_Product_Id__c = oppId;
		apc.Opportunity__c = oppId;
		apc.Annual_Turnover__c = 11000000;
		apc.Asset_Value__c = 200000000;
		apc.IsMainProduct__c = true;
		insert apc;

		if (addParent) {
			Application_Product__c apc1 = new Application_Product__c();
			apc1.Opportunity_Product_Id__c = oppId;
			apc1.Opportunity__c = oppId;

			if (isCurrCheque) {
				apc1.Account_Number__c = Decimal.valueOf('4047854674');
				apc1.Account_Balance__c = 200000000;
			}

			apc1.IsMainProduct__c = false;
			insert apc1;

			apc.Application_Product_Parent__c = apc1.Id;
			update apc;
		}
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @param appId
	 **/
	public static void addConductData(String appId) {
		Application_Financial_Conduct__c appFinCon = new Application_Financial_Conduct__c();
		appFinCon.Application__c = appId;
		appFinCon.Balance__c = 10000;
		appFinCon.Conduct_Type__c = 'Primary Conduct';
		appFinCon.Account_Name_Number__c = '4047854674';
		insert appFinCon;

		appFinCon = new Application_Financial_Conduct__c();
		appFinCon.Application__c = appId;
		appFinCon.Balance__c = 105000;
		appFinCon.Conduct_Type__c = 'Additional Conduct';
		appFinCon.Account_Name_Number__c = '4050797102';
		insert appFinCon;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @return String
	 **/
	private static String codData() {
		String accountNo1 = ChequeAndOverdraftController.encryptDecryptString('4047854674', true),
			accountNo2 = ChequeAndOverdraftController.encryptDecryptString('4050797102', true);
		String objData =
			'[{"conductType":"Primary Conduct","accountNo":"' +
			accountNo1 +
			'","branchCode":"8198"},{"conductType":"Additional Conduct","accountNo":"' +
			accountNo2 +
			'","branchCode":"8788"}]';
		return objData;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @return Application__c
	 **/
	private static Application__c appData() {
		Opportunity opp = oppData();
		Application__c app = [SELECT Id, Name FROM Application__c WHERE Opportunity__c = :opp.Id LIMIT 1];
		return app;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @return Opportunity
	 **/
	private static Opportunity oppData() {
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
		return opp;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @param objData
	 * @return String
	 **/
	private static String itemId(String objData) {
		Map<String, Object> mapObjNew = (Map<String, Object>) JSON.deserializeUntyped(objData);
		String itemId = (String) mapObjNew.get('Id');
		return itemId;
	}

	private static ChequeServicesOrchestration_Resp_IB_v1 ocherCallHandlerMethod(User user) {
		ChequeServicesOrchestration_Resp_IB_v1 resp = ChequeAndOverdraftController.getBasicAccountDetailsService(oppData().Id, user);
		return resp;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @return CQgetOverdraftDetailsV4_Resp_IB_v1
	 **/
	private static CQgetOverdraftDetailsV4_Resp_IB_v1 ovdrtCallHandlerMethod() {
		CQgetOverdraftDetailsV4_Req_IB_v1 dummyBeanParent = CQgetOverdraftDetailsV4_Req_IB_v1.createDummyRequest();
		CQgetOverdraftDetailsV4_Req_IB_v1.Cqh478i reqBean = dummyBeanParent.CQgetOverdraftDetailsV4.cqh478i;
		CQgetOverdraftDetailsV4_Resp_IB_v1 resp = ChequeAndOverdraftController.getOverdraftDetailsService(
			reqBean.accountNbr,
			reqBean.processingSite,
			reqBean.processingSiteType,
			reqBean.tellerNbr,
			reqBean.agencyCode,
			reqBean.agencyType,
			reqBean.controllerNbr,
			reqBean.corpCode
		);
		return resp;
	}

	/**
	 * @description
	 * @author Englarmerdge Mongwe | 2021-06-12
	 * @param user
	 * @return CQgetClientConductV3_Resp_IB_v1
	 **/
	private static CQgetClientConductV3_Resp_IB_v1 condCallHandlerMethod(User user) {
		String accountNbr = '4048017641', branchCode = '8198';
		CQgetClientConductV3_Resp_IB_v1 resp = ChequeAndOverdraftController.getClientConductDetailsService(accountNbr, branchCode, user);
		return resp;
	}
}