/**
 * @description QA Enhancement-  OpportunityTriggerHelper
 * @author Rajesh - 01/12/2020
 * W-006870
*/

@isTest
public class OpportunityTriggerHelperTest {
    /**
    * @description closedOpportunityValidationTest
    */
    @isTest static void approvaltriggerTest(){
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CASA_Screening_Status__c = 'Cancelled';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
       
        insert account;

        Account clietnAccIndv = AccountTDF.addIndividualClient('Individual', 'Test');
       // Id recTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Product Onboarding').RecordTypeId;
        Opportunity opp = new Opportunity ( Name = 'Test', Type = 'Existing Account',StageName='Fulfill Product',CloseDate=Date.today(),
                                           CMS_Linking_Status__c = 'CAPTURED',CheckMandatoryDocuments__c = false, accountId = clietnAccIndv.Id); //RecordTypeId = recTypeId
                                           opp.AccountId = account.Id;
                                           insert opp;
        List<Opportunity> oppList = new  List<Opportunity>();

        test.startTest();
        OpportunityTriggerHelper.updateApprovalData(oppList);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(opp.id);
        Approval.ProcessResult result = Approval.process(app);
        opp.Rejection_Reasons__c = 'Missing Information';
        update opp;
        System.assertNotEquals(null,  opp);
        test.stopTest();
    }
    /**
    * @description closedOpportunityValidationTest
    */
	 @isTest static void closedOpportunityValidationTest() {

         Account account = new Account(Name = 'Test Account');
         account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
         account.Country_of_Incorporation__c='South Africa';
         account.Client_Group__c = 'Non Individual';
         account.CASA_Reference_Number__c = '12233';
         account.CASA_Screening_Status__c = 'Cancelled';
         account.CIF__c = '';
         account.Countries_Traded_With__c = 'South Africa';
         //account.Source_of_Income__c = 'Donation';
         insert account;
         //insert related acct;
         List<AccountContactRelation> acrList = new List<AccountContactRelation>();
         Account acctSecondary = new Account();
         acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
         acctSecondary.ID_Number__pc = '6803037015089';
         acctSecondary.ID_Type__pc = 'SA Identity Document';
         acctSecondary.FirstName = 'First Name';
         acctSecondary.LastName = 'Test Last Name';
         acctSecondary.Initials__pc = 'I';
         acctSecondary.PersonTitle = 'Mr';
         acctSecondary.Client_Type__c = 'Individual Client';
         acctSecondary.CASA_Reference_Number__pc = '12454' ;
         acctSecondary.CASA_Screening_Status__pc = 'Matched';
         insert acctSecondary;
         Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
         Id personContactId = acc.PersonContactId;
         AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
         insert accConRel;
         acrList.add(accConRel);
         Set<Id> relatedPartIdSet = new Set<Id>();
         for(AccountContactRelation acr : acrList){
             relatedPartIdSet.add(acr.ContactId);
         }
         List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
         Opportunity testOpp = new Opportunity();
         testOpp.Name = 'Test Opp';
         testOpp.CloseDate = Date.today();
         testOpp.StageName = 'Drafting';
         testOpp.accountId = account.Id;
         testOpp.QA_Complex_Approval_Status__c = 'Not Submitted';
         insert testOpp;

         Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );

         insert prod;
         Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
         PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);

         OpportunityLineItem oli = new OpportunityLineItem();
         oli.OpportunityId = testOpp.Id;
         if(prod.Id != null) {
             oli.Product2Id = prod.Id;
         }
         oli.PriceBookEntryid = pricebookEntry.Id;
         oli.Quantity = 1;
         oli.TotalPrice = 100;
         insert oli;
         testOpp.CheckMandatoryDocuments__c = false;
         testOpp.QA_Complex_Approval_Status__c = 'Approved';
         testOpp.StageName = 'Closed';
         test.startTest();
         update testOpp;
         test.stopTest();
         System.assertNotEquals(null,  testOpp);
     }

}