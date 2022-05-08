/*
*  Class for getdocumentsforcase and get case service
* @author Haritha Police
* @created 26-01-2021
*/
public class CAF_CaseDocumentsController {
    @AuraEnabled
    public static void getDocumentsForCase(Id caseId) {
        if (String.isBlank(caseId)) {
            throw new AuraHandledException('caseId cannot be null.');
        }

        List<Case> caseList = [
            SELECT Id, External_Reference_Number__c, Application_Product_Id__c
            FROM Case
            WHERE Id = :caseId AND External_Reference_Type__c = 'BCMS'
        ];

        if (caseList == null || caseList.size() < 1) {
            throw new AuraHandledException('Case with caseId ' + caseId + ' not found.');
        }

        Application_Product_CAF__c aPC = storeSAPFields(caseId, caseList[0].External_Reference_Number__c, caseList[0].Application_Product_Id__c);
        downloadAndStoreDocuments(caseId, caseList[0].External_Reference_Number__c);
        update aPC;
    }

    private static Application_Product_CAF__c storeSAPFields(Id caseId, string externalReferenceNo, Id aPCId) {
        CAFGetCase_Resp_IB_v1 response = CAFGetCase_IH_v1.bcmsgetcasev1data(externalReferenceNo);

        if (response == null) {
            throw new AuraHandledException('storeSAPFields: response is null.');
        }

        if (response.GetCaseResponse == null || response.GetCaseResponse.TheCase == null || response.GetCaseResponse.TheCase.Data == null) {
            System.debug('storeSAPFields: Unexpected response received. Service Response: ' + JSON.serialize(response));
            throw new AuraHandledException('storeSAPFields: Unexpected response received. Service Response: ' + JSON.serialize(response));
        }

        String xmlData = EncodingUtil.base64Decode(response.GetCaseResponse.TheCase.Data).toString();
        Dom.Document domDoc = new Dom.Document();
        domDoc.load(xmlData);

        Dom.XmlNode rootNode = domDoc.getRootElement();
        string sapRefNode = rootNode.getChildElement('sapRefNo', null)?.getText();
        string sapExternalReferenceNode = rootNode.getChildElement('sapExternalReference', null)?.getText();
        string scoreResultNode = rootNode.getChildElement('scoreResult', null)?.getText();

        Application_Product_CAF__c aPC = new Application_Product_CAF__c(
            Id = aPCId,
            SAP_Reference_Number__c = sapRefNode,
            SAP_External_Reference__c = sapExternalReferenceNode,
            SAP_Scoring_Status__c = scoreResultNode
        );

        return aPC;
    }

    private static void downloadAndStoreDocuments(Id caseId, string externalReferenceNo) {
        CAFGetDocumentsforCase_Resp_IB_v1 response = CAFGetDocumentsforCase_IH_v1.bcmsGenerateDocumentforcasev1data(externalReferenceNo);

        if (response == null) {
            throw new AuraHandledException('downloadAndStoreDocuments: response is null.');
        }

        if (response.GetDocumentsForCaseResponse == null || response.GetDocumentsForCaseResponse.documents == null) {
            System.debug('downloadAndStoreDocuments: Unexpected response received. Service Response: ' + JSON.serialize(response));
            throw new AuraHandledException('downloadAndStoreDocuments: Unexpected response received. Service Response: ' + JSON.serialize(response));
        }

        if (response.GetDocumentsForCaseResponse.documents.size() < 1) {
            throw new AuraHandledException('downloadAndStoreDocuments: No documents found.');
        }

        List<CAFGetDocumentsforCase_Resp_IB_v1.Documents> documents = response.GetDocumentsForCaseResponse.documents;
        Map<String, String> documentMapWithTimestamp = new Map<String,String>();
        Map<String, String> documentMapWithData = new Map<String,String>();

        List<Document__c> documentListByCase = new DocumentsSelector().selectDocumentsByOppId(caseId);
        Map<String, List<Document__c>> documentMapByReference = Sys_Utilities_General.convertListToMapWithStringKey(documentListByCase, 'Name');
        List<Document__c> documentsToDelete = new List<Document__c>();

        for (CAFGetDocumentsforCase_Resp_IB_v1.Documents document : documents) {
            String name = document.Name;
            String data = document.Data;
            String timestamp = document.Updated;

            if (!documentMapWithTimestamp.containsKey(name) || documentMapWithTimestamp.get(name) < timestamp) {
                documentMapWithTimestamp.put(name, timestamp);
                documentMapWithData.put(name, data);
            }
        }

        for (String name : documentMapWithData.keySet()) {
            if (documentMapByReference.containsKey(name)) {
                documentsToDelete.addAll(documentMapByReference.get(name));
            }
            String data = documentMapWithData.get(name);
            sendTOECM(caseId, 'Avaf contract', name.substringBeforeLast('.pdf'), data);
        }

        delete documentsToDelete;
    }

    @future(callout=true)
    private static void sendTOECM(String caseId, String documentType, String name, String data) {
        DocumentController.sendTOECM(caseId, documentType, name, data);
    }
}