/**
* @description SVcreateAndLinkAccountControllerTest
* 06-09-2021	Brian Maswanganyi   add test to pull request
* 08-09-2021	Brian Maswanganyi   redeploy to SIT
* 28-10-2021	Brian Maswanganyi   redeploy to SIT
*/
@isTest
public class SVcreateAndLinkAccountControllerTest{
    public static final String POSITIVE_RESPONSE_BODY = '{"data":{"AccountNumber": "9051159133"},"status": "","errors": []}';
    public static final String UPDATE_POSITIVE_RESPONSE_BODY = '{    "NBSMSGO": {    "NBSMSGO3": {    "systemErrorText": "",    "messageVersion": "",    "messageEntry": [    {    "messageText": "",    "messageClass": "",    "messageErrorIndicator": "",    "messageCode": ""    },    {    "messageText": "",    "messageClass": "",    "messageErrorIndicator": "",    "messageCode": ""    },    {    "messageText": "",    "messageClass": "",    "messageErrorIndicator": "",    "messageCode": ""    },    {    "messageText": "",    "messageClass": "",    "messageErrorIndicator": "",    "messageCode": ""    },    {    "messageText": "",    "messageClass": "",    "messageErrorIndicator": "",    "messageCode": ""    }    ],    "numberUserErrors": 0,    "numberUserMessages": 0    }    },    "NBSAPDPO": {    "NBSAPLO": {    "serviceVersion": "BUSO002",    "returnCode": 0,    "reasonCode": 0    }    }}';
    
    @TestSetup
    static void makeData(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ SVcreateLinkSavingsAccount_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'SVupdateAccountOpeningDetailsV2'});

        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime()+'@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id
                      FROM Profile
                      WHERE Name = 'Standard User (Branch)'];
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
            Advisor_Code__c = '112233');
        insert au;
        
        Account mainacc = new Account(Name = 'TheStokvel', Phone = '0840404898', CIF__c = 'SEBENZA037', 
                                      CASA_Reference_Number__c = '121229158', Client_Group__c = 'Non Individual', Number_of_Participants__c = 2);
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
        salesProcess.Name = 'CAF Application';
        salesProcess.Opportunity_Record_Type__c = 'CAF Application';
        insert salesProcess;
        
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        
        account.CIF__c = 'LTD 933';
        account.Language__c = 'english';
        account.Number_Of_Dependents__c = 0;
        account.PersonEmail = 'test@absa.africa';
        account.PersonMobilePhone = '0819908786';
        account.ID_Type__pc = 'PASSPORT';
        account.Nationality__pc = 'ZIM';
        account.Highest_Qualification__pc = 'Matric';
        account.Residential_Status__pc = 'Owner';
        account.Marital_Status__pc = 'MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;
        
        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;
        
        Opportunity savingsOpportunity = new Opportunity();
        savingsOpportunity.Name = 'Test Savings Onboarding';
        savingsOpportunity.CloseDate = Date.today();
        savingsOpportunity.StageName = 'New';
        savingsOpportunity.Pricebook2Id = pb.id;
        savingsOpportunity.AccountId = account.id;
        savingsOpportunity.Site__c = siteRec.id;
        savingsOpportunity.CBPIndicator__c = '123456789';
        insert savingsOpportunity;
        
        OpportunityLineItem savingsLineItem = new OpportunityLineItem();
        savingsLineItem.OpportunityId = savingsOpportunity.id;
        savingsLineItem.Product2Id = savingsprod.id;
        savingsLineItem.PricebookEntryId = savingsPrice.id;
        savingsLineItem.Quantity = 1;
        savingsLineItem.TotalPrice = 100;
        savingsLineItem.Policy_Number__c = '9051159122';
        insert savingsLineItem;
        
        Opportunity savingsOpportunity_no_acc = new Opportunity();
        savingsOpportunity_no_acc.Name = 'Test Savings Onboarding NO ACCOUNT';
        savingsOpportunity_no_acc.CloseDate = Date.today();
        savingsOpportunity_no_acc.StageName = 'New';
        savingsOpportunity_no_acc.Pricebook2Id = pb.id;
        savingsOpportunity_no_acc.AccountId = account.id;
        savingsOpportunity_no_acc.Site__c = siteRec.id;
        savingsOpportunity_no_acc.CBPIndicator__c = '123456789';
        insert savingsOpportunity_no_acc;
        
        OpportunityLineItem savingsLineItem_no_acc = new OpportunityLineItem();
        savingsLineItem_no_acc.OpportunityId = savingsOpportunity_no_acc.id;
        savingsLineItem_no_acc.Product2Id = savingsprod.id;
        savingsLineItem_no_acc.PricebookEntryId = savingsPrice.id;
        savingsLineItem_no_acc.Quantity = 1;
        savingsLineItem_no_acc.TotalPrice = 100;
        insert savingsLineItem_no_acc;
    }
    
    @isTest
    static void createSavingsAccountExistingAccountNumberTest(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0){
            for (User u : userList){
                if (u.Email == 'UserAdmin@testorg.com'){
                    au = u;
                }
            }
        }
        
        CreateRetailAccountCommon common = new CreateRetailAccountCommon();
        common.paymentPlanId = '';
        common.usePackageAccount = false;
        common.sourceOfFunds = 'BONUS';
        common.productFamily = 'Savings';
        common.fraudIndicator = 'N';
        common.fraudStatus = 'CLEAN';
        common.applicationNumber = '202107251308319876';
        
        Opportunity opportunity = [SELECT Id
                                   FROM Opportunity
                                   WHERE Name = 'Test Savings Onboarding'
                                   LIMIT 1];
        System.runAs(au){
            Test.startTest();
            String response = SVcreateAndLinkAccountController.createSavingsAccount(opportunity.Id, common);
            System.assert( response == '9051159122', 'Test Successful');
            Test.stopTest();
        }
    }
    
    @isTest
    static void createSavingsAccountNewAccountNumberTest(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0){
            for (User u : userList){
                if (u.Email == 'UserAdmin@testorg.com'){
                    au = u;
                }
            }
        }
        
        CreateRetailAccountCommon common = new CreateRetailAccountCommon();
        common.paymentPlanId = '';
        common.usePackageAccount = false;
        common.sourceOfFunds = 'BONUS';
        common.productFamily = 'Savings';
        common.fraudIndicator = 'N';
        common.fraudStatus = 'CLEAN';
        common.applicationNumber = '202107251308319876';
        
        Opportunity opportunity = [SELECT Id
                                   FROM Opportunity
                                   WHERE Name = 'Test Savings Onboarding NO ACCOUNT'
                                   LIMIT 1];
        System.runAs(au){
            Test.startTest();
            String response = SVcreateAndLinkAccountController.createSavingsAccount(opportunity.Id, common);
            System.assert(response == '9051159133', 'Test Successful');
            Test.stopTest();
        }
    }
    
    @isTest
    static void updateAccountOpeningDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, UPDATE_POSITIVE_RESPONSE_BODY));
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0){
            for (User u : userList){
                if (u.Email == 'UserAdmin@testorg.com'){
                    au = u;
                }
            }
        }
        
        CreateRetailAccountCommon common = new CreateRetailAccountCommon();
        common.managerNumber = '13';
        common.mandateNumber = '113';
        common.accountName = 'Stevovo';
        common.openingReason = '';
        common.sourceOfFunds = 'BONUS';
        common.productFamily = 'Savings';
        
        Opportunity opportunity = [SELECT Id
                                   FROM Opportunity
                                   WHERE Name = 'Test Savings Onboarding NO ACCOUNT'
                                   LIMIT 1];
        System.runAs(au){
            Test.startTest();
            String response = SVcreateAndLinkAccountController.updateAccountOpeningDetails(opportunity.Id, common);

            System.assert(response ==  '0', 'Test Successful');
            Test.stopTest();
        }
    }
}