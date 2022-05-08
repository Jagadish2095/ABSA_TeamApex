/**
 * @description Test class for TriadBehaviourCTRL class
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
@isTest
public class TriadBehaviourCTRLTest {
    /**
    * @description method to setup test data
    * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-14
    **/
    @TestSetup
    static void createData(){
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
    * @description test method to GetTriadBehaviourData
    * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-14
    **/
    @isTest
    static void shouldGetTriadBehaviourData(){
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c application =[SELECT Id FROM Application__C LIMIT 1];
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Application__c = application.Id;
        appTriad.Customer_Alignment_Score__c = 20;
        insert appTriad;

        Test.startTest();
        String theResult = String.valueOf(TriadBehaviourCTRL.getTriadBehaviourData(application.Id));
        Test.stopTest();

        System.assert(theResult != null, true);
        System.assert(theResult.contains('clientName'), true);
        System.assert(theResult.contains('clientCode'), true);
        System.assert(theResult.contains('custAlignScore'), true);
    }
}