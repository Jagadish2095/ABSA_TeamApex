/**
 * @description       :
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * @last modified on  : 2021-07-19

 * @last modified by  : englarmerdge.mongwe@absa.africa

 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   ephetehe.mokgopanyane@tetrad.co.za   Initial Version
 **/
@isTest
public class CreditCardCtrlTest {
	/**
	 * @description date creation
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
	 **/
	@TestSetup
	public static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CommercialBureauEnquiry_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Account account = new Account();
		account.Name = 'Test Account';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
		account.Client_Type__c = 'Company';
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
		application.Accounts_Orchestration_JSON__c = generateDummyAccountsOrch();
		insert application;

		List<Application_Product__c> appProds = new List<Application_Product__c>();
		Application_Product__c appProd = new Application_Product__c();
		appProd.Product_State__c = 'Existing';
		appProd.Product_Name__c = 'Credit Card';
		appProd.Account_Balance__c = 90000;
		appProd.Account_Number__c = 12345667;
		appProd.Credit_Card_Limit__c = 78000;
		appProd.Allocated_Limit__c = 54500;
		appProd.Requested_facility_limit__c = '100000';
		appProd.Opportunity_Product_Id__c = 'Test';
		appProd.Opportunity__c = opportunity.Id;
		appProds.add(appProd);

		appProd = new Application_Product__c();
		appProd.Product_State__c = 'New';
		appProd.Product_Name__c = 'Credit Card';
		appProd.Account_Balance__c = 90000;
		appProd.Account_Number__c = 12345667;
		appProd.Credit_Card_Limit__c = 78000;
		appProd.Allocated_Limit__c = 54500;
		appProd.Requested_facility_limit__c = '100000';
		appProd.Opportunity_Product_Id__c = 'Test';
		appProd.Opportunity__c = opportunity.Id;
		appProds.add(appProd);

		insert appProds;

		Product2 prod = new Product2(Name = 'Credit Card', Family = 'Credit Card');
		insert prod;

		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		system.assertNotEquals(null, application);
	}

	@isTest
	public static void testGetExistingAccounts() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, generateDummyAccountsOrch()));

		Test.startTest();
		List<Map<String, String>> existingAccs = CreditCardCtrl.getExistingAccounts(opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, existingAccs);
	}

	@isTest
	public static void testGetManagedAccounts() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Test.startTest();
		List<Map<String, String>> mngdAccs = CreditCardCtrl.getManagedAccounts(opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, mngdAccs);
	}

	@isTest
	public static void testGetNewAccounts() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Test.startTest();
		List<Application_Product__c> newAccs = CreditCardCtrl.getNewAccounts(opp.Id);
		Test.stopTest();

		System.assertNotEquals(null, newAccs);
	}

	@isTest
	public static void testCreateNewCreditCard() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Test.startTest();
		Application_Product__c appProduct = CreditCardCtrl.createNewCreditCard(opp.Id);
		System.assertNotEquals(null, appProduct);
		Test.stopTest();
	}

	@isTest
	public static void testDeleteManagedAccount() {
		Application_Product__c appProd = [SELECT Id FROM Application_Product__c LIMIT 1];

		Test.startTest();
		Boolean deleteResult = CreditCardCtrl.deleteManagedAccount(appProd.Id);
		System.assertEquals(false, deleteResult);
		Test.stopTest();
	}
    	@isTest
	public static void testSaveAndValidateData() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		List<Application_Product__c> appProds = [SELECT Id, Opportunity__c, Account_Number__c FROM Application_Product__c WHERE Product_State__c = 'New'];
        Application__c app = [Select id, Accounts_Orchestration_JSON__c from Application__c where Opportunity__c =: opp.Id limit 1 ];
        app.Accounts_Orchestration_JSON__c = Null; //Setting this to null to avoid Conduct Exception
        Update app;
        
		Test.startTest();
        
		Boolean dmlSuccess = CreditCardCtrl.saveAndValidateData(
			'[{"accountNumber":"04550190014023019","creditCardLimit":"15000","allocatedLimit":"15000","accBalance":"0","accStatus":"NWD","accStatusDesc":"NEW ACC DECLINE","instalment":"0","serviceFeeAmnt":"0","interestRate":"0","interestType":"V","expiryDate":"19000000","requestedCreditCardLimit":"1345000.00","campaignCode":"Test","recordId":"","opportunityId":"' +
			opp.Id +
			'"}]',
			appProds
		);
		System.assertEquals(true, dmlSuccess);
		Test.stopTest();
	}

	/**
	 * @description dummy Response
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
	 * @return String
	 **/
	public static String generateDummyAccountsOrch() {
		string response = '{"CQgetBasicAcctDetailsV7Responses":[{"CQgetBasicAcctDetailsV7Response":{"cqh455o":{"accntCloseDate":0,"accountBalance":-535083.51,"accountDomicleBrch":0,"accountDomicleDiv":null,"accountHolds":[{';
		response += '"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":"HIGH RISK"},{"accountHold":"PBD"},{"accountHold":"POT-BD-DBT"},{"accountHold":"SEC:NONE"},{"accountHold":"SIGN-HELD"}],"accountInactiveInd":null,"accountNo":4047896791,"accountStatus":1,"accountType":19,';
		response += '"authHoldAmt":0,"availBal":0,"bomSponsoredAmt":0,"branchCode":8392,"businessUnit":1,"chargesDue":-5,"clearingCode":516805,"clientFullName":"WE HEAR TRADING AND PROJECTS CC","closeReason":0,"commitmentInterest":0,';
		response += '"creditInterestDue":0,"dateOvrdrftArrngd":0,"daylightExpryDate":0,"daylightLimit":0,"debitInterestDue":-5204.24,"digitalChannel":null,"division":"ABS","empowermentFund":null,"fullCrTrckngInd":"N","guarnteeAmtReserved":0,';
		response += '"markedCheqsAmt":0,"ncaAgreemntInd":"N","negotiatedCheqAmt":0,"newNxtStmntDate":0,"newStmtFreq":0,"nxtStmntDate":20210611,"offlnAuthAmt":0,"onedaypaafInd":null,"onedaypaafTot":0,"openDate":20161111,"openReason":99,';
		response += '"overdraftExists":"N","overdraftLimit":0,"overdraftType":0,"ovrdrftExpryDate":0,"penaltyInt":-933.89,"postDatedTran":0,"prefStmntInd":"N","rconNxtStmntDate":20190311,"rconStmntFreq":1,"returnedCheques":0,"specialName":null,';
		response += '"statementImageInd":"N","stmntFreq":1,"stmntReleaseInd":"P","stmntReqdInd":"Y","unclearedCheqs":0,"unilatrlLimitIncrease":"N","wapHold":null},"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO006",';
		response += '"version":null},"nbsmsgo3":{"msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,';
		response += '"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}],"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":"MSG3001"}}},';
		response += '{"CQgetBasicAcctDetailsV7Response":{"cqh455o":{"accntCloseDate":0,"accountBalance":-10234.03,"accountDomicleBrch":0,"accountDomicleDiv":null,"accountHolds":[{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":"CMS"},{"accountHold":"HIGH RISK"},{"accountHold":"PBD"},';
		response += '{"accountHold":"POT-BD-DBT"},{"accountHold":"SEC:NONE"},{"accountHold":"SIGN-HELD"}],"accountInactiveInd":null,"accountNo":4047938030,"accountStatus":1,"accountType":19,"authHoldAmt":0,"availBal":0,"bomSponsoredAmt":0,';
		response += '"branchCode":5920,"businessUnit":1,"chargesDue":-5,"clearingCode":630066,"clientFullName":"WE HEAR TRADING AND PROJECTS CC","closeReason":0,"commitmentInterest":0,"creditInterestDue":0,"dateOvrdrftArrngd":0,';
		response += '"daylightExpryDate":0,"daylightLimit":0,"debitInterestDue":0,"digitalChannel":null,"division":"ABS","empowermentFund":null,"fullCrTrckngInd":"N","guarnteeAmtReserved":0,"markedCheqsAmt":0,"ncaAgreemntInd":"N",';
		response += '"negotiatedCheqAmt":0,"newNxtStmntDate":0,"newStmtFreq":0,"nxtStmntDate":20210613,"offlnAuthAmt":0,"onedaypaafInd":null,"onedaypaafTot":0,"openDate":20170613,"openReason":99,"overdraftExists":"N","overdraftLimit":0,';
		response += '"overdraftType":0,"ovrdrftExpryDate":0,"penaltyInt":0,"postDatedTran":0,"prefStmntInd":"N","rconNxtStmntDate":20190313,"rconStmntFreq":1,"returnedCheques":0,"specialName":null,"statementImageInd":"N","stmntFreq":1,';
		response += '"stmntReleaseInd":"P","stmntReqdInd":"Y","unclearedCheqs":0,"unilatrlLimitIncrease":"N","wapHold":null},"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO006","version":null},';
		response += '"nbsmsgo3":{"msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},';
		response += '{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}],"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":"MSG3001"}}},';
		response += '{"CQgetBasicAcctDetailsV7Response":{"cqh455o":{"accntCloseDate":20200526,"accountBalance":0,"accountDomicleBrch":0,"accountDomicleDiv":null,"accountHolds":[{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":"HIGH RISK"},{"accountHold":"SEC:NONE"}],"accountInactiveInd":null,"accountNo":4048226812,"accountStatus":99,"accountType":19,"authHoldAmt":0,"availBal":0,"bomSponsoredAmt":0,';
		response += '"branchCode":8055,"businessUnit":1,"chargesDue":0,"clearingCode":631005,"clientFullName":"WE HEAR TRADING AND PROJECTS CC","closeReason":93,"commitmentInterest":0,"creditInterestDue":0,"dateOvrdrftArrngd":0,';
		response += '"daylightExpryDate":0,"daylightLimit":0,"debitInterestDue":0,"digitalChannel":"ESPB","division":"ABS","empowermentFund":null,"fullCrTrckngInd":"N","guarnteeAmtReserved":0,"markedCheqsAmt":0,"ncaAgreemntInd":"N",';
		response += '"negotiatedCheqAmt":0,"newNxtStmntDate":0,"newStmtFreq":0,"nxtStmntDate":99999999,"offlnAuthAmt":0,"onedaypaafInd":null,"onedaypaafTot":0,"openDate":20191128,"openReason":99,"overdraftExists":"N","overdraftLimit":0,';
		response += '"overdraftType":0,"ovrdrftExpryDate":0,"penaltyInt":0,"postDatedTran":0,"prefStmntInd":"N","rconNxtStmntDate":20191228,"rconStmntFreq":1,"returnedCheques":0,"specialName":null,"statementImageInd":"N","stmntFreq":1,';
		response += '"stmntReleaseInd":"P","stmntReqdInd":"Y","unclearedCheqs":0,"unilatrlLimitIncrease":"N","wapHold":null},"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO006","version":null},"nbsmsgo3":';
		response += '{"msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,';
		response += '"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}],"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":"MSG3001"}}},{"CQgetBasicAcctDetailsV7Response":';
		response += '{"cqh455o":{"accntCloseDate":0,"accountBalance":0,"accountDomicleBrch":0,"accountDomicleDiv":null,"accountHolds":[{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},';
		response += '{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":"HIGH RISK"},{"accountHold":"NEW-ACCNT"},{"accountHold":"SEC:NONE"},';
		response += '{"accountHold":"SIGN-HELD"}],"accountInactiveInd":null,"accountNo":4048499718,"accountStatus":1,"accountType":21,"authHoldAmt":0,"availBal":50000,"bomSponsoredAmt":0,"branchCode":8392,"businessUnit":1,"chargesDue":0,';
		response += '"clearingCode":516805,"clientFullName":"WE HEAR TRADING AND PROJECTS CC","closeReason":0,"commitmentInterest":0,"creditInterestDue":0,"dateOvrdrftArrngd":20210518,"daylightExpryDate":0,"daylightLimit":0,';
		response += '"debitInterestDue":0,"digitalChannel":"FBSS","division":"ABS","empowermentFund":null,"fullCrTrckngInd":"N","guarnteeAmtReserved":0,"markedCheqsAmt":0,"ncaAgreemntInd":"N","negotiatedCheqAmt":0,"newNxtStmntDate":0,';
		response += '"newStmtFreq":0,"nxtStmntDate":20210618,"offlnAuthAmt":0,"onedaypaafInd":null,"onedaypaafTot":0,"openDate":20210518,"openReason":2,"overdraftExists":"Y","overdraftLimit":50000,"overdraftType":1,';
		response += '"ovrdrftExpryDate":99999999,"penaltyInt":0,"postDatedTran":0,"prefStmntInd":"N","rconNxtStmntDate":0,"rconStmntFreq":0,"returnedCheques":0,"specialName":null,"statementImageInd":"N","stmntFreq":1,"stmntReleaseInd":"P",';
		response += '"stmntReqdInd":"Y","unclearedCheqs":0,"unilatrlLimitIncrease":"N","wapHold":null},"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO006","version":null},"nbsmsgo3":{"msgEntry":[{';
		response += '"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,';
		response += '"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}],"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":"MSG3001"}}}],"CAgetCassACSBEnqV1Responses":[{';
		response += '"CAgetCassACSBEnqV1Response":{"cap918o":{"accType":"SLB","accountBalance":0,"acctStatCd":"NWD","allocatedLimit":15000,"amtBhvrScore":999,"budgetInst":0,"budgetLimit":0,"cifKey":"DPCC   780","creditLimit":15000,';
		response += '"debtIntRate":12.5,"expiryDate":19000000,"garageInd":"N","iniFixFee":300,"iniMaxFee":0,"iniPctFee":0,"iniThresholdAmt":0,"initFeePrev":"N","instalment":0,"intRate":0,"intRateType":"V","kbAcctNbr":"04550190014023019",';
		response += '"paymentOption":100,"raAcctNbr":"00000000000000000000000","returnCd":0,"returnMsg":"ACTION SUCCESSFUL","serviceFee":0,"settlementAmt":0,"statCdDescr":"NEW ACC DECLINE","subProd":"VIS","uniLimitIncr":"N"},"nbsapdpo":';
		response += '{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001","version":null}}}]}';
		return response;
	}
}