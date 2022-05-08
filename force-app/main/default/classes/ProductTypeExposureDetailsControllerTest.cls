/**
 * @description       : Test class for ProductTypeExposureDetailsController
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-10   Englarmerdge Mongwe   Initial Version
**/

@IsTest
public class ProductTypeExposureDetailsControllerTest {
    /**
    * @description :Method to create test data
    * @author Englarmerdge Mongwe | 2021-06-10 
    **/
    @testSetup
    public static void dataCreation() {
        ExposureControllerTest.dataCreation();
        Application__c app2 = [SELECT Id FROM Application__c LIMIT 1];
        List<Application_Profile__c> appProfList = [SELECT Client_Name__c, Client_CIF_Code__c, Applicant_Type__c FROM Application_Profile__c];
        List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
        for(Application_Profile__c appProf2 :appProfList) {
            if(appProf2.Applicant_Type__c != 'Main Applicant') {
                Application_Exposure__c appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = 'Loans';
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = 'Cheques';
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = 'Mortgage Loans';
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = 'Credit Card';
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '300';
                appExposure.Arrears__c = '300';
                appExposure.Excess__c = '300';
                appExposure.Installment__c = '300';
                appExposure.Liability__c = '300';
                appExposure.Limit__c = '300';
                appExposure.Exposure_Data_Type__c = 'Asset Finance';
                appExposures.add(appExposure);

                appExposure = new Application_Exposure__c();
                appExposure.Application__c = app2.Id;
                appExposure.Client_Name__c = appProf2.Client_Name__c;
                appExposure.Exposure__c = '666';
                appExposure.Arrears__c = '666';
                appExposure.Excess__c = '666';
                appExposure.Installment__c = '666';
                appExposure.Liability__c = '666';
                appExposure.Limit__c = '666';
                appExposure.Exposure_Data_Type__c = 'Product Type Total';
                appExposures.add(appExposure);

                break;
            }
        }
         insert appExposures;
    }

    @isTest
    static void testGetProductTypeExposureDetails(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        System.assertNotEquals(null, ProductTypeExposureDetailsController.getProductTypeExposureDetails(opp.Id)) ;
        Test.stopTest();
    }
}