/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-13
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class Sys_Utilities_General {
	public static List<Organization> salesforceOrg;
	/**
	 * @description       : 
	 * Method that retrieves the current environment
	 * @return Environment
	 */

	public static String getEnvironment() {
		if (salesforceOrg == null) {
			salesforceOrg = [SELECT IsSandbox FROM Organization];
		}
		if (salesforceOrg.size() == 1) {
			if (salesforceOrg[0].IsSandbox) {
				String hostName = String.valueOf(URL.getSalesforceBaseUrl());
				return hostName.contains(StringConstants.UAT_LOWERCASE_STRING) ? StringConstants.UAT_UPPERCASE_STRING : StringConstants.DEVELOPMENT_STRING;
			} else {
				return StringConstants.PRODUCTION_STRING;
			}
		} else if (salesforceOrg.size() == 0) {
			return StringConstants.ERROR_MSG_NO_ENVIRONMENT_FOUND;
		} else {
			return StringConstants.ERROR_MSG_MULTIPLE_ENVIRONMENTS_FOUND;
		}
	}

	/**
	 * @description       : getSObjectFieldLength  Method that retrieves the current environment
	 * @param objP
	 * @param fieldNameP
	 * @return Integer
	 */
	public static Integer getSObjectFieldLength(String objP, String fieldNameP) {
		//In the future we should store the value in cache so that we don't have to go through all the fields every time. we would check if it exists in the cache first
		for (Schema.SObjectField s : Schema.getGlobalDescribe().get(objP).getDescribe().Fields.getMap().values()) {
			if (s.getDescribe().getName() == fieldNameP) {
				return s.getDescribe().getLength();
			}
		}
		return null;
	}

	/**
	 * @description       : truncateFieldIfNeeded
	 * @param fieldP sObjectListP this is our list of sObject records
	 * @param lengthP  objectFieldNameP this is our sObject field name which will become the map key
	 * @return String
	 **/

	public static String truncateFieldIfNeeded(String fieldP, Integer lengthP) {
		if (fieldP != null) {
			if (fieldP.length() > lengthP) {
				fieldP = fieldP.substring(0, lengthP);
			}
		}
		return fieldP;
	}

	/**
	 * @description       : Creates a Map < Id, List<SObject> from a List based on parameter(s) provided
	 * @param sObjectListP sObjectListP this is our list of sObject records
	 * @param objectFieldNameP  objectFieldNameP this is our sObject field name which will become the map key
	 * @return Map<String, List<SObject>> : Map of objects with a String key
	 **/
	public static Map<String, List<SObject>> convertListToMapWithStringKey(List<SObject> sObjectListP, String objectFieldNameP) {
		Map<String, List<SObject>> sObjectMap = new Map<String, List<SObject>>();

		if (sObjectListP != null) {
			for (SObject sObjectRecord : sObjectListP) {
				String mapKeyString = (String) sObjectRecord.get(objectFieldNameP);

				if (!sObjectMap.containsKey(mapKeyString)) {
					List<SObject> sObjectList = new List<SObject>();

					sObjectList.add(sObjectRecord);
					sObjectMap.put(mapKeyString, sObjectList);
				} else {
					List<SObject> sObjectList = sObjectMap.get(mapKeyString);
					sObjectList.add(sObjectRecord);
				}
			}
		}

		return sObjectMap;
	}

	/**
	 * @description       : Gets record type Id based on parameter(s) provided
	 * @param recordTypeNameP recordTypeNameP this is the developer name of the record type
	 * @return Id if of the RecordType object
	 **/
	public static Id getRecordTypeId(String recordTypeNameP) {
		List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE DeveloperName = :recordTypeNameP LIMIT 1];

		if (recordTypeList != null && recordTypeList.size() > 0) {
			return recordTypeList[0].Id;
		} else {
			return null;
		}
	}

	//PJAIN: 20200421: Method to Query PriceBookEntry for the productId or create if not there
	/**
	 * @description       : getPriceBookEntryId
	 * @param productId
	 * @return Id 
	 **/
	public static Id getPriceBookEntryId(Id productId) {
		PriceBookEntry priceBookEntry;
		Id priceBookEntryId;
		Id stdPriceBookId;

		if (Test.isRunningTest()) {
			stdPriceBookId = Test.getStandardPricebookId();
		} else {
			stdPriceBookId = [SELECT Id FROM Pricebook2 WHERE isStandard = TRUE LIMIT 1].Id;
		}

		List<PriceBookEntry> priceBookEntryList = [SELECT Id FROM PriceBookEntry WHERE Product2Id = :productId AND PriceBook2Id = :stdPriceBookId];

		if (priceBookEntryList.size() > 0) {
			priceBookEntryId = priceBookEntryList.get(0).Id;
		} else {
			priceBookEntry = new PriceBookEntry();
			priceBookEntry.IsActive = true;
			priceBookEntry.Pricebook2Id = stdPriceBookId;
			priceBookEntry.Product2Id = productId;
			priceBookEntry.UnitPrice = 0;
			insert priceBookEntry;
			priceBookEntryId = priceBookEntry.Id;
		}

		return priceBookEntryId;
	}

	/**
	 * Tinashe M Shoko - 2020-08-05
	 * extractListIds description
	 *
	 * ## objects (List<SObject>): objects
	 * ## fieldName (String): fieldName
	 * ## removeNulls (Boolean): removeNulls
	 * @@ Return Set<Id>: Return description
	 */
	/**
	 * @description       : extractListIds
	 * @param objects
	 * @param fieldName
	 * @param removeNulls
	 * @return Set<Id>  
	 **/
	public static Set<Id> extractListIds(List<SObject> objects, String fieldName, Boolean removeNulls) {
		Set<Id> Ids = new Set<Id>();
		ID itemId;
		if (!objects.isEmpty() && objects.size() > 0 && objects != null) {
			for (SObject item : objects) {
				itemId = (Id) item.get(fieldName);
				if (!removeNulls || itemId != null) {
					Ids.add(itemId);
				}
			}
		}
		return Ids;
	}

	/**=================================================================================================================================
	 * Created By Eduardo Salia
	 * Created Date 26/10/2020
	 * Returns a Flag to determine if List is Populated
	 * Param 1: listValues is a List of SObject values
	 ===================================================================================================================================**/
	/**
	 * @description       : isListBlank
	 * @param listValues
	 * @return Boolean
	 **/
	 public static Boolean isListBlank(List<SObject> listValues) {
		return listValues == null || listValues.isEmpty();
	}

	// 20201016: Humbelani Denge
	/**
	 * @description       : getMultipleSelectOptions
	 * @param fieldList
	 * @return Map<String, List<CustomSelectOptions>>
	 **/
	@AuraEnabled
	public static Map<String, List<CustomSelectOptions>> getMultipleSelectOptions(List<String> fieldList) {
		Map<String, List<CustomSelectOptions>> customSelectOptionsMap = new Map<String, List<CustomSelectOptions>>();
		String objectName;
		String fieldName;
		List<String> currentFieldSplit;
		List<CustomSelectOptions> customSelectOptionsList;

		for (String currentField : fieldList) {
			currentFieldSplit = currentField.split('\\.');
			if (currentFieldSplit != null && currentFieldSplit.size() >= 2) {
				objectName = currentFieldSplit[0];
				fieldName = currentFieldSplit[1];

				Schema.sObjectType objectType = ((SObject) Type.forName('Schema', objectName).newInstance()).getSObjectType();
				Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
				List<Schema.PicklistEntry> picklistValues = fieldMap.get(fieldName).getDescribe().getPickListValues();
				customSelectOptionsList = new List<CustomSelectOptions>();

				for (Schema.PicklistEntry currentPicklistValue : picklistValues) {
					CustomSelectOptions customSelectOption = new CustomSelectOptions();
					customSelectOption.label = currentPicklistValue.getLabel();
					customSelectOption.value = currentPicklistValue.getValue();
					customSelectOptionsList.add(customSelectOption);
				}

				customSelectOptionsMap.put(currentField, customSelectOptionsList);
			}
		}
		return customSelectOptionsMap;
	}

	/**
	 * @description       : extractListValues
	 * @param objects
	 * @param fieldName
	 * @return List<String>
	 **/
	public static List<String> extractListValues(List<SObject> objects, String fieldName) {
		List<String> result = new List<String>();

		if (objects != null)
			for (SObject item : objects)
				if (item.get(fieldName) != null)
					result.add((String) item.get(fieldName));

		return result;
	}
}