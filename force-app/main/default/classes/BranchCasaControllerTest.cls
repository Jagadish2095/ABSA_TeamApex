/**
 * @description       : BranchCasaControllerTest
 * @author            : Thomas Dry : ABSA (IQ Business)
 * @created   2021-03-02
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @updated   2021-05-06 conform to PMD
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-06-15   PaulJohn.duRand@absa.africa   IntegrationTranslation for customer type
 * 1.0   2021-06-25   PaulJohn.duRand@absa.africa   Analyst comments for Non-Individual Entities
 * 1.0   2021-07-22   PaulJohn.duRand@absa.africa   Return error on invalid CASA status
 **/

@isTest
public class BranchCasaControllerTest {
	 public static final String POSITIVE_RESPONSE_BODY_GETANALYSTCOMMENTS = '{"WQgetAnalystCommentsV7Response": { "name": null, "surname": "JULY STOKVEL", "idType": "5", "idReg": "121264254", "dob": "0", "sbu": "F", "results": { "seqNo": "1", "commentCode": "0", "commentDesc": "No Comments found" } } }';
     public static final String POSITIVE_RESPONSE_BODY_GENDOCS = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"0","VersionNo":"0","msgNo":"564","msg":"Risk Profiling for supplied reference number was not completed. Cannot continue"}}}}';
	 public static final String POSITIVE_RESPONSE_BODY_GetStatus = '{"WQgetCASAStatusByRefNoV7Response":{"wqp102o":{"surnameComp":"BOOTH","casaStatus":"I","pepSts":null,"msgNo":0,"msg":"INCOMPLETE-RISKP","idType":1,"idRegNo":8805240649081,"firstName":"MAYA","documentSts":"I","comments":null,"approvedSts":null},"nbsapdpo":{"version":"APLO003","serviceVersion":"BUSO001","returnCode":0,"reasonCode":0,"echoKey":null}}}';
	 public static final String POSITIVE_RESPONSE_BODY_Screening = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"2","VersionNo":"1","msgNo":"200","msg":"Success","documentation":[{"docCode":"0001","docDesc":"Doc1"},{"docCode":"0002","docDesc":"Doc2"}]}}}}';
	 public static final String POSITIVE_RESPONSE_BODY_RiskProfile = '{"WQriskProfileClientV7Response":{"msgNo":"200","msg":"Risk Profiling Completed Succesfully!! Score is $4880.0$","riskRating":"M"}}';
	/**
	* @description dataCreation
	* @author PaulJohn.duRand@absa.africa | 2021-08-06
	**/
	@testSetup
	public static void dataCreation() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Wqgetanalystcommentsv7_IH_v2.INTEGRATION_SERVICE_NAME});
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CASAGeneratedocumentsV7_IH_v1.INTEGRATION_SERVICE_NAME});
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME});
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CASAScreenPrimaryClientV7_IH_v1.INTEGRATION_SERVICE_NAME});
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CASARiskProfileClientV7_IH_v1.INTEGRATION_SERVICE_NAME});
		Map<String,String> accMap = new Map<String,String>();
		accMap.put('RecordTypeId',TestMetaDataFactory.getRecordTypeId('Individual_Client'));
		String accountId = TestMetaDataFactory.insertTestObject('Account', 'BranchNTPAccount',accMap);

		Map<String,String> accMapBusiness = new Map<String,String>();
		accMapBusiness.put('RecordTypeId',TestMetaDataFactory.getRecordTypeId('Client'));
		accMapBusiness.put('Name','DefaultBusiness');
		String businessAccountId = TestMetaDataFactory.insertTestObject('Account', 'DefaultAccount',accMapBusiness);

		Map<String,String> opportunityMap = new Map<String,String>();
		opportunityMap.put('AccountId',accountId);
		String opportunityId = TestMetaDataFactory.insertTestObject('Opportunity', 'DefaultOpportunity',opportunityMap);

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		String product2Id = TestMetaDataFactory.insertTestObject('Product2', 'DefaultCheques');

		Map<String,String> pricebookEntryMap = new Map<String,String>();
		pricebookEntryMap.put('Pricebook2Id', pb.Id);
		pricebookEntryMap.put('Product2Id',product2Id);
		String pricebookEntryId = TestMetaDataFactory.insertTestObject('PricebookEntry', 'DefaultPricebookEntry',pricebookEntryMap);

		Map<String,String> opportunityLineItemMap = new Map<String,String>();
		opportunityLineItemMap.put('OpportunityId', opportunityId);
		opportunityLineItemMap.put('Product2Id', product2Id);
		opportunityLineItemMap.put('PricebookEntryId', pricebookEntryId);
	    String OppLineItem = TestMetaDataFactory.insertTestObject('OpportunityLineItem', 'DefaultOpportunityLineItem',opportunityLineItemMap);
	}

	@isTest
	public static void testCallScreening() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GetStatus ));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_Screening ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = BranchCasaController.callScreening(accountId);
			System.assert(res.length() > 0, 'Screening Failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallScreeningBusiness() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GetStatus ));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_Screening ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'DefaultAccount','DefaultBusiness');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = BranchCasaController.callScreening(accountId);
			System.assert(res.length() > 0, 'Screening Failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallRiskProfiling() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_RiskProfile));
		string OppId = TestMetaDataFactory.getRecordId('Opportunity', 'DefaultOpportunity');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = BranchCasaController.callRiskProfiling(OppId);
			System.assert(res.length() > 0, 'Risk profiling failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testGetPrimaryCasaDetailsBusiness() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GetStatus ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'DefaultAccount','DefaultBusiness');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			object caseCont = BranchCasaController.getPrimaryCasaDetails(accountId);
			System.assert(caseCont != null, 'Contact is null');
			Test.stopTest();
		}
	}

	@isTest
	public static void testGetPrimaryCasaDetails() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GetStatus ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			object caseCont = BranchCasaController.getPrimaryCasaDetails(accountId);
			System.assert(caseCont != null, 'Contact is null');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallGenerateDocs() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GENDOCS ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = BranchCasaController.callGenerateDocs(accountId);
			System.assert(res.length() > 0, 'Generate documents failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testCallGenerateDocsBusiness() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GENDOCS ));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'DefaultAccount','DefaultBusiness');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = BranchCasaController.callGenerateDocs(accountId);
			System.assert(res.length() > 0, 'Generate documents failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void testGetAnalystComments() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GETANALYSTCOMMENTS));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string comment = '';
			try {
				comment = BranchCasaController.getAnalystComments(accountId);
			} catch (AuraHandledException e) {
				comment = 'exception';
			}
			System.assert(comment != '', 'comment Contact is null');
			Test.stopTest();
		}
	}

	@isTest
	public static void testGetAnalystCommentsBusiness() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GETANALYSTCOMMENTS));
		string accountId = TestMetaDataFactory.getRecordId('Account', 'DefaultAccount','DefaultBusiness');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string comment = '';
			try {
				comment = BranchCasaController.getAnalystComments(accountId);
			} catch (AuraHandledException e) {
				comment = 'exception';
			}
			System.assert(comment != '', 'comment Contact is null');
			Test.stopTest();
		}
	}
}