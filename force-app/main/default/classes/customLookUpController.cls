public class customLookUpController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord) {
        Id  bankRecordTypeId = Schema.SObjectType.Lookup__c.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        String searchKey = searchKeyWord + '%';     
        
        List < sObject > returnList = new List < sObject > ();
        
        // Created a Dynamic SOQL Query to fetch bank Names from Lookup object (cut Name LIKE: searchKey and)
        String sQuery =  'Select id,RecordTypeId,Name from Lookup__c where Name LIKE: searchKey and RecordTypeId =\''+ bankRecordTypeId + '\' order by Name LIMIT 8 ';
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords###'+lstOfRecords);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}