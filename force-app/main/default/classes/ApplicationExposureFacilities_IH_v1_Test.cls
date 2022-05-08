/**
 * @description       : Test class for ApplicationExposureFacilities_IH_v1
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

@IsTest
public class ApplicationExposureFacilities_IH_v1_Test {
	public static String POSITIVE_RESPONSE_BODY;
    
	@TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ApplicationExposureFacilities_IH_v1.INTEGRATION_SERVICE_NAME});
        ClientDetailsSectionCreditTest.dataCreation();
    }
    
    @IsTest
    static void shouldGetApplicationExposure() {
        ApplicationExposureFacilities_Req_IB_v1 requestbean = new ApplicationExposureFacilities_Req_IB_v1();
        requestbean = ApplicationExposureFacilities_Req_IB_v1.createDummyRequest();
        POSITIVE_RESPONSE_BODY = JSON.serialize(ApplicationExposureFacilities_Resp_IB_v1.createDummyResponse());
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Onboarding' LIMIT 1];

        ApplicationExposureFacilitySelector appExFacSelector = new ApplicationExposureFacilitySelector();        
        List<Application_Exposure_Facility__c> appExpFacilities = appExFacSelector.selectByOpportunityId(new Set<Id>{opportunity.Id});
        
        Test.startTest();
        ApplicationExposureFacilities_Resp_IB_v1 response = ApplicationExposureFacilities_IH_v1.applicationExposureFacilitiesAggregate(appExpFacilities);
        String theResult = JSON.serialize(response);
        Test.stopTest();
        
        System.assertEquals(200, response.statusCode);
        System.assert(theResult.contains('client'));
        System.assert(theResult.contains('description'));
        System.assert(theResult.contains('statusCode'));
        System.assert(theResult.contains('status'));
    }
}