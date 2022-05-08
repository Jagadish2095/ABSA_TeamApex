public class dependentCustomLookUpController {

    @AuraEnabled
    public static List < sObject > fetchDependentLookUpValues(String branchSearch,String bankName) {
        
        // Get recordTypeId for Branch record type
        Id  bankRecordTypeId = Schema.SObjectType.Lookup__c.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        Id  branchRecordTypeId = Schema.SObjectType.Lookup__c.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        
        Id bankId;
        String searchByBankName = bankName ;
        String searchKey = '%'+ branchSearch + '%';
        
        
        List<sobject> lstOfBankIds = [Select Id from Lookup__c where RecordTypeId=:bankRecordTypeId and Name=:searchByBankName limit 1];
        bankId=lstOfBankIds[0].Id;
        
  
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Branch Record List from bankId
        String sQuery =  'SELECT Id, Name, Bank__c, Branch_Code__c, RecordTypeId FROM Lookup__c where Name LIKE: searchKey and RecordTypeId=\''+ branchRecordTypeId + '\' and bank__c= \''+ bankId + '\' order by createdDate DESC LIMIT 8 ';
		
        
        List < sObject > lstOfRecords = Database.query(sQuery);
 
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
       
        return returnList;
    }   
    
}