/** 
* @description - ManualRefreshController for FIC Manual User Refresh
* @author  Saiteja : ABSA
* @version v1.0
* @since   2021-02-24
* @W-008750
**/


public with sharing class ManualRefreshController {
    /**
* @description - Method that to get Account data.
* @param objectId accountId
* @return - Account data
**/
    
    @AuraEnabled
    public static ClientData getData(Id objectId) {
        
        List<Address__c> clientAddr;
        List<Application_Product__c> clientProdInfo;
        ClientData data = new ClientData();
        Account clientInfo = new AccountsSelector().selectAllById(objectId);
        data.clientAcc = clientInfo;
        clientAddr = new AddressesSelector().addressesRelatedToAcc(objectId);
        data.clientAccAddr = clientAddr;
        clientProdInfo = new ApplicationProductSelector().applicationProdRelatedToAcc(objectId);
        data.clientProd = clientProdInfo;
        return data;   
        
    }
    /**
* @description - Method that to get Picklist Values 
* @param objDetail Account 
* @param contrfieldApiName
* @param depfieldApiName
* @param cltGrpfieldApiName
* @return - Wrapper 
**/
    
    @AuraEnabled
    public static fetchPicklistData getDependentMap(sObject objDetail, String contrfieldApiName,String depfieldApiName,String cltGrpfieldApiName) {
        
        fetchPicklistData picklstData = new fetchPicklistData();
        
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        String clientGrpField = cltGrpfieldApiName.toLowerCase();
        
        List < String > allOpts = new list < String > ();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType(); 
        if (objType==null){
            picklstData.ctrldepdt = objResults;
            return picklstData ;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField) || !objFieldMap.containsKey(clientGrpField)){
            picklstData.ctrldepdt = objResults;
            return picklstData ;      
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        Schema.SObjectField cltGrpField = objFieldMap.get(clientGrpField);
        
        List<Schema.PicklistEntry> cltGrpEntries = cltGrpField.getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry a: cltGrpEntries) {
            allOpts.add(a.getValue());
        }
        
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        
        picklstData.ctrldepdt = objResults;
        picklstData.clientGrp = allOpts;
        return picklstData;
    }
    /**
    * @description - Method to convert decimal to binary
    * @param val
    * @return bits 
    **/
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
     /**
    * @description - Method to convert base64 to bits
    * @param validFor
    * @return bits 
    **/
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    //base64Chars
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
     /**
    * @description - Method to deserialize
    * @param PLEs
    * @return  list of PicklistEntries
    **/
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
     /**
    * @description - Wrapper class to get account data
    **/
    
    public class ClientData{
        @AuraEnabled
        public Account clientAcc;
        @AuraEnabled
        public List<Address__c> clientAccAddr;
        @AuraEnabled
        public List<Application_Product__c> clientProd;
        @AuraEnabled
        public Map<String,Risk_Rating__mdt> riskRating;
    }
     /**
    * @description - Wrapper class to get picklist data
    **/
    public class fetchPicklistData{
        @AuraEnabled
        public Map<String, List<String>> ctrldepdt;
        @AuraEnabled
        public List<String> clientGrp;
    }
    /**
    * @description - Wrapper class to get EntryWrapper data.
    **/
    public class PicklistEntryWrapper{
            /**
        * @description - Method for active 
        **/ 
        public String active {get;set;}
        /**
    * @description - Method for defaultValue .
    **/
        public String defaultValue {get;set;}
        /**
    * @description - Method for label .
    **/
        public String label {get;set;}
        /**
    * @description - Method for value .
    **/
        public String value {get;set;}
        /**
    * @description - Method for validFor .
    **/
        public String validFor {get;set;}
        /**
    * @description -
    **/
        public PicklistEntryWrapper(){}           
    }
    
     /**
    * @description - Method to generate Document
    * @param accountId
    * @param templateName
    * @return Document 
    **/
    @AuraEnabled
    public static List<Document__c> attDocument(Id accountId, String templateName) {
        return GenerateAttestationDocument.generateAttestation(accountId,templateName);
    }
    /**
    * @description - Method to Download Document
    * @param documentId
    * @return DocumentId
    **/
    @AuraEnabled
    public static String getDocContent(String documentId){
        return DocumentManagementControler.getDocumentContent(documentId);
    }
     /**
    * @description - Method to get Uploaded Document
    * @param accountId
    * @return Document
    **/
    @AuraEnabled
    public static List<Document__c> getdocuments(Id accountId){
       // List<Document__c> docList =  new DocumentsSelector().selectByAccountId(accountId);
          List<Document__c> docList = [select Id,Name,Reference__c,Signed__c,Document_Status__c,Owner.Name,
                                         CreatedDate,Account__r.Name from Document__c
                                         where Account__c  =:accountId order by CreatedDate desc limit 1 ]; 
        
        
        system.debug('docList' + docList);
        return docList;
    }
     /**
    * @description - Method to get RelatedParties- UBO Structure
    * @param accountId
    * @return wrapper of relatedparties data
    **/
    @AuraEnabled
    public static String getRelatedParties(Id accountId) {
        String relatedPartiesJSON;
        relatedPartiesJSON = OnboardingUBOListViewController.getRelatedParties(accountId);
        return relatedPartiesJSON;
        
    }
    
    
   
}