/*--
* Apex Controller for LookupField Aura component 
*
* @author  Simangaliso Mathenjwa : Absa
* @version v1.0
* @since   04 June 2020
*
*/

public with sharing class LookUpFieldController {
    
    @AuraEnabled
    public static List<sObject> fetchMatchingLookupRecord(String search_keywordP, String query_string){
        
        String search_value =  '%'+ search_keywordP + '%';                
        List<sObject> returnList = new List<sObject>();        
        
        try{
            List< sObject > list_of_record = Database.query(query_string);           //execute query
            //loop through the returned list
            for( sObject current_object : list_of_record ){
                returnList.add( current_object ); 
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE, 'fetchMatchingLookupRecord Error:'+ex);
        }
        
        return returnList;
        
    }//end of function definition
    
    /*
    * 15/07/2020 - Koketso Mpshane - Method to get a query string from custom metadata
    * @param String lookupSearchVal
    */
    @AuraEnabled
    public static String getQueryString(String lookupSearchVal) {
        
        String query;
        
        List<Lookup_Search_Field_Query__mdt> lookupQueries = new LookupSearchFieldQuerySelector().selectByLabel(lookupSearchVal);
        
        if(lookupQueries.size() > 0){
            query = lookupQueries[0].Query_String__c;
        }
        
        return query;
    }

}//end of class definition