/**
* @description DocumentManagementUploaderControler
* @author Robert McLean.
* @created 2019-06-14
**/
public class DocumentManagementUploaderControler {
		/**
    * @description A method to get pick list values from the Document object field Type__c.
    * @author Robert McLean.
    * @created 2019-06-14
    * @return fileTypePickList list of pick list values.
    **/
    @AuraEnabled
     public static List < String > getFileTypePickList() {
        List<String> fileTypePickList = new list<String> {'A third party report provided by an acceptable third party data service provider',
            'ABSA 2814 - Absa Electronic Banking Services Application Form - Business',
            'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation',
            'ABSA 3122 - Affidavit to Confirm Address',
            'ABSA 3141 - Global Application to open/close savings/investment',
            'ABSA 3741 - Client Engagement',
            'ABSA 3741 -Annexure A - Cheque',
            'ABSA 3741 -Annexure A Accounts - Authorised Signatories (Savings)',
            'ABSA 3874 - Declaration to Confirm Address',
            'ABSA 4060 - Opening of an Account',
            'ABSA 4801 EX GENERAL RESOLUTION',
            'ABSA 5247- Client Needs Analysis',
            'ABSA 5635 - Confirmation of business address',
            'ABSA 5665 - business Client Agreement',
            'ABSA 5679 - Personal Client Agreement',
            'ABSA 5820 - Wealth & Investment Client Agreement',
            'ABSA 3741 - Client Engagement',
            'ABSA 6280 - Tax Self- Certification and Declaration',
            'ABSA 2235 - Power of Attorney',
            'Account statement from a service provider',
            'An affidavit from an authorised official confirming the operational address or trading name',
            'Attorney/Accountant/Auditor letter on respective letter head confirming the address of the client',
            'Bank statement from another Bank on an official Bank document/form',
            'Body corporate/governing body letter or statement',
            'CBP Proof of Address',
            'CIPC (Independently drawn CIPC by banker)',
            'E4 Proof Of Address',
            'Experian Certificate',
            'Green bar-coded identity document',
            'Home loan statement from another financial institution',
            'Long/short term insurance policy documents, from another Financial Services Provider',
            'Memorandum of Incorporation (COR 14.1)',
            'Memorandum of Incorporation (COR 15.1)',
            'Mobile - Department of Home Affairs Certificate',
            'Mobile - Proof Of Address Certificate',
            'Mobile - Proof Of Address Image',
            'Motor vehicle registration/licence documents',
            'Municipal councillor letter',
            'Municipal rates and taxes invoice',
            'Notice of Amendment (COR 15.2)',
            'Notice of Conversion (COR 18.3)',
            'Official employer letter for employees resident on company/institution premises',
            'Official SARS document (Not E Filing documentation)',
            'Official university/ technikon registration letter',
            'Proof of Identity - South African Companies CIPC',
            'Proof of Legal Existence',
            'Proof of Registration of Regulated Credit/Financial Entity',
            'Registration Certificate (COR 14.3)',
            'Recent signed lease or rental agreement',
            'Report - Experian-KI',
            'SA ID card',
            'Subscription TV (e.g. Multichoice) statement',
            'Tax Self certification and declaration forms - Entity ABSA 6279',
            'Tax Self certification and declaration forms - Natural persons ABSA 6285',
            'Telephone or cellular phone account',
            'Television licence renewal confirmation letter',
            'Tribal authority letter',
            'Utility bill (municipal water & lights account or Property Managing Agent statement)',
            'Valid drivers licence',
            'Valid passport',
            'Valid television licence',
            'Valid temporary identity document',
            'EDD level ll report',
            'Management sign off',
            'Proof of source of Income / funds',
            'Shareholding Confirmation Letter',
            'Proof of Authority Resolution Mandatory',
            'Bank Statements from another Bank on an official Bank document / Form',
            'Motor Vehicle registration / Licence documents',
            'Subscription TV (e.g Multichoice) statement',
            'Telephone and cellular phone account',
            'CIPC (Independently drawn CIPC By Banker)',
            'Proof of Registration of Regulated Credit / Financial Entity'};
        return fileTypePickList;
    }
    
         /**
    * @description A method to append to and existing file or save a file to the Attachment object. Once the file is save or updated it is then sent to ECM.
    * @param parentId parent object Id the docs are linked to.
    * @param fileName name of the file.
    * @param base64Data body of the file.
    * @param contentType type of file being uploaded.
    * @param fileId Id of existing file that has already been saved to Attachment object.
    * @param done indidcator to continu to ECM
    * @param documentType the type of document beind uploaded.
    * @return fileId Id of file updated or saved.
    * 
    * @modified 2019-06-14 by Robert McLean. 
    * @Change description Added document type to parameters to be used with the completeUpload method.
    **/    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType) {
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        if (done) {
            completeUpload(fileId, documentType);
        }
        return Id.valueOf(fileId);
    }
    
       /**
    * @description A method to save a file to the attachment object.
    * @param parentId parent object Id the docs are linked to.
    * @param fileName name of the file.
    * @param base64Data body of the file.
    * @param contentType type of file being uploaded.
    * @return fileId attachment object Id of file saved.
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
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ]; 
        String existingBody = EncodingUtil.base64Encode(a.Body); 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        update a;
    }
    
        /**
    * @description A method to upload a document from Attachment's object to ECM.
    * @param fileId Id of existing file that has already been saved to Attachment object.
    * @param documentType the type of document beind uploaded.
    * 
    * @modified 2019-06-14 by Robert McLean. 
    * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
    **/  
    @AuraEnabled
    @future(callout = true)
    public static void completeUpload(String fileId, String documentType) {
        Attachment a = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE Id =: fileId];
        String fileName = a.Name;
        Id parentId = a.ParentId;
        Id userId = UserInfo.getUserId();
        List<sObject> accountIdList = Database.query('SELECT AccountId FROM '+getParentObjectName(parentId)+' WHERE Id = \''+parentId+'\'');
        String accountId = String.valueof(accountIdList[0].get('AccountId'));  
        Account acc = [SELECT Id, Registration_Number__c, ID_Number__pc,CIF__c  FROM Account WHERE Id =: accountId];
        User usr = [SELECT Id, Business_Area__c FROM User WHERE Id =: userId];
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
        ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
        ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
        request.Token = login.Token;
        request.FileName = fileName;
        setDocumentECMInfo(request, parentId, acc, usr, documentType);
        request.Data = EncodingUtil.base64Encode(a.Body);
        req.AddRequest = request;
        ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
        String fileReference = addResult.Pid;
        addDocumentItem(fileName, parentId, fileReference, documentType);
    }
    
        /**
    * @description A method to get the of the object based on the Id of the itme in the object.
    * @author Robert McLean.
    * @created 2019-06-14
    * @param parentId parent object Id the docs are linked to.
    * @return parentObjName name of the object.
    **/   
    @AuraEnabled
    public static String getParentObjectName(Id parentId) {
        Id pId = parentId;
        String parentObjName = pId.getSObjectType().getDescribe().getName();
        return parentObjName;
    }
    
        /**
    * @description A method to add a document from Document's object.
    * @param fileName name of the file.
    * @param parentId parent object Id the docs are linked to.
    * @param fileReference ECM reference.
    * @param documentType type of document.
    * 
    * @modified 2019-06-14 by Robert McLean. 
    * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
    **/ 
    @AuraEnabled
    public static void addDocumentItem(String fileName, Id parentId, String fileReference, String documentType) {
        Document__c doc = new Document__c();
        doc.Name = fileName;
        doc.Type__c = documentType;
        switch on getParentObjectName(parentId){
            when 'Asset'{
                doc.Asset__c = parentId;
            }
            when 'Opportunity'{
                doc.Opportunity__c = parentId;
            }
            when 'Account'{
                doc.Account__c = parentId;
            }
            when 'Case'{
                doc.Case__c = parentId;
            }
        }        
        doc.Reference__c = fileReference;
        //if (signedManually) {
            //doc.Document_Status__c = 'Signed Manually';
        //}
        insert doc;
    }
         /**
    * @description A method to support the completeUpload method for all document types
    * @author Vladimir Panajic
    * @created 2019-11-06
    * @param request
    * @param parentId
    * @param acc
    * @param usr
    * @param documentType
    **/
    @AuraEnabled
    public static  void setDocumentECMInfo(ECM_AddRequest_IB_V1.AddRequest request, Id parentId, Account acc, User usr, String documentType) {
        Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByType(documentType);
        request.addFieldValue('FilingDate', DateTime.now().format('dd/MM/yyyy'));
        String idNum = acc.Registration_Number__c!= null ? acc.Registration_Number__c : acc.ID_Number__pc;
        request.addFieldValue('IdNr', idNum);
        request.addFieldValue('CIFNr', acc.CIF__c);
        request.addFieldValue('Origin', 'Salesforce B2C');
        request.addFieldValue('BusinessUnit', 'RB');
        if (documentType == 'Will') {
            switch on getParentObjectName(parentId) {
                when 'Asset'{
                    Set<Id> idSet = new Set<Id>();
                    idSet.add(parentId);
                    List<Asset> will = new AssetsSelector().selectById(idSet);
                    if (!will.isEmpty()) {
                        request.addFieldValue('WillNo', will.get(0).SerialNumber);
                    }
                }
                when 'Opportunity'{
                    request.addFieldValue('WillNo', ('NWN' + parentId).abbreviate(11));
                }
            }
        } else {
            switch on getParentObjectName(parentId) {
                when 'Asset' {
                    request.addFieldValue('AcctNr', ('Ast' + parentId).abbreviate(11));
                }
                when 'Opportunity' {
                    request.addFieldValue('AcctNr', ('Opp' + parentId).abbreviate(11));
                }
            }
        }
        request.ItemType = documentTemplate.ECM_Item_Type__c;
    }
}