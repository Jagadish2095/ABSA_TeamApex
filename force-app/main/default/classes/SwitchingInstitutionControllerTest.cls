/**
 * @description       : SwitchingInstitutionControllerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-12   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
**/

@isTest
public class SwitchingInstitutionControllerTest {
    public static final String POSITIVE_RESPONSE_BODY_GET_BY_NAME = '{ "_embedded": { "items": [ {"createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2021-05-14T08:37:20.545+0000",                "lastModifiedDate": "2021-05-14T08:37:20.545+0000",                "name": "UAT TEST2",                "contactPerson": null,                "contactEmail": "TEST@TEST.COM",                "contactDepartment": null,                "debitOrderAutomatedEmail": null,                "salaryAutomatedEmail": null,                "regexPatterns": null,                "debitOrderAcknowledgeHoursSLA": 0,                "debitOrderResolveHoursSLA": 0,                "salaryAcknowledgeHoursSLA": 0,                "salaryResolveHoursSLA": 0,                "route": "NON_PARTICIPATING",                "categories": null,                "batchFileType": null,                "batchFormatterType": null,                "batchIntegrationType": null,                "archived": 0,                "connectionPrefix": null,                "template": null,                "_links": {                    "self": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "institution": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "history": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404/history"                    }                }            }        ]    },    "_links": {        "self": {            "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search/findByName?name=UAT%20TEST2"        }    }}';
    public static final String POSITIVE_RESPONSE_BODY_POST = '{ "createdBy": "admin",     "lastModifiedBy": "admin",     "creationDate": "2020-10-16T08:14:52.563+0000",     "lastModifiedDate": "2020-10-16T08:14:52.563+0000",     "name": "Cloudy Bananas",     "contactPerson": "Some Person",     "contactEmail": "some1@email.com",     "contactDepartment": "Some Department",     "debitOrderAutomatedEmail": null,     "salaryAutomatedEmail": "some1@email.com",     "regexPatterns": null,     "debitOrderAcknowledgeHoursSLA": 0,     "debitOrderResolveHoursSLA": 0,     "salaryAcknowledgeHoursSLA": 0,     "salaryResolveHoursSLA": 0,     "route": "NON_PARTICIPATING",     "categories": null,     "batchFileType": null,     "batchFormatterType": null,     "batchIntegrationType": null,     "connectionPrefix": null,     "template": null,     "_links": {         "self": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "institution": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "history": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655/history"         }     } }';

    @testSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SwitchingInstitutions_IH_v1.SwitchingInstitutionsByName});
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SwitchingInstitutions_IH_v1.SwitchingInstitutionCreate }
		);
    }

    @isTest
    static void testfetchInstitutions() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_BY_NAME));
        Test.startTest();
        List<Map<String,Object>> institutions = SwitchingInstitutionController.searchNameLike('ABSA');
        System.assert(institutions.size() > 0, 'Test unsuccessful');
        Test.stopTest();
    }

    @isTest
    static void testsaveInstitutionToSwitchIt() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_POST));
        Test.startTest();
        string response = SwitchingInstitutionController.saveInstitutionToSwitchIt('ABSA','Test@test.com');
        System.assert(response != null, 'Test unsuccessful');
        Test.stopTest();
    }
}