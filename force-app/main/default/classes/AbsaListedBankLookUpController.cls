/**
* This is the Controller Class for the Custom Lookup Componens for the selection Absa Listed Bank Beneficiary
* criteria
*
* @author Lulu Rankwe
* @Date    2020-03-10
*/

public class AbsaListedBankLookUpController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord) {  
        String searchKey = searchKeyWord + '%';     
        
        List < sObject > returnList = new List < sObject > ();
        
        // Created a Dynamic SOQL Query to fetch Absa listed beneficiary bank Names from Lookup object (cut Name LIKE: searchKey and)
        String sQuery =  'Select Id, Name, Beneficiary_Account_Number__c,BranchCode__c From Absa_Listed_Beneficiaries__c Where Name LIKE: searchKey  ORDER BY CreatedDate DESC LIMIT 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords###'+lstOfRecords);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
          
        }
        return returnList;
    }

}