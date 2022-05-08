/**
 * @description Test class for TriadRelationshipCTRL class
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
@isTest
public class TriadRelationshipCTRLTest {
    /**
     * @description method to setup test data
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-01
    **/
    @TestSetup
    static void createData(){
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
     * @description method to test getTriadRelationshipData
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-01
    **/
    @isTest
    static void shouldGetTriadRelationshipData(){
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c application =[SELECT Id FROM Application__C LIMIT 1];
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Application__c = application.Id;
        appTriad.Months_Since_Oldest_Relationship__c = 20;
        insert appTriad;

        Test.startTest();
        String theResult = String.valueOf(TriadRelationshipCTRL.getTriadRelationshipData(application.Id));
        Test.stopTest();

        System.assert(theResult != null, true);
        System.assert(theResult.contains('clientName'), true);
        System.assert(theResult.contains('clientCode'), true);
        System.assert(theResult.contains('monthsSinceOldestRel'), true);
    }
}