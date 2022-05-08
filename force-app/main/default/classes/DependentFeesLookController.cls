public class DependentFeesLookController {
    
    @AuraEnabled
    public static List < sObject > fetchDependentLookUpValues(String transactionType,String product) {
   
        String searchByProduct = product;
        String searchKey = '%'+ transactionType + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Transaction Type Record List from bankId
        
        String sQuery = 'SELECT Id, Name,Product_Id__c,GL_Account_Number__c,Statement_Narrative__c,Transaction_Group__c,Reason_Group_Name__c,Is_Vatable__c,Transaction_Type_Class__c FROM Refund_Transaction_Type__c where Name LIKE: searchKey and Product_Id__c=\''+ searchByProduct + '\' order by createdDate DESC LIMIT 5 ';
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('returnList ' + returnList);
        return returnList;
    } 
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String reasonGroup,String reason) {
        
        String searchByReasonGroup= reasonGroup;
        String searchKey = '%'+ reason + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Transaction Type Record List from bankId
        
        String sQuery = 'SELECT Id, Name,Category__c,Reason_Group_Name__c FROM Refund_Reason__c where Name LIKE: searchKey and Reason_Group_Name__c=\''+ searchByReasonGroup + '\'  LIMIT 1 ';
                
        //String sQuery = 'SELECT Statement_Narrative__c,Transaction_Group__c,Reason_Group_Name__c,Is_Vatable__c,Transaction_Type_Class__c FROM Refund_Transaction_Type__c where Name LIKE: searchKey and Product__c=\''+ searchByProduct + '\' order by createdDate DESC LIMIT 5 ';
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('returnList ' + returnList);
        return returnList;
    } 
    

}