/**
* @description       : Test class for PowerCurveController
* @author            : Saurabh.Pandey@absa.africa
* @last modified on  : 2021-11-25
* @last modified by  : almas.aleem@absa.africa
* Modifications Log
* Ver   Date         Author                            Modification
* 1.0   2021-06-15   englarmerdge.mongwe@absa.africa   Initial Version
**/ 
@isTest
public class PowerCurveControllerTest {
    public static final String POSITIVE_RESPONSE_BODY = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":46000125808,"DERPCOUNIQUENUMBER":"000000004950","DerivedCalcAppData":{"DERAPPPRIN":{"PRINCAPPLICABLEIND":"Y"},"DERAPPSPSE":{"SPOUSEDETAILSREQUIREDIND":"N"},"DERAPPGPAM":{"REQMAXTERMVSPURPSLOANMAXTERM":0,"REQMAXTERMVSPURPSLOANNOTBOND":"N"},"DERAPPPAPR":{"PREAPPRIND":"N","PREAPPRREPROCESSLOWERLMTIND":"N"},"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":0,"REQPOTENTIALTOTDIRECT":0,"REQPOTENTIALTOTGROUP":515574,"REQPOTENTIALTGBE":0,"REQPOTENTIALTGAE":515574,"REQPOTENTIALTGOE":0,"REQPOTENTIALTFL":0}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30,"GUINESSRATING":39},"RESAPPCMNG":{"REMAXOFFSETREDUC":0,"REMINPLUSMINRATE":1,"SMMAXOFFSETREDUC":0.5,"SMMINPLUSMINRATE":0.5,"PMMAXOFFSETREDUC":1,"PMMINPLUSMINRATE":0,"HOCMMAXOFFSETREDUC":8,"HOCMMINPLUSMINRATE":0},"RESAPPEXCS":{"WRSTPRINCIPALP1VP2":"Z"}},"Entity":{"INTENTCLIENTCODE1":"KHCC 001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0},"APPENTIDTYPE":"05","INTENTBUR":{"COMMINPREGNUMBER":199303044823}},"DerivedCalcEntity":[{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"},"DERENTINST":{"TOTALINSTALLMENTS":0},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTARRS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTSTOR":{"STRENGTHRELATIONSHIP":"W"}},{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"},"DERENTINST":{"TOTALINSTALLMENTS":0},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTARRS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTSTOR":{"STRENGTHRELATIONSHIP":"N"}},{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"},"DERENTINST":{"TOTALINSTALLMENTS":0},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTARRS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTSTOR":{"STRENGTHRELATIONSHIP":"N"}},{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"},"DERENTINST":{"TOTALINSTALLMENTS":0},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTARRS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTSTOR":{"STRENGTHRELATIONSHIP":"N"}},{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"},"DERENTINST":{"TOTALINSTALLMENTS":0},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTARRS":{"TOTALAMNT":0,"INDICATOR":"Z"},"DERENTSTOR":{"STRENGTHRELATIONSHIP":"N"}}],"APPERRMSG":"000"}}}';
    /**
* @description method to setup test data
* @author Saurabh.Pandey@absa.africa | 2020-09-29
**/
    @testSetup
    public static void testData()   {
        List<Integration_Translation__c> intTrans = new List<Integration_Translation__c>();
        Integration_Translation__c saId = new Integration_Translation__c(Value_Type__c = 'Identity Type', Direction__c = 'Outbound', Internal_Value__c = 'SA Identity Document', External_Value__c = '1', System_Name__c = 'CIF');
        Integration_Translation__c regNum = new Integration_Translation__c(Value_Type__c = 'Identity Type', Direction__c = 'Outbound', Internal_Value__c = 'Registration Number', External_Value__c = '2', System_Name__c = 'CIF');
        Integration_Translation__c pass = new Integration_Translation__c(Value_Type__c = 'Identity Type', Direction__c = 'Outbound', Internal_Value__c = 'Passport', External_Value__c = '3', System_Name__c = 'CIF');
        intTrans.add(saId);
        intTrans.add(regNum);  
        intTrans.add(pass);
        insert intTrans;
        
        List<sObject> listToUpdate = new List<sObject>();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Account tstAccount = testDataFactory.testAccount;
        Opportunity testOpp = testDataFactory.testOpportunity;
        Application_Exposure_Total_Group__c testAppExpos = testDataFactory.testApplicationExposureTotalGroup;
        Application_Exposure_Total_Group__c testAppExpos2 = testDataFactory.testApplicationExposureTotalGroup2;
        Application_Principal__c testAppPrincipal = testDataFactory.testApplicationPrincipal;
        Application_Principal__c testAppPrincipal2 = testDataFactory.testApplicationPrincipal2;
        Application_Principal__c testAppPrincipal3 = testDataFactory.testApplicationPrincipal3;
        Application_Principal__c testAppPrincipal4 = testDataFactory.testApplicationPrincipal4;
        Application_Profile__c testAppProfile = testDataFactory.testApplicationProfile;
        Application_Profile__c testAppProfile2 = testDataFactory.testApplicationProfile2;
        Application_Scoring__c testAppScore = testDataFactory.testApplicationScoring;
        Application_Scoring__c testAppScore2 = testDataFactory.testApplicationScoring2;
        Application_Scoring__c testAppScore3 = testDataFactory.testApplicationScoring3;
        Application_Scoring__c testAppScore4 = testDataFactory.testApplicationScoring4;
        Application_Scoring__c testAppScore5 = testDataFactory.testApplicationScoring5;
        Application_Scoring__c testAppScore6 = testDataFactory.testApplicationScoring6;
        Application_Exposure__c testAppExpose = testDataFactory.testApplicationExposure;
        testAppExpose.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose);
        Application_Exposure__c testAppExpose2 = testDataFactory.testApplicationExposure2;
        testAppExpose2.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose2);
        Application_Exposure__c testAppExpose3 = testDataFactory.testApplicationExposure3;
        testAppExpose3.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose3);
        Application_Exposure__c testAppExpose4 = testDataFactory.testApplicationExposure4;
        testAppExpose4.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose4);
        Application_Exposure__c testAppExpose5 = testDataFactory.testApplicationExposure5;
        testAppExpose5.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose5);
        Application_Exposure__c testAppExpose6 = testDataFactory.testApplicationExposure6;
        testAppExpose6.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose6);
        Application_Exposure__c testAppExpose7 = testDataFactory.testApplicationExposure7;
        
        testAppExpose7.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose7);
        Application_Exposure__c testAppExpose8 = testDataFactory.testApplicationExposure8;
        testAppExpose8.Exposure__c = '9784584'; //added to run test
        listToUpdate.add(testAppExpose8);
        Application_Exposure__c testAppExpose9 = testDataFactory.testApplicationExposure9;
        Application_Exposure__c testAppExpose10 = testDataFactory.testApplicationExposure10;
        Application_Exposure__c testAppExpose11 = testDataFactory.testApplicationExposure11;
        Application_Exposure__c testAppExpose12 = testDataFactory.testApplicationExposure12;
        Application_Exposure__c testAppExpose13 = testDataFactory.testApplicationExposure13;
        Application_Exposure__c testAppExpose14 = testDataFactory.testApplicationExposure14;
        Application_Triad__c testAppTriad = testDataFactory.testApplicationTriad;
        Application_Exposure_Facility__c testAppExpFac = testDataFactory.testApplicationExposureFacility;
        Application_Exposure_Facility__c testAppExpFacBB = testDataFactory.testApplicationExposureFacilityBB;
        Application_Exposure_Facility__c testAppExpFacSLA = testDataFactory.testApplicationExposureFacilitySLA;
        Application_Exposure_Facility__c testAppExpFacAFBB = testDataFactory.testApplicationExposureFacilityAFBB;
        Application_Exposure_Facility__c testAppExpFacAFR = testDataFactory.testApplicationExposureFacilityAFR;
        Application_Exposure_Facility__c testAppExpFacMFBB = testDataFactory.testApplicationExposureFacilityMFBB;
        Application_Exposure_Facility__c testAppExpFacMFR = testDataFactory.testApplicationExposureFacilityMFR;
        Application_Product__c testAppProduct = testDataFactory.testApplicationProduct;
        Application_Product__c testAppProductParent = testDataFactory.testApplicationProductParent;
        Application_Product__c testAppProductParentNew = testDataFactory.testApplicationProductNew;
        testOpp.AccountId = tstAccount.Id;
        listToUpdate.add(testOpp);
        
        Application__c testApp = testDataFactory.testApplication;
        testApp.Opportunity__c = testOpp.Id;
        listToUpdate.add(testApp);
        update listToUpdate;
        
        Application_Product__c testApplicationProduct = new Application_Product__c();
        testApplicationProduct.Opportunity__c = testOpp.Id;
        testApplicationProduct.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProduct.Product_State__c = 'Existing';
        testApplicationProduct.Alternative_Fund_Code__c = '001';
        testApplicationProduct.Account_Number__c = 1234;
        testApplicationProduct.Product_Name__c = 'Credit Card';
        testApplicationProduct.Secured_By_Mortgage_Bond__c = true;
        testApplicationProduct.Alternative_Fund_Indicator__c = false;
        testApplicationProduct.Business_Credit_Card_Product_Type__c = 'VISA';
        testApplicationProduct.Business_Credit_Card_Sub_Product_Type__c ='GOLD';
        testApplicationProduct.Allocated_Limit__c =8500.0;
        testApplicationProduct.Requested_facility_limit__c = '12000';
        insert  testApplicationProduct;
        
        testApplicationProduct = new Application_Product__c();
        testApplicationProduct.Opportunity__c = testOpp.Id;
        testApplicationProduct.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProduct.Product_State__c = 'New';
        testApplicationProduct.Alternative_Fund_Code__c = '001';
        testApplicationProduct.Account_Number__c = 1234;
        testApplicationProduct.Product_Name__c = 'Credit Card';
        testApplicationProduct.Secured_By_Mortgage_Bond__c = true;
        testApplicationProduct.Alternative_Fund_Indicator__c = false;
        testApplicationProduct.Business_Credit_Card_Product_Type__c = 'VISA';
        testApplicationProduct.Business_Credit_Card_Sub_Product_Type__c ='GOLD';
        //testApplicationProduct.Allocated_Limit__c =8500.0;
        testApplicationProduct.Requested_facility_limit__c = '12000';
        insert  testApplicationProduct;
        
        //Inserting Bank Guarantee Products 
        Application_Product__c testApplicationProductLDP = new Application_Product__c();
        testApplicationProductLDP.Opportunity__c = testOpp.Id;
        testApplicationProductLDP.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProductLDP.Product_State__c = 'Existing';
        testApplicationProductLDP.Alternative_Fund_Code__c = '001';
        testApplicationProductLDP.Account_Number__c = 1234;
        testApplicationProductLDP.Product_Name__c = 'Bank Guarantee';
        testApplicationProductLDP.Secured_By_Mortgage_Bond__c = true;
        testApplicationProductLDP.Alternative_Fund_Indicator__c = false;
        testApplicationProductLDP.Allocated_Limit__c =8500.0;
        testApplicationProductLDP.Requested_facility_limit__c = '12000';
        insert  testApplicationProductLDP;
        
        testApplicationProductLDP = new Application_Product__c();
        testApplicationProductLDP.Opportunity__c = testOpp.Id;
        testApplicationProductLDP.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProductLDP.Product_State__c = 'New';
        testApplicationProductLDP.Alternative_Fund_Code__c = '001';
        testApplicationProductLDP.Account_Number__c = 1234;
        testApplicationProductLDP.Product_Name__c = 'Bank Guarantee';
        testApplicationProductLDP.Secured_By_Mortgage_Bond__c = true;
        testApplicationProductLDP.Alternative_Fund_Indicator__c = false;
        //testApplicationProduct.Allocated_Limit__c =8500.0;
        testApplicationProductLDP.Requested_facility_limit__c = '12000';
        insert  testApplicationProductLDP;
        
        
        
        
        
        
    }
    
    /**
* @description test method to submit To Power Curve service
* @author Saurabh.Pandey@absa.africa | 2020-09-29
**/
    @isTest
    public static void testsubmitToPowerCurve() {
        //will setup the mock later, as of now just covering it
        Opportunity oppRecord = [SELECT id FROM Opportunity LIMIT 1];
        Application__c appRec = [SELECT id FROM Application__c LIMIT 1];
        
        Test.startTest();
        System.assert(PowerCurveController.submitToPowerCurve(oppRecord.Id) != null, true) ;
        
        
        Test.stopTest();
        powerCurveController.isSoleTraderAccount(oppRecord.Id);
        powercurveController.getStage7Check(oppRecord.Id);
        
        
        
    }
    
    
    
    /* @description test method to submit To Power Curve service
* @author Almas.Aleem@absa.africa | 2021-07-12
*
    @isTest 
    public static void testReprocessing(){
        Opportunity oppRecord = [SELECT id FROM Opportunity LIMIT 1];
        Application__c appRec = [SELECT id FROM Application__c LIMIT 1];
        oppRecord.Reprocessing__c = true;
        update oppRecord;
        
        
        Test.startTest();
        System.assert(PowerCurveController.getValidationMap(oppRecord.Id) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '01', true) != null, true);
        Test.stopTest();
       /* List<Application_Scoring__c> appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppRecord.Id,'1' );
        delete appScoringList;
        
        oppRecord.Reprocessing__c = true;
        update oppRecord;
        
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '01', true) != null, true);
        
        
        
    }*/
    
    /**
* @description test method to submit To Power Curve service for all stages
**/
    @isTest
    public static void testValidationFields() {
        Opportunity oppRecord = [SELECT id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        //PowerCurveController.getValidationfields(oppRecord.Id);
        System.assert(PowerCurveController.getValidationMap(oppRecord.Id) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '01', true) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '03', true) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '04', true) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '05', true) != null, true);
        System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '06', true) != null, true);
        //System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '07', true) != null, true);
        //System.assert(PowerCurveController.pcoStageHandler(oppRecord.Id, '08', true) != null, true);
        System.assert(PowerCurveController.setValidationFields(oppRecord.Id, 'section', true) != null, true);
        Test.stopTest();
        
    }
    
    /**
* @description test method for getExposureDetails
* @author Saurabh.Pandey@absa.africa | 2020-09-29
**/
    @isTest
    public static void testExposureDetails() {
        Application__c appRec = [SELECT id FROM Application__c LIMIT 1];
        Test.startTest();
        System.assert(PowerCurveController.getExposureDetails('CIFNo', appRec.Id) != null, true);
        Test.stopTest();
    }
}