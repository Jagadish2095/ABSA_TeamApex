/**
 *  @description Test class for TriadAggregatedValuesCTRL class
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
@isTest
public class TriadAggregatedValuesCTRLTest {
    /**
    * @description method to setup test data
    * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-10 
    **/
    @TestSetup
    static void createData(){
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
    * @description test method to dGetTriadAggregatedValues
    * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-10 
    **/
    @isTest
    static void shouldGetTriadAggregatedValues(){
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c application =[SELECT Id FROM Application__C LIMIT 1];
        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Application__c = application.Id;
        appTriad.ECTO_Monthly_Avg_Last_12_Mth__c = 20;
        insert appTriad;

        Test.startTest();
        String theResult = String.valueOf(TriadAggregatedValuesCTRL.getTriadAggregatedValues(application.Id));
        Test.stopTest();

        System.debug(theResult);
        System.assert(theResult != null, true);
        System.assert(theResult.contains('clientName'), true);
        System.assert(theResult.contains('clientCode'), true);
        System.assert(theResult.contains('ectoMonthlyAvgLast12Mth'), true);
    }
}