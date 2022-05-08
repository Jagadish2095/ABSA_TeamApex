/**
 * @description Apex Controller for Smart Search Aura component
 * @author  Simangaliso Mathenjwa : Absa
 * @version v1.0
 * @since   01 March 2021
 */
public without sharing class SmartSearchController {
	/**
	 * @description Method to search based on input
	 * @param  searchKeyword
	 * @param  queryString
	 * @return returnList
	 */
	@AuraEnabled
	public static List<sObject> fetchMatchingLookupRecord(String searchKeyword, String queryString) {
		String searchValue = '%' + searchKeyword + '%';
		List<sObject> returnList = new List<sObject>();

		try {
			List<sObject> listOfRecords = Database.query(queryString); //execute query
			//loop through the returned list
			for (sObject currentObject : listOfRecords) {
				returnList.add(currentObject);
			}
		} catch (Exception ex) {
			system.debug(LoggingLevel.FINE, 'fetchMatchingLookupRecord Error:' + ex);
		}

		return returnList;
	}

	/**
	 * @description Method to get a query string from custom metadata
	 * @param  lookupSearchVal
	 * @return query
	 */
	@AuraEnabled
	public static String getQueryString(String lookupSearchVal) {
		String query;

		List<Lookup_Search_Field_Query__mdt> lookupQueries = new LookupSearchFieldQuerySelector().selectByLabel(lookupSearchVal);

		if (lookupQueries.size() > 0) {
			query = lookupQueries[0].Query_String__c;
		}

		return query;
	}
}