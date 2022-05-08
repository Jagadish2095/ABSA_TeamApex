/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-10
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
public class DocuClassifyInfo_IH_v1_Test {
    @isTest
    public static void testPositive() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Document Classification'});
        Test.setMock(HttpCalloutMock.class, new documentClassificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        DocuClassInfo_Resp_Parse requestBean = DocuClassifyInfo_IH_v1.getDocuInfo('Test','testkdsjfkdaji84pdf');
		System.assertNotEquals(requestBean, null,'Doc classification should not be empty');
    }
    


}