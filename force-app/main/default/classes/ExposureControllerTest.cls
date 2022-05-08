/**
 * @description       : 
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-07-12
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-10   Englarmerdge Mongwe   Initial Version
**/

@IsTest
public class ExposureControllerTest {
    /**
    * @description 
    * @author Englarmerdge Mongwe | 2021-06-10 
    **/
    @testSetup
    public static void dataCreation() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Client_Type__c = 'Private Individual';
        acc.CIF__c = 'SNIFFEL001';
        acc.Sic = '35790';
        acc.AccountNumber = '0';
        acc.Registration_Number__c = '1990/011515/23';
        insert acc;

        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'UoW Test Name';
        opp.StageName = 'Open';
        opp.CloseDate = System.today();
        opp.accountid = acc.id;
        opp.RecordTypeId = onboardingrecId;
        insert opp;

        Application__c app2 = new Application__c();
        app2.Opportunity__c = opp.Id;
        app2.Account__c = acc.id;
        insert app2;

        Application_Principal__c prin1 = new Application_Principal__c();
        //prin1.Id_Number__c = '830000000000000';
        prin1.Main__c = true;
        prin1.Principal_Shareholder_Name__c = 'HERMAN JOHANNES FOURIE';
        prin1.cif__c = 'FOURIBM001';
        prin1.Application__c =  app2.Id;
        insert prin1;

        List<Application_Profile__c> appProfList = new List<Application_Profile__c>();
        Application_Profile__c appProf = new Application_Profile__c();
        appProf.Client_CIF_Code__c = acc.CIF__c;
        appProf.Client_Name__c = acc.Name;
        appProf.Application__c = app2.Id;
        appProf.Applicant_Type__c = 'Main Applicant';
        appProf.Related_to_Client_ID_or_Reg_Number__c = acc.Registration_Number__c;
        appProfList.add(appProf);

        appProf = new Application_Profile__c();
        appProf.Applicant_Type__c = 'Principal';
        appProf.Client_CIF_Code__c = prin1.cif__c;
        appProf.Client_Name__c = prin1.Principal_Shareholder_Name__c;
        appProf.Application__c =  app2.Id;
        appProf.Related_to_Client_ID_or_Reg_Number__c = prin1.Id_Number__c;
        appProfList.add(appProf);

        appProf = new Application_Profile__c();
        appProf.Applicant_Type__c = null;
        appProf.Client_CIF_Code__c = 'AABK   007';
        appProf.Client_Name__c = acc.Name;
        appProf.Application__c = app2.Id;
        appProf.Related_to_Client_ID_or_Reg_Number__c = acc.Registration_Number__c;
        appProfList.add(appProf);

        appProf = new Application_Profile__c();
        appProf.Applicant_Type__c = null;
        appProf.Client_CIF_Code__c = 'FOURIE 910';
        appProf.Client_Name__c = 'FOURIE';
        appProf.Application__c =  app2.Id;
        appProf.Related_to_Client_ID_or_Reg_Number__c = prin1.Id_Number__c;
        appProfList.add(appProf);
        insert appProfList;
        List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
        Application_Exposure_Cash_and_Investment__c appExpCash = new Application_Exposure_Cash_and_Investment__c();
        for(Application_Profile__c appProf2 :appProfList) {
            if(appProf2.Applicant_Type__c == 'Main Applicant') {
                //List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
                Application_Exposure__c appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = 'TERMLN';
                appExposure.subIndicator__c = 'O';
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = 'CHEQ';
                appExposure.subIndicator__c = 'O';
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = 'WJ026';
                appExposure.subIndicator__c = 'O';
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = 'CCARD';
                appExposure.subIndicator__c = 'O';
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = '';
                appExposure.subIndicator__c = '';
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL;
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExposure.Product__c = '';
                appExposure.subIndicator__c = '';
                appExposure.Exposure__c = '666';
                appExposure.Arrears__c = '666';
                appExposure.Excess__c = '666';
                appExposure.Installment__c = '666';
                appExposure.Liability__c = '666';
                appExposure.Limit__c = '666';
                appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PROFILE_PRODUCT_TOTAL;
                appExposures.add(appExposure);
                //insert appExposures;

                //Application_Exposure_Cash_and_Investment__c appExpCash = new Application_Exposure_Cash_and_Investment__c();
                appExpCash.Application__c = app2.Id;
                appExpCash.Client_Name__c = appProf2.Client_Name__c;
                appExpCash.Client_Code__c = appProf2.Client_CIF_Code__c;
                appExpCash.Pens_Back_Prepaid__c = 1;
                appExpCash.Participation_Bond__c = 1;
                //appExpCash.Over_Control_SIte__c = 1;
                appExpCash.Other_Available_Cash__c = 1;
                appExpCash.Notice_of_Deposits__c = 1;
                appExpCash.Mortgage_Prepaid__c = 1;
                appExpCash.Fleet_In_Credit__c = 1;
                appExpCash.Fleet_Cash_Advance__c = 1;
                appExpCash.Customer_Investment_Account__c = 1;
                appExpCash.Credit_Card__c = 1;
                appExpCash.CPF_Prepaid__c = 1;
                appExpCash.Term_Deposits__c = 1;
               // appExpCash.Control_Branch__c = 1;
                appExpCash.Savings__c = 1;
                appExpCash.AFC_In_Credit__c = 1;
                appExpCash.Cheque_In_Credit__c = 1.00;
                appExpCash.Client_Total__c = 16;
                //insert appExpCash;

                break;
            }
        }
        insert appExposures;
        insert appExpCash;
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetExposures_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetProductExposureAggre_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBgetCmsCreditGroupsDetV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBGetContBranchDetV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBgetTotalGroupExposureV3_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{TotalGroupExposure_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest public static void testGetApplicationExposures() {
        Account acc = [SELECT Id, Registration_Number__c FROM Account WHERE CIF__c = 'SNIFFEL001' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'UoW Test Name' LIMIT 1];
        Application__c app2 = [SELECT Id FROM Application__c WHERE Opportunity__c =: opp.Id LIMIT 1];
        Application_profile__c appProfile=[select Client_CIF_Code__c,client_name__c from Application_profile__c where Applicant_Type__c!='Main Applicant' limit 1];
        Map<String,String>clientCodes=new Map<String,String>();
        clientCodes.put(appProfile.Client_CIF_Code__c,appProfile.Client_Name__c);
        GetExposures_IH_v1_Test.exposuresTestMock();

        Test.startTest();
        System.assert(ExposureController.getApplicationExposuresFuture(opp.Id) != null);
        System.assert(ExposureController.getApplicationExposures(opp.Id) != null);
        ExposureController.getAndSaveExposureAggregations(app2.Id,opp.Id);
        ExposureController.getExposurePerClientCode(clientCodes,app2.Id,opp.Id);
        System.assert(ExposureController.getCashAndInvestments(opp.Id) != null);
        Test.stopTest();
    }

    @IsTest public static void testGetCMSData() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'UoW Test Name' LIMIT 1];
        Application__c application = new ApplicationsSelector().selectByOpportunityId(opp.Id).get(0);

        Application_Exposure_Total_Group__c totalGroupRecord = new Application_Exposure_Total_Group__c();
        totalGroupRecord.Application__c = application.id;
        totalGroupRecord.Client_Code__c = 'SNIFFEL001';
        totalGroupRecord.Control_Branch__c = 'test';
        totalGroupRecord.Branch_code__c = 'test';
        totalGroupRecord.Business_Segment__c = 'test';
        totalGroupRecord.Overall_Control_Branch__c = 'test';
        totalGroupRecord.Application_Total_Group__c = 'Total Group Exposure';
        totalGroupRecord.TGAE__c = 10.00;
        totalGroupRecord.TGBE__c = 10.00;
        totalGroupRecord.TGE__c = 10.00;
        totalGroupRecord.TGIE__c = 10.00;
        insert totalGroupRecord;

        Test.startTest();
        System.assertNotEquals(null,ExposureController.loadExposureCMSRecordID(opp.id));
        Test.stopTest();
    }

    @IsTest public static void testGetExposuresServiceApi() {
        GetExposures_IH_v1_Test.exposuresTestMock();

        Test.startTest();
        System.assertEquals(200, expoCallHandlerMethod().statusCode);
        Test.stopTest();
    }

    @IsTest public static void testGetExposuresAggreServiceApi() {
        GetProductExposureAggre_IH_v1_Test.productExpTestMock();
        Application__c app2 = [SELECT Id FROM Application__c LIMIT 1];
        List<Application_Exposure__c> appExposures = new ApplicationExposureSelector().getAllApplicationExposure(app2.Id);

        Test.startTest();
        System.assertEquals(200, expoProdAggreCallHandlerMethod(appExposures).statusCode);
        Test.stopTest();
    }

    private static GetExposures_Resp_IB_v1 expoCallHandlerMethod() {
        String clientCode = 'SNIFFEL001';
        GetExposures_Resp_IB_v1 resp = ExposureController.getExposuresService(clientCode);
        return resp;
    }

    /**
    * @description : Method to call handler method
    * @author Himani Joshi | 2021-07-12 
    * @param appExposureList 
    * @return GetProductExposureAggre_Resp_IB_v1 
    **/
    public static GetProductExposureAggre_Resp_IB_v1 expoProdAggreCallHandlerMethod(List<Application_Exposure__c> appExposureList) {
        List<Application_Profile__c> appProfList = [SELECT Id, Client_CIF_Code__c, Client_Name__c, Application__c, Applicant_Type__c, Related_to_Client_ID_or_Reg_Number__c FROM Application_Profile__c LIMIT 1];
        GetProductExposureAggre_Req_IB_v1 reqBean = GetProductExposureAggre_IU_v1.mapRequestFields(appExposureList, appProfList);
        GetProductExposureAggre_Resp_IB_v1 response = ExposureController.getExposuresAggreService();
        return response;
    }
}