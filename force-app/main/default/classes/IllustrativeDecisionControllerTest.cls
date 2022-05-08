/*
* Test Class For IllustrativeDecisionController
* @author  Himani Joshi: Absa
* @version v1.0
* @since   2020-09-15
*
*/

@IsTest
public class IllustrativeDecisionControllerTest {
    @testSetup static void createData(){
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
        //opp.Spouse_Account_Id__c=account.Id;
        Insert opp;
        Application__c application = new Application__c();
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
        insert testAppProdCred;
        Application_scoring__c appScore=new Application_scoring__c();
        appScore.name='a1';
        appScore.Stage__c='4';
        appScore.Application_Number__c=application.Id;
        appScore.ILST_Decision__c='Y';
        appScore.ILST_Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
        appScore.ILST_Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
        appScore.ILST_Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
        appScore.ILST_Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
        insert appScore;
        Submission_History__c sh=new Submission_History__c();
        sh.application__c=application.Id;
        sh.StageId__c=application.name;
        sh.Type__c='Illustrative Decision';
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
        //app.Related_to_Client_Code__c=account.Registration_Number__c;
        app.Related_to_Client_ID_or_Reg_Number__c=account.Registration_Number__c;
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
        
    }
    @isTest static void testgetIllustrativeDecisions(){
        Opportunity opp=[select Id from Opportunity];
        test.startTest();
        List<Application_Scoring__c>appScoringList =  IllustrativeDecisionController.GetDecisionSummary(opp.Id);
        Map<String,List<String>>getReasonsExceptions=IllustrativeDecisionController.GetReasonsAndExceptions(opp.Id);
        List<Application_Product__c>getRequestedProducts=IllustrativeDecisionController.getRequestedProduct(opp.Id);
        List<Submission_History__c> lstofSubHist= IllustrativeDecisionController.GetSubmissionHistory(opp.Id);
        IllustrativeDecisionController.submit(opp.Id);
        String decTime=IllustrativeDecisionController.getDecisionTime(opp.Id);
        String response=IllustrativeDecisionController.reprocess(opp.Id);
        System.assertNotEquals(null,appScoringList);
        System.assertNotEquals(null,getReasonsExceptions);
        System.assertNotEquals(null,getRequestedProducts);
        System.assertNotEquals(null,lstofSubHist);
        System.assertNotEquals(null,response);
        //System.assertNotEquals(null,decTime);
        test.stopTest();
        
    }

}