/**
 * @description       : This is the Test Class for PowerCurveStatusUpdate class
 * @author            : Gulafsha
 * @last modified on  : 2021-07-17
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-17   Gulafsha   Initial Version
**/

    
    @isTest
    public class PowerCurveStatusUpdateTest {
        
        public static final String POSITIVE_RESPONSE_BODY = '{ "Response": { "ApplicationDV": { "APPERRMSG": "000" } } }';
        /**
        * @description dataCreation
        * @author Gulafsha | 2021-07-17 
        **/
        @testSetup
        public static void dataCreation() {
            
            insertUser();
            
            Account account = new Account();
            account.Name = 'Absa Bank';
            account.Client_Type__c = 'Private Individual';
            account.CIF__c = 'SNIFFEL001';
            account.Sic='35790';
            account.AccountNumber='0';
            account.Registration_Number__c='1990/011515/23';
            insert account;
            
            Opportunity opp = new Opportunity();
            opp.Name = 'EPP';
            opp.StageName = 'Not Interested';
            opp.CloseDate = Date.today() + 10;
            opp.AccountId = account.Id;
            //opp.Spouse_Account_Id__c=account.Id;
            Insert opp;
            
            Application__c application = new Application__c();
            application.Credit_Application_Status__c='Accepted';
            application.stock_Number__c='0';
            application.External_Reference_Number__c=09874667;
            application.Opportunity__c = opp.Id;
            Insert application;
            
            //Products
            Id pricebookId = Test.getStandardPricebookId();
            
            //For Policy without Spouse
            Product2 product1 = new Product2();
            product1.name = 'EPP Executor Fees Policy';
            product1.IsActive = true;
            insert product1;
            
            PricebookEntry pricebookEntry1 = new PricebookEntry();
            pricebookEntry1.UnitPrice = 0;
            pricebookEntry1.Product2Id = product1.id;
            pricebookEntry1.Pricebook2Id = pricebookId;
            pricebookEntry1.IsActive = true;
            insert pricebookEntry1;
            
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opp.Id;
            oppLineItem.Product2Id = product1.Id;
            oppLineItem.PricebookEntryId = pricebookEntry1.Id;
            oppLineItem.Quantity = 1;
            oppLineItem.TotalPrice = 100;
            Insert oppLineItem;
            
            Application_Product__c testAppProdCred = new Application_Product__c();
            testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
            testAppProdCred.Product_State__c='New';
            testAppProdCred.Opportunity__c=opp.Id;
            testAppProdCred.Product_Type__c='11021';
            testAppProdCred.System_Decision__c='Accepted';
            testAppProdCred.Product_Status__c = 'Accepted';
            insert testAppProdCred;
            
            Application_Product__c parentApplicationRecord = new Application_Product__c();
            parentApplicationRecord.Opportunity__c = opp.Id;
            parentApplicationRecord.Product_Name__c = 'Cheque';
            parentApplicationRecord.Product_Type__c = 'Classic';
            parentApplicationRecord.Account_Number__c = 123456789;
            parentApplicationRecord.Product_State__c = 'Existing';
            parentApplicationRecord.Opportunity_Product_Id__c = '001';
            insert parentApplicationRecord;
            
            Application_Product__c parentApplicationRecord1 = new Application_Product__c();
            parentApplicationRecord1.Opportunity__c = opp.Id;
            parentApplicationRecord1.Product_Name__c = 'Cheque';
            parentApplicationRecord1.Product_Type__c = 'Classic';
            parentApplicationRecord1.Account_Number__c = 123456789;
            parentApplicationRecord1.Product_State__c = 'new';
            parentApplicationRecord1.Opportunity_Product_Id__c = '001';
            insert parentApplicationRecord1;
            
            Application_Product__c childApplicationRecord = new Application_Product__c();
            childApplicationRecord.Opportunity__c = opp.Id;
            childApplicationRecord.Product_Name__c = 'Overdraft';
            childApplicationRecord.Product_Amount__c = 10000.00;
            childApplicationRecord.Product_State__c = 'Existing';
            childApplicationRecord.Product_Status__c = 'Accepted';
            childApplicationRecord.Opportunity_Product_Id__c = '002';
            childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
            insert childApplicationRecord;
            
            Application_Product__c childApplicationRecord1 = new Application_Product__c();
            childApplicationRecord1.Opportunity__c = opp.Id;
            childApplicationRecord1.Product_Name__c = 'Overdraft';
            childApplicationRecord1.Product_Amount__c = 10000.00;
            childApplicationRecord1.Product_State__c = 'New';
            childApplicationRecord1.Product_Status__c = 'Accepted';
            childApplicationRecord1.Opportunity_Product_Id__c = '002';
            childApplicationRecord1.Application_Product_Parent__c = parentApplicationRecord1.Id;
            insert childApplicationRecord1;
            
            Application_scoring__c appScore=new Application_scoring__c();
            appScore.name='a1';
            appScore.Stage__c='7';
            appScore.SYST_Decision__c='A';
            appScore.Application_Number__c=application.Id;
            appScore.Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
            appScore.Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
            appScore.Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
            appScore.Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
            appScore.ReqTotAddPotentialOc__c=0;
            appScore.ReqPotentialTotGroup__c=0;
            appScore.ReqPotentialTgae__c=0;
            appScore.ReqPotentialTgbe__c=0;
            appScore.ReqPotentialTfl__c=0;
            appScore.Potential_OC_Offered__c=0;
            appScore.Potential_TGE_Offered__c=0;
            appScore.Potential_TGAE_Offered__c=0;
            appScore.Potential_TGBE_Offered__c=0;
            appScore.Potential_TGBOE_Offered__c=0;
            appScore.Potential_OC_Final__c=0;
            appScore.Potential_TGE_Final__c=0;
            appScore.Potential_TGAE_Final__c=0;
            appScore.Potential_TGBE_Final__c=0;
            appScore.Potential_TGBOE_Final__c=0; 
            insert appScore;
            
            Submission_History__c sh=new Submission_History__c();
            sh.application__c=application.Id;
            sh.StageId__c=application.name;
            sh.Type__c='Decision Summary';
            sh.Version__c='1';
            //sh.Submitted_By__c=application.createdby.name;
            //sh.Submitted__c=application.LastModifiedDate;
            sh.System_Decision__c='N';
            insert sh;
            
            Application_Security__c asv=new Application_Security__c();
            asv.Application_Id_Text__c=application.Id;
            asv.Security_Type__c='Cession of General Pledges';
            insert asv;
            Application_Profile__c app=new Application_Profile__c();
            app.Client_CIF_Code__c='SNIFFEL001';
            app.Client_Name__c='Absa Bank';
            app.Application__c=application.Id;
            app.Applicant_Type__c='Main Applicant';
            app.Related_to_Client_Code__c=account.Registration_Number__c;
            insert app;
            Application_Exposure_Risk__c appEx=new Application_Exposure_Risk__c();
            appEx.Application__c=application.Id;
            appEx.Risk_Grade__c='5';
            insert appEx;
            Application_Exposure__c appExp=new Application_Exposure__c();
            appExp.Application__c=application.Id;
            appExp.Exposure_Data_Type__c='Product';
            insert appExp;
            Application_Exposure_Cash_and_Investment__c appCash=new Application_Exposure_Cash_and_Investment__c();
            appCash.Application__c=application.Id;
            insert appCash;
            Application_Exposure_Total_Group__c appTota=new Application_Exposure_Total_Group__c();
            appTota.Application__c=application.Id;
            insert appTota;
            Application_Exposure_Facility__c appFac=new Application_Exposure_Facility__c();
            appFac.Application__c=application.Id;
            appFac.Client_Code__c='SBSOUTP001';
            insert appFac;
            Application_Triad__c appTriad=new Application_Triad__c();
            appTriad.Application__c=application.Id;
            insert appTriad;
            Application_Triad_Detail__c appTriadDetails=new Application_Triad_Detail__c();
            appTriadDetails.Application_Triad__c=appTriad.Id;
            insert appTriadDetails;
            Application_Assets_and_Liabilities__c assLiab=new Application_Assets_and_Liabilities__c();
            assLiab.Application__c=application.Id;
            assLiab.Primary_Owner__c=account.Id;
            insert assLiab;
            Application_Scoring_Product__c scoProduct=new Application_Scoring_Product__c();
            scoProduct.Application_Scoring__c=appScore.Id;
            insert scoProduct;
            Application_Scoring_Entity__c scoEntity=new Application_Scoring_Entity__c();
            scoEntity.Application_Scoring__c=appScore.Id;
            insert scoEntity;
            
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PowerCurveStatusUpdate_IH_v1.INTEGRATION_SERVICE_NAME});
            
        }
        
        /**
        * @description testpcoCallout
        * @author Gulafsha | 2021-07-17  
        **/
        @isTest
        public static void testpcoCallout() {
            
            Opportunity opp=[select Id from Opportunity];
            List<Application_Product__c> appPrdList =[select id from Application_Product__c];
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            PowerCurveStatusUpdate_Resp_IB_v1 respomse = PowerCurveStatusUpdate.pcoCallout(opp.Id);
            System.assertNotEquals(opp.Id,null);
            Test.stopTest();
        }
        
         /**
         * @description test2pcoCallout
         * @author Gulafsha | 2021-07-17 
         **/
        @isTest
         public static void test2pcoCallout() {
             Opportunity opp=[select Id from Opportunity];
             List<Application__c> appList =[select id,Credit_Application_Status__c from Application__c];
             List<Application_Product__c> appPrdList =[select id,Product_Status__c from Application_Product__c];
             appPrdList[0].Product_Status__c='Declined';
             update appPrdList;
            
             Test.startTest();
             PowerCurveStatusUpdate.pcoCallout(opp.Id);
             System.assertNotEquals(opp.Id,null);
             Test.stopTest();
        }

        /**
        * @description test3pcoCallout
        * @author Gulafsha | 2021-07-17 
        **/
        @isTest
        public static void test3pcoCallout() {
             Opportunity opp=[select Id from Opportunity];
            List<Application__c> appList =[select id,Credit_Application_Status__c from Application__c];
             List<Application_Product__c> appPrdList =[select id,Product_Status__c from Application_Product__c];
            appPrdList[0].Product_Status__c='Refer To Sanctioning';
             update appPrdList;
          
            Test.startTest();
            PowerCurveStatusUpdate.pcoCallout(opp.Id);
            System.assertNotEquals(opp.Id,null);
            Test.stopTest();
        }
         /**
         * @description test4pcoCallout
         * @author Gulafsha | 2021-07-17 
         **/
        @isTest
         public static void test4pcoCallout() {
             Opportunity opp=[select Id from Opportunity];
            List<Application__c> appList =[select id,Credit_Application_Status__c from Application__c];
              List<Application_Product__c> appPrdList =[select id,Product_Status__c from Application_Product__c];
             appPrdList[0].Product_Status__c='Amend';
             update appPrdList;
         
            Test.startTest();
            PowerCurveStatusUpdate.pcoCallout(opp.Id);
            System.assertNotEquals(opp.Id,null);
            Test.stopTest();
        }
        /**
        * @description test5pcoCallout
        * @author Gulafsha | 2021-07-17 
        **/
        @isTest
        public static void test5pcoCallout() {
             Opportunity opp=[select Id from Opportunity];
            List<Application__c> appList =[select id,Credit_Application_Status__c from Application__c];
             List<Application_Product__c> appPrdList =[select id,Product_Status__c from Application_Product__c];
            appPrdList[0].Product_Status__c='Withdrawal';
             update appPrdList;
           
            Test.startTest();
            PowerCurveStatusUpdate.pcoCallout(opp.Id);
            System.assertNotEquals(opp.Id,null);
            Test.stopTest();
        }
        
         /**
         * @description test6pcoCallout
         * @author Gulafsha | 2021-07-17 
         **/
        @isTest
         public static void test6pcoCallout() {
             Opportunity opp=[select Id from Opportunity];
            List<Application__c> appList =[select id,Credit_Application_Status__c from Application__c];
              List<Application_Product__c> appPrdList =[select id,Product_Status__c from Application_Product__c];
             appPrdList[0].Product_Status__c='Pipeline For Fulfillment';
             update appPrdList;
             Test.startTest();
            PowerCurveStatusUpdate.pcoCallout(opp.Id);
            System.assertNotEquals(opp.Id,null);
            Test.stopTest();
        }
        
        @future
        private static void insertUser() {
            Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
            UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
            
            User futureUser = new User(
                ProfileId = p.Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                SiteCode__c = '8198',
                SiteType__c = '034',
                Teller_Operator_Code__c = '12345',
                Supervisor__c = '0',
                Division__c = 'RBB',
                UserRoleId = r.Id
            );
            insert(futureUser);
        }
        
        
        
    }