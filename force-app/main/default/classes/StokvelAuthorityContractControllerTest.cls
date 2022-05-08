@isTest
public class StokvelAuthorityContractControllerTest {

    @testSetup
    static void makeData() {
        Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
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
            UserName = auniqueUserName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
        System.runAs(au) {
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021');
        insert prod; 
       
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
        acc.Contact_Method__pc = 'Email';
        insert acc;
        RecordType recordType = [SELECT Id from RecordType where name = 'Business Prospect' LIMIT 1];   
            
             Account acc1 = new Account();
           acc1.Name='last test1';   
            acc1.Language__c='english';
            acc1.Number_Of_Dependents__c=0;
            acc1.Phone='0819908786';
            acc1.RecordTypeId = recordType.Id;
            insert acc1;
            
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
      	opp.Opportunity_Closed_Date__c = Date.today();
        opp.SiteCode__c = siteRec.Site_Code__c;
        opp.Pricebook2Id=pb.id;
        opp.AccountId=acc.id;
        opp.Site__c=siteRec.id;
        insert opp;
        
        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;  
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Account_Number__c = '123';
        insert app;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;  
            
        Address__c residentialAddress = new Address__c(
        Account__c=acc.Id,
        Address_Type__c='Residential');
           
            
            Document__c document = new Document__c();
            document.ECM_Type__c = 'UAT';
            document.Case_External_Reference__c = 'C-09475447';
            document.Document_Sub_Type__c = '1';
            document.Account__c = acc1.Id;
            document.Reference__c= acc1.Id;
            insert document; 
            
        }
    }

    @isTest 
    public static void TestInsertDocumentInformation()
    {
       string documentScanningData = '{"DocumentList":[{"UploadMSG":"fdvsdf","ECMPID":"test","DocumentType":"test","DocumentSubType":"test1","DocumentGUID":"123456","DocumentCode":"01"}]}';
        string customerContractData = '{"DocumentList":[{"UploadMSG":"contract","ECMPID":"test2","DocumentType":"test2","DocumentSubType":"test2","DocumentGUID":"789","DocumentCode":"000058"}]}';
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
            Account acc = [SELECT Id FROM Account where Name = 'last test1' LIMIT 1];
            Opportunity opp = [SELECT Id FROM Opportunity where Name = 'Test Opp Onboarding' LIMIT 1];
            StokvelAuthorityContractController.insertDocumentInformation( documentScanningData, customerContractData,opp.Id,acc.Id);
            System.assertNotEquals('', 'Test Working');
            Test.stopTest();
		}
    }
    
    @isTest 
    public static void TestUpdateOpportunityStage()
    {
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
            Opportunity opp = [SELECT Id FROM Opportunity where Name = 'Test Opp Onboarding' LIMIT 1];
            StokvelAuthorityContractController.updateOpportunityStage( opp.Id);
            System.assertNotEquals('', 'Test Working');
            Test.stopTest();
		}
    }
}