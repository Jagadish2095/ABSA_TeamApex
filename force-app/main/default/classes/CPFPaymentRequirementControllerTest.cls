/**  * Test class for CPFPaymentRequirementController
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 *
 **/
@IsTest
public class CPFPaymentRequirementControllerTest {
    @testSetup
    public static void dataCreation() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId = account.Id;
        insert opportunity;

        Application__c application = new Application__c();
        application.Opportunity__c = opportunity.id;
        application.Account_Access__c = 'Cellphone';
        application.Surplus_Cash__c = 'Fixed Deposits';
        application.Borrowing_Requiment_General__c = 'Credit Card';
        application.Protection_Of_Services__c = 'Retirement';
        application.Title__c = 'dd';
        application.FirstNameSignature__c = 'Litha';
        application.SurnameSignature__c = 'Nosekeleza';
        application.Signing_Date__c = System.today();
        application.Stock_Number__c = '';
        insert application;

        Application_Product_CPF__c appProductCPF = new Application_Product_CPF__c();
        appProductCPF.Application__c = application.Id;
        insert appProductCPF;
    }

    @IsTest
    static void testGetApplicationProductCPFId() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Id appProductCPFId = CPFPaymentRequirementController.getApplicationProductCPFId(opportunity.Id);
        Test.stopTest();

        System.assertNotEquals(null, appProductCPFId);
    }
}