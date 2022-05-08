/**  * Test class for PrincipalFinancialsIndividualCtrl
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date September 2020
 *
 **/
@IsTest
public class PrincipalFinancialsCtrlTest {
    
	@testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
       
        Opportunity opportunity = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Contact contact = [SELECT Id,CIF__c FROM Contact LIMIT 1];
        
        Account account = [SELECT Id,Name,CIF__c,CASA_Reference_Number__c,CASA_Screening_Status__c FROM Account LIMIT 1];
        
        Application__c application = [SELECT Id FROM Application__c LIMIT 1];
        
        
        AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId =: account.Id LIMIT 1];
        system.debug('opportunity'+ opportunity);
        Application_Principal__c appPrin = new Application_Principal__c();
        appPrin.Application__c = application.Id;
        appPrin.Casa_Reference__c = account.CASA_Reference_Number__c;
        appPrin.Casa_Result__c = account.CASA_Screening_Status__c;
        appPrin.CIF__c = account.CIF__c;
        appPrin.Controlling_Interest__c = 10;
        appPrin.Id_Number__c = '';
        appPrin.Main__c = true;
        appPrin.Principal_Shareholder_Name__c = account.Name;
        appPrin.AccConRelId__c = acr.Id;
        appPrin.Is_Part_Of_Application__c=true;
        insert appPrin;
    }
    
    @IsTest
    static void shouldGetRelatedParties(){
        Opportunity opportunity = [SELECT Id,Name FROM Opportunity LIMIT 1 FOR UPDATE];
        
        Test.startTest();
        List<Contact> accountContacts = PrincipalFinancialsCtrl.getRelatedParties(opportunity.Id);
        Test.stopTest();
        
        System.assert(accountContacts.size() > 0);
    }
    
    @IsTest
    static void shouldGetRelatedPartiesSoleTrader(){
        Opportunity opportunity = [SELECT Id,Name,AccountId FROM Opportunity LIMIT 1 FOR UPDATE];
        Account account = new Account(Id = opportunity.AccountId);
        account.Client_Type__c = 'SOLE TRADER';
        update account;
        
        Test.startTest();
        List<Contact> accountContacts = PrincipalFinancialsCtrl.getRelatedParties(opportunity.Id);
        Test.stopTest();
        
       
    }
}