/*
* @author Thabo Senkomane
* @created 2020-08-28
*/
@IsTest
public class caseDecisionControllerTest {

    /**
    * @description dataCreation
    * @author Gulafsha | 2021-07-14 
    **/
    @testSetup
    public static void dataCreation() {
        //ClientDetailsSectionCreditTest.dataCreation();
        Account account = new Account(); 
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
        insert account;

        Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.AccountId = account.Id;
        insert testOpp;

        Application__c appcovid = new Application__c();
		appcovid.Opportunity__c = testOpp.id;
		appcovid.Title__c = 'Dr';
		appcovid.FirstNameSignature__c = 'Rob';
		appcovid.SurnameSignature__c = 'Robbello';
		appcovid.Signing_Date__c = System.today();
        insert appcovid;

        //Application_Product__c
        Application_Product__c appProd = new Application_Product__c();
        appProd.Opportunity__c = testOpp.id;
        appProd.Opportunity_Product_Id__c = testOpp.id;
        appProd.Alternative_Fund_Code__c = '001';
        appProd.Account_Number__c=1111;
        appProd.Product_Type__c = 'CLASSIC BUSINESS ACCOUNT';
        appProd.Secured_By_Mortgage_Bond__c = true;
        appProd.Alternative_Fund_Indicator__c=true;
        appProd.Overdraft_Type__c = 'REDUCING';
        insert appProd;

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MbCreateInstructionV2_IH_V1.INTEGRATION_SERVICE_NAME}); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MBinitiatePaymentV12_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'cqupdautooverdraftloadv2'}); 
    }
    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testGetQueueMembers() {
       Test.startTest();

        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

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

                                Incident_Date__c = date.today());
        insert caseRec;

    // Account acc = [Select Id FROM Account Limit 1];
    //  Case caseRec = [SELECT Id FROM Case where Subject='Test Credit Case' Limit 1];

    System.assert(caseDecisionController.getQueueMembers(caseRec.Id) != null);

        Test.stopTest();
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testMbCreateInstructionV2DebitAppProduct(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2Response()));
        User u = [select id,Name,SiteCode__c,Teller_Operator_Code__c from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id,Account_Number__c FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestMonthlyDebit();
        appProduct.Debit_Order_Type__c = 'Debit';
        appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        //String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, caseRec.Id);
       List<Case> caseList =  new List<Case>();
        caseList.add(caseRec);
        String response = caseDecisionController.MbCreateInstructionV2(caseList);
        caseDecisionController.mapRequestFieldsMBinit(appProduct,u,paymentPlan);
        caseDecisionController.fetchProductInfo(appProduct.id);
        //System.assert(caseDecisionController.fetchProductInfo(appProduct.id) != null);
        Test.stopTest();

        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testMbCreateInstructionV2FixedAppProductMonthlyDebit(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2Response()));
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestMonthlyDebit();
        appProduct.Debit_Order_Type__c = 'Fixed';
        appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        //String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, caseRec.Id);
         List<Case> caseList =  new List<Case>();
        caseList.add(caseRec);
        String response = caseDecisionController.MbCreateInstructionV2(caseList);
        Test.stopTest();

        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testMbCreateInstructionV2FixedAppProductYearlyDebit(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2Response()));
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestYearlyDebit();
        appProduct.Debit_Order_Type__c = 'Fixed';
        appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        //String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, caseRec.Id);
          List<Case> caseList =  new List<Case>();
        caseList.add(caseRec);
        String response = caseDecisionController.MbCreateInstructionV2(caseList);
        Test.stopTest();

        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testMbCreateInstructionV2FixedAppProductQuarterlyDebit(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2Response()));
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestQuarterlyDebit();
        appProduct.Debit_Order_Type__c = 'Fixed';
         appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        //String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, caseRec.Id);
         List<Case> caseList =  new List<Case>();
        caseList.add(caseRec);
        String response = caseDecisionController.MbCreateInstructionV2(caseList);
        Test.stopTest();

        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testMbCreateInstructionV2FixedAppProductSemiAnnuallyDebit(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2Response()));
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestSemiAnnuallyDebit();
        appProduct.Debit_Order_Type__c = 'Fixed';
         appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        //String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, caseRec.Id);
         List<Case> caseList =  new List<Case>();
        caseList.add(caseRec);
        String response = caseDecisionController.MbCreateInstructionV2(caseList);
        Test.stopTest();

        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testCreateDecisionHistory(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateMbCreateInstructionV2ResponseMbInit()));
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Application_Product__c appProduct = [SELECT Id FROM Application_Product__c LIMIT 1];
        appProduct.Quotes_Input_Request__c = generateDummyQuoteRequestMonthlyDebit();
         appProduct.Quotes_Output_Response__c = generateabfResponse();
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
        String response = caseDecisionController.createDecisionHistory('Accepted', 'some comments', 'Documents Missing', u.Name, 'Instruction Result', caseRec.Id,'12345','["Documents Missing","No Credit"]');
        Test.stopTest();
 
        System.assertNotEquals(null, response);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-07-14 
    **/
    @IsTest
    public static void testGetLoggedInUser(){
        User u = [select id,Name,SiteCode__c from User where id =: userInfo.getUserId()];
        System.assertNotEquals(null, caseDecisionController.fetchUser());
    }

    private static String generateDummyQuoteRequestMonthlyDebit(){
        String requestString = '{"statusCode":200,"status":null,"message":null,"Fault":null,"PLSA71I":{"inputCopybookLayout":{"inputVisibleCreditIndicator":"N","inputTotalSettlementAmount":"0",';
		requestString += '"inputTermLoanType":"RETL","inputSkipMonths":"","inputServiceFee":"69","inputSchemeType":"","inputSchemeCode":"0","inputRepaymentFrequency":"1","inputRatePrimeIndicator"';
		requestString += ':"Y","inputRateFixedIndicator":"Y","inputQuoteNumber":"848160","inputPurposeOfLoanCode":"02","inputNLRReferenceNbr":"0","inputNCAIndicator":"0","inputMortgageIndicator":';
		requestString += '"N","inputMaxRateType":"52","inputLoanToSettleInfo":{"inputLoanSettlementAmount":"0","inputLoanAccountToSettle":"0"},"inputLoanAmount":"50000","inputInterestRate":"18.25"';
		requestString += ',"inputInitiationFeeMethod":"D","inputInitiationFee":"0","inputFirstRepaymentDate":"20210101","inputFinanceType":"01","inputEmpowermentCode":"","inputDebitOrderIndicator":';
		requestString += '"Y","inputCreditlifeSchemeCode":"0","inputCreditlifePremium":"0","inputCreditLifeIndicator":"N","inputContractTerm":"12","inputContractDate":"20201204",';
		requestString += '"inputComplexStructureIndicator":"N","inputClientCode":null,"inputChannelQuoteCreated":"E","inputApplicationNbr":"00","inputAccountNbr":"3001538219"}},"NBSMSGI":';
		requestString += '{"inputErrorMessage":{"inputMessageTarget":"STD","inputMessageLanguage":"E"}},"NBSAPDPI":{"inputHeader":{"traceIndicator":"Y","channelName":"DP","applicationName":"DP"}}}';

        return requestString;
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

    private static String generateDummyQuoteRequestQuarterlyDebit(){
        String requestString = '{"statusCode":200,"status":null,"message":null,"Fault":null,"PLSA71I":{"inputCopybookLayout":{"inputVisibleCreditIndicator":"N","inputTotalSettlementAmount":"0",';
		requestString += '"inputTermLoanType":"RETL","inputSkipMonths":"","inputServiceFee":"69","inputSchemeType":"","inputSchemeCode":"0","inputRepaymentFrequency":"3","inputRatePrimeIndicator"';
		requestString += ':"Y","inputRateFixedIndicator":"Y","inputQuoteNumber":"848160","inputPurposeOfLoanCode":"02","inputNLRReferenceNbr":"0","inputNCAIndicator":"0","inputMortgageIndicator":';
		requestString += '"N","inputMaxRateType":"52","inputLoanToSettleInfo":{"inputLoanSettlementAmount":"0","inputLoanAccountToSettle":"0"},"inputLoanAmount":"50000","inputInterestRate":"18.25"';
		requestString += ',"inputInitiationFeeMethod":"D","inputInitiationFee":"0","inputFirstRepaymentDate":"20210101","inputFinanceType":"01","inputEmpowermentCode":"","inputDebitOrderIndicator":';
		requestString += '"Y","inputCreditlifeSchemeCode":"0","inputCreditlifePremium":"0","inputCreditLifeIndicator":"N","inputContractTerm":"12","inputContractDate":"20201204",';
		requestString += '"inputComplexStructureIndicator":"N","inputClientCode":null,"inputChannelQuoteCreated":"E","inputApplicationNbr":"00","inputAccountNbr":"3001538219"}},"NBSMSGI":';
		requestString += '{"inputErrorMessage":{"inputMessageTarget":"STD","inputMessageLanguage":"E"}},"NBSAPDPI":{"inputHeader":{"traceIndicator":"Y","channelName":"DP","applicationName":"DP"}}}';

        return requestString;
    }

    private static String generateDummyQuoteRequestSemiAnnuallyDebit(){
        String requestString = '{"statusCode":200,"status":null,"message":null,"Fault":null,"PLSA71I":{"inputCopybookLayout":{"inputVisibleCreditIndicator":"N","inputTotalSettlementAmount":"0",';
		requestString += '"inputTermLoanType":"RETL","inputSkipMonths":"","inputServiceFee":"69","inputSchemeType":"","inputSchemeCode":"0","inputRepaymentFrequency":"6","inputRatePrimeIndicator"';
		requestString += ':"Y","inputRateFixedIndicator":"Y","inputQuoteNumber":"848160","inputPurposeOfLoanCode":"02","inputNLRReferenceNbr":"0","inputNCAIndicator":"0","inputMortgageIndicator":';
		requestString += '"N","inputMaxRateType":"52","inputLoanToSettleInfo":{"inputLoanSettlementAmount":"0","inputLoanAccountToSettle":"0"},"inputLoanAmount":"50000","inputInterestRate":"18.25"';
		requestString += ',"inputInitiationFeeMethod":"D","inputInitiationFee":"0","inputFirstRepaymentDate":"20210101","inputFinanceType":"01","inputEmpowermentCode":"","inputDebitOrderIndicator":';
		requestString += '"Y","inputCreditlifeSchemeCode":"0","inputCreditlifePremium":"0","inputCreditLifeIndicator":"N","inputContractTerm":"12","inputContractDate":"20201204",';
		requestString += '"inputComplexStructureIndicator":"N","inputClientCode":null,"inputChannelQuoteCreated":"E","inputApplicationNbr":"00","inputAccountNbr":"3001538219"}},"NBSMSGI":';
		requestString += '{"inputErrorMessage":{"inputMessageTarget":"STD","inputMessageLanguage":"E"}},"NBSAPDPI":{"inputHeader":{"traceIndicator":"Y","channelName":"DP","applicationName":"DP"}}}';

        return requestString;
    }

    private static String generateMbCreateInstructionV2Response(){
        String POSITIVE_RESPONSE_BODY = '{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":';
        POSITIVE_RESPONSE_BODY += '{"version":"MSG3041","sysErrTxt":"*EXCEPTION* 07/12/2020 11:15:17. EXCP CODE: 0001. IN PGM: NBM102D. LABEL/SECTION: RZEXPG-H. CALLING PGM: MBP304.';
        POSITIVE_RESPONSE_BODY += 'PROCESS ID: WSDL STUB -MBP304  -","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"RZSMGAB","msgCode":"0003","msgErrInd":"E","msgTxt":';
        POSITIVE_RESPONSE_BODY += '"A technical/system error has occured."}]},"mbp304o":{"todaysDate":"20201207","timeNow":"11151723","respCode":"219","respOther":"0","recsReturn":"0",';
        POSITIVE_RESPONSE_BODY += '"respDesc":"NO PARAMETER FOUND - PARM 08","instrTypeDrcr":null,"instrTypeDuepe":null,"instrTypeAccs":null,"fwWarnInd":null,"instrNo":"0","multiNo":"0",';
        POSITIVE_RESPONSE_BODY += '"intExtBenInd":null,"actDate":"0","trigDate":"0","srcAcc":"000000000000000000000000","srcAccType":null,"srcClrCode":"0","srcInstCode":null,"trgAcc":';
        POSITIVE_RESPONSE_BODY += '"000000000000000000000000","trgAccType":null,"trgClrCode":"0","trgInstCode":null,"corpCode":null,"sbu":null,"clientType":null,"iipAllowInd":null,';
        POSITIVE_RESPONSE_BODY += '"lastChangeNo":"0","lastMaintFunc":null,"changeNo":"0","changeSet":"0","changeDate":"0","changeTime":"0","changeFunc":null,"changeBranch":"0",';
        POSITIVE_RESPONSE_BODY += '"changeTeller":"0","changeOverride":null}}';

        return POSITIVE_RESPONSE_BODY;
    }

    private static String generateMbCreateInstructionV2ResponseMbInit(){
        String POSITIVE_RESPONSE_BODY = '{"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": null,"echoKey": null},"nbsmsgo3": {"version": null,"sysErrTxt": null,';
        POSITIVE_RESPONSE_BODY += '"nbrUserMsgs": "0","nbrUserErrs": "0"},"mbp301o": {"todaysDate": "20201215","timeNow": "21361282","respCode": "0","respOther": "0","recsReturn": "1",';
        POSITIVE_RESPONSE_BODY += '"respDesc": "SUCCESSFUL PROCESS","instrTypeDrcr": "D","instrTypeDuepe": "P","instrTypeAccs": "Y","keyFormat": null,"fwWarnInd": null,';
        POSITIVE_RESPONSE_BODY += '"uniqueEft": "80004A686C","intExtBenInd": "I","actDate": "20201215","trigDate": "0","startDate": "20201215","endDate": "20991231","freq": "OOP",';
        POSITIVE_RESPONSE_BODY += '"srcAccType": "SA","srcClrCode": "632005","srcInstCode": "ABSA BANK","trgAcc": "000000000000004047373006","trgAccType": "CQ","trgClrCode": "632005",';
        POSITIVE_RESPONSE_BODY += '"trgInstCode": "ABSA BANK","corpCode": "Z","sbu": "E","clientType": "I","minPayAmnt": "0","maxPayAmnt": "9999999999999.99","iipAllowInd": null,';
        POSITIVE_RESPONSE_BODY += '"lastChangeNo": "2","lastMaintFunc": "ADD","lastMaintDate": "20201215","lastMaintTime": "21361282","lastMaintBrnch": "00008089","lastMaintTell": "00011012",';
        POSITIVE_RESPONSE_BODY += '"lastMaintOvrId": "00000000","paymNo": "1","paymBusRef": null,"lastMaintOvr2Id": "00000000","lastPaymDate": "20201215","lastPaymAmnt": "50000",';
        POSITIVE_RESPONSE_BODY += '"lastPaymErr": null,"abal": "60301153.94","avbl": "60296268.94","statusCde": "0","statusIndx": "0","statusDesc": null,"primEvno": "396","secEvno": "4772",';
        POSITIVE_RESPONSE_BODY += '"emvscScriptDataLgth": "0","emvscScriptData": null,"productsSpa": "0","initpaymOverride": null,"benGender": null,"benNonResStat": null,"exref": null}}';
        return POSITIVE_RESPONSE_BODY;
    }

    private static String generateabfResponse(){
         String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"outputHeaders":{"serviceVersion":"","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"PLSA71O":{"outputCopybookLayout":{"outputCreditlifeBenefitDetails":"","outputDateLastInstalment":20260530,"outputRegularCapitalAndInterestInstalmentAmount":0.00,"outputDateLastCapitalAndInterestInstalment":0,"outputTermLoanType":"","outputCreditlifeNetPremium":0.00,"outputNumberOfCapitalAndInterestInstalments":0,"outputSuretyInfo":"","outputInterestAndFeesCreditlife":225211.55,"outputCreditlifePolicyFee":0.00,"outputOtherConditions":"","outputHighestInterestOnlyInstamentAmount":0.00,"outputSchemeType":"","outputTotalInstalmentAmount":19694.06,"outputSettlementIndicator":"","outputTotalCostOfCredit":1122561.55,"outputProductCode":"LOAN","outputPaymentMethodDescription":"DEBIT ORDER","outputNCAIndicator":"","outputCreditLife":0.00,"outputEmpowermentCode":"","outputDateFirstInterestOnlyInstalment":0,"outputCreditlifePremium":0.00,"outputMaxRateType":60,"outputTotalAmountRepay":1299808.09,"outpuComplexStructureIndicator":"N","outputSMSInfoRequiredIndicator":"","outputVersionNumber":0,"outputTotalCreditLife":0.00,"outputRateFactorSign":"+","outputApplicationNbr":100,"outputCreditlifeSchemeCode":0,"outputCreditlifeCommission":0.00,"outputVisibleCreditLimitIndicator":"","outputInitiationFee":42350.00,"outputSecurityRequestIndicator":"N","outputTotalAllInstalmentAmount":0.00,"outputSkipPaymentsAmount":0.00,"outputAgreementType":"L","outputSettlementAmount":0.00,"outputBrokenPeriodIndicator":"","outputNLRReferenceNbr":0,"outputLoanAmount":855000.00,"outputNumberOfInstalments":66,"outputEffectiveInterestRate":7.2500,"outputNumberOfInterestOnlyInstalments":0,"outputFinalInstalmentAmount":19694.19,"outputCreditlifeBusnessIndicator":"","outputRateFactorValue":1.7500,"outputTotalServiceFee":0.00,"outputServiceFee":0.00,"outputRegularInstalmentAmount":19694.06,"outputBrokenPeriodInstalmentAmount":0.00,"outputQuoteNbr":848160,"outputSchemeCode":0,"outputContractDate":20201130,"outputTotalInterestOnlyInstalmentAmount":0.00,"outputChannelQuoteCreated":"","outputRateType":"P","outputTotalSettlementAmount":0.00,"outputTotalInterestAndCapitalInstalmentAmount":0.00,"outputPurposeOfLoanCode":2,"outputNumberOfSkipPayments":9,"outputSkipMonths":9,"outputInitiationFeePaymentMethod":"P","outputDateLastInterestOnlyInstalment":0,"outputTotalFinanceCharges":225211.55,"outputInstalmentIncludingCreditlife":19694.06,"outputAccountType":1,"outputInstalmentFrequencyDescription":"MONTHLY","outputDateFirstInstalment":20201230,"outputCostOfCreditMultiple":1.31,"outputDateFirstCapitalAndInterestInstalment":0,"outputPaymentMethod":"Y","outputTotalAmountDeferred":897350.00,"outputInstalmentFrequency":1,"outputCreditlifeRequestIndicator":"N","outpuCreditlifeSchemeNbr":0,"outputNumberOfRegularInstalments":65}},"NBSMSGO3":{"outputErrorMessage":{"errorMessageVersion":"","outputErrorMessageTable":[{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"                         000000","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"systemErrorTxt":"0000000000BUSO006","numberUserErrors":0,"numberUserMessages":0}}}';
        return POSITIVE_RESPONSE_BODY;

    }
}