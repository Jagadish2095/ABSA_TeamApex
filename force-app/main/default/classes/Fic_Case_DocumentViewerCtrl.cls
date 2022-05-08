/**
*
* @author  updated by Nikolay Kibalov
* @since   2021-05-10
* @description : Fic_Case_DocumentViewerCtrl
**/
public with sharing class Fic_Case_DocumentViewerCtrl {
    /**
* @description  : get contest
*@comment : get Content Documents from a related case
*@return list of content documents
*@param dHAcertName
**/
    
    public static List<ContentVersion> getContents(string dHAcertName) {
        
        List<ContentVersion> entries = new List<ContentVersion>();
        if(ContentVersion.SObjectType.getDescribe().isAccessible()) {
            entries = [SELECT Id, Title, FileType FROM ContentVersion WHERE Title=:dHAcertName];
        } else{
            return null;
        }
        return entries;
    }
   
    /**
*@description  : get Document 
*@comment : get Documents from a related case and document type
*@return list of  documents 
*@param caseId
**/
    @AuraEnabled
    public static List<Document__c> getdocumentS(Id caseId){
        list<Document__c>LstDoc=new list<Document__c>();
        if(Document__c.SObjectType.getDescribe().isAccessible()) {
           LstDoc=[select id, name,Type__c,Account__c,Reference__c,File_Id__c,ContentVersionID__c,ConfidenceLevel__c,Fic_Document_No_Consent_Reason__c,Is_Fic_Document_Consent__c from Document__c where Case__c=:caseId];
        }
        return LstDoc;
    }
    
      /**
*@description  : get Document 
*@comment : get Documents from a related case and document type
*@return list of  documents 
*@param docId
**/
    @AuraEnabled
    public static List<Document__c> specificDoc(Id docId){
        list<Document__c>LstDoc=new list<Document__c>();
        if(Document__c.SObjectType.getDescribe().isAccessible()) {
           LstDoc=[select id, name,Type__c,Account__c,Reference__c,ContentVersionID__c,ConfidenceLevel__c,File_Id__c,Fic_Document_No_Consent_Reason__c,Is_Fic_Document_Consent__c from Document__c where id=:docId];
        }
        return LstDoc;
    }
      /**
    * @description
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
    * @param docId
    * @return String
    **/
    @AuraEnabled
    public static String getDocumentContent(String docId){
        return DocumentController.getDocumentContent(docId);
    }
    
     /**
    * @description : getcase
              *@comment : Get Case
              *@return listCases
              *@param caseId
      **/
    @AuraEnabled
    public static boolean isAOL(String caseId) {
        List<Case> listCases = new List<Case>();
        if(Case.SObjectType.getDescribe().isAccessible()) {
             listCases = [SELECT Id , Origin , Case_Record_Type_Name__c FROM Case WHERE Id = :caseId];
        } 
        if (!listCases.isEmpty()) {
            if(listCases[0].Origin == 'AOL' || listCases[0].Origin == 'DSP'){
                return true;
            }
        } 
        return false;
    }
}