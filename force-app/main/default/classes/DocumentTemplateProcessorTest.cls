/**
 * @description Test class for DocumentTemplateProcessor
 *
 * @author
 * @version
 * @since
 * @updated Danie Booysen 2021-04-13
 */
@IsTest
public class DocumentTemplateProcessorTest {

    @IsTest
    public static void shouldInstantiateContextBuilder() {
        DocumentTemplateProcessor.ContextBuilder builder = new DocumentTemplateProcessor.ContextBuilder();
        Account acc = new Account();
        acc.Name = 'My Account';
        builder.add('Account', acc);
        String json = builder.serialize('{"var1" : true}');
        System.assert(json != null);
    }

    @IsTest
    public static void shouldProcessTemplate() {
        Test.startTest();
        DocumentTemplateProcessor.ContextBuilder builder = new DocumentTemplateProcessor.ContextBuilder();
        Account acc = new Account();
        acc.Name = 'My Account';
        builder.add('Account', acc);
        String json = builder.serialize('{"var1" : true}');
        System.assert(json != null);
        DocumentTemplateProcessor dp = new DocumentTemplateProcessor();
        Document_Template__c d = new Document_Template__c();
        d.Template_Id__c = '12345';
        d.Name = 'Business - Client Agreement';
        d.Document_Type__c = 'Business - Client Agreement';
        insert d;
        Map<String, String> ecmFields = new Map<String, String>();
        ecmFields.put('Id', '984576564987');
        ecmFields.put('password', '984576564987');
        List<String> endpoints = new List<String>();
        endpoints.add(DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
		//mock.addResponse(JSON.serialize(new CC_GenerateContentResponse()));
        mock.addResponse('{}');
        Test.setMock(HttpCalloutMock.class, mock);
        CC_GenerateContentResponse r = dp.generateDocument(builder, d, ecmFields);
        Test.stopTest();
    }

}