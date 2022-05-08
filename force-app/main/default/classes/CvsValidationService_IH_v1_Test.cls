/**
 * @description       : CvsValidationService_IH_v1_Test
 * @last modified on  : 2021-08-24
 * @last modified by  : Manish.battu@absa.africa
**/
@isTest
public class CvsValidationService_IH_v1_Test 
{	
    @isTest static void validateClientDetailsPositive() 
    {        
        CvsValidationService_Req_IB_v1 dummyBean = new CvsValidationService_Req_IB_v1();
        dummyBean.createDummyRequest();
        dummyBean.createDummyRequest1();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
        
        Test.startTest();
        CvsValidationService_Resp_IB_v1 responseBean = CvsValidationService_IH_v1.validateClient(dummyBean); 
        CvsValidationService_Resp_IB_v1 responseBean1 = CvsValidationService_IH_v1.validateClient(dummyBean,false);
        Map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c>  responseBean2 = CvsValidationService_IH_v1.validateClientMap(dummyBean, false);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateClientDetailsNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
        
        Test.startTest();
        
        CvsValidationService_Req_IB_v1.cls_Header header = new CvsValidationService_Req_IB_v1.cls_Header();
        header.applicationId = 'SIEBEL';
        header.clientType = '00101';
        header.clientTypeGroup = 'I';
        header.errorMessagesLanguage = 'EN';
        header.version = '1.0';
        System.assertEquals('00101', header.clientType);
        CvsValidationService_Req_IB_v1 reqBean = new CvsValidationService_Req_IB_v1();
        reqBean.header = header;
        
        CvsValidationService_Resp_IB_v1 responseBean = CvsValidationService_IH_v1.validateClient(reqBean);
        Test.stopTest();
    }
    
    @isTest static void validateClientDetailsException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
        
        Test.startTest();
        
        CvsValidationService_Req_IB_v1 reqBean = new CvsValidationService_Req_IB_v1();
        CvsValidationService_Resp_IB_v1 responseBean = CvsValidationService_IH_v1.validateClient(reqBean);  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    
    @isTest static void getCVSVersionTest() 
    {        
        String vesrion = CvsValidationService_IH_v1.getCVSVersion();
        CvsValidationService_IH_v1.getCVSValidatorSet();
        CvsValidationService_IH_v1.getCVSValidatorSetNonIndividual();
        System.assertNotEquals('', vesrion);
    }
    
    
    @isTest static void mapIndivFieldsTest() 
    {        
        Account theAcc = new Account();
        theAcc.FirstName = 'test acc';
        theAcc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        theAcc.Country_of_Registration__c = 'South Africa';
        theAcc.Client_Group__c = 'Individual';
        theAcc.Client_Type__c = 'Individual Client';
        theAcc.Registration_Number__c = '201930633006';
        theAcc.ID_Type__c = 'Registration Number';
        theAcc.LastName = '0844226270';
        theAcc.BillingStreet= '270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.ShippingStreet='270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.Phone = '0124142313';
        theAcc.PersonBirthdate = date.today();
        theAcc.Non_Credit_Marketing_Indicator__pc = 'Email';
        theAcc.PersonHomePhone = '0124142313';
        theAcc.PersonMobilePhone = '0124142313';
        insert theAcc;
        System.assertEquals('0124142313', theAcc.PersonMobilePhone);
        List<Account> accountListP =new List<Account>();
        accountListP.add(theAcc);
        List<Address__c> addrList = new List<Address__c>();
        Address__c addrRes = new Address__c();
        addrRes.Account__C = theAcc.Id;
        addrRes.Address_Type__c = 'Employers';
        addrRes.Address1__c = '270 REPUBILE ave';
        addrRes.Address2__c = 'test';
        addrRes.Address3__c = 'test';
        addrRes.Address4__c = 'JOHANNESBURG';
        addrRes.Address5__c = 'SO003';
        addrRes.Shipping_Street__c='270 REPUBILE ave';
        addrRes.Shipping_Suburb__c='test';
        addrRes.Shipping_City__c='test';
        addrRes.Shipping_State_Province__c='JOHANNESBURG';
        addrRes.Shipping_Zip_Postal_Code__c='0157';
        insert addrRes;
        addrList.add(addrRes);
        
        Address__c addrPhy = new Address__c();
        addrPhy.Account__C = theAcc.Id;
        addrPhy.Address_Type__c = 'Physical Address';
        addrPhy.Address1__c = '270 REPUBILE ave';
        addrPhy.Address2__c = 'test';
        addrPhy.Address3__c = 'test';
        addrPhy.Address4__c = 'JOHANNESBURG';
        addrPhy.Address5__c = 'SO003';
        addrPhy.Shipping_Street__c='270 REPUBILE ave';
        addrPhy.Shipping_Suburb__c='test';
        addrPhy.Shipping_City__c='test';
        addrPhy.Shipping_State_Province__c='JOHANNESBURG';
        addrPhy.Shipping_Zip_Postal_Code__c='0157';
        insert addrPhy;
        addrList.add(addrPhy);
        
        Address__c addrPostal = new Address__c();
        addrPostal.Account__C = theAcc.Id;
        addrPostal.Address_Type__c = StringConstants.POSTAL_STRING;
        addrPostal.Address1__c = '270 REPUBILE ave';
        addrPostal.Address2__c = 'test';
        addrPostal.Address3__c = 'test';
        addrPostal.Address4__c = 'JOHANNESBURG';
        addrPostal.Address5__c = 'SO003';
        addrPostal.Shipping_Street__c='270 REPUBILE ave';
        addrPostal.Shipping_Suburb__c='test';
        addrPostal.Shipping_City__c='test';
        addrPostal.Shipping_State_Province__c='JOHANNESBURG';
        addrPostal.Shipping_Zip_Postal_Code__c='0157';
        insert addrPostal;
        addrList.add(addrPostal);
        Map<String, String> tanslationValueMapP = new Map<String, String>();
        tanslationValueMapP.put('Individual','I');
        tanslationValueMapP.put('SOLE TRADER','S');
        tanslationValueMapP.put('SOLE PROP','S');
        
        CvsValidationService_IU_v1.mapFailedResponseFields(1234,'test','test');
        CvsValidationService_IU_v1.mapIndividualRequestFields(theAcc, addrList, 'I', tanslationValueMapP);
        CvsValidationService_IU_v1.mapRBBIndividualRequestFields(theAcc, addrList, 'I', tanslationValueMapP); 
        CvsValidationService_IU_v1.mapRBBMiniIndividualRequestFields(theAcc, addrList, 'I', tanslationValueMapP); 
        
        theAcc.Client_Type__c = 'Sole Trader';
        CvsValidationService_IU_v1.mapRBBIndividualRequestFields(theAcc, addrList, 'S', tanslationValueMapP);

    }
    @isTest static void mapNonIndivFieldsTest() 
    {        
        Account theAcc = new Account();
        theAcc.name = 'test acc';
        theAcc.Country_of_Registration__c = 'South Africa';
        theAcc.Client_Group__c = 'Non Individual';
        theAcc.Registration_Number__c = '201930633006';
        theAcc.ID_Type__c = 'Registration Number';
        theAcc.name = '0844226270';
        theAcc.BillingStreet= '270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.ShippingStreet='270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        insert theAcc;
        System.assertEquals('0844226270', theAcc.name);
        
        List<Account> accountListP =new List<Account>();
        accountListP.add(theAcc);
        List<Address__c> addrList = new List<Address__c>();
        Address__c addrRes = new Address__c();
        addrRes.Account__C = theAcc.Id;
        addrRes.Address_Type__c = 'Employers';
        addrRes.Address1__c = '270 REPUBILE ave';
        addrRes.Address2__c = 'test';
        addrRes.Address3__c = 'test';
        addrRes.Address4__c = 'JOHANNESBURG';
        addrRes.Address5__c = 'SO003';
        addrRes.Shipping_Street__c='270 REPUBILE ave';
        addrRes.Shipping_Suburb__c='test';
        addrRes.Shipping_City__c='test';
        addrRes.Shipping_State_Province__c='JOHANNESBURG';
        addrRes.Shipping_Zip_Postal_Code__c='0157';
        insert addrRes;
        addrList.add(addrRes);
        
        Address__c addrPhy = new Address__c();
        addrPhy.Account__C = theAcc.Id;
        addrPhy.Address_Type__c = 'Physical Address';
        addrPhy.Address1__c = '270 REPUBILE ave';
        addrPhy.Address2__c = 'test';
        addrPhy.Address3__c = 'test';
        addrPhy.Address4__c = 'JOHANNESBURG';
        addrPhy.Address5__c = 'SO003';
        addrPhy.Shipping_Street__c='270 REPUBILE ave';
        addrPhy.Shipping_Suburb__c='test';
        addrPhy.Shipping_City__c='test';
        addrPhy.Shipping_State_Province__c='JOHANNESBURG';
        addrPhy.Shipping_Zip_Postal_Code__c='0157';
        insert addrPhy;
        addrList.add(addrPhy);
        
        Address__c addrPostal = new Address__c();
        addrPostal.Account__C = theAcc.Id;
        addrPostal.Address_Type__c = StringConstants.POSTAL_STRING;
        addrPostal.Address1__c = '270 REPUBILE ave';
        addrPostal.Address2__c = 'test';
        addrPostal.Address3__c = 'test';
        addrPostal.Address4__c = 'JOHANNESBURG';
        addrPostal.Address5__c = 'SO003';
        addrPostal.Shipping_Street__c='270 REPUBILE ave';
        addrPostal.Shipping_Suburb__c='test';
        addrPostal.Shipping_City__c='test';
        addrPostal.Shipping_State_Province__c='JOHANNESBURG';
        addrPostal.Shipping_Zip_Postal_Code__c='0157';
        insert addrPostal;
        addrList.add(addrPostal);
        
        Address__c addrResd = new Address__c();
        addrResd.Account__C = theAcc.Id;
        addrResd.Address_Type__c = StringConstants.RESIDENTIAL_STRING;
        addrResd.Address1__c = '270 REPUBILE ave';
        addrResd.Address2__c = 'test';
        addrResd.Address3__c = 'test';
        addrResd.Address4__c = 'JOHANNESBURG';
        addrResd.Address5__c = 'SO003';
        addrResd.Shipping_Street__c='270 REPUBILE ave';
        addrResd.Shipping_Suburb__c='test';
        addrResd.Shipping_City__c='test';
        addrResd.Shipping_State_Province__c='JOHANNESBURG';
        addrResd.Shipping_Zip_Postal_Code__c='0157';
        insert addrResd;
        addrList.add(addrResd);
        Map<String, String> tanslationValueMapP = new Map<String, String>();
        //tanslationValueMapP.put('Individual','I');
        tanslationValueMapP.put('Non Individual','N');
        CvsValidationService_IU_v1.mapNonIndividualRequestFields(theAcc,addrList);
        CvsValidationService_IU_v1.mapFailedResponseFields(1234,'test','test');
        CvsValidationService_IU_v1.mapBusinessRequestFields(theAcc,accountListP,theAcc.Id, addrList, 'N', tanslationValueMapP);
    }
}