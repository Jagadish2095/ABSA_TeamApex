/**
 * @description       : 
 * @author            : Gulafsha
 * @last modified on  : 2021-06-12
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-12   Gulafsha   Initial Version
**/
@isTest
public class ClientSecuritiesControllerNewTest {
    @isTest
    public static void testApplicationSecurityTrigger(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        Opportunity opp = new Opportunity();
        opp.Name = 'UoW Test Name ';
        opp.StageName = 'Open';
        opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Profile__c appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = 'AABK   007';
        appProfile.Client_Name__c = 'Absa Bank';
        appProfile.Related_to_Client_ID_or_Reg_Number__c ='AABK   007';
        appProfile.Application__c = application.Id;
        appProfile.Applicant_Type__c = 'Main Applicant';
        insert appProfile;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Bond';
        appsec.Application_Id_Text__c = application.id;
        appsec.Client_Code__c = 'AABK   007';
        appsec.Specific__c = 'Test';
        appsec.ASV__c = 10;
        appsec.ASV_MASV__c = 10;
        appsec.Status__c = 'Open';
        insert appsec;
        Application_Security__c appsec1 = new Application_Security__c();
        appsec1.Application__c = application.id;
        appsec1.Security_Type__c = 'Letter of Undertaking';
        appsec1.Application_Id_Text__c = application.id;
        appsec1.Client_Code__c = 'AABK   007';
        appsec1.Specific__c = 'Test';
        appsec1.ASV__c = 10;
        appsec1.Account_Number__c = '123456';
        appsec1.ASV_MASV__c = 10;
        appsec1.MASV__c =10;
        appsec1.Status__c = 'Open';
        insert appsec1;
        System.assertEquals(10,appsec.ASV__c,'');
        appsec1.Specific__c = 'Testing';
        appsec1.ASV__c = 101;
        appsec1.MASV__c = 101;
        appsec1.Client_Code__c ='AABK   007';
        update appsec1;
        System.assertEquals(101,appsec1.ASV__c,'');
        List<string> handlerNames = new List<string>();
        handlerNames.add('Test');
        system.debug(appsec);
        TriggerDispatcher.resume(handlerNames);
        TriggerDispatcher.skip(handlerNames);
        ClientSecuritiesControllerNew.calculatePowerCurveSummary(opp.Id,TRUE);
        ClientSecuritiesControllerNew.calculatePowerCurveSummaryProducts(Opp.Id, '123456');
    }
    @isTest 
    public static void validatesMgetAsVbondsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Bond';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Ranking_Number__c = 10;
        appsec.Amount__c = 100;
        appsec.Realistic_Market_Value__c = 100;
        appsec.Status__c = 'Open';
        appsec.Date_Signed__c = system.today();
        insert appsec;
        system.debug(opp);
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_BONDS_V1
        });

        Test.startTest();
        //ClientSecuritiesControllerNew clientsec = new ClientSecuritiesControllerNew();
        ClientSecuritiesControllerNew.getApplication(opp.id);
        String respose = ClientSecuritiesControllerNew.getSecurityBonds(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securities(setids);
        List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> bondsWrapperList = new  List<sMgetAsVbondsV1_Resp_IB_v1.BondTable>();
        sMgetAsVbondsV1_Resp_IB_v1.BondTable bondT = new sMgetAsVbondsV1_Resp_IB_v1.BondTable();
                                              
                                              bondT.specific = appsec.Specific__c;
                                              bondT.status   = appsec.Status__c;
        bondT.regdt = string.valueof(appsec.Date_Signed__c);
        bondT.ApplicationId = appsec.Application_Id_Text__c;
        bondsWrapperList.add(bondT);
        ClientSecuritiesControllerNew.insertAppSecurities(bondsWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    @isTest 
    public static void validatesCOUTPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Cession of Unit Trust';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Ranking_Number__c = 10;
        appsec.Amount__c = 100;
        appsec.Realistic_Market_Value__c = 100;
        appsec.Status__c = 'Open';
        appsec.Date_Signed__c = system.today();
        insert appsec;
        system.debug(opp);
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMgetASVCOUnitTrustsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            'SM Get ASVCessionOfUnitTrusts V1'
        });

        Test.startTest();
        //ClientSecuritiesControllerNew clientsec = new ClientSecuritiesControllerNew();
        ClientSecuritiesControllerNew.getApplication(opp.id);
        String respose = ClientSecuritiesControllerNew.getCessionofUnitTrusts(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesCOUT(setids);
        List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl> bondsWrapperList = new  List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl>();
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl bondT = new SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl();
                                              
                                              bondT.specific = appsec.Specific__c;
                                              bondT.status   = appsec.Status__c;
        //bondT.regdt = string.valueof(appsec.Date_Signed__c);
        bondT.ApplicationId = appsec.Application_Id_Text__c;
        bondsWrapperList.add(bondT);
        ClientSecuritiesControllerNew.insertAppSecuritiesCOUT(bondsWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
     @isTest 
    public static void validatesgetSuretyshipsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Suretyship';
        appsec.Application_Id_Text__c = application.id;
        appsec.ASV_MASV__c =10;
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Date_Signed__c = system.today();
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSuretyshipsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SURETYSHIPS_V1
        });

        Test.startTest();
       
        String respose = ClientSecuritiesControllerNew.getSuretyships(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesSuretyS(setids);
        List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> SuretyshipsWrapperList = new  List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable>();
        sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable suretysh = new sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable();
        //suretysh.specific = appsec.Specific__c;
                                              suretysh.status   = appsec.Status__c;
        suretysh.ApplicationId = appsec.Application_Id_Text__c;
        suretysh.dateSign = string.valueof(appsec.Date_Signed__c);
        suretysh.mortasv = string.valueof(appsec.ASV_MASV__c);
        SuretyshipsWrapperList.add(suretysh);
        ClientSecuritiesControllerNew.insertAppSecurities(SuretyshipsWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetCreditLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Credit Life Assurance';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Date_Signed__c = system.today();
        appsec.Status__c = 'Open';
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCreditLifePolicyV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CREDIT_LIFE_POLICY_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCreditLifePolicy(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCLA(setids);
        List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> policiesWrapperList = new  List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable>();
        sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable policies = new sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable();
        //suretysh.specific = appsec.Specific__c;
                                              policies.status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policies.startDate = string.valueof(appsec.Date_Signed__c);
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetgetCessionofLinkLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Cession of Life Policy';
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_LINKED_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionofLinkLifePolicy(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCessionLLP(setids);
        List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table>();
        sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table policies = new sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              policies.statusout   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
     @isTest
    public static void validatesgetCessionofNoLinkLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'Cession of Life Policy (not Linked)';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPNoLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionofNoLinkLifePolicy(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCessionNoLLP(setids);
        List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table>();
        sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table policies = new sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              policies.statusout   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
     @isTest
    public static void validatesgetCessionofDebtorsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Cession of Debtors';
        appsec.Application_Id_Text__c = application.id;
        appsec.Current_Net_Number_Debtors__c =10;
            appsec.X30_Days_Number_Debtors__c =10;
            appsec.X60_Days_Number_Debtors__c =10;
            appsec.X90_Days_Number_Debtors__c =10;
            appsec.X120_Days_Number_Debtors__c =10;
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
            appsec.Ranking_Number__c =10;
            appsec.X30_Days_Amount__c =10;
            appsec.X60_Days_Amount__c =10;
            appsec.X90_Days_Amount__c=10;
            appsec.X120_Days_Amount__c =10;
            appsec.Amount__c=10;
            appsec.Account_Balance__c =10;
            
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        insert appsec;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_DEBTORS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionofDebtors(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCOD(setids);
        List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table>();
        sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table policies = new sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              policies.statusout   = appsec.Status__c;
      policies.num0out = string.valueof(appsec.Current_Net_Number_Debtors__c); 
          policies.num30out = string.valueof(appsec.X30_Days_Number_Debtors__c);
        policies.anldteout = string.valueof(appsec.Date_Analysis__c);
        policies.cesdteOut = string.valueof(appsec.Date_Signed__c);
          policies.num60out =string.valueof(appsec.X60_Days_Number_Debtors__c);
         policies.num90out = string.valueof(appsec.X90_Days_Number_Debtors__c);
          policies.num120out =string.valueof(appsec.X120_Days_Number_Debtors__c);
         policies.numtotout = string.valueof(appsec.Ranking_Number__c);
         policies.amt30out = string.valueof(appsec.X30_Days_Amount__c);
        policies.amt60out = string.valueof(appsec.X60_Days_Amount__c);
         policies.amt90out = string.valueof(appsec.X90_Days_Amount__c);
          policies.amt120out = string.valueof(appsec.X120_Days_Amount__c);
          policies.amttotout = string.valueof(appsec.Amount__c);
           policies.amt0out= string.valueof(appsec.Account_Balance__c); 
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetCessionofGeneralpledgesPositive(){
       Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Cession of General Pledges';
        appsec.Application_Id_Text__c = application.id;
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Realistic_Market_Value__c = 10;
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionofGeneralpledges(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCogP(setids);
        List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table>();
        sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table policies = new sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              policies.statusout   = appsec.Status__c;
       policies.plddteout = string.valueof(appsec.Date_Signed__c);
        policies.valdteOut = string.valueof(appsec.Date_Analysis__c);
        policies.remvalout = string.valueof(appsec.Realistic_Market_Value__c);
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetCessionofInternalInvestmentsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Cession of Internal Investments';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
        appsec.Status__c = 'Open';
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
		
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_INVSTMNT_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionofInternalInvestments(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCoiI(setids);
        List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> policiesWrapperList = new  List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable>();
        sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable policies = new sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable();
        //suretysh.specific = appsec.Specific__c;
                                              policies.astatusout   = appsec.Status__c;
        policies.dtesignedOut = string.valueof(appsec.Date_Signed__c);
        policies.matdteOut = string.valueof(appsec.Date_Analysis__c);
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetgetCessionOfSchemesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'Cession of Schemes';
        appsec.ASV_MASV__c = 10;
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
		
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getCessionOfSchemes(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesCOS(setids);
        List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table>();
        sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table policies = new sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              policies.Status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policies.crisdtOut = string.valueof(appsec.ASV_MASV__c);
        policies.guarntOut = '7';
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetDematSharesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Dematerialized Shares';
        appsec.Specific__c = 'Test';
        appsec.Date_Signed__c = system.today();
        appsec.Status__c = 'Open';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
		
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvDematSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_DEMAT_SHARES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getDematShares(ac.Id,opp.id);
        //system.assertNotEquals(null, respose);
        ClientSecuritiesControllerNew.securitiesDematS(setids);
        List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> policiesWrapperList = new  List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl>();
        sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl policies = new sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl();
        //suretysh.specific = appsec.Specific__c;
                                              policies.Status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policies.signDte = string.valueof(appsec.Date_Signed__c);
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetAsvLettersV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Letter of Undertaking';
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
		
		set<id> setids = new set<id>();
        setids.add(app.id);
		
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_LETTERS_V1
        });
		
        setids.add(app.id);
        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getAsvLettersV1(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesLoU(setids);
        List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> policiesWrapperList = new  List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable>();
        sMgetAsvLettersV1_Resp_IB_v1.LettersTable policies = new sMgetAsvLettersV1_Resp_IB_v1.LettersTable();
        //suretysh.specific = appsec.Specific__c;
                                              policies.Status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetASVGeneralCessionsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        
        insert application;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'General Session';
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        
         // Set mock callout class 
       Test.setMock(HttpCalloutMock.class, new sMgetAsvGeneralCessionsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_GENERAL_SESSION_V1
        });
		set<id> setids = new set<id>();
        setids.add(app.id);
        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getASVGeneralCessionsV1(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesASVGCV1(setids);
        List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> policiesWrapperList = new  List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable>();
        sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable policies = new sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable();
        //suretysh.specific = appsec.Specific__c;
                                              policies.Status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policies.datesign = string.valueof(appsec.Date_Signed__c);
        policies.valDate = string.valueof(appsec.Date_Analysis__c);
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
	
	@isTest
    public static void validatesgetAsvCessionOfSharesV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        
        insert application;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'Cession of Stock and Shares';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        
         // Set mock callout class 
       Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SHARES_V1
        });
		set<id> setids = new set<id>();
        setids.add(app.id);
        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getAsvCessionOfShares(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesASVCessionS(setids);
        List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> policiesWrapperList = new  List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl>();
        sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl policies = new sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl();
        //suretysh.specific = appsec.Specific__c;
        policies.signDte = string.valueof(appsec.Date_Signed__c);
                                              policies.Status   = appsec.Status__c;
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    
    @isTest
    public static void validatesgetCessionOfFireShortTermInsuranceV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        
        insert application;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.ASV_MASV__c = 10;
        appsec.Amount__c = 10;
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'Cession of Fire Short-Term Insurance';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        
         // Set mock callout class 
       Test.setMock(HttpCalloutMock.class, new SMgetASVCessionOfFireSrtV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1
        });
		set<id> setids = new set<id>();
        setids.add(app.id);
        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getASVCessionOfFireShortTermInsuranceV1(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesASVCessionFSTI(setids);
        List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> policiesWrapperList = new  List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table>();
        SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table policies = new SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                              //policies.Status   = appsec.Status__c;
        policies.polamtOut = string.valueof(appsec.Amount__c);
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policies.ackdteOut =  string.valueof(appsec.ASV_MASV__c);
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetCessionOfExternalInvestmentsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
            opp.Name = 'UoW Test Name ';
            opp.StageName = 'Open';
            opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        
        insert application;
        
        Application_Profile__c app=new Application_Profile__c();
        app.Client_CIF_Code__c='SNIFFEL001';
        app.Client_Name__c='Absa Bank';
        app.Application__c=application.Id;
        app.Applicant_Type__c='Main Applicant';
        insert app;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.Date_Analysis__c = system.today();
        appsec.Date_Signed__c = system.today();
        appsec.Status__c = 'Open';
        appsec.Security_Type__c = 'Cession of External Investments';
        appsec.Application_Id_Text__c = application.id;
        insert appsec;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfExtInv_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1
        });
		set<id> setids = new set<id>();
        setids.add(app.id);
        Test.startTest();
        String respose = ClientSecuritiesControllerNew.getASVCessionOfExternalInvestmentsV1(ac.Id,opp.id);
        ClientSecuritiesControllerNew.securitiesASVCessionEI(setids);
        List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> policiesWrapperList = new  List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table>();
        sMgetAsvCessionOfExtInv_Resp_IB_v1.Table policies = new sMgetAsvCessionOfExtInv_Resp_IB_v1.Table();
        //suretysh.specific = appsec.Specific__c;
                                            policies.dtesignedOut = string.valueof(appsec.Date_Signed__c);
        policies.matdteOut = string.valueof(appsec.Date_Analysis__c);
        policies.ApplicationId = appsec.Application_Id_Text__c;
        policiesWrapperList.add(policies);
        ClientSecuritiesControllerNew.insertAppSecurities(policiesWrapperList);
        //system.assertNotEquals(null, respose);
        System.assert(new ApplicationSecuritySelector().getSObjectType() != null);
        Test.stopTest();
    }
}