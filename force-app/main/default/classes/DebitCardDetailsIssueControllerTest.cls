/**
 * @description       :
 * @author            : André Pietersen (IQ Business)
 * @group             :
 * @last modified on  : 2021-10-18
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   05-19-2021   Brian Maswanganyi    Initial Version
 * 1.1   09-06-2021   Brian Maswanganyi    Add Delivery Method
 * 1.2   09-06-2021   André Pietersen (IQ Business)    Added card issued status field
 **/
@isTest
public with sharing class DebitCardDetailsIssueControllerTest {
	public static final String POSITIVE_RESPONSE_BODY_BRANDS = '{"wsd_CClistCombiBrandsForPreferredProductV1Response": {        "nbsapdpo": {            "returnCode": "0",            "reasonCode": "0",            "serviceVersion": "BUSO001"        },        "nbsmsgo": {            "nbrUserMsgs": "0",            "nbrUserErrs": "0",            "msgEntry": {                "msgClass": null,                "msgCode": null,                "msgErrInd": null,                "msgTxt": null            }        },        "ccp306o": {            "prodRetrvdInd": "Y",            "nbrBrandRet": "14",            "prdBrandDetails": {                "prdBrandLst": [                    {                        "brandNbr": "2147",                        "brandSeq": "1",                        "brandType": "DM",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2812",                        "brandSeq": "2",                        "brandType": "VA",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2324",                        "brandSeq": "5",                        "brandType": "BC",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2498",                        "brandSeq": "6",                        "brandType": "BK",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2826",                        "brandSeq": "7",                        "brandType": "ZD",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2830",                        "brandSeq": "8",                        "brandType": "ZH",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2630",                        "brandSeq": "9",                        "brandType": "BW",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2698",                        "brandSeq": "11",                        "brandType": "PG",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2699",                        "brandSeq": "12",                        "brandType": "PP",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2629",                        "brandSeq": "14",                        "brandType": "BU",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2141",                        "brandSeq": "15",                        "brandType": "DP",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2159",                        "brandSeq": "17",                        "brandType": "FF",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2618",                        "brandSeq": "18",                        "brandType": "BF",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    },                    {                        "brandNbr": "2847",                        "brandSeq": "19",                        "brandType": "YD",                        "brandSubType": "VF",                        "brandSegm": "O",                        "brandSubSegm": "O"                    }                ]            }        }    }}';
	public static final String POSITIVE_GHOST_RESPONSE_BODY_ISSUE = '{  "NBSAPDPO": {    "outputHeader": {      "version": "7.4.6",      "returnCode": 97,      "reasonCode": 58385591,      "serviceVersion": "roklo",      "echoKey": "kosripuhoj"    }  },  "NBSMSGO3": {    "outputErrorMessage": {      "version": "6.3.1",      "systemErrorText": "zicems",      "numberUserMessages": 0,      "numberUserErrors": 0,      "errorMessageTable": [        {          "errorMessageClass": "47",          "errorMessageCode": "18",          "errorMessageIndicator": "29",          "errorMessageText": "59"        },        {          "errorMessageClass": "46",          "errorMessageCode": "57",          "errorMessageIndicator": "62",          "errorMessageText": "32"        },        {          "errorMessageClass": "40",          "errorMessageCode": "18",          "errorMessageIndicator": "63",          "errorMessageText": "46"        },        {          "errorMessageClass": "59",          "errorMessageCode": "57",          "errorMessageIndicator": "43",          "errorMessageText": "49"        },        {          "errorMessageClass": "56",          "errorMessageCode": "20",          "errorMessageIndicator": "46",          "errorMessageText": "23"        }      ]    }  },  "CCS311O": {    "outputCopybook": {      "combiNumber": 773111596773111596,      "prtPassNumber": "773111596773111596",      "lvpNumber": 773111596773111596    }  }}';
	public static final String POSITIVE_GHOST_RESPONSE_BODY_ISSUE_DUPLICATE = '{  "NBSAPDPO": {    "outputHeader": {      "version": "7.4.6",      "returnCode": 97,      "reasonCode": 58385591,      "serviceVersion": "roklo",      "echoKey": "kosripuhoj"    }  },  "NBSMSGO3": {    "outputErrorMessage": {      "version": "6.3.1",      "systemErrorText": "",      "numberUserMessages": 1,      "numberUserErrors": 0,      "errorMessageTable": [        {          "errorMessageClass": "47",          "errorMessageCode": "18",          "errorMessageIndicator": "29",          "errorMessageText": "Combi 773111596773111596 card is already active."        },        {          "errorMessageClass": "46",          "errorMessageCode": "57",          "errorMessageIndicator": "62",          "errorMessageText": "32"        },        {          "errorMessageClass": "40",          "errorMessageCode": "18",          "errorMessageIndicator": "63",          "errorMessageText": "46"        },        {          "errorMessageClass": "59",          "errorMessageCode": "57",          "errorMessageIndicator": "43",          "errorMessageText": "49"        },        {          "errorMessageClass": "56",          "errorMessageCode": "20",          "errorMessageIndicator": "46",          "errorMessageText": "23"        }      ]    }  },  "CCS311O": {    "outputCopybook": {      "combiNumber": 773111596773111596,      "prtPassNumber": "773111596773111596",      "lvpNumber": 773111596773111596    }  }}';
	public static final String POSITIVE_RESPONSE_BODY_ISSUE = '{    "CCissueCombiCardV1Response": {        "nbsapdpo": {            "version": "",            "returnCode": "0",            "reasonCode": "0",            "serviceVersion": "BUSO001",            "echoKey": ""        },        "nbsmsgo3": {            "version": "",            "sysErrTxt": "",            "nbrUserMsgs": "0",            "nbrUserErrs": "0",            "msgEntry": [                {                    "msgClass": "CCS299",                    "msgCode": "0113",                    "msgErrInd": "E",                    "msgTxt": "Card number 4483860000145941 already exists on Combi system"                },                {                    "msgClass": "",                    "msgCode": "",                    "msgErrInd": "",                    "msgTxt": ""                },                {                    "msgClass": "",                    "msgCode": "",                    "msgErrInd": "",                    "msgTxt": ""                },                {                    "msgClass": "",                    "msgCode": "",                    "msgErrInd": "",                    "msgTxt": ""                },                {                    "msgClass": "",                    "msgCode": "",                    "msgErrInd": "",                    "msgTxt": ""                }            ]        },        "ccp348o": {            "cardIssueInd": "N",            "newCombiNbr": "00000000000000000",            "lvpApplNbr": "00000000000000000",            "cardFeeInd": "",            "cardFeeType": "",            "cardFeeAmnt": "0",            "delvFeeInd": "",            "delvFeeType": "",            "delvFeeAmnt": "0"        }    }}';
	public static final String POSITIVE_RESPONSE_BODY_GET_LIMITS = '{"CCgetDailyLimitsV2Response":{"ccp312o":{"cardCntLim":999999999,"cardCntMax":999999999,"cardCshLim":10,"cardCshMax":10000,"cardPosLim":10,"cardPosMax":500000,"cardTrfLim":110,"cardTrfMax":5000,"cheqApplNo":0,"cheqCshLim":0,"cheqNomAcc":0,"cheqPosLim":0,"cheqTrfLim":0,"limInd":"Y","savsApplNo":4483850000353637,"savsCshLim":10,"savsNomAcc":9050423693,"savsPosLim":10,"savsTrfLim":110},"nbsapdpo":{"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001"},"nbsmsgo":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';
	public static final String POSITIVE_RESPONSE_BODY_POST_LIMITS = '{"CCupdDailyTransactionLimitsV2Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"ccp321o":{"limRec":"Y"}}}';
	public static final String POSITIVE_RESPONSE_BODY_ACCOUNTS = '{"CClistNominatableAccountsV1Response":{"ccp315o":{"nomAccntLst":[{"accntNbr":4048376500,"prodCode":11003,"prodType":"CQ"},{"accntNbr":9051337380,"prodCode":9050,"prodType":"SA"}],"nomNbrAccntRet":2,"nomNxtAccnt":0},"nbsapdpo":{"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001"},"nbsmsgo":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';
	@testSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistCombiBrandsForPrefProdV1_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ CCIssueCombiCardV1_IH_v2.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ CCIssueV2_IH_v2.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistNominatableAccountsV1_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CCgetDailyLimitsV2_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CCUpdDailyTansactionLimitsV2_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
		insert prod;

		Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
		insert savingsprod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPrice;

		Account account = new Account();
		account.ID_Number__pc = '9308305015082';
		account.FirstName = 'TestCVSServicesHelper';
		account.LastName = 'Tester';
		account.Gender__pc = 'Male';
		account.Next_of_Kin_Last_Name__pc = 'Testing';
		account.Next_of_Kin_First_Name_s__pc = 'Testing';
		account.CIF__c = 'LTD 933';
		account.Language__c = 'english';
		account.Number_Of_Dependents__c = 0;
		account.PersonEmail = 'test@absa.africa';
		account.PersonMobilePhone = '0819908786';
		account.ID_Type__pc = 'PASSPORT';
		account.Nationality__pc = 'ZIM';
		account.Highest_Qualification__pc = 'Matric';
		account.Residential_Status__pc = 'Owner';
		account.Marital_Status__pc = 'MARRIED';
		account.CASA_Risk_Status__c = 'High';
		insert account;

		site__c siteRec = new site__c();
		//siteRec.Site_Code__c='1334';
		siteRec.Site_Code__c = '8474';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp Onboarding';
		opp.CloseDate = Date.today();
		opp.StageName = 'New';
		opp.Pricebook2Id = pb.id;
		opp.AccountId = account.id;
		opp.Site__c = siteRec.id;
		opp.CBPIndicator__c = '123456789';
		insert opp;

		Opportunity savingsOpportunity = new Opportunity();
		savingsOpportunity.Name = 'Test Savings Onboarding';
		savingsOpportunity.CloseDate = Date.today();
		savingsOpportunity.StageName = 'New';
		savingsOpportunity.Pricebook2Id = pb.id;
		savingsOpportunity.AccountId = account.id;
		savingsOpportunity.Site__c = siteRec.id;
		savingsOpportunity.CBPIndicator__c = '123456789';
		insert savingsOpportunity;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.id;
		app.Source_of_Funds__c = 'ALLOWANCE';
		insert app;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		oppLineItem.Policy_Number__c = '4048272164';
		insert oppLineItem;

		OpportunityLineItem savingsLineItem = new OpportunityLineItem();
		savingsLineItem.OpportunityId = savingsOpportunity.id;
		savingsLineItem.Product2Id = savingsprod.id;
		savingsLineItem.PricebookEntryId = savingsPrice.id;
		savingsLineItem.Quantity = 1;
		savingsLineItem.TotalPrice = 100;
		savingsLineItem.Policy_Number__c = '9051159122';
		insert savingsLineItem;

		Application_Product__c appSavingsProd = new Application_Product__c();
		appSavingsProd.Opportunity__c = savingsOpportunity.Id;
		appSavingsProd.Opportunity_Product_Id__c = savingsLineItem.Id;
		insert appSavingsProd;

		Application_Product__c appProd = new Application_Product__c();
		appProd.Opportunity__c = savingsOpportunity.Id;
		appProd.Opportunity_Product_Id__c = savingsLineItem.Id;
		appProd.Debit_Card_Number__c = 'TESTCARDNUM';
		insert appProd;

		Application_Product__c appProd2 = new Application_Product__c();
		appProd2.Opportunity__c = opp.Id;
		appProd2.Opportunity_Product_Id__c = oppLineItem.Id;
		appProd2.Debit_Card_Number__c = 'TESTCARDNUMDUP';
		insert appProd2;

		RecordType branchSite = [SELECT Id FROM RecordType WHERE SobjectType = 'Site__c' AND Name = 'Branch Site'];

		Site__c cresta = new Site__c();
		cresta.Name = 'Cresta';
		cresta.Site_Code__c = '8007';
		cresta.RecordTypeId = branchSite.Id;
		insert cresta;
	}

	@isTest
	static void testgetAppProdAndAccount() {
		//    Opportunity opp = [SELECT Id,Product__c FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		OpportunityLineItem lineitem = [SELECT ID, OpportunityId, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '4048272164'];
		Test.startTest();
		DebitCardDetailsIssueController.CombiProductDetails resp = DebitCardDetailsIssueController.getAppProdAndAccount(lineitem.OpportunityId);
		system.assertNotEquals(resp.ProductFamily, '');
		Test.stopTest();
	}

	@isTest
	static void testgetBrands() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_BRANDS));
		Test.startTest();
		OpportunityLineItem lineitem = [SELECT ID, OpportunityId, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '4048272164'];

		List<String> resp = DebitCardDetailsIssueController.getBrands(lineitem.OpportunityId, '15');
		List<String> error = new List<String>();
		error.add('error');
		system.assertNotEquals(resp, error);
		Test.stopTest();
	}

	@isTest
	static void testissueCard() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_ISSUE));
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		String jsonRequest =
			'{"CardNumber":"4483860000145941","AccountNumber":"4048374867","NomCheq":"4048374867","NomSavs":"","NomCred":"","BrandNumber":"2698","oppId":"' +
			opp.Id +
			'"}';
		Test.startTest();
		DebitCardDetailsIssueController.setOpportunityDetails(opp.Id);
		String resp = DebitCardDetailsIssueController.issueCard(jsonRequest);
		system.assertNotEquals(resp, '');
		Test.stopTest();
	}

	@isTest
	static void testissueCardPersonalisedCard() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_ISSUE));
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		String jsonRequest =
			'{ "isPersonalisedCard":"Yes","CardNumber":"","AccountNumber":"4048374867","NomCheq":"4048374867","NomSavs":"","NomCred":"","BrandNumber":"2698","oppId":"' +
			opp.Id +
			'"}';
		Test.startTest();
		DebitCardDetailsIssueController.setOpportunityDetails(opp.Id);
		String resp = DebitCardDetailsIssueController.issueCard(jsonRequest);
		system.assertNotEquals(resp, '');
		Test.stopTest();
	}

	@isTest
	static void testissueGhostCard() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_GHOST_RESPONSE_BODY_ISSUE));
		Test.startTest();

		OpportunityLineItem lineitem = [SELECT OpportunityId, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '9051159122'];

		Application_Product__c appProd = [SELECT Id FROM Application_Product__c WHERE Debit_Card_Number__c = 'TESTCARDNUM' LIMIT 1];

		String actual = DebitCardDetailsIssueController.issueGhostCard(lineitem.OpportunityId, appProd.Id);
		string expected = '';

		system.assertNotEquals(expected, actual);
		Test.stopTest();
	}

	@isTest
	static void testissueGhostCardDuplicate() {
		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_GHOST_RESPONSE_BODY_ISSUE_DUPLICATE)
		);
		Test.startTest();

		OpportunityLineItem lineitem = [SELECT OpportunityId, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '9051159122'];

		Application_Product__c appProd = [SELECT Id FROM Application_Product__c WHERE Debit_Card_Number__c = 'TESTCARDNUMDUP' LIMIT 1];

		String actual = DebitCardDetailsIssueController.issueGhostCard(lineitem.OpportunityId, appProd.Id);
		string expected = '';

		system.assertNotEquals(expected, actual);
		Test.stopTest();
	}

	@isTest
	static void testSetOpportunity() {
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		Test.startTest();
		DebitCardDetailsIssueController.setOpportunityDetails(opp.Id);
		system.assert(true);
		Test.stopTest();
	}

	@isTest
	static void testgetNominatableAccounts() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_ACCOUNTS));
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		Test.startTest();
		String resp = DebitCardDetailsIssueController.getNominatableAccounts('4048374867', opp.Id);
		system.assertNotEquals(resp, '');
		Test.stopTest();
	}

	@isTest
	static void testgetDailyLimits() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_LIMITS));
		Test.startTest();
		String resp = DebitCardDetailsIssueController.getDailyLimits('4483860000145941');
		system.assertNotEquals(resp, '');
		Test.stopTest();
	}

	@isTest
	static void testupdateDailyLimits() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_POST_LIMITS));
		Test.startTest();
		String jsonRequest = '{"CombiNbr":"4483860000145941","CheqNomAcc":"4048374867","CardCshLim":"100","CardPosLim":"100","CardCntLim":"100","CardTrfLim":"100"}';
		String resp = DebitCardDetailsIssueController.updateDailyLimits(jsonRequest);
		system.assertNotEquals(resp, '');
		Test.stopTest();
	}

	@isTest
	static void getDeliveryBranchByNameExisting() {
		Test.startTest();
		Map<String, String> resp = DebitCardDetailsIssueController.searchDeliveryBranchByName('Cresta');
		system.assertEquals(resp.size(), 1);
		Test.stopTest();
	}

	@isTest
	static void getDeliveryBranchByNameNonExisting() {
		Test.startTest();
		Map<String, String> resp = DebitCardDetailsIssueController.searchDeliveryBranchByName('Waterloo');
		system.assertEquals(resp.size(), 0);
		Test.stopTest();
	}
}