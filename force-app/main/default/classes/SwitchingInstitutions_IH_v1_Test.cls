/**
 * @description       : SwitchingInstitutions_IH_v1_Test
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-21   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/

@isTest
public class SwitchingInstitutions_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY_GET = '{ "_embedded" : { "items" : [ { "createdBy" : "bdp_user", "lastModifiedBy" : "bdp_user", "creationDate" : "2020-07-02T12:28:47.118+0000", "lastModifiedDate" : "2020-07-02T12:28:47.118+0000", "name" : "ABSA ", "contactPerson" : null, "contactEmail" : null, "contactDepartment" : null, "debitOrderAutomatedEmail" : null, "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 0, "debitOrderResolveHoursSLA" : 0, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "NON_PARTICIPATING", "categories" : null, "batchFileType" : null, "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518/history" } } }, { "createdBy" : "admin", "lastModifiedBy" : "admin", "creationDate" : "2019-11-27T21:22:00.404+0000", "lastModifiedDate" : "2019-11-27T21:22:00.404+0000", "name" : "CHUBB SA", "contactPerson" : "", "contactEmail" : "Depolelo.Mathebula@absa.africa", "contactDepartment" : "Customer Service", "debitOrderAutomatedEmail" : "Depolelo.Mathebula@absa.africa", "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 4, "debitOrderResolveHoursSLA" : 4, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "PARTICIPATING", "categories" : [ ], "batchFileType" : "EXCEL", "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235/history" } } } ] }, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions" }, "profile" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/profile/institutions" }, "search" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search" } } }';
	public static final String POSITIVE_RESPONSE_BODY_POST = '{ "createdBy": "admin",     "lastModifiedBy": "admin",     "creationDate": "2020-10-16T08:14:52.563+0000",     "lastModifiedDate": "2020-10-16T08:14:52.563+0000",     "name": "Cloudy Bananas",     "contactPerson": "Some Person",     "contactEmail": "some1@email.com",     "contactDepartment": "Some Department",     "debitOrderAutomatedEmail": null,     "salaryAutomatedEmail": "some1@email.com",     "regexPatterns": null,     "debitOrderAcknowledgeHoursSLA": 0,     "debitOrderResolveHoursSLA": 0,     "salaryAcknowledgeHoursSLA": 0,     "salaryResolveHoursSLA": 0,     "route": "NON_PARTICIPATING",     "categories": null,     "batchFileType": null,     "batchFormatterType": null,     "batchIntegrationType": null,     "connectionPrefix": null,     "template": null,     "_links": {         "self": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "institution": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "history": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655/history"         }     } }';
	public static final String POSITIVE_RESPONSE_BODY_GET_BY_NAME = '{ "_embedded": { "items": [ {"createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2021-05-14T08:37:20.545+0000",                "lastModifiedDate": "2021-05-14T08:37:20.545+0000",                "name": "UAT TEST2",                "contactPerson": null,                "contactEmail": "TEST@TEST.COM",                "contactDepartment": null,                "debitOrderAutomatedEmail": null,                "salaryAutomatedEmail": null,                "regexPatterns": null,                "debitOrderAcknowledgeHoursSLA": 0,                "debitOrderResolveHoursSLA": 0,                "salaryAcknowledgeHoursSLA": 0,                "salaryResolveHoursSLA": 0,                "route": "NON_PARTICIPATING",                "categories": null,                "batchFileType": null,                "batchFormatterType": null,                "batchIntegrationType": null,                "archived": 0,                "connectionPrefix": null,                "template": null,                "_links": {                    "self": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "institution": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "history": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404/history"                    }                }            }        ]    },    "_links": {        "self": {            "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search/findByName?name=UAT%20TEST2"        }    }}';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SwitchingInstitutions_IH_v1.SwitchingInstitutionCreate }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ SwitchingInstitutions_IH_v1.SwitchingInstitutions });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SwitchingInstitutions_IH_v1.SwitchingInstitutionsByName }
		);
	}

	@isTest
	public static void testgetSwitchingInstitutions() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));
		Test.startTest();
		SwitchingInstitutions_Resp_IB_v1 responseBean = callgetInstitutionsHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testgetSwitchingInstitutionByName() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_BY_NAME));
		Test.startTest();
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = callgetInstitutionByNameHandlerMethod();
		System.assert(responseBean != null, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testgetSwitchInstitutionByNameAndArchived() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_BY_NAME));
		Test.startTest();
		List<SwitchingInstitutions_Resp_IB_v1.Item> responseBean = callgetInstitutionByNameAndArchivedHandlerMethod();
		System.assert(responseBean != null, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testgetSwitchingInstitutionsWithSizeLimits() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));
		Test.startTest();
		SwitchingInstitutions_Resp_IB_v1 responseBean = callgetInstitutionsWithLimitsHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testgetSwitchInstitution() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_POST));
		Test.startTest();
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = callgetSwitchInstitutionHandlerMethod();
		System.assertEquals(500, responseBean.statusCode, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testcreateSwitchingInstitution() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_POST));
		Test.startTest();
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = callcreateInstitutionsHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testcreateSwitchingInstitutionInSalesforce() {
		List<SwitchingInstitutions_Resp_IB_v1.Item> intitutions = new List<SwitchingInstitutions_Resp_IB_v1.Item>();
		SwitchingInstitutions_Resp_IB_v1.Item intitution = new SwitchingInstitutions_Resp_IB_v1.Item();
		intitution.createdBy = 'admin';
		intitution.lastModifiedBy = 'admin';
		intitution.creationDate = '2020-10-20T12:53:04.950+0000';
		intitution.lastModifiedDate = '2020-10-20T12:53:04.950+0000';
		intitution.name = 'empliers';
		intitution.contactPerson = '';
		intitution.contactEmail = '';
		intitution.contactDepartment = '';
		intitution.debitOrderAutomatedEmail = '';
		intitution.salaryAutomatedEmail = '';
		intitution.regexPatterns = null;
		intitution.debitOrderAcknowledgeHoursSLA = 0;
		intitution.debitOrderResolveHoursSLA = 0;
		intitution.salaryAcknowledgeHoursSLA = 0;
		intitution.salaryResolveHoursSLA = 0;
		intitution.route = 'NON_PARTICIPATING';
		intitution.categories = null;
		intitution.batchFileType = '';
		intitution.batchFormatterType = '';
		intitution.batchIntegrationType = '';
		intitution.connectionPrefix = '';
		intitution.template = '';
		intitution.x_links = null;

		intitutions.add(intitution);

		Test.startTest();
		List<Switching_Institution__c> institution = SwitchingInstitutions_IH_v1.createSwitchingInstitutionInSalesforce(intitutions);
		System.assert(institution != null, 'Test unsuccessful');
		Test.stopTest();
	}

	private static SwitchingInstitutions_Resp_IB_v1 callgetInstitutionsHandlerMethod() {
		SwitchingInstitutions_Resp_IB_v1 responseBean = SwitchingInstitutions_IH_v1.getSwitchingInstitutions();
		return responseBean;
	}

	private static SwitchingInstitutions_Resp_IB_v1.Item callgetInstitutionByNameHandlerMethod() {
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = SwitchingInstitutions_IH_v1.getSwitchInstitutionByName('UAT TEST2');
		return responseBean;
	}

	private static List<SwitchingInstitutions_Resp_IB_v1.Item> callgetInstitutionByNameAndArchivedHandlerMethod() {
		List<SwitchingInstitutions_Resp_IB_v1.Item> responseBean = SwitchingInstitutions_IH_v1.getSwitchInstitutionByNameAndArchived('0', 'ABSA');
		return responseBean;
	}

	private static SwitchingInstitutions_Resp_IB_v1 callgetInstitutionsWithLimitsHandlerMethod() {
		String page = '0';
		String size = '1';
		SwitchingInstitutions_Resp_IB_v1 responseBean = SwitchingInstitutions_IH_v1.getSwitchingInstitutionsWithSizeLimits(page, size);
		return responseBean;
	}

	private static SwitchingInstitutions_Resp_IB_v1.Item callgetSwitchInstitutionHandlerMethod() {
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = SwitchingInstitutions_IH_v1.getSwitchInstitution('660');
		return responseBean;
	}

	private static SwitchingInstitutions_Resp_IB_v1.Item callcreateInstitutionsHandlerMethod() {
		SwitchingInstitutions_Req_IB_v1 dummyReqBean = SwitchingInstitutions_Req_IB_v1.createDummyRequest();
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = SwitchingInstitutions_IH_v1.createSwitchingInstitution(dummyReqBean);
		return responseBean;
	}
}