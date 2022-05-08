/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SVupdateAccountControllerTest {
        @testSetup
    static void dataCreation(){
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
            Advisor_Code__c = '112233'
        );
        insert au;
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        
        account.CIF__c='LTD 933';
        account.Language__c='english';
        account.Number_Of_Dependents__c=0;
        account.PersonEmail='test@absa.africa';
        account.PersonMobilePhone='0819908786';
        account.ID_Type__pc='PASSPORT';
        account.Nationality__pc='ZIM';
        account.Highest_Qualification__pc='Matric';
        account.Residential_Status__pc='Owner';
        account.Marital_Status__pc='MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;
        
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;   
     	Opportunity savingsOpportunity = new Opportunity();
        savingsOpportunity.Name = 'Test Savings Onboarding';
        savingsOpportunity.CloseDate = Date.today();
        savingsOpportunity.StageName = 'New';
        savingsOpportunity.Pricebook2Id=pb.id;
        savingsOpportunity.AccountId=account.id;
        savingsOpportunity.Site__c=siteRec.id;
        savingsOpportunity.CBPIndicator__c = '123456789';
        insert savingsOpportunity;
    }
    
    
    @IsTest
    static void updateAccountOpeningDetNegativeTest(){
        String accountNumber = '9051159122';
        String brokerNumber= '5035555';
        String openingReason ='01';
        List<User> userP = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
        
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List < String > {
            ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME
        });

        
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
        
        System.runAs(au) 
        { 
        Test.startTest();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        string resp = SVupdateAccountController.updateAccountOpeningDetails(opportunity.Id,'12345', brokerNumber, openingReason,'Maldives', '12345','D');
      
        System.assert(resp !=null, 'SUCCESS');
            
        Test.stopTest();
        }
    }
 @IsTest
    static void updateAccountOpeningDetPositiveTest(){
        String accountNumber = '9051159122';
        String brokerNumber= '5035555';
        String openingReason ='01';
        List<User> userP = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
        
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List < String > {
            ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME
        });

        
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
        
        System.runAs(au) 
        { 
        Test.startTest();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
      	string resp =  SVupdateAccountController.updateAccountOpeningDetails(opportunity.Id,accountNumber, brokerNumber, openingReason, 'Maldives','12345','S');
     
     	system.assert(resp == 'SUCCESS', 'assert failed');
        
        Test.stopTest();
        }
    }
}