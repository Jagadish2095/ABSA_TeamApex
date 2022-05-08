@isTest
public class MerchantApplicationParentControllerTest {

    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        Insert app;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'Mobile - SmartPay';
        product1.IsActive = true;
        insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        insert pricebookEntry1;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        Insert oppLineItem;

        Application_Product_Merchant__c testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = oppLineItem.Id;
        Insert testAppProdMerch;
    }

    @isTest static void testGetObjectData() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Map<String, String> dataMap = MerchantApplicationParentController.getObjectData(opp.Id);
        System.assert(dataMap.containsKey('applicationId'));
        System.assert(dataMap.containsKey('applicationProductMerchantId'));
        Test.stopTest();
    }

    // PJAIN: 20200714: W-005081
    @isTest static void testCheckApprovals1() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String labelMerchantApprovalProcesses = System.Label.Merchant_Approval_Processes;

        if (String.isNotBlank(labelMerchantApprovalProcesses)) {
            List<String> processNames = labelMerchantApprovalProcesses.split(',');

            if (processNames != null && processNames.size() > 0) {
                createApproval(opp.Id, processNames[0], 'Removed');
                for (String processName : processNames) {
                    createApproval(opp.Id, processName, 'Approve');
                }
                createApproval(opp.Id, processNames[0], 'Removed');
            }
        }

        Test.startTest();
        String returnMessage = MerchantApplicationParentController.checkApprovals(opp.Id);
        System.assert(String.isBlank(returnMessage));
        Test.stopTest();
    }

    // PJAIN: 20200714: W-005081
    @isTest static void testCheckApprovals2() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String labelMerchantApprovalProcesses = System.Label.Merchant_Approval_Processes;

        if (String.isNotBlank(labelMerchantApprovalProcesses)) {
            List<String> processNames = labelMerchantApprovalProcesses.split(',');

            if (processNames != null && processNames.size() > 0) {
                createApproval(opp.Id, processNames[0], 'Reject');
            }
        }

        Test.startTest();
        String returnMessage = MerchantApplicationParentController.checkApprovals(opp.Id);
        System.assertNotEquals(null, returnMessage);
        Test.stopTest();
    }

    static void createApproval(Id objectId, String processName, String action) {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(objectId);
        req1.setProcessDefinitionNameOrId(processName);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);

        if (result.success) {
            List<Id> newWorkitemIds = result.getNewWorkitemIds();
            if (newWorkitemIds != null && newWorkitemIds.size() > 0) {
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        		req2.setAction(action);
                req2.setWorkitemId(newWorkitemIds[0]);
        		result = Approval.process(req2);
            }
        }
    }

    // PJAIN: 20200724
    @isTest
    static void testGenerateMerchantApplicationDocument() {
        Test.startTest();
        String returnMessage = MerchantApplicationParentController.generateMerchantApplicationDocument(new Map<String, String>(), 'Absa 1391: Merchant Agreement');

        String returnMessage2 = MerchantApplicationParentController.generateMerchantApplicationDocument(new Map<String, String>(), System.Label.Merchant_Application_Agreement_E_Commerce_5122_Template_Name);

        System.assertEquals(null, returnMessage);
        Test.stopTest();
    }

    //Added By Himani for #W-005298
    static testMethod void testGetMandatoryDocs(){
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        System.assertNotEquals(null, MerchantApplicationParentController.getUploadedAndMandatoryDocuments(testOpp.id,'Private Company','E-Commerce'));
        Test.stopTest();
    }

    @isTest
    private static void testDocs() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        Contact testContact = testDataFactory.testContact;
        Document__c appDoc = testDataFactory.testApplicationFormDocument;
        Document__c quoteDoc = testDataFactory.testQuoteDocument;
        test.startTest();
        MerchantApplicationParentController.documentRestricted(opp.Id);
        MerchantApplicationParentController.getAllClientEmailsSignature(opp.Id);
        MerchantApplicationParentController.getMobile(opp.Id);
        MerchantApplicationParentController.getDigitalSignatorySelectOptions('Preferred_Method__c');

        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
        Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c=testDataFactory.testOpportunity.id,
                                                                         Preferred_Email__c='test@12.com',Preferred_Method__c='Realtime',
                                                                         Preferred_Mobile__c='0989876543',
                                                                         Signatory_Party__c=testProspectAccountContactId);
        insert spo2;
        String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';

        MerchantApplicationParentController.getUpdatedSignatoriesData(opp.Id, quoteDoc.Id, sigs, 'Realtime', '0988765432', 'test@123.com');
        MerchantApplicationParentController.sendForImpressionSignature(opp.Id,  sigs);
        MerchantApplicationParentController.fetchImpressionRequest(opp.Id);
        //MerchantApplicationParentController.getDocumentContent(opp.Id,  'Download',  '');
        MerchantApplicationParentController.sendDocumentSharingEmail(opp.Id);
        MerchantApplicationParentController.getQuoteDocumentName(opp.Id);
        test.stopTest();
    }

    //D Booysen: 2020/08/07 (W-005541)
    private static testMethod void testOutdateDocumentStatus(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        MerchantApplicationParentController.outdateDocumentStatus(testDataFactory.testOpportunity.Id);
        Test.stopTest();
    }
}