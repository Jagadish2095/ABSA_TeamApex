/*
 * Test Integration Handler for RelatedPartiesService Service
 * @author Vladimir Panajic
 * @created 2020-02-06
 */

@IsTest
public class RelatedPartiesServiceTest {

    @IsTest
    static void createRelatedPartiesTest() {
        String registrationNumber = '197101150307';
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List < String > {
            ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME
        });

        Test.startTest();
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
        if(responseBean.statusCode == 200) {
            Account acctPrimary = new Account(Name = 'Test Primary Account');
            insert acctPrimary;
            List<ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails> directorDetailsList = responseBean.CompanyDownload.Results.KreditSearchFile.Directors.DirectorDetails;
            RelatedPartiesService rps = new RelatedPartiesService();
            rps.createRelatedParties(acctPrimary.Id, directorDetailsList, 'Director');
        }
        Test.stopTest();
    }

    @IsTest
    static void constructRelatedPartyTest() {
        Test.startTest();
        RelatedPartiesService rps = new RelatedPartiesService();
        rps.constructRelatedParty('6803037015089', 'SA Identity Document', 'First Name', 'Last Name', 'I', 'Mr.', '19680303');
        Test.stopTest();
    }

    @IsTest
    static void linkRelatedPartiesTest() {
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        insert acctPrimary;
        Account acctPerson = new Account(Name = 'Test Person Account');
        insert acctPerson;
        Set<Id> relatedPartiesPersonContactIds = new Set<Id>();
        relatedPartiesPersonContactIds.add(acctPerson.PersonContactId);
        RelatedPartiesService rps = new RelatedPartiesService();
        Map<string, string> sharePercentageDirMap = new Map<string, string>();
        sharePercentageDirMap.put(acctPerson.PersonContactId, '100.00');
        Test.startTest();
        rps.linkRelatedParties(acctPrimary.Id, relatedPartiesPersonContactIds, 'Director', sharePercentageDirMap);
        Test.stopTest();
    }

    @IsTest
    static void searchClientFinderTest() {
        Test.startTest();
        RelatedPartiesService rps = new RelatedPartiesService();
        rps.searchClientFinder('SA Identity Document', '9601305224087');
        Test.stopTest();
    }

    @IsTest
    static void constructAddressTest() {
        Map<string, id> accountIdMap = new Map<string, id>();
        Map<string, id> personContactIdMap = new Map<string, id>();
        Account acctRelParty = new Account(Name = 'Test Related party Account');
        insert acctRelParty;
        accountIdMap.put('6803037015089', acctRelParty.Id);
        personContactIdMap.put('6803037015089', acctRelParty.Id);
        Test.startTest();
        RelatedPartiesService rps = new RelatedPartiesService();
        rps.constructAddress(accountIdMap, personContactIdMap, '6803037015089', 'Postal', 'Line 1', 'Line 2', 'Line 3', 'Line 4', '2198');
        Test.stopTest();
    }
}