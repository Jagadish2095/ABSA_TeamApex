/*
* Test Integration Handler for MBinitiatePaymentV10_IH_v1 Service
* @author Srikanth N
* @created 2020-02-06
*/   

@isTest
public class ccdelinkaccountsv1_IH_v1_Test {
  
    @isTest 
    static void ccdelinkaccountsv1Positive() {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
          IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.ccdelinkaccountsv1_STRING});
        Test.startTest();
         List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
        ccdelinkaccountsv1_IH_v1.getccdelinkaccountsv1('04483850000284469',accountNumbers, true);
        Test.stopTest(); 
    }
    
    @isTest static void ccdelinkaccountsv1Negative1() {
          // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
          //IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.ccdelinkaccountsv1_STRING});
        Test.startTest();
         List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
        ccdelinkaccountsv1_IH_v1.getccdelinkaccountsv1('04483850000284469',accountNumbers, true);
        Test.stopTest(); 
    }
    @isTest static void ccdelinkaccountsv1Negative() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
          //IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
         // IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.ccdelinkaccountsv1_STRING});
        Test.startTest();
         List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
        ccdelinkaccountsv1_IH_v1.getccdelinkaccountsv1('04483850000284469',accountNumbers, true);
        ccdelinkaccountsv1_Req_IB_v1 req =new ccdelinkaccountsv1_Req_IB_v1();
        req.createDummyBean();
        ccdelinkaccountsv1_Resp_IB_v1.dummyResponse();
        Test.stopTest(); 
    }
    
}