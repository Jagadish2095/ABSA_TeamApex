/**
 * Test class by Tinashe Shoko
*/
@isTest
public class ImpressionApiWrapperTest {
    public static  testMethod void testAll() {
        test.startTest();
        ImpressionApiWrapper iaw = new ImpressionApiWrapper();
        ImpressionApiWrapper.getRoles( 'apiKey', 'body');
        ImpressionApiWrapper.createWorkflow('apiKey', 'body');
        ImpressionApiWrapper.createPDFSignatureRequestEvent('apiKey', 'body');
        ImpressionApiWrapper.oauthGetToken();
        ImpressionApiWrapper.signatureAuditTrail('apiKey',  'param');
        ImpressionApiWrapper.docReturn('apiKey',  'param');
        ImpressionApiWrapper.signatureAuditRequest('apiKey',  'param');
        ImpressionApiWrapper.createInlineSignatureWorkflow('apiKey',  'param');
        ImpressionApiWrapper.designDoc('apiKey',  'param');
        test.stopTest();
    }
}