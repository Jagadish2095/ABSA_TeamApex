/**
 * @description       : Test class for ApplicationSecuritySelector class
 * @author            : Gulafsha
 * @last modified on  : 2021-06-10
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-10   Gulafsha   Initial Version
**/

@IsTest
public class ApplicationSecuritySelectorTest {
    /**
    * @description 
    * @author Gulafsha | 2021-06-10 
    **/
    @testSetup
    public static void dataCreation() {
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        
        Security_Offered__c sc1=new Security_Offered__c();
        sc1.Application__c=application.Id;
        sc1.Account__c=ac.Id;
        sc1.Physical_Address_line_1__c=null;
        insert sc1;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Bond';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Ranking_Number__c = 10;
        appsec.Amount__c = 100;
        appsec.Realistic_Market_Value__c = 100;
        appsec.Status__c = 'Open';
        appsec.Date_Signed__c = system.today();
        appsec.Security_Offered__c=sc1.id;
        insert appsec;
        system.debug(opp);
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
    }
    @IsTest
    public static void testGetSObjectType() {
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
    }
    @IsTest
    public static void testGetSObjectFieldList() {
        System.assert(new ApplicationSecuritySelector().getSObjectFieldList() != null);
    }
    @IsTest
    public static void testAllSelectorMethods() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Application_Security__c appSec = new ApplicationSecuritySelector().selectByApplicationId(app.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(appSec.Id);

        String securityType = appSec.Security_Type__c, bondType = appSec.Bond_Type__c;

        System.assert(new ApplicationSecuritySelector().selectById(idSet) != null);
        System.assert(new ApplicationSecuritySelector().selectByApplicationId(app.Id) != null);
        System.assert(new ApplicationSecuritySelector().selectByApplicationIdAndSecType(app.Id, securityType) != null);
        System.assert(new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(app.Id, securityType) != null);
        System.assert(new ApplicationSecuritySelector().selectByApplicationIdTextAndBondType(idSet, bondType) != null);
        System.assert(new ApplicationSecuritySelector().selectByApplicationIdTextSet(idSet) != null);
        System.assert(new ApplicationSecuritySelector().selectBySecurityOfferedId(appsec.Security_Offered__c) != null);
    }
}