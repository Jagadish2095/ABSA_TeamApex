/**
 * @description       : This is the Test Class for Decision Summary (Origination and Sanctioning) Test
 * @author            : Himanshu Nimje
 * @last modified on  : 2021-11-26
 * @last modified by  : luluwitney.rankwe@absa.africa
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-07-12   Himani Joshi   Initial Version
**/ 


@isTest
public class CreditDecisionSummaryControllerTest{
    public static final String POSITIVE_RESPONSE_BODY = '{ "Response": { "ApplicationDV": { "APPERRMSG": "000" } } }';
    /**
    * @description : Method for creating test data
    * @author Himanshu Nimje | 2021-07-12
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
        opp.AccountId=account.Id;
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        //opp.Spouse_Account_Id__c=account.Id;
        Insert opp;

        Application__c application = new Application__c();
        //application.Credit_Application_Status__c='Accepted';
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
        insert testAppProdCred;

        Application_Product__c parentApplicationRecord = new Application_Product__c();
        parentApplicationRecord.Opportunity__c = opp.Id;
        parentApplicationRecord.Product_Name__c = 'Cheque';
        parentApplicationRecord.Product_Type__c = 'Classic';
        parentApplicationRecord.Account_Number__c = 123456789;
        parentApplicationRecord.Product_State__c = 'New';
        parentApplicationRecord.Opportunity_Product_Id__c = '001';
        insert parentApplicationRecord;

        Application_Product__c childApplicationRecord = new Application_Product__c();
        childApplicationRecord.Opportunity__c = opp.Id;
        childApplicationRecord.Product_Name__c = 'Overdraft';
        childApplicationRecord.Product_Amount__c = 10000.00;
        childApplicationRecord.Product_State__c = 'New';
        childApplicationRecord.Product_Status__c = 'Accepted';
        childApplicationRecord.Opportunity_Product_Id__c = '002';
        childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
        insert childApplicationRecord;

        Application_Product__c parentApplicationRecord1 = new Application_Product__c();
        parentApplicationRecord1.Opportunity__c = opp.Id;
        parentApplicationRecord1.Product_Name__c = 'Cheque';
        parentApplicationRecord1.Product_Type__c = 'Classic';
        parentApplicationRecord1.Account_Number__c = 123456789;
        parentApplicationRecord1.Product_State__c = 'New';
        parentApplicationRecord1.Product_Status__c='Pending';
        parentApplicationRecord1.Opportunity_Product_Id__c = '001';
        insert parentApplicationRecord1;

        Application_scoring__c appScore1 =new Application_scoring__c();
        appScore1.name='a1';
        appScore1.Stage__c='1';
        appScore1.SYST_Decision__c='A';
        appScore1.SYST_Decision_Time__c=system.now().time();
        appScore1.Application_Number__c=application.Id;
        appScore1.Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
        appScore1.Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
        appScore1.Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
        appScore1.Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
        appScore1.ReqTotAddPotentialOc__c=0;
        appScore1.ReqPotentialTotGroup__c=0;
        appScore1.ReqPotentialTgae__c=0;
        appScore1.ReqPotentialTgbe__c=0;
        appScore1.ReqPotentialTfl__c=0;
        appScore1.Potential_OC_Offered__c=0;
        appScore1.Potential_TGE_Offered__c=0;
        appScore1.Potential_TGAE_Offered__c=0;
        appScore1.Potential_TGBE_Offered__c=0;
        appScore1.Potential_TGBOE_Offered__c=0;
        appScore1.Offered_Total_Financing_Limit__c=0;
        appScore1.Potential_OC_Final__c=0;
        appScore1.Potential_TGE_Final__c=0;
        appScore1.Potential_TGAE_Final__c=0;
        appScore1.Potential_TGBE_Final__c=0;
        appScore1.Potential_TGBOE_Final__c=0;
        appScore1.Final_Total_Financing_Limit__c=0;
        insert appScore1;

        Application_scoring__c appScore=new Application_scoring__c();
        appScore.name='a1';
        appScore.Stage__c='7';
        appScore.SYST_Decision__c='A';
        appScore.SYST_Decision_Time__c=system.now().time();
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
        appScore.Offered_Total_Financing_Limit__c=0;
        appScore.Potential_OC_Final__c=0;
        appScore.Potential_TGE_Final__c=0;
        appScore.Potential_TGAE_Final__c=0;
        appScore.Potential_TGBE_Final__c=0;
        appScore.Potential_TGBOE_Final__c=0;
        appScore.Final_Total_Financing_Limit__c=0;
        insert appScore;


        Application_scoring__c appScore5=new Application_scoring__c();
        appScore5.name='a1';
        appScore5.Stage__c='5';
        appScore5.SYST_Decision__c='A';
        appScore5.SYST_Decision_Time__c=system.now().time();
        appScore5.Application_Number__c=application.Id;
        appScore5.Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
        appScore5.Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
        appScore5.Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
        appScore5.Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
        appScore5.ReqTotAddPotentialOc__c=0;
        appScore5.ReqPotentialTotGroup__c=0;
        appScore5.ReqPotentialTgae__c=0;
        appScore5.ReqPotentialTgbe__c=0;
        appScore5.ReqPotentialTfl__c=0;
        appScore5.Potential_OC_Offered__c=0;
        appScore5.Potential_TGE_Offered__c=0;
        appScore5.Potential_TGAE_Offered__c=0;
        appScore5.Potential_TGBE_Offered__c=0;
        appScore5.Potential_TGBOE_Offered__c=0;
        appScore5.Offered_Total_Financing_Limit__c=0;
        appScore5.Potential_OC_Final__c=0;
        appScore5.Potential_TGE_Final__c=0;
        appScore5.Potential_TGAE_Final__c=0;
        appScore5.Potential_TGBE_Final__c=0;
        appScore5.Potential_TGBOE_Final__c=0;
        appScore5.Final_Total_Financing_Limit__c=0;
        insert appScore5;

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
        scoEntity.Enforce_Rework__c='N';
        scoEntity.Entity_Number__c='1';
        scoEntity.Lookup_Period__c=60;
        insert scoEntity;

        Application_Scoring_Entity__c scoEntity5=new Application_Scoring_Entity__c();
        scoEntity5.Application_Scoring__c=appScore5.Id;
        scoEntity5.Enforce_Rework__c='N';
        scoEntity5.Entity_Number__c='1';
        scoEntity5.Lookup_Period__c=60;
        insert scoEntity5;



    }

    /**
    * @description : Test Method to get requested product
    * @author Himanshu Nimje | 2021-07-12
    **/
        @isTest static void testgetRequestedProduct() {
        //CreditDecisionSummaryController.ProductDataWrapper pWrap=new CreditDecisionSummaryController.ProductDataWrapper();
        //Opportunity opp=[select Id from Opportunity];
        //system.assertNotEquals(null,opp.Id);
        //List<Application_Product__c> appPrdList =[select id from Application_Product__c];
        Test.startTest();
        CreditDecisionSummaryController.ProductDataWrapper pWrap=new CreditDecisionSummaryController.ProductDataWrapper();
        Opportunity opp=[select Id from Opportunity];
        system.assertNotEquals(null,opp.Id);
        List<Application_Product__c> appPrdList =[select id from Application_Product__c];
        List<Application_Scoring__c> appScoringList =  CreditDecisionSummaryController.GetDecisionSummary(opp.Id);
        List<CreditDecisionSummaryController.ProductDataWrapper> getRequestedProducts = CreditDecisionSummaryController.getRequestedProduct(opp.Id);
        List<Submission_History__c> lstofSubHist = CreditDecisionSummaryController.GetSubmissionHistory(opp.Id);
        Map<String,List<String>> getReasonsExceptions = CreditDecisionSummaryController.GetReasonsAndExceptions(opp.Id);
        CreditDecisionSummaryController.getPotTotalGrpExps(opp.Id);
        String isUpdateSuccess= CreditDecisionSummaryController.updateNTUStatus(opp.Id, appPrdList[0].Id, 'test','Test');
        Application__c app = CreditDecisionSummaryController.GetApplication(opp.Id);
        Opportunity oppo = CreditDecisionSummaryController.GetOpportunity(opp.Id);
        String  result = CreditDecisionSummaryController.UpdateApplication(opp.Id);
        user u = CreditDecisionSummaryController.fetchUser();
        CreditDecisionSummaryController.GetUpdatedApplication(opp.Id);
        CreditDecisionSummaryController.getDecisionTime(opp.Id);
        CreditDecisionSummaryController.updateWithdrawalStatus(opp.Id, appPrdList[0].Id, 'test','Test');
        String amendReponse =  CreditDecisionSummaryController.AmendmentProcess(opp.Id);
        CreditDecisionSummaryController.startSanctioningProcess(opp.Id,'Cape');
        //CreditDecisionSummaryController.amendDeleteRecord(opp.Id);
        Test.stopTest();
    }

    /**
    * @description : Test Method to get requested product
    * @author Himanshu Nimje | 2021-07-12
    **/
        @isTest static void testgetProduct() {
        Test.startTest();
        Opportunity opp=[select Id from Opportunity];
        system.assertNotEquals(null,opp.Id);
        CreditDecisionSummaryController.amendDeleteRecord(opp.Id);
        Test.stopTest();
        }

    /**
    * @description : Method to do negative testing
    * @author Himanshu Nimje| 2021-07-12
    **/
     @isTest static void NegativetestsubmissionHist() {

        Opportunity opp=[select Id from Opportunity];
        system.assertNotEquals(null,opp.Id);
        List<Submission_History__c> responseSubHistList =[ SELECT  Id, Name,StageId__c,Type__c,Version__c,application__c,Submitted_By__c,
                                                          Submitted__c,System_Decision__c FROM Submission_History__c];
        delete responseSubHistList;
        List<Submission_History__c> lstofSubHist = CreditDecisionSummaryController.GetSubmissionHistory(opp.Id);

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