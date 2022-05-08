/*
Controller Test Class For PackageLinkProductController class
*
* @author  Satya Boyenepalli
* @version v1.0
* @since   2021-02-26
*
*/
@isTest
public class PackageLinkControllerTest 
{
    public static final String POSITIVE_RESPONSE_BODY_IDNUMBER = '{"customerDetails":null,"currentCustomerPackages":null,"qualifyingPackages":[{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025054011","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]},{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025104014","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]}]}';
    public static final String POSITIVE_RESPONSE_BODY_CLIENT ='{"customerDetails":null,"currentCustomerPackages":null,"qualifyingPackages":[{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025054011","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]},{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025104014","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]}]}}';
    public static final String POSITIVE_RESPONSE_BODY_CREATE = '{"responseReason":"","responses":{"chequeResponse":"","cardResponse":""},"packageId":"210317095548571632","chequeAccountNumber":"4048374003","creditAccountNumber":"04550270024348018","packageType":"GOLD","pricingSchemeCode":"CQT01S03"}';
    @testSetup
    static void makeData(){   
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ClientKey_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{idNumber_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Create_IH_v1.INTEGRATION_SERVICE_NAME});  
        
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'Onboard New Product Everyday Banking Test',
            Sales_Process__c = 'Physical Channels Process',
            Opportunity_Record_Type__c = 'Physical Channels',
            Request_Name__c = 'TestRequest'
        );
        insert salesProcessType;   
        
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
			Advisor_Code__c = '112233',
            SiteCode__c = '1334'
		);
		insert au;

    }
    @isTest
    public static void GetPackagesProductbyClientkeys()
    {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CLIENT));
        ClientKey_Req_IB_v1 requestBean = new ClientKey_Req_IB_v1();
        requestBean.clientKey='KRUGET 004';
        requestBean.Channel = new ClientKey_Req_IB_v1.Channel();
        requestBean.Channel.agentUserId='exsb149';
        requestBean.Channel.branch='8474';
        requestBean.Channel.deviceId='deviceid';
        requestBean.Channel.deviceType='laptop';
        requestBean.Channel.siteCode = 8474;  
        requestBean.Channel.tellerId='000878'; 
        requestBean.Channel.employeeNumber='9117669';
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
        string   responseBean = PackageLinkController.GetLinkProductsByCif('KRUGET 004');
        system.assertNotEquals('', 'error on test');
        Test.stopTest();
        }
    }
    @isTest
    public static void GetPackagesProductbyIdNumbers()
    {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_IDNUMBER));
        string idNumber='6409090192003';
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
        idNumber_Resp_IB_v1 responseBeanID = new idNumber_Resp_IB_v1();
        string packages = PackageLinkController.GetLinkProductsById(idNumber);
        System.assertNotEquals('', 'error in method');
        Test.stopTest();
        }
    }
    @isTest
    public static void CreateLinkTest() //'GROENJ 004','4048374003','04550270024348018','CQT01S03','GOLD'
    {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CREATE));
        //string tclientKey,string tchequeAccountNumber,string tcreditAccountNumber, string tpricingCode,string tpackageName
        string packageid;
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
        packageid = PackageLinkController.CreatePackageLink('ADAMSB 029','4048234415','4550270025143012','CQT01S48','GOLD');
        System.assertNotEquals('', 'Error');
        Test.stopTest();
        //return packageid;
        }
    }
    @isTest 
    public static void testgetDetails(){
        
        String products = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
        
        ROAProduct__c product = new ROAProduct__c();
        //product.Name = 'a2B5E000001c7zx';
        product.ProductId__c = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE';
        product.Description__c = 'Gold Package';
        product.Code__c = '11032 CQT01S48';
        product.PackageChargeOption__c = '';
        product.Synopsis__c = 'A transactional account vehicle that allows you to have an affordable Silver, Gold or Platinum Value Bundle pricing option. Each Value Bundle is simple to understand and unique in its design, offering a pricing option that suits your need. You can now take control of your bank charges and benefit from discounts on your monthly management fee, cash backs, option to apply for a credit card, overdraft facilities and numerous other value added benefits.';
        insert product;
        
        
        ROAFeature__c feature1 = new ROAFeature__c();
        feature1.Recommended_Income__c = 'R4 000.00';
        feature1.Montly_Fee__c = 'R149.00';
        feature1.Cheque_Monthly_Fee__c='R219.00';
        feature1.Credit_Card_Monthly_Account_Fee__c='R219.00';
        feature1.Credit_Card_Facility_Fee__c='R219.00';
        feature1.Pdf_Url__c = 'http://oneintranet.intra.absaafrica/sites/ppsg/Product%20Information%20UAT/Gold%20Package.pdf';
        feature1.Name = 'Gold Package';
        insert feature1;
        
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
        List<FnbSynopsesWrapper.Product> resp = PackageLinkController.getDetails(products);
        System.assert(resp != null);
        Test.stopTest();
        }
    }
    @isTest 
    public static void testgetDetails2(){
        
        String products = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
        
        ROAProduct__c product = new ROAProduct__c();
        //product.Name = 'Premium Package';
        product.ProductId__c = 'ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
        product.Description__c = 'Premium Package';
        product.Code__c = '11032 CQT01S49';
        product.PackageChargeOption__c = '';
        product.Synopsis__c = 'A transactional account vehicle that allows you to have an affordable Silver, Gold or Platinum Value Bundle pricing option. Each Value Bundle is simple to understand and unique in its design, offering a pricing option that suits your need. You can now take control of your bank charges and benefit from discounts on your monthly management fee, cash backs, option to apply for a credit card, overdraft facilities and numerous other value added benefits.';
        insert product;
        
        
        ROAFeature__c feature = new ROAFeature__c();
        feature.Recommended_Income__c = 'R25,000.00';
        feature.Montly_Fee__c = 'R219.00';
        feature.Cheque_Monthly_Fee__c='R219.00';
        feature.Credit_Card_Monthly_Account_Fee__c='R219.00';
        feature.Credit_Card_Facility_Fee__c='R219.00';
        feature.Pdf_Url__c = 'http://oneintranet.intra.absaafrica/sites/ppsg/Product%20Information%20UAT/Premium%20Package.pdf';
        feature.Name = 'Premium Package';
        insert feature;
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
        List<FnbSynopsesWrapper.Product> resp = PackageLinkController.getDetails2(products);
        System.assert(resp != null);
        Test.stopTest();
        }
    }
    @isTest 
    public static void testgetSalesProcessData() {
        String requestName= [SELECT Name FROM Sales_Process_Type__c WHERE Name =:'Onboard New Product Everyday Banking Test' ].Name;
        Test.startTest();        
        PackageLinkController.getSalesProcessData(requestName);
        System.assert(requestName != null);
        Test.stopTest();
    }
    
    @isTest 
    public static void testgetNewOpportunityPositive() {
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11032');
        insert prod; 
        
        Product2 relProd = new Product2(Name = 'Credit Product', Family = 'Credit',ProductCode='11032');
        insert relProd;
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account acc = new Account();       
        acc.FirstName='First test';
        acc.LastName='last test';
        acc.CIF__c='LTD 933';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        insert acc;
        
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=acc.id;
        opp.Site__c=siteRec.id;
        insert opp;
        
        Product_Product_Entry__c productProductEntry = new Product_Product_Entry__c(
            Parent_Product__c = prod.Id,
            Related_Product__c = relProd.Id
        );
        
        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;  
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Electronic_Statements__c=false;
        insert app;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;
        
        //  String productType= [SELECT Product_Type__c FROM Product2 WHERE Name =:'Premium Package Test01'].Product_Type__c;
        String requestName= [SELECT Name FROM Sales_Process_Type__c WHERE Name =:'Onboard New Product Everyday Banking Test' ].Name;
        
        Test.startTest();
        
        Map<String, String> oppMap = PackageLinkController.getNewOpportunity( acc.id , prod.ProductCode, prod.Product_Type__c, requestName,'210315150357777965' );
        // System.AssertEquals(oppMap.size(),2);
        System.assertNotEquals('', 'error in method');
        Test.stopTest();
        
    }
    
    
    
    @isTest 
    public static void testgetUpdatePackage() {
        
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today(), CBPIndicator__c='210315150357777965');
        insert opp;
        //opp.COpportunityBPIndicator__c = '210315150357777965';
        
        opp = [Select CBPIndicator__c From Opportunity where Id= :opp.Id];
        System.assertEquals('210315150357777965', opp.CBPIndicator__c);
        PackageLinkController.UpdatePackage(opp.Id, opp.CBPIndicator__c);
        update opp;
        
        /*Test.startTest();        
PackageLinkController.UpdatePackage('0065E00000HZI50QAH','210315150357777965');
Test.stopTest();*/
    }
    
    @isTest 
    public static void testgetPackageIndicatorPositive() {
        
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today(), CBPIndicator__c='210315150357777965');
        insert opp;     	
        Test.startTest();        
        PackageLinkController.GetPackageIndicator(opp.Id);
        System.assertNotEquals('', 'error in method');
        Test.stopTest();
    }
    @isTest 
    public static void testgetPackageIndicatorNegative() {
        
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today());
        insert opp;     	
        Test.startTest();        
        PackageLinkController.GetPackageIndicator(opp.Id);
        System.assertNotEquals('', 'error in method');
        Test.stopTest();
    }
    @isTest public static void UpdatePackageTest(){
        string result='';
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today());
        insert opp;  
        Test.startTest();
        try
        {
            result = PackageLinkController.UpdatePackage(opp.Id,'987654321987654321');
            system.assert(true);
        }catch(DMLException ex)
        {
            System.assertNotEquals(ex, null);
        }
        Test.stopTest();
    }
    @isTest public static void UpdatePackageTestNegative(){
        string result='';
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today());
        insert opp; 
        Test.startTest();
        result = PackageLinkController.UpdatePackage(opp.Id,'987654321987654321');
        system.assert(true);
        Test.stopTest();
    }
    @isTest public static void GetPackageTest(){
        string result='';
        Opportunity  opp =new Opportunity (Name='Testing', StageName='Testing',CloseDate = date.today());
        insert opp;  
        Test.startTest();
        result = PackageLinkController.GetPackageIndicator(opp.Id);
        system.assert(true);
        Test.stopTest();
    }
}