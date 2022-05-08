/**
 * @description       : est class for ApplicationAIPSCTRL class
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12  Ephetehe Mokgopanyane   Initial Version
 **/

@isTest
public class ApplicationAIPSCTRL_Test {
	@TestSetup
	static void createData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ IPlistNCARatesV1_IH_v1.INTEGRATION_SERVICE_NAME });
		ClientDetailsSectionCreditTest.dataCreation();
	}

	@isTest
	static void shouldGetAipsData() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateResponseString()));

		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

		Test.startTest();
		Map<String, Object> aipsResponse = ApplicationAIPSCTRL.getAipsData(opportunity.Id);
		Test.stopTest();

		System.assertNotEquals(null, aipsResponse);
		System.assertNotEquals(null, aipsResponse.get('creditFacilitiesMax'));
	}

	@isTest
	static void shouldGetAipsDataNoServiceCall() {
		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
		Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c = :opportunity.Id];
		application.AIPS__c = generateResponseString();
		update application;

		Test.startTest();
		Map<String, Object> aipsResponse = ApplicationAIPSCTRL.getAipsData(opportunity.Id);
		Test.stopTest();

		System.assertNotEquals(null, aipsResponse);
		System.assertNotEquals(null, aipsResponse.get('creditFacilitiesMax'));
	}

	@isTest
	static void testGetAipsDataApp() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateResponseString()));

		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
		Application__c application = [SELECT Id, AIPS__c FROM Application__c WHERE Opportunity__c = :opportunity.Id];

		Test.startTest();
		Map<String, Object> aipsResponse = ApplicationAIPSCTRL.getAipsData(application);
		Test.stopTest();

		System.assertNotEquals(null, aipsResponse);
		System.assertNotEquals(null, aipsResponse.get('creditFacilitiesMax'));
	}

	@isTest
	static void testGetAipsDataNoServiceCallApp() {
		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
		Application__c application = [SELECT Id, AIPS__c FROM Application__c WHERE Opportunity__c = :opportunity.Id];
		application.AIPS__c = generateResponseString();
		update application;

		Test.startTest();
		Map<String, Object> aipsResponse = ApplicationAIPSCTRL.getAipsData(application);
		Test.stopTest();

		System.assertNotEquals(null, aipsResponse);
		System.assertNotEquals(null, aipsResponse.get('creditFacilitiesMax'));
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @return String
	 **/
	public static String generateResponseString() {
		String responseString = '{"IPlistNCARatesV1Response":{"ipb100o":{"ncaMaxfeeCfErr":"0000 - SUCCESS","ncaMaxfeeCfMaxsf":69,"ncaMaxfeeMaErr":"0000 - SUCCESS","ncaMaxfeeMaMaxsf":69,';
		responseString += '"ncaMaxfeeOcaErr":"0000 - SUCCESS","ncaMaxfeeOcaMaxsf":69,"ncaMaxfeeStctErr":"0000 - SUCCESS","ncaMaxfeeStctMaxsf":69,"ncaMaxfeeUctErr":"0000 - SUCCESS",';
		responseString += '"ncaMaxfeeUctMaxsf":69,"ncaMaxifeeCfErr":"0000 - SUCCESS","ncaMaxifeeCfFirst":189.75,"ncaMaxifeeCfMax":6050.5,"ncaMaxifeeCfNext":11.5,"ncaMaxifeeCfPerc":1000,';
		responseString += '"ncaMaxifeeMaErr":"0000 - SUCCESS","ncaMaxifeeMaFirst":1265,"ncaMaxifeeMaMax":6037.5,"ncaMaxifeeMaNext":11.5,"ncaMaxifeeMaPerc":10000,';
		responseString += '"ncaMaxifeeOcaErr":"0000 - SUCCESS","ncaMaxifeeOcaFirst":189.75,"ncaMaxifeeOcaMax":1207.5,"ncaMaxifeeOcaNext":11.5,"ncaMaxifeeOcaPerc":1000,';
		responseString += '"ncaMaxifeeStctErr":"0000 - SUCCESS","ncaMaxifeeStctFirst":189.75,"ncaMaxifeeStctMax":1207.5,"ncaMaxifeeStctNext":11.5,"ncaMaxifeeStctPerc":1000,';
		responseString += '"ncaMaxifeeUctErr":"0000 - SUCCESS","ncaMaxifeeUctFirst":189.75,"ncaMaxifeeUctMax":6040.5,"ncaMaxifeeUctNext":11.5,"ncaMaxifeeUctPerc":1000,';
		responseString += '"ncaMaxrateCfErr":"0000 - SUCCESS","ncaMaxrateCfMaxdr":20.75,"ncaMaxrateMaErr":"0000 - SUCCESS","ncaMaxrateMaMaxdr":19,"ncaMaxrateOcaErr":"0000 - SUCCESS",';
		responseString += '"ncaMaxrateOcaMaxdr":21,"ncaMaxrateStctErr":"0000 - SUCCESS","ncaMaxrateStctMaxdr":60,"ncaMaxrateUctErr":"0000 - SUCCESS","ncaMaxrateUctMaxdr":27.75,';
		responseString += '"primeRate":6.25,"primeRateErr":"0000 - SUCCESS","repurchaseRate":7,"repurchaseRateErr":"0000 - SUCCESS"},"nbsapdpo":{"reasonCode":0,"returnCode":0,';
		responseString += '"serviceVersion":"BUSO001"},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';

		return responseString;
	}
}