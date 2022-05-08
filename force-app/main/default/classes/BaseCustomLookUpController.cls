/**
 * @author		Nelson Chisoko
 * @description	Used for fetching a record list from the appropriate sObject
 * @date		17/12/2020
 **/
public class BaseCustomLookUpController {
    
    /**
     * @description	Returns a list of sObject records matching the sObject name specified, as well as matching the search keyword provided 
     * @param		searchKeyWord	The search keyword
     * @param		objectName		The sObject's name
     * @return		List<sObject>	A list of sObject records
     **/
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String objectName) {
        
        String searchKey = '%' + searchKeyWord + '%';        
        List<sObject> returnList = new List<sObject>();
      
        String sQuery =  'SELECT Id, Name FROM ' + objectName + ' WHERE Name LIKE: searchKey ORDER BY CreatedDate DESC LIMIT 5';
        List<sObject> listOfRecords = Database.query(sQuery);
        
        for (sObject sObj: listOfRecords) {
            
            returnList.add(sObj);
            
        }
        
        return returnList;
        
    }

}