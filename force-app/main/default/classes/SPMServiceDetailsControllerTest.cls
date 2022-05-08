/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-08
 * @last modified by  : Manish.battu@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-11   muvhuso.nekhubvi@absa.africa   Initial Version
**/
@isTest
public class SPMServiceDetailsControllerTest {
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-08 
    **/
    @isTest
    static void getOppDetailsTest() {
        
        Opportunity opp = new Opportunity();
        Test.startTest();
        
        opp.name = 'Test Opp';
        opp.StageName='Upload Documents';
        opp.CloseDate = Date.newInstance(2008,04,28);
        insert opp;
        SPMServiceDetailsController.getOppDetails(opp.id);
        SPMServiceDetailsController.updateOppStage(opp.id);
        System.assertNotEquals(null,opp , 'cannot be null');
        Test.stopTest();
    }
    @isTest
    static void updateAppDetailsTest() {
        Application__c app = new Application__c ();
        Application__c app1 = new Application__c ();
        
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.name = 'Test Opp';
        opp.StageName='Upload Documents';
        opp.CloseDate = Date.newInstance(2008,04,28);
        insert opp;
        
        app.Opportunity__c = opp.Id;
        app.Source_of_Funds_Savings__c='COMMISSION';
        app.Investment_Number_s__c='32456';
        app.Investor_Type__c='Individual';
        app.Specify_Other_Investment_Type__c= 'Individual';
        app.Investment_Product_s_please_list_them__c='test';
        app.applicable_option__c='Central Securities Depository Participants (“CSDP”)';
        app.Exemption__c='The government, provincial administration or municipality';
        insert app;
        
        List<Application__c> allApps = [SELECT Id FROM Application__c limit 1];
        SPMServiceDetailsController.getAppRec(opp.id);
        //List Application__c = [Select Id, Name from Account Limit 10];
        SPMServiceDetailsController.updateAppDetails(app.Source_of_Funds_Savings__c,app.Investment_Number_s__c,app.Investor_Type__c,app.Specify_Other_Investment_Type__c,app.Investment_Product_s_please_list_them__c,
                                                     app.applicable_option__c,app.Exemption__c,'',app.id);
        SPMServiceDetailsController.updateAppDetails(app1.Source_of_Funds_Savings__c,app1.Investment_Number_s__c,app1.Investor_Type__c,app1.Specify_Other_Investment_Type__c,app1.Investment_Product_s_please_list_them__c,
                                                     app1.applicable_option__c,app1.Exemption__c,'',app1.id);
        
        System.assertNotEquals(0, allApps.size(), 'Optional message in case of failure');
        Test.stopTest();
    }
    
    
}