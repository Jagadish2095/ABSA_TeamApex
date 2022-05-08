/**
 * @description DocumentTemplateSelectorTest Description
 * New fields 
 */
@isTest
public class DocumentTemplateSelectorTest {
/**
 * @description DocumentTemplateSelectorTest Description
 * New fields
 */
    @isTest
    private static void testSelectTemplateByName() {
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'EPP ROA';
        dt.Document_Type__c = 'EPP ROA';
        dt.Parent_Document_Type__c = 'Application Forms';
        dt.Generate_Document__c =  true;
        dt.ECM_Item_Type__c = 'Ent_ProofOfId'; //By mohammed Junaid U
        insert dt;
        test.startTest();
        DocumentTemplateSelector dts = new DocumentTemplateSelector();
        Document_Template__c docTemplate = dts.selectTemplateByName(dt.Name);
        Document_Template__c docTemplate2 = dts.selectTemplateByType(dt.Document_Type__c);
        List<Document_Template__c> ctList =  dts.selectTemplateByClientType('clientType');
        List<Document_Template__c> getAll =  dts.getAllDocumentTemplates();
        List<Document_Template__c> selTemplateNames = dts.selectTemplateNames();
        List<Document_Template__c> selTemplateByType = dts.selectTemplateByParentDocumentType(dt.Parent_Document_Type__c);
        List<Document_Template__c> selECMItemType = dts.selectTemplateByECMItemType(dt.ECM_Item_Type__c); // by Mohammed Junaid U to cover the method created
        system.assert(selTemplateNames != null,'Must not be null');
        test.stopTest();
    }
}