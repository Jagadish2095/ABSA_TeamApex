/**
 * @description Test Class for MandatoryDocumentSelector
 *
 * @author  Tracy de Bruin
 * @since   July 2021 
 */ 
@IsTest
public class MandatoryDocumentSelectorTest {
    
    @isTest 
     static void testMandate(){
        string Entitytype = 'aa';
        Mandatory_Doc__mdt md1=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='Sole Trader';
        md1.ECM_Type__c='Ent_Declaration';
        //return md1;
        Mandatory_Doc__mdt md2=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='aa';
        md1.ECM_Type__c='bb';
        //md2.Type__c='bb';
        //return md2;Mandatory_Doc__mdt md1=new Mandatory_Doc__mdt();
        Mandatory_Doc__mdt md3=new Mandatory_Doc__mdt();
        md3.Entity_Type__c='Related Party Private Company';
        md3.ECM_Type__c='Ent_Declaration';
        
        Mandatory_Doc__mdt md4=new Mandatory_Doc__mdt();
        md4.Entity_Type__c='UBO';
        md4.ECM_Type__c='Ent_Declaration';
   
        Test.startTest();
        new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype('UBO');
        new MandatoryDocumentSelector().getAllMandatoryDocuments();
        new MandatoryDocumentSelector().getMandatoryDocumentsByEntityTypes(new Set<String>{'UBO'});
        List<Mandatory_Doc__mdt> mandatoryDoc = new MandatoryDocumentSelector().getRelatedMandatoryDocumentsWithEntitytype('Related Party Private Company');
         System.assert(mandatoryDoc.size() > 0);
        Test.stopTest();
    }

}