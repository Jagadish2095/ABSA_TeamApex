@isTest
public class UpdateJntPartByClientCode_IH_v1_Test {
	
    @isTest static void UpdateJntPartByClientCodePositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateJntPartByClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPD_JNT_PART_BY_CLIENT_CODE});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Address
        CvsValidationService_Resp_IB_v1 cvsBean = new CvsValidationService_Resp_IB_v1();
        List<CvsValidationService_Resp_IB_v1.cls_addressCollection> cvsBeanList = new List<CvsValidationService_Resp_IB_v1.cls_addressCollection>();
        CvsValidationService_Resp_IB_v1.cls_addressCollection testContactAddress = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
        testContactAddress.accountSFId = testDataFactory.testProspectAccount.Id;
        testContactAddress.addressLine1 = '55 Hello World Avenue';
        testContactAddress.addressLine2 = '';
        testContactAddress.town = 'Town';
        testContactAddress.postalCode = '0000';
        cvsBeanList.add(testContactAddress);
        cvsBean.addressCollection = cvsBeanList;
        
        Test.startTest();
        // Call the method to test
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode('TEST+01','WILLS', '3232', 'A', new List<Account>{testDataFactory.testProspectAccount}, UserInfo.getUserId(), cvsBean);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        //System.assertEquals(200, responseBean.statusCode);
    }
    
    @isTest static void UpdateJntPartByClientCodeNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateJntPartByClientCodeMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPD_JNT_PART_BY_CLIENT_CODE});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Address
        CvsValidationService_Resp_IB_v1 cvsBean = new CvsValidationService_Resp_IB_v1();
        List<CvsValidationService_Resp_IB_v1.cls_addressCollection> cvsBeanList = new List<CvsValidationService_Resp_IB_v1.cls_addressCollection>();
        CvsValidationService_Resp_IB_v1.cls_addressCollection testContactAddress = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
        testContactAddress.accountSFId = testDataFactory.testProspectAccount.Id;
        testContactAddress.addressLine1 = '55 Hello World Avenue';
        testContactAddress.addressLine2 = '';
        testContactAddress.town = 'Town';
        testContactAddress.postalCode = '0000';
        cvsBeanList.add(testContactAddress);
        cvsBean.addressCollection = cvsBeanList;
        
        Test.startTest();
        // Call the method to test
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode('TEST+01','WILLS', '3232', 'A', new List<Account>{testDataFactory.testProspectAccount}, UserInfo.getUserId(), cvsBean);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        //System.assertEquals(400, responseBean.statusCode);
    }
    
    @isTest static void UpdateJntPartByClientCodeNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateJntPartByClientCodeMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Address
        CvsValidationService_Resp_IB_v1 cvsBean = new CvsValidationService_Resp_IB_v1();
        
        Test.startTest();
        // Call the method to test
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode('TEST+01','WILLS', '3232', 'A', new List<Account>{testDataFactory.testProspectAccount}, UserInfo.getUserId(), cvsBean);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }
    
    @isTest static void UpdateJntPartByClientCodeNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPD_JNT_PART_BY_CLIENT_CODE});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Address
        CvsValidationService_Resp_IB_v1 cvsBean = new CvsValidationService_Resp_IB_v1();
        
        Test.startTest();
        // Call the method to test
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode('TEST+01','WILLS', '3232', 'A', new List<Account>{testDataFactory.testProspectAccount}, UserInfo.getUserId(), cvsBean);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }

    @isTest static void UpdateJntPartByClientCodeNoIntegrationTranslations(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateJntPartByClientCodeMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPD_JNT_PART_BY_CLIENT_CODE});
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Address
        CvsValidationService_Resp_IB_v1 cvsBean = new CvsValidationService_Resp_IB_v1();
        
        Test.startTest();
        // Call the method to test
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode('TEST+01','WILLS', '3232', 'A', new List<Account>{testDataFactory.testProspectAccount}, UserInfo.getUserId(), cvsBean);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }
    
    @isTest static void UpdateJntPartByClientCodeCreateDummy(){
        UpdateJntPartByClientCode_req_IB_v1 requestBean = UpdateJntPartByClientCode_req_IB_v1.createDummy();
    }
    
}