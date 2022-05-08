@IsTest
public class JitterbitAuth_IH_V1Test {
    
    @IsTest
    public static void testAuthenticate1() {
        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit', endpoints);
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
    RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
    mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        JitterbitAuthResponse res2 = JitterbitAuth_IH_V1.authenticate();
        System.assert(res2 != null);
        Test.stopTest();
    }
    
    @IsTest
    public static void testAuthenticate2() {
        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH2);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
    RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
    mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        JitterbitAuthResponse res3 = JitterbitAuth_IH_V1.authenticate2();
        System.assert(res3 != null);
        Test.stopTest();
    }
    
    @IsTest
    public static void testAuthenticate3() {
        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit', endpoints);
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
    RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
    mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        JitterbitAuthResponse res3 = JitterbitAuth_IH_V1.authenticate('username', 'password', 'apiid');
        System.assert(res3 != null);
    }
    
    @IsTest
    public static void testAuthenticate4() {
        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH);
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH2);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        JitterbitAuthResponse res = JitterbitAuthResponse.getExample();
    RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
    mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        JitterbitAuthResponse res3 = JitterbitAuth_IH_V1.authenticate2('username', 'password', 'apiid');
        System.assert(res3 != null);
    }

}