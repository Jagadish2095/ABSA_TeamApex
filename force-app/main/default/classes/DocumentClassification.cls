/**
* @description : Document Classification to classify the type of document
* @author : Sandeep
* @group :
* @last modified on : 2021-12-08
* @last modified by : muvhuso.nekhubvi@absa.africa
* Modifications Log
* Ver Date Author Modification
* 1.0 06-10-2021 Sandeep Chodisetti Initial Version
* Updates: Hari>> add classifyAndUploadToCISService method
**/
 
public with sharing class DocumentClassification {
    /***
* @comment : getclassify
* @description : method to get the document type from the classification service
* @param recname
* @param docustring
* @return : documentType
* **/
    public static boolean IsDocumentUpsert=false;
    public static string getclassify(string recname,string docustring) {
        string documentType;
        string message;
        DocuClassInfo_Resp_Parse docPackResponse;
        If(String.isNotBlank(docustring)){
            try{
                docPackResponse = DocuClassifyInfo_IH_v1.getDocuInfo(recname,docustring);
                if(docPackResponse.statusCode == 200 && docPackResponse.DocumentType!=null){
                    documentType = docPackResponse.responseFields.ItemType;
                }else if(docPackResponse.statusCode == 200 && (docPackResponse.DocumentType==null ||docPackResponse.DocumentType.contains('Error') || docPackResponse.DocumentType.contains('UnKnown'))){
                    documentType = 'UnKnown';
                }else{
                }

            }catch(exception ex){
                ex.getCause();
            }
        }else{
            message = 'Document not received';
        }
        return documentType;
    }
    /***
* @comment : classifyAndUploadToCISService
* @description method to call classification service and CIS serive
* @param docIdAttachmentMap
* @param docType
* **/
    @future(callout=true)
    public static void classifyAndUploadToCISService(map<id,id> docIdAttachmentMap,string docType) {
        ContentVersion cv = new ContentVersion();
        if (Schema.sObjectType.ContentVersion.fields.ContentDocumentId.isAccessible()) {
            cv = [SELECT id, VersionData,Title,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in:docIdAttachmentMap.keyset() limit 1];
        }
        Attachment attachmentRec=new Attachment();
        attachmentRec.Name=cv.Title;
        attachmentRec.Body=cv.VersionData;
        attachmentRec.ParentId=docIdAttachmentMap.get(cv.ContentDocumentId);
        string documentType=docType;
        if(cv.VersionData!=null && documentType==''){
            documentType=getclassify(cv.Title,EncodingUtil.base64Encode(cv.VersionData));
        }
        if(attachmentRec!=null){
            uploadDoctoCIS(attachmentRec,documentType,cv.ContentDocumentId,cv.Id);
        }

    }
    /***
* @comment : classifyAndUploadToCISService
* @description method to call classification service and CIS serive
* @param attRec
* @param documentType
* @param fileId
* @param ContentVersionID
* **/
    public static void uploadDoctoCIS(Attachment attRec, string documentType,id fileId,id ContentVersionID){
        string jointCIF;
        list<case> caeReclist = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{attRec.ParentId} ,1);
        Account acc;
        if(caeReclist.size()>0 && caeReclist[0].AccountId!=null){
            acc = new AccountsSelector().selectAllById(caeReclist[0].AccountId);
            if(caeReclist[0].Customer_Type__c != null){
                jointCIF = caeReclist[0].Customer_Type__c == 'Joints and Several' ?  caeReclist[0].Client_Number__c : '';
             }
        }
        CIS_AddDocResult_IB_v1 addDocRequest=new CIS_AddDocResult_IB_v1();
        documentType=documentType!=null && documentType.contains('Ent_')?documentType.remove('Ent_'):documentType;
        if(!test.isRunningTest() && documentType!=null && documentType!='Unknown' && acc!=null){
            try{
                addDocRequest= CIS_IH_v1.UploadDocument(attRec.Name,documentType,attRec,acc,'','false','',jointCIF); //By Mohammed Junaid U as the Upload document parameters have changed
            }catch(exception ex){
                ex.getCause();
            }
        }else if(attRec.Name.contains('DHACert')){
            String filename = attRec.Name + '.pdf';
            addDocRequest= CIS_IH_v1.UploadDocument(filename,'ProofOfId',attRec,acc,'SMAPP','true','',jointCIF); //By Mohammed Junaid U as the Upload document parameters have changed   
       }
        //adding the document record in Salesforce with the PID received as the response from AMBER
        if(addDocRequest.Pid != null || Test.isRunningTest() || documentType=='Unknown' || documentType!=null){
            DocumentWraper doc = new DocumentWraper();
            doc.docname=attRec.Name;
            doc.caseId=attRec.ParentId;
            doc.Doctype=documentType;
            doc.accountId=acc!=null?acc.id:null;
            doc.reference=addDocRequest.Pid!=null?addDocRequest.Pid :'No PID -'+system.now();
            doc.fileId=fileId;
            doc.ContentVersionID=ContentVersionID;
            doc.ConfidenceLevel=addDocRequest.OcrDocResults!=null?addDocRequest.OcrDocResults.Confidence:'UnKnown';
            doc.ConfidenceMessage=addDocRequest.OcrDocResults!=null?addDocRequest.OcrDocResults.ConfidenceMessage:'';
            Documentcreation(doc);
        }
    }
    /**
* @description DocumentWrapper
*/
    public class DocumentWraper{
        public string docname;
        public id caseId;
        public id accountId;
        public string Doctype;
        public string reference;
        public string fileId;
        public string ConfidenceLevel;
        public string ConfidenceMessage;
        public string ContentVersionID;
    }
    /***
* @comment : documentcreation
* @description method to create Custom Document and calling HL_CaseUpdateCISResponse.caseUpdateOnCisResp
* @param doc
* **/
    public static void Documentcreation(DocumentWraper doc ){
        Document__c document = new Document__c(Description__c=doc.ConfidenceMessage,ConfidenceLevel__c=doc.ConfidenceLevel,ContentVersionID__c=doc.ContentVersionID,name=doc.docname,case__c=doc.caseId,Type__c=doc.Doctype,Account__c=doc.accountId,Reference__c=doc.reference,File_Id__c=doc.fileId);
        if(document!=null && Schema.sObjectType.Document__c.fields.Name.isCreateable()){
            IsDocumentUpsert=true;
            upsert document File_Id__c;
            if(doc.CaseId != null) {
            List<Case> aicCases = [select id from Case where id = :doc.CaseId AND RecordType.DeveloperName = 'AIC' ];
            if(aicCases.size() > 0){
            AIC_CaseUpdateCISResponse.caseUpdateOnCisResp(doc.caseId, doc.ConfidenceLevel);
            }
            else{
            HL_CaseUpdateCISResponse.caseUpdateOnCisResp(doc.caseId, doc.ConfidenceLevel);
            }
            }
        }
        //Calling caseUpdateOnCisResp method if confidence level is high/Low
    }
}