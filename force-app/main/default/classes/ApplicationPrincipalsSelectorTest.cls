/**
 * Test class for ApplicationPrincipalsSelector object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-27
 **/
@IsTest
public class ApplicationPrincipalsSelectorTest {
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    static testMethod void testGetSObjectType() {

        System.assert(new ApplicationPrincipalsSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {

        System.assert(new ApplicationPrincipalsSelector().getSObjectFieldList() != null);
    }

    static testMethod void testSelectById() {
        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        Account account = [SELECT Id, Name, CIF__c, CASA_Reference_Number__c, CASA_Screening_Status__c FROM Account LIMIT 1];
        
        Application_Principal__c appPrin = new Application_Principal__c();
        appPrin.Application__c = app.Id;
        appPrin.Casa_Reference__c = account.CASA_Reference_Number__c;
        appPrin.Casa_Result__c = account.CASA_Screening_Status__c;
        appPrin.CIF__c = account.CIF__c;
        appPrin.Controlling_Interest__c = 10;
        appPrin.Id_Number__c = '';
        appPrin.Main__c = true;
        appPrin.Is_Part_Of_Application__c = true;
        appPrin.Principal_Shareholder_Name__c = account.Name;
        insert appPrin;
        
        Application_Principal__c application = new ApplicationPrincipalsSelector().selectByApplicationId(app.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(application.Id);

        System.assert(new ApplicationPrincipalsSelector().selectById(idSet) != null);
        System.assert(new ApplicationPrincipalsSelector().getSelectedApplicationPrincipals(application.Id)!= null);
    }

    static testMethod void testSelectByApplicationId() {

        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        System.assert(new ApplicationPrincipalsSelector().selectByApplicationId(app.Id) != null);
    }

    static testMethod void testSelectByOpportunityId() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        System.assert(new ApplicationPrincipalsSelector().selectByOpportunityId(new Set<Id>{opportunity.Id}) != null);
    }
    //Added By Himani Joshi
    static testMethod void testgetApplicationPrincipals() {

        Application__c app = [SELECT Id, Name FROM Application__c LIMIT 1];
        System.assert(new ApplicationPrincipalsSelector().getApplicationPrincipals(app.Id) != null);
    }
}