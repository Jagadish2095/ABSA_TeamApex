/**
* Controller for Compliance View Lightning component
* @author  Kyle Alexander
* @created 2019-02-06
*/
public class ComplianceViewController {
    
    /**
    * Method that gets all Compliance Data
    *
    * @param objectId - opportunity/contact Id
    */
    @AuraEnabled
    public static ComplianceData getMissingData(Id objectId) {
        Boolean isContact = false;
        if(String.valueOf(objectId).substring(0, 3) == '003'){
            isContact = true;
        }
        
        GetRegulatoryCompliance_Resp_IB_v1 compliance;
        List<Contact> contacts;
        List<Opportunity> opportunities;
        
        //Is Contact
        if(isContact){
            contacts = [SELECT Id, ID_Number__c, FICA_Address_Attested__c, Identification_Attested__c, FICA_Address_Attested_Date__c, Identification_Attested_Date__c FROM Contact WHERE Id = :objectId];
            if(contacts.get(0).ID_Number__c != null){
            	compliance = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('SAID', contacts.get(0).ID_Number__c);
            }
            else{
                return null;
            }
        }
        //Else is Opportunity
        else{
            opportunities = new OpportunitiesSelector().selectByOpportunityId(objectId, 1);
            Set<Id> accountIds = new Set<Id>{opportunities.get(0).AccountId};
            List<Account> accounts = new AccountsSelector().selectById(accountIds);
                        
            if(accounts.get(0).CIF__c != null){
                compliance = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('CIF', accounts.get(0).CIF__c);
            }
            else if(accounts.get(0).ID_Number__pc != null){
                compliance = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('SAID', accounts.get(0).ID_Number__pc);
            }
            else{
                return null;
            }
        }
        
        System.debug('compliance: ' + compliance);
        //If compliance service is successful
        if(compliance.statusCode == 200){
            
            ComplianceData data = new ComplianceData();
            //Missing Data
            data.missingData = compliance.content.missingData;
            //Missing Documents
            data.missingDocuments = new String[]{};
            for(GetRegulatoryCompliance_Resp_IB_v1.cls_MissingDocuments docs : compliance.content.missingDocuments){
                data.missingDocuments.add(docs.description);
            }
            //Refreshable Documents
            data.refreshableDocuments = new RefreshableDocuments[]{};
            for(GetRegulatoryCompliance_Resp_IB_v1.cls_RefreshableDocuments docs : compliance.content.refreshableDocuments){
                System.debug('Here:' + docs);
                RefreshableDocuments rd = new RefreshableDocuments();
                rd.source = docs.source;
                rd.lastRefreshDate = docs.lastRefreshDate;
                rd.nextRefreshDate = docs.nextRefreshDate;
                rd.receivedDate = docs.receivedDate;
                if(docs.regType != null){ 
                    rd.description = docs.regType.description;
                }
                rd.uniqueId = docs.uniqueIdInSourceSystem;
                data.refreshableDocuments.add(rd);
            }
            //Reusable Documents 
            data.reusableDocuments = new ReusableDocuments[]{};
            for(GetRegulatoryCompliance_Resp_IB_v1.cls_ReusableDocuments docs : compliance.content.reusableDocuments){
                ReusableDocuments rd = new ReusableDocuments();
                rd.source = docs.source;
                rd.lastRefreshDate = docs.lastRefreshDate;
                rd.nextRefreshDate = docs.nextRefreshDate;
                rd.receivedDate = docs.receivedDate;
                if(docs.regType != null){
                    rd.description = docs.regType.description;
                }
                rd.uniqueId = docs.uniqueIdInSourceSystem;
                data.reusableDocuments.add(rd);
            }
            
            if(isContact){
                data.addressAttested = contacts.get(0).FICA_Address_Attested__c;
            	data.idAttested = contacts.get(0).Identification_Attested__c;
            }
            else{
                data.addressAttested = opportunities.get(0).FICA_Address_Attested__c;
            	data.idAttested = opportunities.get(0).Identification_Attested__c;
            }
            
            return data;
        }
        else{
            return null;
        }
    }
    
    public class ComplianceData{
        
        @AuraEnabled public String[] missingData;
        @AuraEnabled public String[] missingDocuments;
        @AuraEnabled public RefreshableDocuments[] refreshableDocuments;
        @AuraEnabled public ReusableDocuments[] reusableDocuments;
        
        @AuraEnabled public Boolean addressAttested;
        @AuraEnabled public Boolean idAttested;
    }
    
    /**
    * Method that gets all Compliance Data
    *
    * @param objectId - opportunity/contact Id
    */
    @AuraEnabled
    public static String  updateCheckboxes(Id objectId, Boolean addressAttestedCheckbox, Boolean idAttestedCheckbox) {
        Boolean isContact = false;
        if(String.valueOf(objectId).substring(0, 3) == '003'){
            isContact = true;
        }
        
        if(isContact){
            List<Contact> contacts = [SELECT Id, FICA_Address_Attested__c, Identification_Attested__c, FICA_Address_Attested_Date__c, Identification_Attested_Date__c FROM Contact WHERE Id = :objectId];
            
            contacts.get(0).FICA_Address_Attested__c = addressAttestedCheckbox;
            contacts.get(0).Identification_Attested__c = idAttestedCheckbox;
            
            contacts.get(0).FICA_Address_Attested_Date__c = Date.today();
            contacts.get(0).Identification_Attested_Date__c = Date.today();
            
            try{
                update contacts;
                
                return 'Success';
            }
            catch(Exception ex){
                return 'Error:' + ex.getMessage();
            }
        }
        else{
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(objectId, 1);
            
            opportunities.get(0).FICA_Address_Attested__c = addressAttestedCheckbox;
            opportunities.get(0).Identification_Attested__c = idAttestedCheckbox;
            
            opportunities.get(0).FICA_Address_Attested_Date__c = Date.today();
            opportunities.get(0).Identification_Attested_Date__c = Date.today();
            
            try{
                update opportunities;
                
                return 'Success';
            }
            catch(Exception ex){
                return 'Error:' + ex.getMessage();
            }
        }
    }
    
    public class RefreshableDocuments{
        @AuraEnabled public String source;
        @AuraEnabled public String lastRefreshDate;
        @AuraEnabled public String nextRefreshDate;
        @AuraEnabled public String receivedDate;
        @AuraEnabled public String description;
        @AuraEnabled public String uniqueId;
    }
    
    public class ReusableDocuments{
        @AuraEnabled public String source;
        @AuraEnabled public String lastRefreshDate;
        @AuraEnabled public String nextRefreshDate;
        @AuraEnabled public String receivedDate;
        @AuraEnabled public String description;
        @AuraEnabled public String uniqueId;
    }
}