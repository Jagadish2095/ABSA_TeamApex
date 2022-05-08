/**
* @description - DocumentUploadController for Attestation Process
* @author  Saiteja : ABSA
* @version v1.0
* @since   2021-04-08
* @W-010215
**/


public with sharing class DocumentUploadController {
    /**
* @description -method used to save the document uploaded from the fileUpload component
* @param parentId 
* @param  fileName Name of the uploaded file
* @param  base64Data document
* @param contentType
* @param fileId
* @param done
* @param documentType
* @return fileId
*/ 
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, boolean done, string documentType) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if(fileId == ''){
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        }else{
            appendToFile(fileId, base64Data);
        }
 
        if(done){
           completeUpload(fileId, documentType);
        }
        
        return Id.valueOf(fileId);
    }
    
/**
* @description A method to save to an uploaded file in the attachment object.
* @param  parentId Id of account record from where the document is uploaded
* @param  fileName Name of the uploaded file
* @param base64Data Body of the file.
* @param contentType
* @return AttachmentId
**/    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        insert oAttachment;
        return oAttachment.Id;
    }
    
    /**
* @description A method to append to an existing file in the attachment object.
* @param fileId Id of existing file that has already been saved to Attachment object.
* @param base64Data body of the file.
**/
    public static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = [SELECT Id, Body FROM Attachment WHERE Id =: fileId]; 
        String existingBody = EncodingUtil.base64Encode(a.Body); 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        update a;
    }
    
    /**
* @description - Async call to make the callout to login and upload the document to the ECM
* @param fileId
* @param documentType
**/   
    @AuraEnabled
    @future(callout = true)
    public static void completeUpload(String fileId, String documentType) {
        
        Attachment attach = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE Id =: fileId];
        String fileName = attach.Name;
        Id parentId = attach.ParentId;       
        Account acc = [SELECT Id, Registration_Number__c, ID_Number__pc, CIF__c FROM Account WHERE Id =:parentId];
       
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
        ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
        ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
        request.Token = login.Token;
        request.FileName = fileName;
        request.addFieldValue('IdNr', acc.Registration_Number__c);
        request.addFieldValue('CIFNr', acc.CIF__c);

        setDocumentECMInfo(request, parentId, acc, documentType);
        request.Data = EncodingUtil.base64Encode(attach.Body);
        req.AddRequest = request;
        ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
        String fileReference = addResult.Pid;
        system.debug('fileReference'+fileReference);
        addDocumentItem(fileName, parentId, fileReference, documentType);
    }
    
    
     /**
     * @description A method to support the completeUpload method for all document types
     * @param request
     * @param parentId
     * @param acc
     * @param documentType
     **/
    @AuraEnabled
    public static void setDocumentECMInfo(ECM_AddRequest_IB_V1.AddRequest request, Id parentId, Account acc, String documentType){
        Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByType(documentType);
        if (documentTemplate != null){
            request.ItemType = documentTemplate.ECM_Item_Type__c;
        }
    }

    /**
* @description - creates a document in salesforce with the file reference from ECM.
* @param fileName
* @param parentId (Account ID)
* @param fileReference (PID)
* @param documentType 
*/  
    @AuraEnabled
    public static void addDocumentItem(String fileName, Id parentId, String fileReference, String documentType) {
        system.debug('fileReference'+fileReference);
        Document__c doc = new Document__c();
        doc.Name = fileName;
        doc.Type__c = documentType;
        doc.Account__c = parentId;        
        doc.Reference__c = fileReference;
        insert doc;
        system.debug('inserted success');
    }  
   
}