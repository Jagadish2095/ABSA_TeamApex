/*
*CBPIndicatorController Test
* @author Satya Boyenepalli 
* @ created on 2020-12-10
*
*/
@isTest
public class CBPIndicatorControllerTest {
 @isTest 
    public static void TestCBPIndicator() { 
        IZcreateUniqueKeyV1_Resp_IB_v1 responsegetcbiindicator  = new IZcreateUniqueKeyV1_Resp_IB_v1();
        Profile profile = new profile();
         profile= [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'fname';
        sysAdminUser.LastName = 'lname';
        sysAdminUser.Email = 'flastname@test.com';
        sysAdminUser.Phone = '111-222-2222';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'satya012521@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11032');
        insert prod; 
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account acc = new Account();       
        acc.FirstName='FirstName test';
        acc.LastName='lastname test';
        acc.CIF__c='GOLDJ 004';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0726631180';
        insert acc;
        
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='8474';
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
        
        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;  
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Notifyme__c='Yes';
        insert app;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4047187106';
        insert oppLineItem;
        
        Test.startTest(); 
      
        responsegetcbiindicator= CBPIndicatorController.getCBPIndicator();
        System.assertEquals(500, responsegetcbiindicator.StatusCode);
        
        Test.stopTest();
    }
   
}