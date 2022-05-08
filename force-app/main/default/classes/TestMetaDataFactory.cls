/**
 * @description       : Test Factory used to populate SObject based on the metadataReference
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
@isTest
public class TestMetaDataFactory {
	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-05
	 * @param objectName
	 * @param metadataReference
	 * @return string
	 **/
	public static string insertTestObject(String objectName, String metadataReference) {
		return insertTestObject(objectName, metadataReference, null);
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-06
	 * @param objectName
	 * @param metadataReference
	 * @param idFieldMappings
	 * @return string
	 **/
	public static string insertTestObject(String objectName, String metadataReference, Map<String, String> idFieldMappings) {
		TestObjectData__mdt metadataItem = getMetadata(objectName, metadataReference);
		SObject objectToInsert = getIdReplacedSObject(metadataItem.JSON__c, idFieldMappings);
		insert objectToInsert;
		return objectToInsert.Id;
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-06
	 * @param jsonString
	 * @param idFieldMappings
	 * @return SObject
	 **/
	private static SObject getIdReplacedSObject(string jsonString, Map<String, String> idFieldMappings) {
		SObject objectToInsert = (SObject) json.deserialize(jsonString, SObject.class);
		if (idFieldMappings != null) {
			for (string key : idFieldMappings.keySet()) {
				String idField = key;
				String idValue = idFieldMappings.get(key);
				objectToInsert.put(idField, idValue);
			}
		}
		return objectToInsert;
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-05
	 * @param objectName
	 * @param metadataReference
	 * @return String
	 **/
	public static String getRecordId(String objectName, String metadataReference) {
		return getRecordId(objectName,metadataReference,'');
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-05
	 * @param objectName
	 * @param metadataReference
	 * @param lookupFieldValue
	 * @return String
	 **/
	public static String getRecordId(String objectName, String metadataReference,String lookupFieldValue) {
		TestObjectData__mdt metadataItem = getMetadata(objectName, metadataReference);
		SObject objectToInsert = (SObject) JSON.deserialize(metadataItem.JSON__c, SObject.class);
		if(lookupFieldValue == null || lookupFieldValue == '' ){
			lookupFieldValue = (String) objectToInsert.get(metadataItem.lookupObjectField__c);
		}
		String strQuery =
			'SELECT Id, Name FROM ' +
			metadataItem.ObjectType__c +
			' WHERE ' +
			metadataItem.lookupObjectField__c +
			' = \'' +
			lookupFieldValue +
			'\' Limit 1';
		List<SObject> listData = Database.query(strQuery);
		return  listData[0].id;
	}


	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-05
	 * @param ProfileName
	 * @return BranchTHelperObject
	 **/
	public static User getUser(String ProfileName) {
		List<User> users = TestDataFactory.getTestUsers(ProfileName, 1);
		return users[0];
	}

	/**
	* @description getMetadata
	* @author PaulJohn.duRand@absa.africa | 2021-08-16
	* @param objectName
	* @param metadataReference
	* @return TestObjectData__mdt
	**/
	private static TestObjectData__mdt getMetadata(String objectName, String metadataReference) {
		TestObjectData__mdt metadataItem = [
			SELECT JSON__c, lookupObjectField__c, ObjectType__c
			FROM TestObjectData__mdt
			WHERE ObjectType__c = :objectName AND Label = :metadataReference
			LIMIT 1
		];
		return metadataItem;
	}

	/**
	* @description getRecordTypeId
	* @author PaulJohn.duRand@absa.africa | 2021-08-16
	* @param name
	* @return String
	**/
	public static String getRecordTypeId(String name) {
		Map<String, Schema.RecordTypeInfo>  accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	    String recordId = accountRecordTypeMap.get(name).getRecordTypeId();
		return recordId;
	}
}