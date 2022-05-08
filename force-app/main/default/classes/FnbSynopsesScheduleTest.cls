@isTest
public class FnbSynopsesScheduleTest { 
    @isTest static void testFnbSynopsesSchedule(){
        Integration_API__c api = new Integration_API__c();
        api.Base_URL__c = 'https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api';
        api.Client_ID__c = 'e33caff9-53d8-43ad-8b2a-d5531aae3c06';
        api.Environment__c = 'Development';
        api.Name = 'Test';
        insert api;

        Integration_Service__c service = new Integration_Service__c();
        service.Name = 'SearchProductsV2';
        service.Content_Type__c = 'application/json';
        service.Integration_API_ID__c = api.Id;
        service.Method__c = 'POST';
        service.URL_Extension__c = '/pc/searchFeatures';
        insert service;

        ROAProduct__c product = new ROAProduct__c();
        product.ProductId__c = 'CREDIT_LIFE_PERSONAL_LOAN';
        product.Description__c = 'Personal Loan';
        product.Code__c = '0501600';
        product.Synopsis__c = 'Personal Loan';
        insert product;

        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH2);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();

        mock.addResponse(JSON.serialize(res));
        mock.addResponse('{     "searchProductsV2ResponseMsg": {         "common": {             "messageSuccess": "1",             "messageTimeStamp": "Dec 4, 2020"         },         "searchProductsV2ResponseDto": {             "productCount": "1",             "cifProducts": [                 {                     "oid": "A99923497CCA46989FCB9300D54DA4C1",                     "code": "09010",                     "shortName": "Call Account",                     "longName": "Call Account",                     "description": "The Call Account is a demand account offering clients competitive interest rates.",                     "features": [                         {                             "oid": "54DB0182E7BB49AB92424EB3FFE5EDD5",                             "code": "max011",                             "shortName": "Maximum discretionary period app",                             "longName": "Maximum discretionary period applicable",                             "description": "Interest / Profit Share   Maximum discretionary period applicable",                             "usageValue": "Unlimited",                             "sortOrder": "96",                             "createdOn": "2007-10-31+02:00",                             "changedOn": "2007-10-31+02:00"                         },                         {                             "oid": "D1E2FC9C222B467282C75C0BC1F82F07",                             "code": "acc013",                             "shortName": "Account type -  Normal ",                             "longName": "Account type -  Normal ",                             "description": "Account Types Account type -  Normal ",                             "usageValue": "No",                             "sortOrder": "83",                             "createdOn": "2007-10-31+02:00",                             "changedOn": "2007-10-31+02:00"                         }                     ],                     "rules": [                         {                             "oid": "9BEEB4462CB847D3B81B768DD4E4BFE7",                             "code": "ip001",                             "shortName": "Investment Period",                             "longName": "Investment Period",                             "description": "Investment Period",                             "usageValue": "Unlimited",                             "sortOrder": "0",                             "createdOn": "2007-08-13+02:00",                             "changedOn": "2007-08-13+02:00"                         }                     ],                     "definitionChangedOn": null,                     "createdOn": "2007-07-06+02:00",                     "changedOn": "2007-10-24+02:00",                     "cifShortName": "CALL"                 }             ]         }     } }');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        FnbSynopsesSchedule.processSynopsisSync();
        Test.stopTest();
    }
}