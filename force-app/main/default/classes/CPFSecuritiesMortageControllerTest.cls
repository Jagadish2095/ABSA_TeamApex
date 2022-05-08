/**
 * @description       : Test class for CPFSecuritiesMortageController
 * @author            : Rajesh
 * @last modified on  : 2021-07-02
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-07-02      Initial Version
**/
@isTest
public class CPFSecuritiesMortageControllerTest {

    @isTest
    public static void testCPFSecuritiesMortage(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;


        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        insert app;

        Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
        appPrdctcpf.Application__c=app.Id;
        insert appPrdctcpf;

        Application_Security_CPF__c securityobj = new Application_Security_CPF__c();
        securityobj.Category__c='Limited Suretyship';

        test.startTest();
        CPFSecuritiesMortageController.getSecurityofferedRec(opp.Id,'New');
        CPFSecuritiesMortageController.getUnlimitedSecurityofferedRec(opp.Id,'New');
        CPFSecuritiesMortageController.InsertLimitedSecurityOfferedCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New');
        CPFSecuritiesMortageController.InsertLimitedExistingCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New');
        CPFSecuritiesMortageController.InsertUnlimitedExistingCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New');
        CPFSecuritiesMortageController.InsertUnlimitedExistingCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New');
        CPFSecuritiesMortageController.InsertUnlimitedSecurityOfferedCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New','test','test','test');
        List<OpportunityLineItem> opplinelst=CPFSecuritiesMortageController.getprodName(opp.Id);
        system.assertNotEquals(null, opplinelst);
        test.stopTest();
    }
}