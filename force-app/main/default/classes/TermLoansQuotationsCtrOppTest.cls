@isTest
public class TermLoansQuotationsCtrOppTest {
static testMethod void getTestMethod(){
     Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        insert testOpp;
        Application_Product__c appPrdct=new Application_Product__c();
    	List<Application_Product__c> lappPrdct=new List<Application_Product__c>();
        appPrdct.Opportunity__c=testOpp.Id;	
   appPrdct.Opportunity_Product_Id__c = '001';
    	//appPrdct[0].Opportunity_Product_Id__c=
        insert appPrdct;
    	lappPrdct.add(appPrdct);
    	Case caseRec= new Case();
   		caseRec.Opportunity__c=testOpp.Id;
    	insert caseRec;
    	//TermLoansQuotationsCtrOpp.getAppProduct(testOpp.id);
    	TermLoansQuotationsCtrOpp.getOpportunityRecord(testOpp.id);
    	TermLoansQuotationsCtrOpp.getOpportunityApplicationProductRecord(testOpp.id);
    	TermLoansQuotationsCtrOpp.getOpportunityApplicationProductRecord(caseRec.id);
    
    TermLoansQuotationsCtrOpp.insertReqBean('003', appPrdct.Id);
    TermLoansQuotationsCtrOpp.insertRespBean('003', appPrdct.Id);
    TermLoansQuotationsCtrOpp.QuoteResponseData(testOpp.id);
    TermLoansQuotationsCtrOpp.QuoteResponseData(caseRec.id);
        TermLoansQuotationsCtrOpp.QuoteRequestData(testOpp.id);
    TermLoansQuotationsCtrOpp.QuoteRequestData(caseRec.id);
    TermLoansQuotationsCtrOpp.getCalculateQuotes(testOpp.id, 'loanAmountP', 'contractDateP', 'firstRepayDateP', 'repayFreqP', 'contractTermP', 'mortgageP', 'ratePrimeP', 'rateFixedP', 'interestRateP', 'initiationFeeP', 'serviceFeeP', 'skipMonthsP', 'creditLifeP', 'debitOrderP', 'quoteNumberP', 'complexStrP', 'initMethodP', 'applicationNumberP', 'purposeOfLoanP', 'maxRateTypeP', 'totalSettleAmountP', 'loanAccToSettleP', 'loanSettleAmountP', 'termLoanTypeP', 'quoteCreatedByP', 'inpmargin', 'inpRate');
    TermLoansQuotationsCtrOpp.getCalculateQuotes(caseRec.id, 'loanAmountP', 'contractDateP', 'firstRepayDateP', 'repayFreqP', 'contractTermP', 'mortgageP', 'ratePrimeP', 'rateFixedP', 'interestRateP', 'initiationFeeP', 'serviceFeeP', 'skipMonthsP', 'creditLifeP', 'debitOrderP', 'quoteNumberP', 'complexStrP', 'initMethodP', 'applicationNumberP', 'purposeOfLoanP', 'maxRateTypeP', 'totalSettleAmountP', 'loanAccToSettleP', 'loanSettleAmountP', 'termLoanTypeP', 'quoteCreatedByP', 'inpmargin', 'inpRate');
    
}
}