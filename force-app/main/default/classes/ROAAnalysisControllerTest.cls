/**
* @description ROAAnalysisControllerTest for ROA Analysis component
* @author  Khaliq Pasha
* @created 2021-07-15
*/
@isTest
public without sharing class ROAAnalysisControllerTest {
    
     @TestSetup
    static void makeData(){

        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
            SiteCode__c ='8999',
			Advisor_Code__c = '112233'
		);
		insert au;
        
        List<User> currentUser = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		Site__c site = new Site__c();
		site.Name = 'New ATM SIte';
		site.Branch_ATM__c = true;
		site.Branch_Site_Name__c = 'Fourways';
		site.Branch_Site_Code__c = 1007;
		site.Site_Code__c = '8999';
		site.Site_Address__c = 'ABC';
		insert site;

		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			Communication_Method__c = 'Email',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2,
			Country_of_Registration__c = 'South Africa',
			Country_of_Incorporation__c = 'South Africa',
			RepresetentiveName__c = 'anna',
			RepresentativeLastname__c = 'dave'
		);
		insert mainacc;
        
         Account  account = WillsTestDataFactory.createAccount();
        Product2 product = WillsTestDataFactory.createProduct('Savings and Investments Test01','Merchant');
        Product2 prod = new Product2(Name = 'Absa Travel Club', Family = 'Savings',ProductCode='11021', Price_Scheme_Code__c = 'TEST');
        insert prod; 
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
              
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Product2 relProduct = WillsTestDataFactory.createProduct('Savings and Investments Test02','Merchant');
        Product_Product_Entry__c productProductEntry = WillsTestDataFactory.createProductProductEntry(product.Id,relProduct.Id);
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry priceBookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id,relProduct.Id);
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'Stokvel Test',
            Sales_Process__c = 'Physical Channels Process',
            Opportunity_Record_Type__c = 'Physical Channels',
            Request_Name__c = 'TestRequest'
        );
        insert salesProcessType;  
        
        Opportunity opp = new Opportunity();            
        opp.Name = mainacc.Name; //+ ' - ' + productType,
        opp.AccountId = mainacc.Id;
        opp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
        opp.CloseDate = System.today().addDays(7);
        opp.priceBook2Id = standardPriceBook.Id;
         insert opp;
       // opp.RecordTypeId = 1;
        string questionTracker = '[{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"TAX_FREE_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"STAFF_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":true,"answerType":"radio","answerId":"GENERAL_SAVINGS_AND_INVESTMENTS_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"SHARIAH_COMPLAINT"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":true,"answerType":"radio","answerId":"A_REGULATOR_CONTRIBUTION"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":false,"answerType":"radio","answerId":"A_ONCE_OFF_LUMP_SUM"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":false,"answerType":"radio","answerId":"A_ONCE_OFF_LUMP_SUM_WITH_REGULAR_CONTRIBUTION"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GET_FUNDS_AT_MATURITY"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GET_ACCESS_TO_A_PORTION_OF_MY_FUNDS_WHENEVER_REQUIRED"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":true,"answerType":"radio","answerId":"GET_ACCESS_TO_ALL_MY_FUNDS_WHENEVER_REQUIRED"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GIVE_NOTICE_WHEN_I_NEED_FUNDS"},{"sequenceNumber":4,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":""}]]';
        Application__c newApplication = new Application__c();
		newApplication.Name__c    = 'Pjane' ;   
        newApplication.Account__c = mainacc.Id;
        newApplication.Opportunity__c = opp.Id;
        newApplication.ROAQuestionnaire__c = questionTracker;        
        insert newApplication;
        
        
    }
    @IsTest
	public static void getROAQuestionnairePositiveTest() {
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Application__c newApplication = [SELECT ID FROM Application__c WHERE Name__c = 'Pjane' limit 1 ];
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
            String result = ROAAnalysisController.getROAQuestionnaire(newApplication.Id, mainacc.Id);
            Test.stopTest();
            System.assert(result != null, 'Test Working');
        }
    }
    
    @IsTest
	public static void updateApplicationROAQuestionnairePositiveTest() {
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Application__c newApplication = [SELECT ID,ROAQuestionnaire__c FROM Application__c WHERE Name__c = 'Pjane' limit 1 ];
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
            boolean result = ROAAnalysisController.updateApplicationROAQuestionnaire(newApplication.Id, mainacc.Id,newApplication.ROAQuestionnaire__c);
            Test.stopTest();
            System.assert(result == true, 'Test Working');
        }
    }
    
     @IsTest
     public static void testFetchKnockoutQuestions(){
         Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
         Application__c newApplication = [SELECT ID,ROAQuestionnaire__c FROM Application__c WHERE Name__c = 'Pjane' limit 1 ];
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
             string questionList = ROAAnalysisController.fetchKnockoutQuestion('Knockout');
             Test.stopTest();             
             System.assertNotEquals('', 'Error');
         }
    }
    /**
	 * @description attempEntityRiskProfilingTest
	 */
	@IsTest
	static void callGenerateDocsTest() {
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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TheStokvel'];
			//Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			string resp = ROAAnalysisController.callGenerateDocsStokvel(opportunity.Id);
			system.assert(resp!= null, 'assertfailed');
			Test.stopTest();
		}
	}
}