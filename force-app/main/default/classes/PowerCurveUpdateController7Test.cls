/**
 * @description       : Test Class For PowerCurveUpdateController7
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-01-29   Himanshu.Nimje@absa.africa   Initial Version
**/
@isTest
Public class PowerCurveUpdateController7Test {
    /**
    * @description method to setup test data
    * @author Himanshu.Nimje@absa.africa | 2021-01-12
    **/
    @testSetup static void testData(){

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
        opp.AccountId=account.Id;
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
        testAppProdCred.Product_State__c='existing';
        testAppProdCred.Opportunity__c=opp.Id;
        testAppProdCred.Product_Type__c='11021';
        testAppProdCred.System_Decision__c='Accepted';
        testAppProdCred.Account_Number__c = 123456789;
        testAppProdCred.Product_Amount__c = 10000;
        testAppProdCred.Secured_By_Mortgage_Bond__c=true;
        insert testAppProdCred;

        Application_Product__c parentApplicationRecord = new Application_Product__c();
        parentApplicationRecord.Opportunity__c = opp.Id;
        parentApplicationRecord.Product_Name__c = 'Cheque';
        parentApplicationRecord.Product_Type__c = 'Classic';
        parentApplicationRecord.Account_Number__c = 123456789;
        parentApplicationRecord.Product_State__c = 'New';
        parentApplicationRecord.Opportunity_Product_Id__c = '001';
        parentApplicationRecord.Secured_By_Mortgage_Bond__c=true;
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

        Questionnaire_Template__c qTemp1 = new Questionnaire_Template__c();
        qTemp1.Name = 'General Qualitative Information';
        insert qTemp1;

        List<Questionnaire_Question__c> quesList = new List<Questionnaire_Question__c>();
        Questionnaire_Question__c qQues0 = new Questionnaire_Question__c();
        qQues0.Question__c = 'Key Management Personnel Changes';
        qQues0.Question_Label__c = 'Key Management Personnel Changes';
        qQues0.Include_Comment__c = true;
        qQues0.Section__c = 'Artist Info';
        qQues0.Default_Answer__c = '';
        qQues0.Answer_Options__c = '';
        qQues0.Answer_Type__c = 'string';
        qQues0.Answer_Control_Type__c = 'Textbox';
        qQues0.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues0);

        Questionnaire_Question__c qQues1 = new Questionnaire_Question__c();
        qQues1.Question__c = 'Business Direction Changes';
        qQues1.Question_Label__c = 'Business Direction Changes';
        qQues1.Include_Comment__c = true;
        qQues1.Section__c = 'Artist Info';
        qQues1.Default_Answer__c = '';
        qQues1.Answer_Options__c = '';
        qQues1.Answer_Type__c = 'String';
        qQues1.Answer_Control_Type__c = 'Textbox';
        qQues1.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues1);

        Questionnaire_Question__c qQues2 = new Questionnaire_Question__c();
        qQues2.Question__c = 'Exposure Increase';
        qQues2.Question_Label__c = 'Exposure Increase';
        qQues2.Include_Comment__c = true;
        qQues2.Section__c = 'Artist Info';
        qQues2.Default_Answer__c = '';
        qQues2.Answer_Options__c = '';
        qQues2.Answer_Type__c = 'String';
        qQues2.Answer_Control_Type__c = 'Textbox';
        qQues2.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues2);

        Questionnaire_Question__c qQues3 = new Questionnaire_Question__c();
        qQues3.Question__c = 'Arreas Or Sars';
        qQues3.Question_Label__c = 'Arreas Or Sars';
        qQues3.Include_Comment__c = true;
        qQues3.Section__c = 'Artist Info';
        qQues3.Default_Answer__c = '';
        qQues3.Answer_Options__c = '';
        qQues3.Answer_Type__c = 'String';
        qQues3.Answer_Control_Type__c = 'Textbox';
        qQues3.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues3);

        Questionnaire_Question__c qQues4 = new Questionnaire_Question__c();
        qQues4.Question__c = 'Other Financial Institutions';
        qQues4.Question_Label__c = 'Other Financial Institutions';
        qQues4.Include_Comment__c = true;
        qQues4.Section__c = 'Artist Info';
        qQues4.Default_Answer__c = '';
        qQues4.Answer_Options__c = '';
        qQues4.Answer_Type__c = 'String';
        qQues4.Answer_Control_Type__c = 'Textbox';
        qQues4.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues4);

        Questionnaire_Question__c qQues5 = new Questionnaire_Question__c();
        qQues5.Question__c = 'Dispute Between Parties';
        qQues5.Question_Label__c = 'Dispute Between Parties';
        qQues5.Include_Comment__c = true;
        qQues5.Section__c = 'Artist Info';
        qQues5.Default_Answer__c = '';
        qQues5.Answer_Options__c = '';
        qQues5.Answer_Type__c = 'String';
        qQues5.Answer_Control_Type__c = 'Textbox';
        qQues5.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues5);

        Questionnaire_Question__c qQues6 = new Questionnaire_Question__c();
        qQues6.Question__c = 'Write Off Failure';
        qQues6.Question_Label__c = 'Write Off Failure';
        qQues6.Include_Comment__c = true;
        qQues6.Section__c = 'Artist Info';
        qQues6.Default_Answer__c = '';
        qQues6.Answer_Options__c = '';
        qQues6.Answer_Type__c = 'String';
        qQues6.Answer_Control_Type__c = 'Textbox';
        qQues6.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues6);

        Questionnaire_Question__c qQues7 = new Questionnaire_Question__c();
        qQues7.Question__c = 'Other Knowledge';
        qQues7.Question_Label__c = 'Other Knowledge';
        qQues7.Include_Comment__c = true;
        qQues7.Section__c = 'Artist Info';
        qQues7.Default_Answer__c = '';
        qQues7.Answer_Options__c = '';
        qQues7.Answer_Type__c = 'String';
        qQues7.Answer_Control_Type__c = 'Textbox';
        qQues7.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues7);

        Questionnaire_Question__c qQues8 = new Questionnaire_Question__c();
        qQues8.Question__c = 'Debtor Book Funding';
        qQues8.Question_Label__c = 'Debtor Book Funding';
        qQues8.Include_Comment__c = true;
        qQues8.Section__c = 'Artist Info';
        qQues8.Default_Answer__c = '';
        qQues8.Answer_Options__c = '';
        qQues8.Answer_Type__c = 'String';
        qQues8.Answer_Control_Type__c = 'Textbox';
        qQues8.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues8);

        Questionnaire_Question__c qQues9 = new Questionnaire_Question__c();
        qQues9.Question__c = 'Support Application';
        qQues9.Question_Label__c = 'Support Application';
        qQues9.Include_Comment__c = true;
        qQues9.Section__c = 'Artist Info';
        qQues9.Default_Answer__c = '';
        qQues9.Answer_Options__c = '';
        qQues9.Answer_Type__c = 'String';
        qQues9.Answer_Control_Type__c = 'Textbox';
        qQues9.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues9);

        Questionnaire_Question__c qQues10 = new Questionnaire_Question__c();
        qQues10.Question__c = 'Borrowing Power Limit';
        qQues10.Question_Label__c = 'Borrowing Power Limit';
        qQues10.Include_Comment__c = true;
        qQues10.Section__c = 'Artist Info';
        qQues10.Default_Answer__c = 'Limited - Fixed Amount';
        qQues10.Answer_Options__c = '';
        qQues10.Answer_Type__c = 'String';
        qQues10.Answer_Control_Type__c = 'Textbox';
        qQues10.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues10);

        Questionnaire_Question__c qQues11 = new Questionnaire_Question__c();
        qQues11.Question__c = 'Borrowing Power Limit';
        qQues11.Question_Label__c = 'Borrowing Power Limit';
        qQues11.Include_Comment__c = true;
        qQues11.Section__c = 'Artist Info';
        qQues11.Default_Answer__c = 'Unlimited';
        qQues11.Answer_Options__c = '';
        qQues11.Answer_Type__c = 'String';
        qQues11.Answer_Control_Type__c = 'Textbox';
        qQues11.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues11);

        Questionnaire_Question__c qQues12 = new Questionnaire_Question__c();
        qQues12.Question__c = 'Borrowing Power Limit';
        qQues12.Question_Label__c = 'Borrowing Power Limit';
        qQues12.Include_Comment__c = true;
        qQues12.Section__c = 'Artist Info';
        qQues12.Default_Answer__c = 'Limited - Other';
        qQues12.Answer_Options__c = '';
        qQues12.Answer_Type__c = 'String';
        qQues12.Answer_Control_Type__c = 'Textbox';
        qQues12.Questionnaire_Template__c = qTemp1.Id;
        quesList.add(qQues12);

        insert quesList;

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PowerCurveUpdateApplication_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest
    public static void testmapPowerCureveUpdateRequest() {

        String pcoStage6Req ='{"Request":{"ApplicationDV":{"RequestedProducts01":{"INTPRDNEWF":{},"APPPRDNEWF":{"SETTLEMENTSAMNT":"0","REQTOTALAMNT":"100000","REQTERMOFLOAN":"0","REQREQEMPOWERMNTFUNDIND":"Y","REQREQEMPOWERMNTFUND":"002","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPRODUCT":"CHQ","REQPRODTYPE":"11016","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"D","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"4","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"","REQLIMIT":"100000","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"0","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"0","INSTSETTLEMENTS":"0","ESPINSTRUCTION":"","CARDTYPE":"","APPLICATIONSTATUS":"P"}},"INTAPPSICCODE":"50100","INTAPPOVERALLCONTROLBRANCH":"3840","INTAPPEXISTINGFRANCHISORTYPE":"425","INTAPPEXISTINGFRANCHISEFINANCING":"Y","INTAPPENTERPRDEVFUNDEXISTING":"TSAFRIC048","INTAPPBUSINESSSUBSEGMENT":"S","INTAPPBUSINESSSEGMENT":"F","INTAPPBRANCHCODE":"8198","ExistingProducts01":{"INTPRDSECE":{"SPECASVLIMITED":"0","SPECASVFULL":"0"},"INTPRDEXST":{"SECUREDBYMORTGAGEBOND":"N","PRODUCTTYPE":"11019","PRODUCT":"CHQ","NCAMAXINITFEEAMNT":"0","ESPINSTRUCTION":"","CURRSUBPRODTYPE":"","CURRSETTLEMENTAMNT":"0","CURRREDUCTIONFREQ":"0","CURRREDUCTIONAMNT":"0","CURRONCEOFFREDUCTION":"0","CURRLIMIT":"0","CURRINTRATEPRIMEOFFSET":"0","CURRINSTALMNTFREQ":"0","CURRINSTALLMENT":"0","CURRINITFEEPREVDEBITED":"","CURREXISTEMPOWERMNTFUNDIND":"Y","CURREXISTEMPOWERMNTFUND":"999","CURRENFORCEDREDLIM":"N","CURRBALANCE":"-6109596","CARDTYPE":"","ACCOUNTNUMBER":"1000157283"},"APPPRDSECO":{"SUPPORTINGSPECIFIC":"0","SPECIFIC":"0"},"APPPRDEXST":{"REQTOTALAMNT":"900000","REQTERMOFLOAN":"0","REQSUBPRODTYPE":"","REQREQEMPOWERMNTFUNDIND":"Y","REQREQEMPOWERMNTFUND":"999","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPRODTYPE":"11019","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"2","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"0","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"0","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"0","INITIATIONFEEPAYMNTMETHOD":"","APPLICATIONSTATUS":"P"}},"Entity06":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"N","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"ATSET  001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity05":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"N","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"PRICING001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity04":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"Y","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"8777","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"VWYK   305","INTENTCLIENTCODE2":"BONTSE 001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity03":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"126","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"130000","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXCLUSIONTYPE":"P","EXCLUSIONREASON":"402","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"DCO","WRSTARMSHOLD":"","INBUSNRESC":"","EWLLISTING":"2.0","BUSNRESCAFFECTEDPARTY":"N"},"INTENTPARTOFCREDITGROUP":"Y","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"2","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"10000","CHEQ":"0","CC":"5000165"},"INTENTINST":{"TL":"8734","OTHEROC":"658","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"Y","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"TOTALEXPOSURE":"2141912","TOTALDIRECTEXPOSURE":"2141912","RECOVERYEXPOSURE":"10635","ORDCRED":"994841","MORTGTOTAL":"198234","MORTGRES":"198234","MORTGCPF":"0","MORTGAGRI":"0","CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"5000","CHEQACCS":"809337","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"272788","INTENTCTBALANCESAVINGS":"234609","INTENTCTBALANCENOTICEDEPOSITS":"19894","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"1214760","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ORDCREDIT":"996378","MORTGTOTAL":"198234","MORTGRES":"198234","MORTGCPF":"0","MORTGAGRI":"0","ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"101","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"FOURIE 961","INTENTCLIENTCODE2":"FOURIE 910","INTENTCLIENTCODE1":"FOURIBM001","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"30556","OTHEROC":"11565","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRPCODE":"2194","APPENTWORKADDRCITY":"RANDBURG","APPENTSHAREHOLDINGPERC":"","APPENTPASSPORTNATIONALITY":"South Africa","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTIDTYPE":"01","APPENTHOMECELLNUM":"123000000","APPENTGENDER":"M","APPENTEXPO":{"SETTLEMENTLIMITS":"3","APPRFACILITIESODNONSCR":"6","APPRFACILITIESMLNONSCR":"6","APPRFACILITIESAFINNONSCR":"3"},"APPENTBUR":{"CONSINPNATID":"7010075121089"},"APPENTAPRF":{"INSTORDCREDNONSCORED":"8","INSTMLOANNONSCORED":"8","INSTASSETFINNONSCORED":"4"},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"126","APPENTAGE":"5000"},"Entity01":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"297","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"200000","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXCLUSIONTYPE":"P","EXCLUSIONREASON":"405","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"INS","WRSTARMSHOLD":"BDH","INBUSNRESC":"N","EWLLISTING":"0.0","BUSNRESCAFFECTEDPARTY":"N"},"INTENTPARTOFCREDITGROUP":"","INTENTNUMPARTICIPANTS6":"0","INTENTNUMPARTICIPANTS5":"0","INTENTNUMPARTICIPANTS4":"0","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"400000","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"TOTALEXPOSURE":"7382297","TOTALDIRECTEXPOSURE":"7382297","RECOVERYEXPOSURE":"0","ORDCRED":"6109597","MORTGTOTAL":"1272700","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"1272700","CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"6109597","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"0","INTENTCTBALANCESAVINGS":"0","INTENTCTBALANCENOTICEDEPOSITS":"0","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"0","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ORDCREDIT":"7382297","MORTGTOTAL":"1272700","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"1272700","ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"02301","INTENTCLIENTCODE6":"CGTWO  001","INTENTCLIENTCODE5":"CGONE  002","INTENTCLIENTCODE4":"CGONE  001","INTENTCLIENTCODE3":"CGCC   002","INTENTCLIENTCODE2":"BCC    770","INTENTCLIENTCODE1":"SBSOUTP001","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"50","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"SETTLEMENTLIMITS":"1","APPRFACILITIESODNONSCR":"2","APPRFACILITIESMLNONSCR":"2","APPRFACILITIESAFINNONSCR":"1"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"4","INSTMLOANNONSCORED":"4","INSTASSETFINNONSCORED":"2"},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"297","APPENTAGE":"0000"},"DERPCOUNIQUENUMBER":"000000007620","AppData":{"INTAPPSECE":{"SPECASVALL":"0","SPECASVACCSSETTLE":"0","PERCNORMCHANGED":"N","OUSTANDINGSEC":"N","MASVAGRI":"0","MASV":"0","CESSIONDEBTORS":"N","CASHCOVER":"0","ASVOC":"0","APPRSECVALUE":"0"},"APPAPPQUAL":{"CHANGEKEYMNGMNTL12M":"","CHANGEBUSDIRECTION":"","EXPINCREASEL6TO12M":"","ARREARSSARS":"","ACCOTHERBANK":"","DISPUTEBETWEENPARTIES":"","PREVIOUSWOFFBUSFAILURE":"","OTHERNEGKNOWLEDGE":"","DEBTORBOOKFUNDING":"","RESUPPORTAPPLICATION":""},"INTAPPNCAP":{"UCTMAXSERVICEFEES":"69","UCTINTERESTRATE":"27.75","UCTINITFEESTHRESHOLD":"1000","UCTINITFEESNEXTPERC":"11.5","UCTINITFEESMAX":"6040.5","UCTINITFEESFIRST":"189.75","STCTMAXSERVICEFEES":"69","STCTINTERESTRATE":"60","STCTINITFEESTHRESHOLD":"1000","STCTINITFEESNEXTPERC":"11.5","STCTINITFEESMAX":"1207.5","STCTINITFEESFIRST":"189.75","REPORATE":"7","PRIMERATE":"6.25","OCAMAXSERVICEFEES":"69","OCAINTERESTRATE":"21","OCAINITFEESTHRESHOLD":"1000","OCAINITFEESNEXTPERC":"11.5","OCAINITFEESMAX":"1207.5","OCAINITFEESFIRST":"189.75","MAMAXSERVICEFEES":"69","MAINTERESTRATE":"19","MAINITFEESTHRESHOLD":"10000","MAINITFEESNEXTPERC":"11.5","MAINITFEESMAX":"6037.5","MAINITFEESFIRST":"1265","CAMAXSERVICEFEES":"69","CAINTERESTRATE":"20.75","CAINITFEESTHRESHOLD":"1000","CAINITFEESNEXTPERC":"11.5","CAINITFEESMAX":"6050.5","CAINITFEESFIRST":"189.75"},"INTAPPEXPO":{},"INTAPPCCLP":{"TLCREDITLIFEMINAMNT":"0","TLCREDITLIFEMAXAMNT":"0","ODCREDITLIFEMINAMNT":"0","ODCREDITLIFEMAXAMNT":"0"},"INTAPPAFFECTEDPERSREG31F":"","INTAPPABSA":{"NUMBEROFPRODUCTS":"5","CHQACCRELATIONSHIP":"S"},"APPAPPSECUREDBYMORTGAGEBOND":"Y","APPAPPSECO":{"SUPPORTINGSPECIFIC":"0","SUPPORTINGNONSPECIFIC":"0","ASVOFFERED":"0","ASVADDOFFERED":"0"},"APPAPPNUMPARTICIPANTS":"","APPAPPNUMKEYPRINCIPALS":"4","APPAPPNUMCOREPRINCIPALS":"4","APPAPPNONRESPRINCIPALS":"0","APPAPPMNTHSSINCEBUSESTABLISHED":"0","APPAPPEXTR":{"TLNACC":"N","SAVAMNT":"0","SAVACC":"N","MLOANAMNT":"0","MLOANACC":"N","INVAMNT":"0","INVACC":"N","CHEQAMNT":"0","CHEQACC":"N","CARDAMNT":"0","CARDACC":"N","ASSETAMNT":"0","ASSETACC":"N"},"APPAPPBSTM":{"TURNOVER":"0","PERIOD":"0","ODLIMITS":"0","NUMRDITEMS":"0","MINBALANCE":"0"}},"APPBANKERNUMBER":"9145944","APPAPPTRADINGINDICATOR":"Y","APPAPPSTOKVELAPPLICATION":"N","APPAPPSTAGEID":"1","APPAPPREQUESTEDFRANCHISORTYPE":"","APPAPPREQUESTEDFRANCHISEFINANCING":"N","APPAPPFORMALAPPINDICATOR":"N","APPAPPFOREIGNCONTROLLEDPERC":"0","APPAPPEXTRTLAMNT":"57000","APPAPPESPINSTRUCTION":"0000004068","APPAPPENTERPRDEVFUNDREQ":"","APPAPPAPPLICATIONTYPE":"O","APPAPPAPPLICATIONTIME":"101751","APPAPPAPPLICATIONSUBSTATUS":"","APPAPPAPPLICATIONSTATUS":"P","APPAPPAPPLICATIONNUMBER":"0","APPAPPAPPLICATIONDATE":"2021-01-27","APPAPPBORROWINGPOWERS":""}}}';
        Opportunity opp = [SELECT Id,AccountId,Name FROM Opportunity ];
        Application__c app = [SELECT Id, Name FROM Application__c ];
        Account account = [select Id,Client_Type__c from Account where Id=:opp.AccountId];
        Questionnaire_Template__c qTemp = [SELECT Id, Name FROM Questionnaire_Template__c LIMIT 1];
        Questionnaire_Question__c qQues = [SELECT Id, Name, Questionnaire_Template__c FROM Questionnaire_Question__c LIMIT 1];
        Application_Product__c appProd = [SELECT   Product_Name__c, Product_Type__c, Temp_Account_Number__c, System_Decision__c, Final_Decision__c,Product_Status__c,
        Opportunity__c, Name, Id, Product_State__c,NCA_Appplicable__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Account_Number__c
        FROM Application_Product__c where Product_Name__c = 'Cheque'];
        Application_Product__c appProd2 = [SELECT   Product_Name__c, Product_Type__c, Temp_Account_Number__c, System_Decision__c, Final_Decision__c,Product_Status__c,
        Opportunity__c, Name, Id, Product_State__c,NCA_Appplicable__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Account_Number__c
        FROM Application_Product__c where Product_State__c = 'existing'];

        Questionnaire_Answer__c qAnsw = new Questionnaire_Answer__c();
        qAnsw.Answer__c = 'true';
        qAnsw.Answer_Data_Type__c = 'String';
        qAnsw.Comment__c = 'Mxm, you do me like that huh?';
        qAnsw.Questionnaire_Question__c = qQues.Id;
        qAnsw.Questionnaire_Template__c = qQues.Questionnaire_Template__c;
        qAnsw.Related_Application__c = app.Id;
        qAnsw.Related_Opportunity__c = opp.id;
        insert qAnsw;

        PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean7 = (PowerCurveUpdateApplication_Req_IB_v1)JSON.deserialize(pcoStage6Req, PowerCurveUpdateApplication_Req_IB_v1.class);
        pcoUpdateRequestBean7.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.UNIQUEPRODID = appProd.Name;
        pcoUpdateRequestBean7.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.ACCOUNTNUMBER = String.valueOf(appProd.Account_Number__c);
        Test.startTest();
        PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequest = PowerCurveUpdateController7.mapPowerCureveUpdateRequest(pcoUpdateRequestBean7,opp.Id,7);

        pcoUpdateRequestBean7.Request.ApplicationDV.ExistingProducts01.APPPRDEXST = null;

        appProd.Secured_By_Mortgage_Bond__c=false;
        appProd.Product_Amount__c =14000;
        update appProd;
        appProd2.Secured_By_Mortgage_Bond__c=false;
        appProd2.Product_Amount__c =14000;
        update appProd2;
        pcoUpdateRequest = PowerCurveUpdateController7.mapPowerCureveUpdateRequest(pcoUpdateRequestBean7,opp.Id,7);

        appProd.Product_Amount__c= 50000;
        update appProd;
        appProd2.Product_Amount__c= 50000;
        update appProd2;
        pcoUpdateRequest = PowerCurveUpdateController7.mapPowerCureveUpdateRequest(pcoUpdateRequestBean7,opp.Id,7);

        appProd.Product_Amount__c = 260000;
        update appProd;
        appProd2.Product_Amount__c = 260000;
        update appProd2;
        pcoUpdateRequest = PowerCurveUpdateController7.mapPowerCureveUpdateRequest(pcoUpdateRequestBean7,opp.Id,7);

        Test.stopTest();

        System.assertNotEquals(null, pcoUpdateRequest);
    }
}