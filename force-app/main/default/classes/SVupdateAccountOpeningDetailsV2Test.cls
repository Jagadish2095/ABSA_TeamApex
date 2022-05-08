@isTest
public class SVupdateAccountOpeningDetailsV2Test {

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
    static void updateAccountOpeningDetTest(){
        String accountNumber = '9051159122';
        String brokerNumber= '5035555';
        String openingReason ='01';
        List<User> userP = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
        
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, ExperianBusinessDetailsGet_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List < String > {
            ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME
        });

         SVupdateAccount_Req_IB_v1 requestBean = new SVupdateAccount_Req_IB_v1().getNewInstance();
                requestBean.SVSP09I = new SVupdateAccount_Req_IB_v1.SVSP09I();
                requestBean.SVSP09I.sVSP09IINPUTAREA = new SVupdateAccount_Req_IB_v1.SVSP09I_INPUT_AREA();
                system.debug('name ' +account.Name );
                system.debug('accountNumber ' +accountNumber);
                requestBean.NBSAPDPI.NBSAPLI.channel = 'BDP';
        		requestBean.NBSAPDPI.NBSAPLI.application = 'BDP';
        		requestBean.NBSAPDPI.NBSAPLI.trace = 'N';
        		requestBean.MSGI.NBSMSGI.messageLanguage ='E';
        		requestBean.MSGI.NBSMSGI.messageTarget = 'STD';
                requestBean.SVSP09I.sVSP09IINPUTAREA.accountNumber = '9033834343' ; 
                requestBean.SVSP09I.sVSP09IINPUTAREA.savingsDepositType = 'D';
                requestBean.SVSP09I.sVSP09IINPUTAREA.openReasonCode = '0';//account.Client_Creation_Reason__c ;
                requestBean.SVSP09I.sVSP09IINPUTAREA.accountName = 'Account name';
                requestBean.SVSP09I.sVSP09IINPUTAREA.groupSchemeCode = '0' ;
                requestBean.SVSP09I.sVSP09IINPUTAREA.homeEmployPlanCode = '';
                requestBean.SVSP09I.sVSP09IINPUTAREA.grantType = '0';
                requestBean.SVSP09I.sVSP09IINPUTAREA.specialAccountType= 'N';
                requestBean.SVSP09I.sVSP09IINPUTAREA.brokerSource = '';
                requestBean.SVSP09I.sVSP09IINPUTAREA.brokerNumber = '';//use the one from the screen
                requestBean.SVSP09I.sVSP09IINPUTAREA.crpCode = 'ABS';
                requestBean.SVSP09I.sVSP09IINPUTAREA.divisionCode = 'ABS';
                requestBean.SVSP09I.sVSP09IINPUTAREA.workStation= 'AA';
                requestBean.SVSP09I.sVSP09IINPUTAREA.branchCode = '8007';
                system.debug('name1 ' +userP[0].SiteCode__c );
                system.debug('name2 ' +userP[0].SiteType__c );
                system.debug('name3 ' +userP[0].Teller_Operator_Code__c );
                requestBean.SVSP09I.sVSP09IINPUTAREA.agencyCode =  '8198';
                requestBean.SVSP09I.sVSP09IINPUTAREA.agencySiteType = '034';
                requestBean.SVSP09I.sVSP09IINPUTAREA.tellerCode = '00687';
                requestBean.SVSP09I.sVSP09IINPUTAREA.supervisorCode ='0';//userP[0].Supervisor__c;
                requestBean.SVSP09I.sVSP09IINPUTAREA.branchSiteType =  '034';
        
        
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
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        SVupdateAccountOpeningDetailsV2.updateAccountOpeningDetails(requestBean);
        System.assert(opportunity !=null, 'SUCCESS');
        Test.stopTest();
            
        }
    }
}