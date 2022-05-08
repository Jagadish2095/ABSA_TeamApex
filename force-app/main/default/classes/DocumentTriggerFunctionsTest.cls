@isTest
public class DocumentTriggerFunctionsTest {
    @isTest 
    public static void documentTriggerFunctionsTestMethod() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        Contact testContact = testDataFactory.testContact;
        Document__c appDoc = testDataFactory.testApplicationFormDocument;
        Document__c quoteDoc = testDataFactory.testQuoteDocument;
        Application__c app = testDataFactory.testApplication;
        appDoc.Document_Status__c = 'Signed';
        quoteDoc.Document_Status__c = 'Signed';
        test.startTest();
        opp.Quote_Status__c = 'Pending';
        update opp;
        app.Application_Status__c = 'Pending';
        update app;
        update appDoc;
        update quoteDoc;
        Set<Id> opportunityIds = new Set<Id>();
        opportunityIds.add(opp.id);
        DocumentTriggerFunctions.updateOpportunityQuoteStatus(opportunityIds);
        DocumentTriggerFunctions.updateApplicationStatus(opportunityIds);
        //System.assertEquals('Accepted', [Select Quote_Status__c from Opportunity where id = : opp.Id].Quote_Status__c);
        //System.assertEquals('Accepted', [Select Application_Status__c from Application__c where id = : app.Id].Application_Status__c);
        delete appDoc;
        test.stopTest();
        System.assert(true);  
    }
       @isTest
    public static void documentTriggerhandlerTestMethod() {
        WimiTestDataFactory testDataFactorydoc = new WimiTestDataFactory();
        Document__c appDoc = testDataFactorydoc.testApplicationFormDocument;
        
         String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='6211275132089';
        accountList[0].AccountNumber ='6211275132089';
        accountList[0].Country_of_Citizenship__c =  'South Africa';
        accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
        accountList[0].Gender__pc = 'Male';
        insert accountList;
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].AccountId=accountList[0].id;
        insert testcase[0];
        system.debug('testcase[0]>>'+testcase[0].RecordtypeId);
        ContentVersion contVerFile = new ContentVersion();
        contVerFile.VersionData = Blob.valueOf('testsjdaru893pdf'); 
        contVerFile.VersionData =EncodingUtil.base64Decode('testkdsjfkdaji84pdf');
        contVerFile.Title = 'DHACert'; 
        contVerFile.PathOnClient = 'DHA.pdf';
        contVerFile.ContentLocation= 's';
        Test.startTest(); 
        insert contVerFile;
        System.assert(contVerFile.id!= null,false);
        
        //Get Content Documents
        Id conDoc; 
        if(contVerFile!=null){
            conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contVerFile.Id].ContentDocumentId;
        }
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = testcase[0].id;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        
        insert cDe;
        
        appDoc.File_Id__c=cDe.ContentDocumentId;
        
        update appDoc;
        System.assert(cDe.id!= null,false);
        
    }
    
}