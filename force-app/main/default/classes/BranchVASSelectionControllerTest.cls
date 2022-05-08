/**
 * @description       : BranchVASSelectionControllerTest
 * @author            : Jabulani Mashia
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-23   André Pietersen (IQ Business)   Initial Version
 * 1.0   2021-08-04   André Pietersen (IQ Business)   Marketing consent fix
 * 1.0   2021-08-05   PaulJohn.duRand@absa.africa     Update VAS Indicators
**/

@isTest
public class BranchVASSelectionControllerTest
{
    public static final String POSITIVE_RESPONSE_BODY = '{"CVSUpdateCIFv22Response":{"msgNo": 200,"msg":""}}';

    @testSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CVSUpdateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME});

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';

        account.CIF__c = 'LTD 933';
        account.Language__c = 'english';
        account.Number_Of_Dependents__c = 0;
        account.PersonEmail = 'test@absa.africa';
        account.PersonMobilePhone = '0819908786';
        account.ID_Type__pc = 'PASSPORT';
        account.Nationality__pc = 'ZIM';
        account.Highest_Qualification__pc = 'Matric';
        account.Residential_Status__pc = 'Owner';
        account.Marital_Status__pc = 'MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;

        Account account2 = new Account(Name = 'Test Account2');
        insert account2;

        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=account.id;
        opp.Site__c=siteRec.id;
        opp.CBPIndicator__c = '123456789';
        insert opp;

        Application__c app = new Application__c();
        app.Account__c = account.Id;
        app.Opportunity__c = opp.Id;
        insert app;
    }

    @isTest
    public static void updateMarketConsentTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        String result = BranchVASSelectionController.updateMarketConsent('{"oppId":"' + opp.Id + '","recordId":"' + acc.Id + '","digitalBankingInd":"Y","notifyMeInd":"Y","eStatementInd":"Y","rewardsInd":"Y","yesNoProductGroup":"no","yesNoCreditGroup":"yes","answerFirstQuestion":["Email","SMS","Voice Recording"],"answerSecondQuestion":["Email","SMS","Telephone"]}');  
    	System.assertEquals('Success', result, 'Indicators not updated');
        test.stopTest();
    }

    @isTest
    public static void updateMarketConsentTestAlternative() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        String result = BranchVASSelectionController.updateMarketConsent('{"oppId":"' + opp.Id + '","recordId":"' + acc.Id + '","digitalBankingInd":"N","notifyMeInd":"N","eStatementInd":"N","rewardsInd":"N","yesNoProductGroup":"no","yesNoCreditGroup":"no"}');  
    	System.assertEquals('Success', result, 'Indicators not updated');
        test.stopTest();
    }

    @isTest
    public static void getCreditConsentTest() {
        test.startTest();
        Map<String, String> result = BranchVASSelectionController.getCreditConsent();
        System.assert(result.size() > 0, 'Labels not retrieved');
        test.stopTest();
    }

    @isTest
    public static void getNonCreditConsentTest() {
        test.startTest();
        Map<String, String> result = BranchVASSelectionController.getNonCreditConsent();
        System.assert(result.size() > 0, 'Labels not retrieved');
        test.stopTest();
    }

    @isTest
    public static void getContactDetails() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        test.startTest();
        String result = BranchVASSelectionController.getContactDetails(acc.Id);
        System.assert(result != null, 'Labels not retrieved');
        test.stopTest();
    }

    @isTest
    public static void getContactDetailsNegative() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account2'];
        test.startTest();
        String result = BranchVASSelectionController.getContactDetails(acc.Id);
        System.assert(result != null, 'Labels not retrieved');
        test.stopTest();
    }

    @isTest
    public static void updateContactDetails() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        test.startTest();
        String result =  BranchVASSelectionController.updateContactDetails('{"recordId":"' + acc.Id + '","email":"leanette@leanete.com","cellphone":"0813339992","alternativeNumber":"0712823727"}');
        System.assert(result != null, 'Indicators not updated');
        test.stopTest();
    }

    @isTest
    public static void updateContactDetailsNegative() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account2'];
        test.startTest();
        String result =  BranchVASSelectionController.updateContactDetails('{"recordId":"' + acc.Id + '","email":"leanette@leanete.com","cellphone":"0813339992","alternativeNumber":"0712823727"}');
        System.assert(result != null, 'Indicators not updated');
        test.stopTest();
    }
}