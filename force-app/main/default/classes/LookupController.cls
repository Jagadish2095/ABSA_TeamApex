/**
 * @description This is the Controller Class for the Custom Lookup Component for the selection of sObject records based on search
 * criteria
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-03-11
 * @updated by Himanshu Nimje(Mphatek)
 * @Date    2019-07-23
 */
public class LookupController {
	/**
	 * @description This is a method to fetch all service groups associated with the current user
	 * Added changes against W-005675 dated 11/09/2020 by Humbe
	 * @return  List<String>   The list of service groups associated with the current user.
	 */
	@AuraEnabled
	public static List<string> getUserServiceGroups() {
		Set<Id> userIdSet = new Set<Id>{ Id.valueOf(UserInfo.getUserId()) };
		List<String> userServiceGroupList = new List<String>();
		ServiceGroupUserEntriesSelector userEntries = new ServiceGroupUserEntriesSelector();
		List<Service_Group_User_Entry__c> serviceGroupUserEntry = userEntries.selectByUserId(userIdSet);
		if (serviceGroupUserEntry.isEmpty()) {
			userServiceGroupList.add(StringConstants.BUSINESS_BANKING);
		} else {
			for (Service_Group_User_Entry__c entry : serviceGroupUserEntry) {
				userServiceGroupList.add(entry.Service_Group__r.Name);
			}
		}
		return userServiceGroupList;
	}

	/**
	 * @description This is a method to fetch all sales groups associated with the current user
	 * Added changes against W-012959 dated 15/06/2021 by Chandra
	 * @return  List<String>   The list of sales groups associated with the current user.
	 */
	@AuraEnabled
	public static List<string> getUserSalesGroups() {
		Set<Id> userIdSet = new Set<Id>{ Id.valueOf(UserInfo.getUserId()) };
		List<String> userSalesGroupList = new List<String>();
		SalesGroupUserEntriesSelector userEntries = new SalesGroupUserEntriesSelector();
		List<Sales_Group_User_Entry__c> salesGroupUserEntry = userEntries.selectByUserId(userIdSet);
		if (salesGroupUserEntry.isEmpty()) {
			userSalesGroupList.add(StringConstants.BUSINESS_BANKING);
		} else {
			for (Sales_Group_User_Entry__c entry : salesGroupUserEntry) {
				userSalesGroupList.add(entry.Sales_Group__r.Name);
			}
		}
		return userSalesGroupList;
	}

	/**
	 * @description This is a method to fetch all the lookup values matching a particular search keyword
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param objectName        The object to search in
	 * @param userServiceGroupList        List<String> containing the list of users for a Service Group
	 * @return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<sObject> fetchLookUpValues(String searchKeyWord, String objectName, List<String> userServiceGroupList) {
		List<sObject> lstOfRecords = new List<sObject>();
		List<Service_Group_Type__c> lstOfServiceGroupType = new List<Service_Group_Type__c>();
		switch on objectName {
			when 'Employee__c' {
				lstOfRecords = Database.query(
					'SELECT Id, Name FROM Employee__c WHERE Advisor_Code__c LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\' OR Name LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\'  ORDER BY CreatedDate DESC LIMIT 5'
				);
			}
			when 'Service_Group_Type__c' {
				ServiceGroupTypesSelector serviceGroupSelector = new ServiceGroupTypesSelector();
				lstOfServiceGroupType = serviceGroupSelector.getServiceTypeWithServiceGroupAndServiceLimitInfo(
					true,
					'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%',
					userServiceGroupList
				);
				lstOfRecords = lstOfServiceGroupType;
			}
		}
		return lstOfRecords;
	}

	/**
	 * @description This is a method to fetch all the lookup values matching a particular search keyword
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param objectName        The object to search in
	 * @param userServiceGroupList        List<String> containing the list of users for a Service Group
	 * @return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<sObject> fetchLookUpValuesforOnboarding(String searchKeyWord, String objectName, List<String> userServiceGroupList) {
		List<sObject> returnList = new List<sObject>();
		String sQuery;
		List<sObject> lstOfRecords = new List<sObject>();
		List<Service_Group_Type__c> lstOfServiceGroupType = new List<Service_Group_Type__c>();
		switch on objectName {
			when 'Service_Group_Type__c' {
				ServiceGroupTypesSelector serviceGroupSelector = new ServiceGroupTypesSelector();
				lstOfServiceGroupType = serviceGroupSelector.getServiceTypeWithServiceGroupAndServiceLimitInfoForOnboarding(
					true,
					'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%',
					userServiceGroupList
				);
				lstOfRecords = lstOfServiceGroupType;
			}
		}
		return lstOfRecords;
	}

	/**
	 * @description This is a method to fetch all the lookup values matching a particular search keyword
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param userSalesGroupList        List<String> containing the list of users for a Sales Group
	 * @return List<Sales_Group_Process_Type__c>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<Sales_Group_Process_Type__c> fetchLookUpValuesforSales(String searchKeyWord, List<String> userSalesGroupList) {
		List<Sales_Group_Process_Type__c> lstOfSalesGroupProcessType = new List<Sales_Group_Process_Type__c>();
		SalesGroupProcessTypesSelector salesGroupProcessTypeSelector = new SalesGroupProcessTypesSelector();
		lstOfSalesGroupProcessType = salesGroupProcessTypeSelector.getSalesProcessTypeWithSalesGroup(
			'%' +
			String.escapeSingleQuotes(searchKeyWord) +
			'%',
			userSalesGroupList
		);
		return lstOfSalesGroupProcessType;
	}

	/**
	 * @description This is a method to fetch all the associated sites to a selected adviser
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param objectName        The object to search in
	 * @return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<sObject> fetchSiteValues(String searchKeyWord, String objectName) {
		List<sObject> lstOfRecords = new List<sObject>();
		String sQuery;
		String sRecordTypeId = 'Branch Site';
		switch on objectName {
			when 'Site__c' {
				lstOfRecords = Database.query(
					'SELECT Id, Name , Site_Code__c FROM Site__c WHERE (Site_Code__c LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\' OR Name LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\') AND RecordType.Name LIKE \'%' +
					String.escapeSingleQuotes(sRecordTypeId) +
					'%\'  ORDER BY CreatedDate DESC LIMIT 15'
				);
			}
			when 'Employee__c' {
				lstOfRecords = Database.query(
					'SELECT Id, Name FROM Employee__c WHERE Advisor_Code__c LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\' OR Name LIKE \'%' +
					String.escapeSingleQuotes(searchKeyWord) +
					'%\' ORDER BY CreatedDate DESC LIMIT 5'
				);
			}
		}
		return lstOfRecords;
	}

	/**
	 * @description This is a method to fetch all the branch site code
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @return  List<Absa_Branch_Site_Code__mdt>   The list of Absa_Branch_Site_Code__mdt as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<Absa_Branch_Site_Code__mdt> fetchBranchSiteCodeValues(String searchKeyWord) {
		List<Absa_Branch_Site_Code__mdt> lstOfRecords = new List<Absa_Branch_Site_Code__mdt>();
		lstOfRecords = Database.query(
			'SELECT Id, Site_Code__c, Branch_Name__c FROM Absa_Branch_Site_Code__mdt WHERE Branch_Name__c LIKE \'%' +
			String.escapeSingleQuotes(searchKeyWord) +
			'%\' LIMIT 20'
		);
		return lstOfRecords;
	}

	/**
	 * @description This is a method to fetch all the lookup values matching a particular search keyword
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param ObjectName        The object to search in
	 * @return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<sObject> fetchLookUpFinProductValues(String searchKeyWord, String ObjectName) {
		List<sObject> lstOfRecords = new List<sObject>();
		lstOfRecords = Database.query(
			'SELECT  Name FROM ' +
			String.escapeSingleQuotes(ObjectName) +
			' WHERE Name LIKE \'%' +
			String.escapeSingleQuotes(searchKeyWord) +
			'%\'ORDER BY createdDate DESC LIMIT 5'
		);
		return lstOfRecords;
	}

	/**
	 * Added by Diksha
	 * @description This is a method to fetch all the lookup values matching a particular search keyword
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @param ObjectName        The object to search in
	 * @return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<sObject> fetchLookUpProductValues(String searchKeyWord, String ObjectName) {
		List<sObject> lstOfRecords = new List<sObject>();
		lstOfRecords = Database.query(
			'SELECT  Name FROM ' +
			String.escapeSingleQuotes(ObjectName) +
			' WHERE IsActive = true AND Name LIKE \'%' +
			String.escapeSingleQuotes(searchKeyWord) +
			'%\'ORDER BY createdDate DESC LIMIT 5'
		);
		return lstOfRecords;
	}

	/**
	 * @description This is a method to fetch all the franchise site code
	 *
	 * @param searchKeyWord     The search key word to look for
	 * @return  List<ABSA_Franchise_Code__mdt>   The list of ABSA_Franchise_Code__mdt as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<ABSA_Franchise_Code__mdt> fetchFranchiserCodeValues(String searchKeyWord) {
		String searchKey = '%' + searchKeyWord + '%';
		List<ABSA_Franchise_Code__mdt> returnList = new List<ABSA_Franchise_Code__mdt>();

		String sQuery =
			'SELECT Id, Franchise_Code__c FROM ABSA_Franchise_Code__mdt WHERE Franchise_Code__c LIKE \'' +
			String.escapeSingleQuotes(searchKey) +
			'\' LIMIT 3';

		List<ABSA_Franchise_Code__mdt> lstOfRecords = Database.query(sQuery);

		if (!lstOfRecords.isEmpty()) {
			for (ABSA_Franchise_Code__mdt FranchiseCode : lstOfRecords) {
				returnList.add(FranchiseCode);
			}
		}
		return returnList;
	}
	
}