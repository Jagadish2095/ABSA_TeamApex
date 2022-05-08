@IsTest
public class updateoverdraftserviceTest {
    
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'cqupdautooverdraftloadv2'}); 
     }
    
    public static testMethod void updateoverdraft() {
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestYearlyDebit();
        appProduct.Debit_Order_Type__c = 'Fixed';
        appProduct.Overdraft_Type__c ='Fixed';
        update appProduct;
        
        Payment_Plan__c paymentPlan = new Payment_Plan__c(Application_Product__c = appProduct.Id,
                                                          Method__c = 'Debit Instruction', 
                                                          Status__c = 'Submitted');
        insert paymentPlan;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                Account = account,
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Type__c = 'Dispute Debit Order',
                                Description = 'test',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Application_Product_Id__c = appProduct.Id,
                                Incident_Date__c = date.today());
        insert caseRec;
        Test.startTest();
        updateoverdraftservice.updateoverdraft(appProduct.Id,caseRec.Id,113);
        Test.stopTest();
    }
    private static String generateDummyQuoteRequestYearlyDebit(){
        String requestString = '{"statusCode":200,"status":null,"message":null,"Fault":null,"PLSA71I":{"inputCopybookLayout":{"inputVisibleCreditIndicator":"N","inputTotalSettlementAmount":"0",';
		requestString += '"inputTermLoanType":"RETL","inputSkipMonths":"","inputServiceFee":"69","inputSchemeType":"","inputSchemeCode":"0","inputRepaymentFrequency":"12","inputRatePrimeIndicator"';
		requestString += ':"Y","inputRateFixedIndicator":"Y","inputQuoteNumber":"848160","inputPurposeOfLoanCode":"02","inputNLRReferenceNbr":"0","inputNCAIndicator":"0","inputMortgageIndicator":';
		requestString += '"N","inputMaxRateType":"52","inputLoanToSettleInfo":{"inputLoanSettlementAmount":"0","inputLoanAccountToSettle":"0"},"inputLoanAmount":"50000","inputInterestRate":"18.25"';
		requestString += ',"inputInitiationFeeMethod":"D","inputInitiationFee":"0","inputFirstRepaymentDate":"20210101","inputFinanceType":"01","inputEmpowermentCode":"","inputDebitOrderIndicator":';
		requestString += '"Y","inputCreditlifeSchemeCode":"0","inputCreditlifePremium":"0","inputCreditLifeIndicator":"N","inputContractTerm":"12","inputContractDate":"20201204",';
		requestString += '"inputComplexStructureIndicator":"N","inputClientCode":null,"inputChannelQuoteCreated":"E","inputApplicationNbr":"00","inputAccountNbr":"3001538219"}},"NBSMSGI":';
		requestString += '{"inputErrorMessage":{"inputMessageTarget":"STD","inputMessageLanguage":"E"}},"NBSAPDPI":{"inputHeader":{"traceIndicator":"Y","channelName":"DP","applicationName":"DP"}}}';
        
        return requestString;
    }
    public static testMethod void getFormattedDate() {
       Date dt = Date.newInstance(1960, 2, 1);
       String dd = updateoverdraftservice.getFormattedDate(dt);
        Date dt1 = Date.newInstance(1960, 12, 11);
       String dd1 = updateoverdraftservice.getFormattedDate(dt1);
    }
    
}