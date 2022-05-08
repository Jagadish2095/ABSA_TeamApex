/* Lightning cmp controller for fees and interest refund
* Author: Lulu Rankwe
* Date :  17/12/2020 
* 
* */
public class FeesAndInterestRefundController {
    

   /**
    * @description A method to get products
    * @return  list products
    **/  
    @AuraEnabled
    public static List <Product2> getProduct() {
        List<Product2> productList = [SELECT Id,Name FROM Product2 WHERE Approval_Group__c != null];//=: 'AG1'];
        List <String> allOpts = new list <String> ();
        
        system.debug('allOpts ' + productList);
        return productList;
    }

     /**
    * @description A method to updatecase record
    * @return  String
    **/ 
    @AuraEnabled
    public static string updateCase(Id caseRecordId,String productId,String refundTransactionId,String refundReasonId,double amount,String clientDomicileBranch,String subLedger,String journalMode,String description,String motivation,String itemReference,String refundRangeDateFrom,String refundRangeDateTo,String effectiveJournalDate,String seletedAccountNumber){
        String output;
        
        effectiveJournalDate = effectiveJournalDate.replace('-', '/');
        refundRangeDateFrom = refundRangeDateFrom.replace('-', '/');
        refundRangeDateTo = refundRangeDateTo.replace('-', '/');
        
        date expectedEffectiveDate = date.parse(effectiveJournalDate);
        date expectedRefundRangeDateFrom= date.parse(refundRangeDateFrom);
        date expectedrefundRangeDateTo = date.parse(refundRangeDateTo);
        
        if(caseRecordId != null){
            Case caseObj = new Case(Id=caseRecordId);
            caseObj.Client_Domicile_Branch__c = clientDomicileBranch;
            caseObj.Sub_Ledger__c = subLedger;
            caseObj.Journal_Mode__c = journalMode;
            caseObj.Description = description;
            caseObj.Deadlock_Reason_Motivation__c = motivation;
            caseObj.Reference_Number__c = itemReference;
            caseObj.Refund_Date_Range_From__c = expectedRefundRangeDateFrom;
            caseObj.Refund_Date_Range_To__c = expectedrefundRangeDateTo;
            caseObj.Effective_Date_for_Journal__c = expectedEffectiveDate;
            caseObj.Amount__c = amount;
            caseObj.Product_Search__c = productId;
            caseObj.Refund_Transaction_Type_Id__c = refundTransactionId;
            caseObj.Refund_Reason_Id__c = refundReasonId;
            caseObj.Account_Number__c = seletedAccountNumber;
            Update caseObj;
            output ='Case is Updated successfully';
            
        }else{
            output ='Failed to update case ';
        }
        system.debug('results: ' + output);
        
        return output;
        
    }
    


/** 
* Method that gets a list of all documents (email) 
* @param recordId
* @return a list of documents linked to the recordId parameter
*/
   @AuraEnabled
    public static List<Document__c> getDocAuditHistoryEmail(Id recordId) {
        List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(recordId);
        return docList;
    }
    
    
    // Method that gets a list of documents uploaded
    
    @AuraEnabled
    public static List<string> getDocs(Id recordId) { 
        Map<Id,Document_Template__c>docmap1=new map<Id,Document_Template__c>([select name,ECM_Item_Type__c from Document_Template__c]); 
        system.debug('docmap1'+docmap1); 
        Map<string,string>docmap2=new Map<string,string>(); 
        for(Id aa: docmap1.keyset()) { 
            //docmap2.put(aa.Id,aa.ECM_Item_Type__c); 
            docmap2.put(docmap1.get(aa).name,docmap1.get(aa).ECM_Item_Type__c); 
        }
        
        system.debug('docmap2'+docmap2);
        
        List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(recordId);
        system.debug('docList '+ docList);
        list<string>auditlist=new list<string>();
        
        for(Document__c d:docList) {
            
            system.debug('d.Type__c'+d.Type__c);
            
            if(docmap2.containsKey(d.Type__c))  {
                
                auditlist.add(docmap2.get(d.Type__c));
                
            }
            
        }
        
        system.debug('auditlist'+auditlist);
        
        return auditlist;
        
    }
    

    @AuraEnabled
    public static List<Document__c> validate(Id recordId) {
        List<Document__c> lst = new List<Document__c>();
        List<Document__c>  docList = [SELECT Id,Type__c From Document__c Where Case__c =: recordId];
        for(Document__c doc :docList){
            lst.add(doc);
        }
        system.debug('doc: ' + lst);
        return docList;
    }
    
    // Method that gets a list of mandatory documents
    @AuraEnabled
    public static List<Mandatory_Doc__mdt> getAllMandatoryDocuments(String Entitytype) {
        List<Mandatory_Doc__mdt> MandatoryDocs = new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype(Entitytype);
        if (MandatoryDocs != null && MandatoryDocs.size() > 0) {
            return MandatoryDocs;
        } else {
            return new List<Mandatory_Doc__mdt>();
        }
    }
    
    
    
    @AuraEnabled
    public static List<String> updateRec(String recordId, String docFlag) {
        List<String> response = new List<String>();
        try {
            Opportunity opp = new Opportunity(Id=recordId, CheckMandatoryDocuments__c = Boolean.valueOf(docFlag));
            system.debug('CheckMandatoryDocuments'+opp.CheckMandatoryDocuments__c);
            update opp;
            response.add('SUCCESS');
            return response;
        } catch(Exception e) {
            response.add('ERROR');
            response.add(String.valueOf(e.getMessage()));
            return response;
        }
        
        
    }
    
    /**
* Method that logs to ECM
*/
    public static ECM_LoginResult_IB_V1 ECMLogin() {
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
        return login;
    }
    
/**
* Method that downloads a document to the desktop
*
* @param documentId
* @return ECM_GetResult_IB_V1.Content.data
*/
    @AuraEnabled
    public static String getDocumentContent(Id documentId) {
        
        System.debug('***DOCUMENT ID: ' + documentId);
        List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);
        
        ECM_LoginResult_IB_V1 login = ECMLogin();
        ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);
        
        if(getResult.Content != null) {
            return getResult.Content.data;
        } else {
            return 'ECM returned no results.';
        }
        
    }
    
}