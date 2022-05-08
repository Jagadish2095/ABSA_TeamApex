/**
 * @description       : Test class for ApplicationExposureRiskSelector
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-12
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-08   Himani Joshi   Initial Version
 * 
**/

@IsTest
private class ApplicationExposureRiskSelectorTest {

    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        Insert app;
        system.debug('app'+app);
    }
    @isTest
    public static void testGetSObjectType() {
        test.startTest();
        System.assert(new ApplicationExposureRiskSelector().getSObjectType() != null);
        test.stopTest();
    }
    @isTest
    public static void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new ApplicationExposureRiskSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    @isTest
    public static void testgetApplicationExposureRisks() {
        
        string clientCode='aabk 007';
        Set<String>clientCodes=new Set<String>();
        clientCodes.add(clientCode);
        Application__c app=[select Id from Application__c];
        test.startTest();
        System.assert(new ApplicationExposureRiskSelector().orderByRiskGrade(app.Id,clientCodes) != null);
        System.assert(new ApplicationExposureRiskSelector().orderBySequenceNumber(app.Id,clientCodes) != null);
        System.assert(new ApplicationExposureRiskSelector().getApplicationExposureRisks(clientCode,app.Id) != null);
        test.stopTest();
    }
    @isTest
    public static void testgetAllApplicationExposureRisk() {
        Application__c app=[select Id from Application__c];
        test.startTest();
        System.assert(new ApplicationExposureRiskSelector().getAllApplicationExposureRisk(app.Id) != null);
        test.stopTest();
    }

}