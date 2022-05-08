/**
 * Apex controller class for the Aura bundle LeadOverride.
 *
 * @author  Tracy de Bruin : CloudSmiths
 * @since   2019-01-30
 *
 **/
/**
 * @description LeadoverrideController Description
 *
 */

public class LeadOverrideController {
	private static final String QUEUE_DD_INBOUND_NON_ADVICE_NAME = 'DD Non-Advice Inbound';
	private static final String QUEUE_DD_INBOUND_REFERRAL_ADVICE_STI_NAME = 'DD_Referral_Advice_STI';
	private static final String LEAD_STATUS_ALLOCATED = 'Allocated';
	private static final String DD_LEAD_REC_TYPE_DEV_NAME = 'Direct_Delivery_Sales_Lead';
	private static final String STI_LEAD_REC_TYPE_DEV_NAME = 'DD_STI_Lead';
	private static final String VA_LEAD_REC_TYPE_DEV_NAME = 'Virtual_Advisor_Lead';
	private static final String FINANCIAL_PRODUCT_CODE_STI = 'STI';
	//Added By Divya
	private static final String Investment_Banking_Lead_NAME = 'Investment_Lead';
	private static final String Investment_Opp_Name = 'Investment_Opportunity';
	/**
	 * @description Exception
	 */
	public class oppException extends Exception {
	}

	/**
	 * @description createLead description
	 *
	 * @param newLeadRecord (Lead): newLeadRecord
	 * @param relatedClient (Account): relatedClient
	 * @param financialProductRecord (Financial_Product__c): financialProductRecord
	 * @param preferredSiteRecord (Site__c): preferredSiteRecord
	 * @param useLeadAssignmentRule (Boolean): useLeadAssignmentRule
	 * @return Return String: Return description
	 */
	@AuraEnabled
	public static String createLead(
		Lead newLeadRecord,
		Account relatedClient,
		Financial_Product__c financialProductRecord,
		Site__c preferredSiteRecord,
		Boolean useLeadAssignmentRule
	) {
		String leadId = null;
		Account clientRecord = new Account();
		map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Set<Id> financialProductIdSet = new Set<Id>();
		List<Financial_Product__c> financialProductList = new List<Financial_Product__c>();
		//System.debug('Lead Details'+newLeadRecord);
		try {
			if (newLeadRecord != null) {
				//Assign using Active Assignment Rules?
				if (useLeadAssignmentRule == true) {
					//Fetching the assignment rules on Lead
					List<AssignmentRule> assignmentRuleLst = new AssignmentRulesSelector().selectByActiveSoBjectType('Lead', 1);

					//Creating the DMLOptions for "Assign using active assignment rules" checkbox
					if (assignmentRuleLst != null && assignmentRuleLst.size() > 0) {
						Database.DMLOptions dmlOpts = new Database.DMLOptions();
						dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRuleLst[0].id;

						newLeadRecord.setOptions(dmlOpts);
					}
				}

				if (preferredSiteRecord != null) {
					newLeadRecord.Preferred_Site__c = preferredSiteRecord.Id;
				}

				//Product Interest
				if (financialProductRecord != null && financialProductRecord.Id != null) {
					newLeadRecord.Financial_Product__c = financialProductRecord.Id;
					financialProductIdSet.add(financialProductRecord.Id);
					financialProductList = new FinancialProductsSelector().selectById(financialProductIdSet);
				}

				// System.debug('###financialProductList : ' + financialProductList);
				//Set Lead record type based on Financial_Product.Business_Unit
				if (financialProductList != null && financialProductList.size() > 0) {
					if (financialProductList[0].Business_Unit__c == 'WIMI') {
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('WIMI_Lead').getRecordTypeId();
					} else if (financialProductList[0].Business_Unit__c == 'Individual Banking') {
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Individual_Banking').getRecordTypeId();
					} else if (financialProductList[0].Business_Unit__c == 'Stockbroking') {
						// Addded By Rajesh
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Stockbroker_Lead').getRecordTypeId();
					} else if (financialProductList[0].Business_Unit__c == 'VSTI') {
						// Addded By Litha
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Virtual_STI_Lead').getRecordTypeId();
					} else if (financialProductList[0].Business_Unit__c == 'STI - CAF') {
						// Added By Poornima
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('STI_Lead').getRecordTypeId();
					} else if (financialProductList[0].Business_Unit__c == 'Virtual Advisor') {
						//Added By Divya
						//Added By Divya
						//Assign Lead to Advisor Group queue
						List<Group> queuerec = [SELECT Id, Type, Name FROM Group WHERE Type = 'Queue' AND Name = 'Advisor queue - Virtual'];
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get(Investment_Banking_Lead_NAME).getRecordTypeId();
						newLeadRecord.External_Reference_Number__c = 'Investment';
						if (queuerec.size() > 0) {
							newLeadRecord.OwnerId = queuerec[0].Id;
						}
					} else {
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Idirect').getRecordTypeId();
						newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Business_Bank_Lead').getRecordTypeId();
					}
				} else {
					newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Personal_Lines').getRecordTypeId();
					//If no Business Unit defined - default to Business Banking Lead
					newLeadRecord.RecordTypeId = leadRecordTypeMap.get('Business_Bank_Lead').getRecordTypeId();
				}

				//Call method in ClientFinderUtilities class to create/search for Client in Salesforce

				/*clientRecord = ClientFinderUtilities.findOrCreateClient(relatedClient);

System.debug('clientRecord : ' + clientRecord);

if(clientRecord != null) {
newLeadRecord.FinServ__RelatedAccount__c = clientRecord.id;
}*/

				//Call method in AccountCreate_CIF_MDM to create/update Client in Salesforce
				AccountCreate_CIF_MDM.GIPResponse createdAccount;
				if (relatedClient.CIF__c != null) {
					createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(relatedClient.CIF__c, '0', '009970');
					// System.debug('NEW createdAccount from CIF key: ' + createdAccount.accountId);
				} else if (relatedClient.ID_Number__pc != null && relatedClient.ID_Type__pc == 'SA Identity Document') {
					createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('SAID', relatedClient.ID_Number__pc);
					// System.debug('NEW createdAccount from ID number: ' + createdAccount.accountId);
				} /*else{
System.debug('No CIF key or ID number found - ' + relatedClient.FirstName + ' ' + relatedClient.LastName);
throw new AuraHandledException('No CIF key or ID number found - ' + relatedClient.FirstName + ' ' + relatedClient.LastName); 
}*/
				if (createdAccount != null) {
					newLeadRecord.FinServ__RelatedAccount__c = createdAccount.accountId;
				}
				//system.debug('lead record==>'+ JSON.serialize(newLeadRecord));
				//Insert Lead
				if (string.isBlank(newLeadRecord.OwnerId)) {
					newLeadRecord.OwnerId = userinfo.getUserId();
				}
				insert newLeadRecord;

				leadId = newLeadRecord.Id;
			}
		} catch (DmlException ex) {
			// System.debug('There was an error creating the Lead - ' + ex.getMessage());

			//Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
			String msg = '';
			//Get All DML Messages
			for (Integer i = 0; i < ex.getNumDml(); i++) {
				//Get Validation Rule & Trigger Error Messages
				msg = +ex.getDmlMessage(i) + '\n';
			}
			//throw DML exception message
			throw new AuraHandledException(msg);
		} catch (Exception ex) {
			//throw all other exception message
			//System.debug('There was an error creating the Lead - ' + ex.getMessage());
			throw new AuraHandledException(ex.getMessage());
		}

		return leadId;
	}

	/**
	 * @description findFinancialProduct description
	 *
	 * @param financialProductId (String): financialProductId
	 * @return Return Financial_Product__c: Return description
	 */
	@AuraEnabled
	public static Financial_Product__c findFinancialProduct(String financialProductId) {
		// System.debug('###financialProductId : ' + financialProductId);
		//Add Id to a Set
		Set<Id> financialProductIds = new Set<Id>();
		financialProductIds.add(financialProductId);
		List<Financial_Product__c> financialProductList = [
			SELECT Id, Name, Business_Unit__c, CurrencyIsoCode
			FROM Financial_Product__c
			WHERE Id IN :financialProductIds
		]; //new FinancialProductsSelector().selectById(financialProductIds);

		// System.debug('###financialProductList : ' + financialProductList);

		if (financialProductList.size() > 0) {
			return financialProductList[0];
		} else {
			return null;
		}
	}

	/**
	 * @description MyPickListInfo Description
	 *
	 */
	public class MyPickListInfo {
		public String validFor;
	}
	/**
	 *@description getFieldDependencies description
	 *
	 * @param objectName (sObject): objectName
	 * @param controllingField (String): controllingField
	 * @param dependentField (String): dependentField
	 * @return Return Map<String,List<String>>: Return description
	 */
	@AuraEnabled
	public static Map<String, List<String>> getFieldDependencies(sObject objectName, String controllingField, String dependentField) {
		Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

		Schema.SObjectType objType = objectName.getSObjectType();
		Schema.DescribeSObjectResult describeResult = objType.getDescribe();
		Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
		Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
		List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
		List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
		for (Schema.PicklistEntry currControllingValue : controllingValues) {
			//  System.debug('ControllingField: Label:' + currControllingValue.getLabel());
			controllingInfo.put(currControllingValue.getLabel(), new List<String>());
		}
		for (Schema.PicklistEntry currDependentValue : dependentValues) {
			String jsonString = JSON.serialize(currDependentValue);
			MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
			String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
			// System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);
			Integer baseCount = 0;
			for (Integer curr : hexString.getChars()) {
				Integer val = 0;
				if (curr >= 65)
					val = curr - 65 + 10;
				else
					val = curr - 48;
				if ((val & 8) == 8) {
					/* System.debug(
                        'Dependent Field: ' +
                        currDependentValue.getLabel() +
                        ' Partof ControllingField:' +
                        controllingValues[baseCount + 0].getLabel()
                    );*/
					controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
				}
				if ((val & 4) == 4) {
					/*  System.debug(
                        'Dependent Field: ' +
                        currDependentValue.getLabel() +
                        ' Partof ControllingField:' +
                        controllingValues[baseCount + 1].getLabel()
                    );*/
					controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());
				}
				if ((val & 2) == 2) {
					/*  System.debug(
                        'Dependent Field: ' +
                        currDependentValue.getLabel() +
                        ' Partof ControllingField:' +
                        controllingValues[baseCount + 2].getLabel()
                    ); */
					controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());
				}
				if ((val & 1) == 1) {
					/*  System.debug(
                        'Dependent Field: ' +
                        currDependentValue.getLabel() +
                        ' Partof ControllingField:' +
                        controllingValues[baseCount + 3].getLabel()
                    );*/
					controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());
				}
				baseCount += 4;
			}
		}
		//System.debug('ControllingInfo: ' + controllingInfo);
		return controllingInfo;
	}

	/**
	 * @description findSite description
	 *
	 * @param siteId (String): siteId
	 * @return Return Site__c: Return description
	 */
	@AuraEnabled
	public static Site__c findSite(String siteId) {
		// System.debug('###siteId : ' + siteId);
		//Add Id to a Set
		Set<Id> siteIds = new Set<Id>();
		siteIds.add(siteId);
		List<Site__c> sitesList = new SitesSelector().selectById(siteIds);

		// System.debug('###sitesList : ' + sitesList);

		if (sitesList.size() > 0) {
			return sitesList[0];
		} else {
			return null;
		}
	}
	/**
	 * @description createNewRetailLead description
	 *
	 * @param leadRecord (Lead): leadRecord
	 * @param accountRecord (Account): accountRecord
	 * @param productInterestList (List<Product_Interest__c>): productInterestList
	 * @param serviceGroupRecord (Service_Group__c): serviceGroupRecord
	 * @param routeLead (Boolean): routeLead
	 * @return Return String: Return description
	 */
	@AuraEnabled
	public static String createNewRetailLead(
		Lead leadRecord,
		Account accountRecord,
		List<Product_Interest__c> productInterestList,
		Service_Group__c serviceGroupRecord,
		Boolean routeLead
	) {
		// system.debug(LoggingLevel.FINE, '***LeadAccount:***' + accountRecord);

		Lead newLead = new Lead();

		List<Product_Interest__c> interestedProducts = new List<Product_Interest__c>();
		Set<Product_Interest__c> productInterestSet = new Set<Product_Interest__c>();
		List<Product_Interest__c> uniqueProducts = new List<Product_Interest__c>();

		productInterestSet.addAll(productInterestList);
		uniqueProducts.addAll(productInterestSet);

		// system.debug(LoggingLevel.FINE, 'uniqueProducts:' + uniqueProducts);

		Id leadId = null;

		if (leadRecord != null) {
			try {
				newLead = leadRecord;

				if (serviceGroupRecord != null) {
					if (String.isBlank(serviceGroupRecord.Id)) {
						List<Service_Group__c> sGroupList = getLoggedInUserServiceGroups();

						if (sGroupList != null) {
							serviceGroupRecord = sGroupList[0];
						} else {
							return 'No Service Group Found';
						}
					}

					newLead.sd_Service_Group_Id__c = serviceGroupRecord.Id;
					newLead.sd_Service_Group__c = serviceGroupRecord.Name;
					newLead.sd_Original_Service_Group__c = serviceGroupRecord.Name;
					newLead.sd_Original_Service_Queue__c = serviceGroupRecord.Queue__c;
					newLead.Business_Hours__c = serviceGroupRecord.Business_Hours__c;
					newLead.sd_Response_Email_Address__c = serviceGroupRecord.Response_Email_Address__c;
					newLead.sd_Email_Template_Lead_Creation__c = serviceGroupRecord.Email_Template_Lead_Creation__c;
					newLead.Internal_SLA_Notification_User__c = serviceGroupRecord.Internal_SLA_Notification_User__c;
					newLead.Manager__c = serviceGroupRecord.Manager__c;
					newLead.Non_IB_Regional_Manager__c = serviceGroupRecord.Internal_SLA_Notification_User__c;

					//External Sales
					//TODO : Remove profile 'System Administrator (Custom)' ONLY for testing
					Profile p = new ProfilesSelector().selectByLoggedInUser();

					if (
						p.Name == 'Standard User (External Sales - B2B)' ||
						p.Name == 'Standard User (External Sales - B2C)' ||
						p.Name == 'System Administrator (Custom)' ||
						newLead.Lead_Type__c == 'External Sales (B2C and B2B)'
					) {
						Set<Id> svrGrpSet = new Set<Id>();
						svrGrpSet.add(serviceGroupRecord.Id);

						List<Service_Group_Type__c> serviceGroupList = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(svrGrpSet);

						if (serviceGroupList.size() > 0) {
							newLead.Lead_Type__c = 'External Sales (B2C and B2B)';
							newLead.Business_Hours__c = serviceGroupList[0].Service_Group__r.Business_Hours__c;

							newLead.sd_Internal_SLA_Time_Measure__c = serviceGroupList[0].Service_Group__r.Internal_SLA_Time_Measure__c;
							newLead.sd_Internal_SLA_Units__c = serviceGroupList[0].Service_Group__r.Internal_SLA_Units__c;

							newLead.sd_External_SLA_Time_Measure__c = serviceGroupList[0].Service_Level__r.External_SLA_Time_Measure__c;
							newLead.sd_External_SLA_Units__c = serviceGroupList[0].Service_Level__r.External_SLA_Units__c;

							if (
								newLead.sd_Internal_SLA_Time_Measure__c != null &&
								newLead.sd_Internal_SLA_Units__c != null &&
								newLead.Business_Hours__c != null
							) {
								Map<String, DateTime> internalSLA = calculateSLADateTime(
									System.now(),
									newLead.Business_Hours__c,
									newLead.sd_Internal_SLA_Time_Measure__c,
									Integer.valueOf(newLead.sd_Internal_SLA_Units__c)
								);

								newLead.Internal_SLA_Warning_Date__c = internalSLA.get('slaWarningDate');
								newLead.Internal_SLA_End_Date__c = internalSLA.get('slaEndDate');
							}

							if (
								newLead.sd_External_SLA_Time_Measure__c != null &&
								newLead.sd_External_SLA_Units__c != null &&
								newLead.Business_Hours__c != null
							) {
								Map<String, DateTime> externalSLA = calculateSLADateTime(
									System.now(),
									newLead.Business_Hours__c,
									newLead.sd_External_SLA_Time_Measure__c,
									Integer.valueOf(newLead.sd_External_SLA_Units__c)
								);

								newLead.External_SLA_Warning_Date__c = externalSLA.get('slaWarningDate');
								newLead.External_SLA_End_Date__c = externalSLA.get('slaEndDate');
							}
						}
					}
					//

					Set<Id> sGroupIdSet = new Set<Id>();
					sGroupIdSet.add(serviceGroupRecord.Id);

					List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(sGroupIdSet);
					//system.debug(LoggingLevel.FINE, 'serviceGroupTypes:' + serviceGroupTypes.isEmpty());

					if (!serviceGroupTypes.isEmpty()) {
						newLead.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
						newLead.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].Id;
						newLead.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
						newLead.IB_Regional_Manager__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
					}

					if (routeLead) {
						if (serviceGroupRecord.Queue__c != null) {
							List<Group> leadQueues = [SELECT Id, Name, DeveloperName FROM Group WHERE Name = :serviceGroupRecord.Queue__c AND Type = :'Queue'];
							// system.debug(LoggingLevel.FINE, 'leadQueues:' + leadQueues);
							if (leadQueues.size() > 0) {
								newLead.OwnerId = leadQueues[0].Id;
							}
						}
						newLead.Status = 'Unallocated';
					} else {
						newLead.Status = 'Allocated';
						newLead.Allocated_Time__c = system.now();
					}

					if (uniqueProducts.size() > 0) {
						if (uniqueProducts[0].Financial_Product__c != null && String.isNotBlank(uniqueProducts[0].Financial_Product__c)) {
							newLead.Product_Interest_1__c = uniqueProducts[0].Financial_Product__c;
							//Set Financial Product if empty
							if (newLead.Financial_Product__c == null) {
								newLead.Financial_Product__c = uniqueProducts[0].Financial_Product__c;
							}
						}
						if (uniqueProducts.size() > 1) {
							if (uniqueProducts[1].Financial_Product__c != null && String.isNotBlank(uniqueProducts[1].Financial_Product__c)) {
								newLead.Product_Interest_2__c = uniqueProducts[1].Financial_Product__c;
							}
						}
						if (uniqueProducts.size() > 2) {
							if (uniqueProducts[2].Financial_Product__c != null && String.isNotBlank(uniqueProducts[2].Financial_Product__c)) {
								newLead.Product_Interest_3__c = uniqueProducts[2].Financial_Product__c;
							}
						}
						if (uniqueProducts.size() > 3) {
							if (uniqueProducts[3].Financial_Product__c != null && String.isNotBlank(uniqueProducts[3].Financial_Product__c)) {
								newLead.Product_Interest_4__c = uniqueProducts[3].Financial_Product__c;
							}
						}
						if (uniqueProducts.size() > 4) {
							if (uniqueProducts[4].Financial_Product__c != null && String.isNotBlank(uniqueProducts[4].Financial_Product__c)) {
								newLead.Product_Interest_5__c = uniqueProducts[4].Financial_Product__c;
							}
						}
					}

					if (accountRecord != null) {
						newLead.FinServ__RelatedAccount__c = accountRecord.Id;
					}
				}

				insert newLead;

				if (newLead.Id != null) {
					leadId = newLead.Id;
					/*if(uniqueProducts.size() > 0){
for(Product_Interest__c prod: uniqueProducts){
if(prod.Financial_Product__c != null){
prod.Lead__c = leadId; 
interestedProducts.add(prod);
}
}
insert interestedProducts;
}

if(accountRecord.ID_Number__pc != newLead.ID_Number__c){
accountRecord.ID_Number__pc = newLead.ID_Number__c;
update accountRecord;
}*/
				}
			} catch (DmlException ex) {
				//  system.debug('New Lead ERROR:' + ex.getMessage());
				//throw DML exception message
				throw new AuraHandledException(ex.getMessage());
			} catch (Exception ex) {
				//  system.debug('New Lead ERROR:' + ex.getMessage());
				//throw all other exception message
				throw new AuraHandledException(ex.getMessage());
			}
		}

		return String.valueOf(leadId);
	}

	/**
	 * @description findServiceGroupRecord description
	 *
	 * @param serviceGroupId (String): serviceGroupId
	 * @return Return Service_Group__c: Return description
	 */
	@AuraEnabled
	public static Service_Group__c findServiceGroupRecord(String serviceGroupId) {
		//Add Id to a Set
		Set<Id> IdSet = new Set<Id>();
		IdSet.add(serviceGroupId);

		List<Service_Group__c> serviceGroupRec = new ServiceGroupsSelector().selectById(IdSet);
		if (serviceGroupRec.size() > 0) {
			return serviceGroupRec[0];
		} else {
			return null;
		}
	}
	//Monde for Short term
	/**
	 * @description find Postal Code Record description
	 *
	 * @param postalCodeId
	 * @return PostalCodeRec[0];
	 */
	// Uncomment While deploy QA to SIT   Comment Start
	@AuraEnabled
	public static Postal_Code__c findPostalCodeRecord(String postalCodeId) {
		// system.debug('postalCodeId' + postalCodeId);
		List<Postal_Code__c> PostalCodeRec = new LeadAddressSelector().selectById(new Set<Id>{ postalCodeId });
		if (!PostalCodeRec.isEmpty()) {
			// system.debug('PostalCodeRec' + PostalCodeRec[0]);
			return PostalCodeRec[0];
		} else {
			return null;
		}
	}

	/**
	 * @description getLoggedInUserLeadRecordTypes description
	 *
	 * @return Return List<LeadRecordTypes>: Return description
	 */
	@AuraEnabled
	public static List<LeadRecordTypes> getLoggedInUserLeadRecordTypes() {
		List<LeadRecordTypes> recordTypeList = new List<LeadRecordTypes>();

		List<Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Lead.RecordTypeInfos;

		for (Schema.RecordTypeInfo rtInfo : recordTypeInfos) {
			String recordTypeName = rtInfo.getDeveloperName();
			if (rtInfo.isActive() == true && rtInfo.isAvailable() == true) {
				LeadRecordTypes recordTypeItem = new LeadRecordTypes();
				recordTypeItem.recordTypeId = rtInfo.getRecordTypeId();
				recordTypeItem.label = rtInfo.getName();
				recordTypeItem.value = rtInfo.getDeveloperName();
				recordTypeItem.isDefault = rtInfo.isDefaultRecordTypeMapping();
				recordTypeList.add(recordTypeItem);
			}
		}
		// system.debug('**recordTypeList**' + recordTypeList);

		return recordTypeList;
	}

	/**
	 * @description getLoggedInUserPermissionSets description
	 *
	 * @return Return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> getLoggedInUserPermissionSets() {
		List<String> userPermissionSets = new List<String>();

		Profile loggedInUserProfile = new ProfilesSelector().selectByLoggedInUser();

		//Changed by Eduardo Salia and Vitthal Jivrag for VA STI
		List<PermissionSetAssignment> creationPermsionSetAssign = new PermissionSetAssignmentsSelector()
			.selectByNameAndUserId(
				new Set<String>{ 'Manual_Lead_Assign_Button', 'STI_VA_Advisor_Permission_set', 'STI_VA_Banker_Permission_set' },
				UserInfo.getUserId()
			);

		// System.debug('###creationPermsionSetAssign : ' + creationPermsionSetAssign);

		if (creationPermsionSetAssign != null && creationPermsionSetAssign.size() > 0) {
			for (PermissionSetAssignment permissionSetAssignment : creationPermsionSetAssign) {
				if (String.isNotBlank(permissionSetAssignment.PermissionSetId)) {
					// System.debug('###permissionSetAssignment : ' + permissionSetAssignment.PermissionSet.Name);
					if (permissionSetAssignment.PermissionSet.Name == 'Manual_Lead_Assign_Button')
						userPermissionSets.add('Assign');
					else if (
						permissionSetAssignment.PermissionSet.Name == 'STI_VA_Advisor_Permission_set' ||
						permissionSetAssignment.PermissionSet.Name == 'STI_VA_Banker_Permission_set'
					)
						userPermissionSets.add('VA');
				}
			}
		}

		if (loggedInUserProfile != null) {
			//System Admins users will see all
			if (loggedInUserProfile.Name.contains('System Administrator')) {
				userPermissionSets.add('Assign');
				userPermissionSets.add('Route');
			} else {
				userPermissionSets.add('Route');
			}
		}

		// System.debug('###userPermissionSets : ' + userPermissionSets);

		return userPermissionSets;
	}

	/**
	 * @description getLoggedInUserServiceGroups description
	 *
	 * @return Return List<Service_Group__c>: Return description
	 */
	@AuraEnabled
	public static List<Service_Group__c> getLoggedInUserServiceGroups() {
		List<Service_Group__c> serviceGroupRecords;
		Set<String> groupNames = new Set<String>();
		Set<String> recordtypes = new Set<String>{ 'Retail Sales Lead' };
		List<GroupMember> groups = [SELECT Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()];

		if (groups.size() > 0) {
			for (GroupMember member : groups) {
				String userGroup;
				String groupName = member.Group.Name;
				// system.debug(LoggingLevel.FINE, 'groupName:' + groupName);
				if (groupName.contains(' - Non Sales')) {
					userGroup = groupName.remove(' - Non Sales');
				} else if (groupName.contains(' - BM')) {
					userGroup = groupName.remove(' - BM');
				} else {
					userGroup = groupName;
				}
				groupNames.add(userGroup);
			}

			//  system.debug(LoggingLevel.FINE, 'GROUPS:' + groupNames);

			serviceGroupRecords = new ServiceGroupsSelector().selectByNameAndAssignedRecordType(groupNames, recordtypes);

			// System.debug(LoggingLevel.FINE, 'serviceGroupRecordsSIZE:' + serviceGroupRecords.size());
		} else {
			return null;
		}

		return serviceGroupRecords;
	}

	/**
	 * @description getSelectedUserServiceGroupIds description
	 *
	 * @param userId (String): userId
	 * @param groupNames (List<String>): groupNames
	 * @return Return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> getSelectedUserServiceGroupIds(String userId, List<String> groupNames) {
		Set<String> serviceGroupNames = new Set<String>();
		List<String> serviceGroupIds = new List<String>();

		List<GroupMember> groups = [SELECT Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId = :userId AND Group.Name IN :groupNames];

		if (groups.size() > 0) {
			for (GroupMember member : groups) {
				String userGroup;
				String groupName = member.Group.Name;
				// system.debug(LoggingLevel.FINE, 'groupName:' + groupName);
				if (groupName.contains(' - Non Sales')) {
					userGroup = groupName.remove(' - Non Sales');
				} else if (groupName.contains(' - BM')) {
					userGroup = groupName.remove(' - BM');
				} else {
					userGroup = groupName;
				}
				serviceGroupNames.add(userGroup);
			}

			//  System.debug(LoggingLevel.FINE, 'serviceGroupNames:' + serviceGroupNames);

			List<Service_Group__c> serviceGroupRecords = new ServiceGroupsSelector().selectByName(serviceGroupNames);

			for (Service_Group__c sg : serviceGroupRecords) {
				serviceGroupIds.add(sg.Id);
			}

			// system.debug(LoggingLevel.FINE, 'serviceGroupIds:' + serviceGroupIds);
		}

		return serviceGroupIds;
	}

	/**
	 * @description createNewDirectDeliveryLead description
	 *
	 * @param leadRecord (Lead): leadRecord
	 * @param relatedClient (Account): relatedClient
	 * @param financialProductRecord (Financial_Product__c): financialProductRecord
	 * @param isReferral (Boolean): isReferral
	 * @param campaignName (String): campaignName
	 * @param userOrQueue (Id): userOrQueue
	 * @return Return Lead: Return description
	 */
	@AuraEnabled
	public static Lead createNewDirectDeliveryLead(
		Lead leadRecord,
		Account relatedClient,
		Financial_Product__c financialProductRecord,
		Boolean isReferral,
		String campaignName,
		Id userOrQueue
	) {
		/**
		 * Moving the creation of leads to a class without sharing to CrossSellProductsController
		 *
		 * */
		leadRecord = CrossSellProductsController.createNewDDLead(leadRecord, relatedClient, financialProductRecord, isReferral, campaignName, userOrQueue);

		return leadRecord;
	}

	/**
	 * @description LeadRecordTypes Description
	 *
	 */
	public class LeadRecordTypes {
		@AuraEnabled
		public boolean isDefault;
		@AuraEnabled
		public string label;
		@AuraEnabled
		public string value;
		@AuraEnabled
		public string recordTypeId;
		/**
		 * @description LeadRecordTypes description
		 *
		 */
		public LeadRecordTypes() {
			isDefault = false;
			value = '';
			label = '';
			recordTypeId = '';
		}
	}

	//Method to calculate new SLA DateTime
	/**
	 * @description calculateSLADateTime
	 * @param dateTimeCalc (DateTime)
	 * @param busHoursId (Id)
	 * @param timesMeasure (String)
	 * @param units (Integer)
	 * @return Map<String, DateTime>
	 *
	 */

	public static Map<String, DateTime> calculateSLADateTime(DateTime dateTimeCalc, Id busHoursId, String timesMeasure, Integer units) {
		Map<String, DateTime> slaDateTimeMap = new Map<String, DateTime>();

		String timeMeasure = timesMeasure;
		Integer timeUnits = units;
		Integer warningTime = 0;

		//hours in milliseconds
		if (timeMeasure.contains('Hour')) {
			timeUnits = timeUnits * 60 * 60 * 1000;
		} else if (timeMeasure.contains('Day')) {
			timeUnits = timeUnits * 8; //8 hour day
			timeUnits = timeUnits * 60 * 60 * 1000;
		} else if (timeMeasure.contains('Week')) {
			timeUnits = timeUnits * 40; //5 day week at 8 hours per day
			timeUnits = timeUnits * 60 * 60 * 1000;
		}

		//If SLA is 1 hour use 30min as warning else 60min
		if (timeUnits == (60 * 60 * 1000)) {
			warningTime = 30 * 60 * 1000; //30min
		} else if (timeUnits > (60 * 60 * 1000)) {
			warningTime = 60 * 60 * 1000; //60min
		}

		//This should be the Team Classifications SLA dates
		DateTime finalSLADate = BusinessHours.add(busHoursId, dateTimeCalc, timeUnits);
		DateTime warningSLADate = BusinessHours.add(busHoursId, finalSLADate, (warningTime * -1));

		slaDateTimeMap.put('slaEndDate', finalSLADate);
		slaDateTimeMap.put('slaWarningDate', warningSLADate);

		return slaDateTimeMap;
	}

	/**=================================================================================================================================
* Author: Eduardo Salia
* Created Date: 27-01-2021

* Returns a Flag after each Lead Creation attempt
* Param 1: salesLead is our Lead object from the Aura component
* Param 2: opportunityId is the Id of the Opportunity record that started this transaction
* Param 3: campaignName is our chosen campaign from the Aura component
===================================================================================================================================**/
	/**
	 * @description createReferredLead
	 * @param salesLead (salesLead)
	 * @param recId (Id)
	 * @param campaignName (String)
	 * @param selectedFinancialProduct (Id)
	 * @return Lead
	 *
	 */
	@AuraEnabled
	public static Lead createReferredLead(Lead salesLead, Id recId, String campaignName, Id selectedFinancialProduct) {
		String objectType;
		objectType = LeadOverrideController.getObjectName(recId);
		List<Opportunity> opportunities = new List<Opportunity>();
		List<Case> cases = new List<Case>();
		Account accountRecord = new Account();
		Lead newLead = new Lead();
		String ownerId = null;
		Boolean isReferral = true;
		// System.debug('<<<<<<<<< sales lead >>>>>>>>>' + salesLead);
		if (objectType == 'Opportunity' && recId != null) {
			opportunities = new OpportunitiesSelector().selectByOpportunityId(recId, 1);

			if (!Sys_Utilities_General.isListBlank(opportunities)) {
				// System.debug('<<<<<<<<< sales lead owner ID >>>>>>>>>' + salesLead.ownerId);
				//Get Account By Id
				accountRecord = new AccountsSelector().selectAllById(opportunities[0].AccountId);
				//Unable to insert salesLead variable due to following error
				//Stack Trace: INVALID_FIELD, Cannot specify both an external ID reference Owner and a salesforce id, OwnerId
				//Solution is to map existing fields into a new lead record

				if (opportunities[0].converted_lead__c != null) {
					newLead = setLeadDetails(opportunities[0].converted_lead__c, salesLead);
				} else {
					newLead = mapLeadFields(salesLead, opportunities[0]);
				}
			}
		}

		if (objectType == 'Case' && recId != null) {
			cases = new CasesSelector().selectById(new Set<Id>{ recId });
			accountRecord = new AccountsSelector().selectAllById(cases[0].AccountId);
			if (accountRecord.Converted_Lead__pc != null) {
				newLead = setLeadDetails(accountRecord.Converted_Lead__pc, salesLead);
			} else {
				//System.debug('<<<<<<<<< sales lead.idnumber >>>>>>>>>' + salesLead.ID_Number__c);
				newLead.ID_Number__c = salesLead.ID_Number__c;
				newLead.DD_Agent_Who_Referred_Lead__c = salesLead.DD_Agent_Who_Referred_Lead__c;
				newLead.DD_AVAF_Account_Number__c = salesLead.DD_AVAF_Account_Number__c;
				newLead.DD_Convenient_Time_To_Call__c = salesLead.DD_Convenient_Time_To_Call__c;
				newLead.FirstName = accountRecord.FirstName;
				newLead.LastName = accountRecord.LastName;
			}
		}
		// code for AIP
		// 2021/06/28
		// Pravin W.
		Lead currentLeadRecord = new Lead();
		Id stiRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead').getRecordTypeId();
		if (objectType == 'Lead' && recId != null) {
			currentLeadRecord = new LeadsSelector().selectLeadById(recId);
			//System.debug('currentLeadRecord : ' + currentLeadRecord);
			accountRecord = new AccountsSelector().selectAllById(currentLeadRecord.FinServ__RelatedAccount__c);
			if (accountRecord.Converted_Lead__pc != null) {
				newLead = setLeadDetails(accountRecord.Converted_Lead__pc, salesLead);
			} else {
				//System.debug('<<<<<<<<< sales lead.idnumber >>>>>>>>>' + salesLead.ID_Number__c);
				newLead.ID_Number__c = salesLead.ID_Number__c;
				newLead.DD_Agent_Who_Referred_Lead__c = salesLead.DD_Agent_Who_Referred_Lead__c;
				newLead.DD_AVAF_Account_Number__c = salesLead.DD_AVAF_Account_Number__c;
				newLead.DD_Convenient_Time_To_Call__c = salesLead.DD_Convenient_Time_To_Call__c;
				newLead.FirstName = accountRecord.FirstName;
				newLead.LastName = accountRecord.LastName;

				//Adding ALL AIP fields
				newLead.RecordTypeid = stiRecTypeId;
				newLead.Title = currentLeadRecord.Title;
				newLead.DD_Initials__c = currentLeadRecord.DD_Initials__c;
				newLead.Language_Preference__c = currentLeadRecord.Language_Preference__c;
				newLead.DD_Gender__c = currentLeadRecord.DD_Gender__c;
				newLead.ID_Type__c = currentLeadRecord.ID_Type__c;
				newLead.ID_Number__c = currentLeadRecord.ID_Number__c;
				newLead.CIF__c = currentLeadRecord.CIF__c;
				newLead.DD_Existing_Products_Within_Absa__c = currentLeadRecord.DD_Existing_Products_Within_Absa__c;
				newLead.DD_Marketing_Consent__c = currentLeadRecord.DD_Marketing_Consent__c;
				newLead.DD_AVAF_Account_Number__c = currentLeadRecord.DD_AVAF_Account_Number__c;
				newLead.Contract_Start_Date__c = currentLeadRecord.Contract_Start_Date__c;
				newLead.DD_Market_Value__c = currentLeadRecord.DD_Market_Value__c;
				newLead.Plan_type__c = currentLeadRecord.Plan_type__c;
				newLead.Marital_status__c = currentLeadRecord.Marital_status__c;
				newLead.Marital_Contract_Type__c = currentLeadRecord.Marital_Contract_Type__c;
				newLead.MobilePhone = currentLeadRecord.MobilePhone;
				newLead.DD_Additional_Cell_Phone__c = currentLeadRecord.DD_Additional_Cell_Phone__c;
				newLead.DD_Work_Phone__c = currentLeadRecord.DD_Work_Phone__c;
				newLead.DD_Home_Phone__c = currentLeadRecord.DD_Home_Phone__c;
				newLead.Email = currentLeadRecord.Email;
				newLead.Vehicle_Name__c = currentLeadRecord.Vehicle_Name__c;
				newLead.DD_Premium__c = currentLeadRecord.DD_Premium__c;
				newLead.Description = currentLeadRecord.Description;
				newLead.DD_Vehicle_Year__c = currentLeadRecord.DD_Vehicle_Year__c;
			}
		}

		//System.debug('selectedFinancialProduct' + selectedFinancialProduct);
		//Proceed if Opportunity found

		List<Financial_Product__c> financialProduct = new List<Financial_Product__c>();
		//Find STI Financial Product
		if (selectedFinancialProduct == null) {
			financialProduct = new FinancialProductsSelector().selectByProductCode(new Set<String>{ FINANCIAL_PRODUCT_CODE_STI });
		} else {
			List<Financial_Product__c> financialProductList = [
				SELECT Id, Name, Business_Unit__c, CurrencyIsoCode
				FROM Financial_Product__c
				WHERE Id = :selectedFinancialProduct
				LIMIT 1
			];

			if (!financialProductList.isEmpty()) {
				financialProduct.add(financialProductList[0]);
			}
		}

		//Assign Owner
		if (String.isNotBlank(salesLead.OwnerId)) {
			ownerId = salesLead.OwnerId;
		}

		//System.debug('<<<<<<<<< ownerId >>>>>>>>>' + ownerId);

		//Setting this to false so it can follow the route of getting a campaign assigned based on the financial product selected
		if (campaignName == 'Direct Delivery Product') {
			isReferral = false;
		}

		return createNewDirectDeliveryLead(
			newLead,
			accountRecord != null ? accountRecord : null,
			!Sys_Utilities_General.isListBlank(financialProduct) ? financialProduct[0] : null,
			isReferral,
			campaignName,
			ownerId
		);
	}

	/**@description getAccountDetails
	 * @param recordId (Id)the ID of the Record
	 * @param leadRecord (Lead) the lead record
	 *
	 * @return a lead record set with new values
	 */
	@testVisible
	private static Lead getAccountDetails(Id recordId, Lead leadRecord) {
		Account currentAccount = new AccountsSelector().selectAllById(recordId);

		return leadRecord;
	}

	@testVisible
	private static Lead setLeadDetails(Id clonedLead, Lead currentLeadRecord) {
		Lead convertedLead = [
			SELECT
				Id,
				FirstName,
				LastName,
				DD_Gender__c,
				DD_Date_of_Birth__c,
				Financial_Product__c,
				ID_Number__c,
				CIF__c,
				DD_Source_of_Income__c,
				DD_Source_of_Funds__c,
				Salutation,
				Address,
				DD_Marital_Status__c,
				DD_Nationality__c,
				DD_Initials__c,
				DD_Home_Phone__c,
				DD_Work_Phone__c,
				RecordTypeId
			FROM Lead
			WHERE Id = :clonedLead
			LIMIT 1
		];
		Lead leadRecord = convertedLead.clone(false, false, false, false);
		leadRecord.Status = 'Unallocated';
		leadRecord.SubStatus__c = '';
		leadRecord.Converted_Status_Date__c = null;
		leadRecord.Converted__c = 'NO';
		leadRecord.RecordTypeId = null;
		leadRecord.Financial_Product__c = null;
		leadRecord.DD_Agent_Who_Referred_Lead__c = currentLeadRecord.DD_Agent_Who_Referred_Lead__c;
		leadRecord.DD_AVAF_Account_Number__c = currentLeadRecord.DD_AVAF_Account_Number__c;
		leadRecord.DD_Convenient_Time_To_Call__c = currentLeadRecord.DD_Convenient_Time_To_Call__c;
		leadRecord.DD_Nationality__c = '';

		return leadRecord;
	}

	/**=================================================================================================================================
* Author: Eduardo Salia
* Created Date: 27-01-2021

* Returns the Opportunity Record that started this transaction
* Param 1: opportunityId is the Id of the Opportunity record that started this transaction
===================================================================================================================================**/
	/**@description getOpportunityDetails
	 * @param opportunityId (Id)the ID of the Record
	 * @return OpportunitywithAccount
	 */

	@AuraEnabled
	public static OpportunitywithAccount getOpportunityDetails(Id opportunityId) {
		Id personAccountId1 = (Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId());
		Id personAccountId2 = (Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId());

		//Get Opportunity By Id
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
		OpportunitywithAccount oppwithAcc = new OpportunitywithAccount();
		//Proceed if Opportunity found
		if (!Sys_Utilities_General.isListBlank(opportunities)) {
			if (opportunities[0].Account.RecordTypeId == personAccountId1 || opportunities[0].Account.RecordTypeId == personAccountId2) {
				oppwithAcc.isIndClient = true;
			} else {
				oppwithAcc.isIndClient = false;
			}
			oppwithAcc.Opp = opportunities[0];
			return oppwithAcc;
		}
		return null;
	}
	/*   @AuraEnabled
public static Opportunity getOpportunityDetails(Id opportunityId)
{
//Get Opportunity By Id
List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);

//Proceed if Opportunity found
if(!Sys_Utilities_General.isListBlank(opportunities))
return opportunities[0];

return null;
}*/

	/**=================================================================================================================================
* Author: Eduardo Salia
* Created Date: 28-01-2021

* Returns a mapped Lead record
* Unable to insert lead parameter from the Aura Component due to following error
* INVALID_FIELD, Cannot specify both an external ID reference Owner and a salesforce id, OwnerId

* Param 1: lead is our Lead object from the Aura component
===================================================================================================================================**/

	/**@description mapleadfields
	 * @param salesLead (Lead)
	 * @param opportunity (Opportunity)
	 * @return Lead
	 */

	@AuraEnabled
	public static Lead mapLeadFields(Lead salesLead, Opportunity opportunity) {
		Lead newLead = new Lead();
		newLead.ID_Number__c = salesLead.ID_Number__c;
		newLead.DD_Agent_Who_Referred_Lead__c = salesLead.DD_Agent_Who_Referred_Lead__c;
		newLead.DD_AVAF_Account_Number__c = salesLead.DD_AVAF_Account_Number__c;
		newLead.DD_Convenient_Time_To_Call__c = salesLead.DD_Convenient_Time_To_Call__c;
		newLead.FirstName = opportunity.Person_Account_First_Name__c;
		newLead.LastName = opportunity.Person_Account_Last_Name__c;
		//newLead.Financial_Product__c = salesLead.Financial_Product__c; //added by divya
		return newLead;
	}

	//To fetch the username
	/**
	 * @description getUserName description
	 *
	 * @return Return String: Return description
	 */
	@AuraEnabled
	public static String getUserName() {
		return userinfo.getName();
	}

	/**@description createFerredLeadVASTI
	 * @param salesLead (Lead)
	 * @param opportunityId (Id)
	 * @param campaignName (String)
	 * @param financialProductRecord (Financial_Product__c)
	 * @param preferredSiteRecord (Site__c)
	 * @param useLeadAssignmentRule (Boolean)
	 * @return Lead
	 */

	@AuraEnabled
	public static Lead createReferredLeadVASTI(
		Lead salesLead,
		Id opportunityId,
		String campaignName,
		Financial_Product__c financialProductRecord,
		Site__c preferredSiteRecord,
		Boolean useLeadAssignmentRule
	) {
		//Get Opportunity By Id
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);

		//Proceed if Opportunity found
		if (!Sys_Utilities_General.isListBlank(opportunities)) {
			//System.debug('Inside createReferredLeadVASTI MVP2 opportunities not null');
			String ownerId;
			string u = userinfo.getUserId();
			Set<String> permissionSetNames = new Set<String>();
			permissionSetNames.add('STI_VA_Advisor_Permission_set');
			PermissionSetAssignmentsSelector pm = new PermissionSetAssignmentsSelector();
			List<PermissionSetAssignment> plist = pm.selectByNameAndUserId(permissionSetNames, u);
			if (plist.size() > 0) {
				throw new oppException('You do not Have Authorization to Create Lead From CAF Opportunity');
			}
			//Get Account By Id
			Account account = new AccountsSelector().selectAccountPhoneDetailsByID(opportunities[0].AccountId);

			//Create Lead
			String leadId = createLead(salesLead, account != null ? account : null, financialProductRecord, preferredSiteRecord, useLeadAssignmentRule);
			//System.debug('MVP2 lead id' + leadId);

			Lead newLead = new LeadsSelector().selectLeadById(leadId);

			if (newLead != null) {
				//System.debug('Inside createReferredLeadVASTI MVP2 lead' + newLead);

				return newLead;
			} else {
				return null;
			}
		}
		return null;
	}
	/******
//Added by Divya
@AuraEnabled
public static Map<String, String> getCampaigns() {

List<Direct_delivery_campaigns__mdt> ddcampaigns = [SELECT Id,Label,DeveloperName,Lead_Record_Type_Developer_Name__c, Opportunity_Record_Type_Developer_Name__c, Queue_Developer_Name__c FROM Direct_delivery_campaigns__mdt];
Map<String, String> options = new Map<String, String>();

for (Direct_delivery_campaigns__mdt p: ddcampaigns) {
//Put Picklist Value & Label in Map
options.put(p.DeveloperName, p.Label);
}
return options;

}
*******/

	//Added by Divya
	// Change the method name to something more generic eg , getreferrealList
	// param for oppID --> we need to get the record type back so that we can know what values to display
	/**@description getReferralCampaigns
* @param recordId (Id)

* @return Map<String, String>
*/

	@AuraEnabled
	public static Map<String, String> getReferralCampaigns(Id recordId) {
		String objectType = LeadOverrideController.getObjectName(recordId);
		Map<String, String> options = new Map<String, String>();
		List<Referral_Setting__mdt> allOptions = new List<Referral_Setting__mdt>();

		if (objectType == 'Opportunity') {
			OpportunitiesSelector oppSelector = new OpportunitiesSelector();
			List<Opportunity> currentOpportunity = oppSelector.selectByOpportunityId(recordId);

			allOptions = [
				SELECT
					Id,
					Label,
					Campaign_Name__c,
					DeveloperName,
					Lead_Record_Type_Developer_Name__c,
					Opportunity_Record_Type_Developer_Name__c,
					Queue_Developer_Name__c
				FROM Referral_Setting__mdt
				WHERE Opportunity_Record_Type_Developer_Name__c = :currentOpportunity[0].RecordType.DeveloperName
			];
		}
		if (objectType == 'Case') {
			List<Case> currentCase = new CasesSelector().selectByIdWithRecordTypeDeveloperName(recordId);

			allOptions = [
				SELECT
					Id,
					Label,
					Campaign_Name__c,
					DeveloperName,
					Lead_Record_Type_Developer_Name__c,
					Opportunity_Record_Type_Developer_Name__c,
					Queue_Developer_Name__c,
					Case_Record_Type_Developer_Name__c
				FROM Referral_Setting__mdt
				WHERE Case_Record_Type_Developer_Name__c = :currentCase[0].RecordType.DeveloperName
			];
		}
		// added below code for AIP
		// 2021/06/28
		// Pravin W.
		if (objectType == 'Lead') {
			Lead currentLead = new LeadsSelector().selectLeadById(recordId);

			allOptions = [
				SELECT
					Id,
					Label,
					Campaign_Name__c,
					DeveloperName,
					Lead_Record_Type_Developer_Name__c,
					Opportunity_Record_Type_Developer_Name__c,
					Queue_Developer_Name__c,
					Case_Record_Type_Developer_Name__c,
					Referral_Lead_Record_Type_Name__c
				FROM Referral_Setting__mdt
				WHERE Referral_Lead_Record_Type_Name__c = :currentLead.RecordType.Name
			];
		}

		for (Referral_Setting__mdt p : allOptions) {
			//Put Picklist Value & Label in Map
			options.put(p.Campaign_Name__c, p.Label);
		}
		return options;
	}

	// Wrapper Class for Account RecordTypes
	/**
	 * @description OpportunitywithAccount Description
	 *
	 */
	public class OpportunitywithAccount {
		@AuraEnabled
		public boolean isIndClient;
		@AuraEnabled
		public Opportunity Opp;
	}

	/**=================================================================================================================================
@description getObjectName
@param recordId (Id)
@return String

* Created By Eduardo Salia 13/03/2021
* Returns Object Type Name
* Param 1: recordId is our record Id from the Aura Component
===================================================================================================================================**/
	@AuraEnabled
	public static String getObjectName(Id recordId) {
		return recordId.getSObjectType().getDescribe().getName();
	}

	/******
	 * Created By Pranav
	 *******/
	/**@description duplicateCheck
* @param idnumber (string)
* @param financialProductRecord (Financial_Product__c)

* @return boolean
*/

	@AuraEnabled
	public static boolean duplicateCheck(string idnumber, Financial_Product__c financialProductRecord) {
		//System.debug('financialProductRecord.Name'+financialProductRecord.Name);
		try {
			List<Flexi_Funeral_Relationship_Code__mdt> ddSettings = [
				SELECT Id, Inbound_Campaign_Name__c
				FROM Flexi_Funeral_Relationship_Code__mdt
				WHERE Product__c = :financialProductRecord.Name
				LIMIT 1
			];

			string campaignName;
			//System.debug('ddSettings'+ddSettings);
			if (!ddSettings.isEmpty()) {
				campaignName = ddSettings[0].Inbound_Campaign_Name__c;
			} else {
				campaignName = 'DD - Advice - STI Cross-Sell';
			}
			//System.debug('campaignName' + campaignName);
			list<CampaignMember> cm = [
				SELECT id, Lead.ID_Number__c, Lead.Status
				FROM CampaignMember
				WHERE
					Campaign.Name = :campaignName
					AND lead.Status != 'closed'
					AND lead.Status != 'Auto Closed'
					AND lead.recordType.developerName = 'DD_STI_Lead'
					AND Lead.ID_Number__c = :idnumber
				LIMIT 1
			];

			//System.debug('cm' + cm.size());
			//select id,Lead.ID_Number__c,Lead.Status from CampaignMember where Campaign.Name ='DD - Advice - STI Cross-Sell' AND lead.Status!='closed' AND lead.recordType.developerName='DD_STI_Lead'
			boolean isExisting;
			if (cm != null && cm.size() > 0) {
				isExisting = true;
			} else {
				isExisting = false;
			}
			return isExisting;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	/**
	 * @description getSTIRecordTypeId description
	 *
	 * @return Return String: Return description
	 */
	@AuraEnabled
	public static String getSTIRecordTypeId() {
		return Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
	}
	/**=================================================================================================================================
	 * Created By Chenna on 21/04/2021
	 * @description Recinfo will provide the existing Record values
	 * @param Recinfo (Lead): newLeadRecord
	 * @param caseInfo (Case): relatedCase
	 * @param isTeamAssign  :true if is assigned
	 * @return Return String: Return description
	 ===================================================================================================================================**/
	//Update By Divya
	@AuraEnabled
	public static String createVAReferredLead(Lead Recinfo, Case caseInfo, boolean isTeamAssign) {
		Lead newlead = new Lead();
		Account parentAccount = new Account();
		try {
			Group objGroup = [SELECT Id, name FROM Group WHERE type = 'Queue' AND DeveloperName = 'Virtual_Advisors'];
			if (Recinfo.Parent_Account__c != null) {
				AccountsSelector accController = new AccountsSelector();
				parentAccount = accController.selectAllById(Recinfo.Parent_Account__c);
			} else {
				AccountsSelector accController = new AccountsSelector();
				parentAccount = accController.selectAllById(caseInfo.AccountId);
			}
			Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

			newlead.ID_Number__c = Recinfo.ID_Number__c;
			newlead.Financial_Product__c = Recinfo.Financial_Product__c;
			//newlead.DD_Agent_Who_Referred_Lead__c = Recinfo.DD_Agent_Who_Referred_Lead__c;
			if (isTeamAssign == true) {
				newlead.OwnerId = objGroup.Id;
			} else {
				if (Recinfo.OwnerId != null) {
					newlead.OwnerId = Recinfo.OwnerId;
				}

				newlead.DD_Agent_Who_Referred_Lead__c = Recinfo.DD_Agent_Who_Referred_Lead__c;
			}
			newLead.Comments__c = Recinfo.Comments__c;
			newLead.DD_Convenient_Time_To_Call__c = Recinfo.DD_Convenient_Time_To_Call__c;
			if (caseInfo != null) {
				//system.debug('case---' + caseInfo);
				//newLead.Customer_Type__c = caseInfo.Customer_Type__c ;
				newLead.Company = caseInfo.Account.Name;
				newLead.Language_Preference__c = caseInfo.Language__c;
				newLead.DD_Initials__c = caseInfo.Initials__c;
				newLead.Title = caseInfo.Title__c;
				if (caseInfo.Gender__c == 'M')
					newLead.DD_Gender__c = 'Male';
				if (caseInfo.Gender__c == 'F')
					newLead.DD_Gender__c = 'Female';
				if (caseInfo.ID_Type__c == 'SA ID')
					newLead.ID_Type__c = 'SA Identity Document';
				else if (caseInfo.ID_Type__c == 'Passport')
					newLead.ID_Type__c = 'Passport';
				else
					newLead.ID_Type__c = caseInfo.ID_Type__c;
				newLead.DD_Date_of_Birth__c = caseInfo.Birth_Date__c;
				newLead.Nationality__c = caseInfo.Nationality__c;
				newLead.CIF__c = caseInfo.CIF_Custom__c;
				newLead.firstname = caseInfo.First_Name__c;
				newLead.lastname = caseInfo.Last_Name__c;
				newLead.MobilePhone = caseInfo.Mobile__c;
				newLead.Case__c = caseInfo.Id;
				newLead.Alternate_Phone1__c = caseInfo.Alternate_Phone1__c;
				newLead.Alternate_Phone2__c = caseInfo.Alternate_Phone2__c;
				newLead.Alternate_Phone3__c = caseInfo.Alternate_Phone3__c;
				newLead.DD_Home_Phone__c = caseInfo.Home_Phone__c;
				newLead.DD_Work_Phone__c = caseInfo.Work_Phone__c;
				newLead.Email = caseInfo.Email__c;
				newLead.Postal_Address_Line_1__c = caseInfo.Post_Addr_Line1__c;
				newLead.Postal_Address_Line_2__c = caseInfo.Post_Addr_Line2__c;
				newLead.Postal_Address_Suburb__c = caseInfo.Post_Addr_Line3__c;
				newLead.Postal_Address_City__c = caseInfo.Post_Addr_Line4__c;
				if (caseInfo.Post_Addr_Post_Code__c != null) {
					newLead.Postal_Address_Postal_code__c = caseInfo.Post_Addr_Post_Code__c.left(4);
				}
				newLead.Physical_address_line_1__c = caseInfo.Phys_Addr_Line1__c;
				newLead.Physical_address_Line_2__c = caseInfo.Phys_Addr_Line2__c;
				newLead.Physical_address_Suburb__c = caseInfo.Phys_Addr_Line3__c;
				newLead.Physical_address_City__c = caseInfo.Phys_Addr_Line4__c;
				if (caseInfo.Phys_Addr_Post_Code__c != null) {
					newLead.Physical_address_Postal_code__c = caseInfo.Phys_Addr_Post_Code__c.left(4);
				}

				newLead.Description = caseInfo.Description;
				newLead.Subject__c = caseInfo.Subject;
				newLead.Rating = 'Cold';
				newlead.FinServ__RelatedAccount__c = caseInfo.AccountId;
				if (caseInfo.RecordType.Name == 'VA Client Review' || caseInfo.RecordType.Name == 'VA Maturity')
					newLead.RecordTypeId = leadRecordTypeMap.get(VA_LEAD_REC_TYPE_DEV_NAME).getRecordTypeId();

				//Added By divya
				if (Recinfo.Financial_Product__r != null && Recinfo.Financial_Product__r.Name == 'Investment Product') {
					newLead.RecordTypeId = leadRecordTypeMap.get(Investment_Banking_Lead_NAME).getRecordTypeId();
					newlead.Financial_Product__c = Recinfo.Financial_Product__c;
					if (Recinfo.Parent_Account__c == null) {
						newlead.Parent_Account__c = caseInfo.AccountId;
						newlead.Salutation = caseInfo.Account.Salutation;
					} else {
						newlead.Parent_Account__c = Recinfo.Parent_Account__c;
						newlead.Salutation = parentAccount.Salutation;
					}
					/*newlead.Physical_Address__c = (parentAccount.BillingStreet !=null ?parentAccount.BillingStreet :'')  
                                                                 +'\r\n'+ (parentAccount.BillingCity !=null ?parentAccount.BillingCity :'') +','+ (parentAccount.BillingState !=null ?parentAccount.BillingState :'')
                                                                 +','+(parentAccount.BillingPostalCode !=null ?parentAccount.BillingPostalCode :'')+'\r\n'+(parentAccount.BillingCountry !=null ?parentAccount.BillingCountry :'');
                                                             
                    newlead.Postal_Address__c = (parentAccount.ShippingStreet !=null ?parentAccount.ShippingStreet :'')  
                                 +'\r\n'+ (parentAccount.ShippingCity !=null ?parentAccount.ShippingCity :'') +','+ (parentAccount.ShippingState !=null ?parentAccount.ShippingState :'')
                                 +','+(parentAccount.ShippingPostalCode !=null ?parentAccount.ShippingPostalCode :'')+'\r\n'+(parentAccount.ShippingCountry !=null ?parentAccount.ShippingCountry :'');
                    */
					//Get Fields data from account
					newLead.DD_Initials__c = parentAccount.Initials__pc;
					newLead.Title = parentAccount.PersonTitle;
					newLead.DD_Gender__c = parentAccount.Gender__pc;
					newLead.ID_Type__c = parentAccount.ID_Type__pc;

					newLead.DD_Date_of_Birth__c = parentAccount.PersonBirthDate;
					newLead.Nationality__c = parentAccount.Nationality__pc;
					newLead.CIF__c = parentAccount.CIF__pc;
					newLead.firstname = parentAccount.FirstName;
					newLead.lastname = parentAccount.LastName;
					newLead.MobilePhone = parentAccount.PersonMobilePhone;
					newLead.Email = parentAccount.PersonEmail;
				}
			}
			insert newlead;
			//Added by Deepthi N
			if (newlead.OwnerId != newlead.CreatedById) {
				LeadShareHandler.shareLeadWithCreator(newLead);
			}
			return 'Success';
		} catch (exception e) {
			string excepmsg = e.getMessage();
			if (caseinfo.AccountId == null) {
				excepmsg = 'Account is not linked to this Case';
			}
			//System.debug('------>' + e);
			return excepmsg;
		}
	}
	//Added by Divya

	// param for caseid --> we need to get the case details
	/**@description getCaseDetails
* @param caseId (Id)

* @return Case
*/
	@AuraEnabled
	public static Case getCaseDetails(Id caseId) {
		List<Case> currentCase = new CasesSelector().selectByIdWithRecordTypeDeveloperName(caseId);
		return currentCase[0];
	}
	/**@description : Method used to get the details for refer a lead component. We need information for setting
	 *           default values in the component
	 * @param leadId (Id)
	 * @return Lead
	 * @author : Pravin W.
	 */
	@AuraEnabled
	public static Lead getLeadDetails(Id leadId) {
		Lead currentLead = new Lead();
		currentLead = new LeadsSelector().selectLeadById(leadId);
		return currentLead;
	}

	/**
	 * @description create the lead record for short term insurance.
	 * @author Mbuyiseni Mbhokane | 05-30-2021
	 * @param newLeadRecord
	 * @param acc
	 * @param selectedServiceGroupId
	 * @param route
	 * @return String
	 **/
	@AuraEnabled
	public static String createLeadForShortTermInsurance(Lead newLeadRecord, Account acc, Id selectedServiceGroupId, Boolean route) {
		try {
			/*System.debug('###selectedServiceGroupId : '+ selectedServiceGroupId);
            System.debug('###acc : '+ acc);
            System.debug('###newLeadRecord : '+ newLeadRecord);
            System.debug('###route : '+ route); */
			if (newLeadRecord != null) {
				Id serviceGroupId;

				//set the service group id based on the selected service group record
				if (String.isNotBlank(selectedServiceGroupId)) {
					serviceGroupId = selectedServiceGroupId;
					//System.debug('###serviceGroupId: '+ serviceGroupId);
				}

				List<Service_Group__c> serviceGroups = new List<Service_Group__c>();
				List<Group> queuesForLead = new List<Group>();
				if (String.isNotBlank(serviceGroupId)) {
					serviceGroups = new ServiceGroupsSelector().selectById(new Set<Id>{ serviceGroupId });

					//System.debug('###serviceGroups : '+ serviceGroups);
					if (!serviceGroups.isEmpty()) {
						newLeadRecord.sd_Service_Group_Id__c = serviceGroups.get(0).id;
						newLeadRecord.sd_Service_Group__c = serviceGroups.get(0).Name;
						newLeadRecord.Service_Group_Search__c = serviceGroups.get(0).Id;
						newLeadRecord.sd_Original_Service_Group__c = serviceGroups.get(0).Name;
						newLeadRecord.sd_Original_Service_Queue__c = serviceGroups.get(0).Queue__c;
						newLeadRecord.Business_Hours__c = serviceGroups.get(0).Business_Hours__c;
						newLeadRecord.sd_Response_Email_Address__c = serviceGroups.get(0).Response_Email_Address__c;
						newLeadRecord.sd_Email_Template_Lead_Creation__c = serviceGroups.get(0).Email_Template_Lead_Creation__c;
						newLeadRecord.Internal_SLA_Notification_User__c = serviceGroups.get(0).Internal_SLA_Notification_User__c;
						newLeadRecord.Manager__c = serviceGroups.get(0).Manager__c;
					}
				}

				if (route) {
					//service group is not blank and the queue is not blank
					if (!serviceGroups.isEmpty() && String.isNotBlank(serviceGroups.get(0).Queue__c)) {
						queuesForLead = [SELECT Id, Name, DeveloperName FROM Group WHERE Name = :serviceGroups.get(0).Queue__c AND Type = :'Queue'];
					}
					//assign the queue Id to the lead
					if (!queuesForLead.isEmpty()) {
						newLeadRecord.OwnerId = queuesForLead.get(0).Id;
					}
					newLeadRecord.Status = 'Unallocated';
				} else {
					newLeadRecord.Status = 'Allocated';
					newLeadRecord.Allocated_Time__c = System.now();
				}
				//set the account on the lead
				if (acc != null) {
					newLeadRecord.FinServ__RelatedAccount__c = acc.Id;
				}
				//create the lead
				//System.debug('###newLeadRecord.sd_Service_Group__c : '+ newLeadRecord.sd_Service_Group__c);
				insert newLeadRecord;
			}
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}

		return newLeadRecord.Id;
	}
	//Added By Divya
	/*@AuraEnabled
	public static Lead createInvReferredLead(Lead salesLead, Id recId) {
		String objectType;
		objectType = LeadOverrideController.getObjectName(recId);
		List<Opportunity> opportunities = new List<Opportunity>();
		Account accountRecord = new Account();
		Lead newLead = new Lead();
		List<Group> allQueues = new List<Group>();
		Id userOrQueue;

		if (objectType == 'Opportunity' && recId != null) {
			opportunities = new OpportunitiesSelector().selectByOpportunityId(recId, 1);
			accountRecord = new AccountsSelector().selectAllById(opportunities[0].AccountId);
			if (opportunities[0].converted_lead__c != null) {
				newLead = setLeadDetails(opportunities[0].converted_lead__c, salesLead);
			} else {
				newLead = mapLeadFields(salesLead, opportunities[0]);
			}
		}
		 //Added By Divya On 12-10-2021
		 System.debug('Metadata is'+Investment_Opp_Name);
		     List<Referral_Setting__mdt> allReferralSettings = [
                    SELECT Id, Lead_Record_Type_Developer_Name__c, Campaign_Name__c, Queue_Developer_Name__c, Financial_Product_Name__c
                    FROM Referral_Setting__mdt
                    WHERE Opportunity_Record_Type_Developer_Name__c = :Investment_Opp_Name
                    LIMIT 1
                ];
        if (!allReferralSettings.isEmpty()) {
            allQueues = [SELECT Id FROM Group WHERE DeveloperName = :allReferralSettings[0].Queue_Developer_Name__c LIMIT 1];
                        if (!allQueues.isEmpty()) {
                            userOrQueue = allQueues[0].Id;
                        }
            if (allReferralSettings[0].Lead_Record_Type_Developer_Name__c != null) {
                        newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName()
                            .get(allReferralSettings[0].Lead_Record_Type_Developer_Name__c)
                            .getRecordTypeId();
                    }
        }
		if (userOrQueue != null) {
			newLead.OwnerId = userOrQueue;
		}
		newLead.Parent_Account__c = accountRecord.Id;
		try {
			insert newLead;
			//System.debug('Id of Lead >>>>>>>>>>' + newLead.Id);
				if (newLead.Id != null) {
				//System.debug('Opp Size'+opportunities.size());
				if (opportunities.size() > 0) {
					//Added By Divya On 12-10-2021
                    opportunities[0].Is_Referred_Sys__c = true;
                     opportunities[0].Is_Referred_System__c = 'Yes';
                    opportunities[0].Sys_BypassValidation__c = true;
					update opportunities[0];
				}
			} 
		} catch (Exception ex) {
		//System.debug('There was an error creating the Lead - ' + ex.getMessage());
			AuditTrailLog.logException(ex, 'New', 'Error', 'LeadOverrideController', 'createNewDirectDeliveryLead', 'Trying to insert new DD lead');
			throw new AuraHandledException(ex.getMessage());
		}
		return newLead;
	} */
}