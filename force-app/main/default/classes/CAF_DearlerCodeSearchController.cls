/**
*@description  Apex Enterprise Design Patters
* Application_Product_CAF__c objects
* @description DealerCode
* @author  Rajesh
* @since   04/30/2021
*/

public class CAF_DearlerCodeSearchController {
  /**
*@description  Apex Enterprise Design Patters
* @return : returnList
* @param searchKeyWord
* @param ObjectName
*/
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%'+searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String accType = 'Dealer';
        //String sQuery =  'select id, Name,Franchise_Code__c,Trading_Name__c,ShippingStreet,ShippingCity from ' +ObjectName + ' where (Name LIKE: searchKey OR Franchise_Code__c LIKE: searchKey) AND Type =: accType order by createdDate DESC limit 5';
        String sQuery =  'select id, Name,Franchise_Code__c,ShippingStreet,ShippingCity from ' +String.escapeSingleQuotes(ObjectName) + ' where (Name LIKE: searchKey OR Franchise_Code__c LIKE: searchKey) AND Type =: accType order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}