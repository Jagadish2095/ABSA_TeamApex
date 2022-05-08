/**
 * @description RiskProfileNonIndividualClientV7_test
 */
@istest
public with sharing class RiskProfileNonIndividualClientV7_test {
	/**
	 * @description       :
	 */
	@testSetup
	public static void dataCreation() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';

		//Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			sitecode__c = '8404',
			Teller_Operator_Code__c = '878',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233',
			SiteType__c = '034'
		);
		insert au;
		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
		insert savingsprod;

		PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPrice;

		Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
		salesProcess.Request_Name__c = 'CAF Application';
		salesProcess.Name = 'stokvel Application';
		salesProcess.Opportunity_Record_Type__c = 'CAF Application';
		insert salesProcess;
		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity savingsOpportunity = new Opportunity();
		savingsOpportunity.Name = 'Test Savings Onboarding';
		savingsOpportunity.CloseDate = Date.today();
		savingsOpportunity.StageName = 'New';
		savingsOpportunity.Pricebook2Id = pb.id;
		savingsOpportunity.AccountId = mainacc.id;
		savingsOpportunity.Site__c = siteRec.id;
		savingsOpportunity.CBPIndicator__c = '123456789';
		insert savingsOpportunity;

		OpportunityLineItem savingsLineItem = new OpportunityLineItem();
		savingsLineItem.OpportunityId = savingsOpportunity.id;
		savingsLineItem.Product2Id = savingsprod.id;
		savingsLineItem.PricebookEntryId = savingsPrice.id;
		//savingsLineItem.Product_Name__c = 'savinfn';
		savingsLineItem.Quantity = 1;
		savingsLineItem.TotalPrice = 100;
		savingsLineItem.Policy_Number__c = '9051159122';
		insert savingsLineItem;
	}
    @isTest static void rikprofile() 
    {    LIST< OpportunityLineItem> oppLineItem = [SELECT Id, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '9051159122']; 
         User userRec = [ SELECT ID ,Alias,	Email,sitecode__c,Teller_Operator_Code__c,UserName,	MobilePhone,SiteType__c from user WHERE Email= 'UserAdmin@testorg.com'];
   
        WQRiskProfileClientV7_Req_IB_v1 requestBean = new WQRiskProfileClientV7_Req_IB_v1();
		Account mainAccount = [
			SELECT Id, CASA_Reference_Number__c, CIF__C, Client_Group__c, Countries_Traded_With__c, Source_of_Income__c, Name
			FROM Account
			WHERE NAME  = 'TheStokvel'
			WITH SECURITY_ENFORCED
		];

		List<String> lineItemIds = new List<String>();
		for (OpportunityLineItem item : oppLineItem) {
			lineItemIds.add(item.Id);
		}
		List<Product2> p = [
			SELECT ProductCode, Price_Scheme_Code__c
			FROM Product2
			WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE Id IN :lineItemIds AND ProductCode != NULL)
			WITH SECURITY_ENFORCED
		];
		//for (Product2 item : p) {
			WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable prodEntry = new WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable();
			WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable subProdEntry = new WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable();
			prodEntry.productCode = '09072';
			subProdEntry.subProductCode = '0900';
     		List<WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable> lpprodEntry = new List<WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable>();
			lpprodEntry.add( prodEntry);
			List<WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable> subbprodEntry = new List<WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable>();
			subbprodEntry.add(subProdEntry);
       // }
	   WQRiskProfileClientV7_Req_IB_v1.WQriskProfileClientV7Request  WQriskProfileClientV7Request = new WQRiskProfileClientV7_Req_IB_v1.WQriskProfileClientV7Request();

		WQriskProfileClientV7Request.customerTypeCode = 'S0OO3';
	/*	requestBean.WQriskProfileClientV7Request.customerStatusCode = '';
		requestBean.WQriskProfileClientV7Request.customerSourceUniqueId = mainAccount.CASA_Reference_Number__c;
		requestBean.WQriskProfileClientV7Request.companyForm = '07401';
		requestBean.WQriskProfileClientV7Request.customerSourceRefID = mainAccount.CASA_Reference_Number__c;
		requestBean.WQriskProfileClientV7Request.cifkey= mainAccount.CIF__C;
		requestBean.WQriskProfileClientV7Request.occupation = '';
		requestBean.WQriskProfileClientV7Request.businessSegment1 = '01';
		requestBean.WQriskProfileClientV7Request.employmentStatus = '';
		requestBean.WQriskProfileClientV7Request.primeBranchID = '2626';
		WQRiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable sofEntry = new WQRiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable();
		sofEntry.absaSourceOfIncome = '45';
		requestBean.WQriskProfileClientV7Request.absaSourceOfIncomeTable.add(sofEntry);

		WQRiskProfileClientV7_Req_IB_v1.AbsaCountryTradedWithTable absaCountryTradeWithPrimaryClientObj = new WQRiskProfileClientV7_Req_IB_v1.AbsaCountryTradedWithTable();

		absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = 'S0O3';
		requestBean.WQriskProfileClientV7Request.AbsaCountryTradedWithTable.add(absaCountryTradeWithPrimaryClientObj);
		WQRiskProfileClientV7_Req_IB_v1.AbsaCountryOfOperationTable absaCountryOfOperationRelatedPartyObj = new WQRiskProfileClientV7_Req_IB_v1.AbsaCountryOfOperationTable();
		absaCountryOfOperationRelatedPartyObj.absaCountryOfOperation = 'S0O3';
		requestBean.WQriskProfileClientV7Request.absaCountryOfOperationTable.add(absaCountryOfOperationRelatedPartyObj);
*/
		//OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
		//List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(opportunityId);
		
        User au = new User();
    Set<String> userEmails = new Set<String>();
    userEmails.add('UserAdmin@testorg.com');
    List<User> userList = new UsersSelector().selectByEmail(userEmails);
    if (userList.size() > 0) {
        for (User u : userList) {
            if (u.Email == 'UserAdmin@testorg.com') {
                au = u;
            }
        }
    }
    System.runAs(au) {
        Test.startTest();
        CASARiskProfileClientV7_Resp_IB_v1 obj = RiskProfileNonIndividualClientV7_IH_v1.RiskProfileNonIndividualClientV7(
			requestBean
        );
        System.assert(obj != null, 'assert failed');
        Test.stopTest();
	
    }
    }
}