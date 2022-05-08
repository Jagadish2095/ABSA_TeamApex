/**
 * @description Controller for Documents Generate Lightning component
 * @author Vladimir Panajic
 * @created 2019-09-19
 */
public class DocumentsGenerateControler{
	/**
	 * @description getDocumentSelectOptions
	 * @author Vladimir Panajic
	 * Gets the LOVs for Document input field
	 *
	 * @param fld
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getDocumentSelectOptions(string fld){
		List<String> allOpts = new list<String>();
		Document__c document = new Document__c();
		Schema.sObjectType objType = document.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : values){
			allOpts.add(a.getValue());
		}
		allOpts.sort();
		return allOpts;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Gets the LOVs for Document input field
	 *
	 * @param opprtunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getDocumentGenerationOption(Id opprtunityId){
		List<String> allOpts = new list<String>();

		return allOpts;
	}

	/**
	 * @description generateDocument description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param templateName (String): templateName
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateDocument(Id opportunityId, String templateName){
		//templateName = DOCUMENT_TYPES.get(templateName);
		List<SignatureRequest__c> signatureRequests = new List<SignatureRequest__c>();
		return GenerateDocument.generateTheDocument(opportunityId, templateName, signatureRequests);
	}

	/**
	 * @description generateNewDocument description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param templateName (String): templateName
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateNewDocument(Id opportunityId, String templateName){
		//templateName = DOCUMENT_TYPES.get(templateName);
		List<SignatureRequest__c> signatureRequests = new List<SignatureRequest__c>();
		return GenerateDocument.generateNewDocument(opportunityId, templateName, signatureRequests);
	}

	/**
	 * @author Vladimir Panajic
	 * @description Generates a document for the input type and links it to the input opportunity
	 *
	 * @param opportunityId
	 * @param documentType
	 */
	@AuraEnabled
	public static void generateDocumentNow(Id opportunityId, String documentType){
		List<Opportunity> opportunity = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		if (documentType == 'FAIS Disclosure'){
			Set<Id> opportunityAccountIds = new Set<Id>();
			Set<Id> opportunityOwnerIds = new Set<Id>();
			Map<Id, Account> account = new Map<Id, Account>([SELECT Id, PersonTitle, FirstName, LastName, CIF__c
			                                                 FROM Account
			                                                 WHERE Id = :opportunity.get(0).AccountId]);
			Map<Id, User> user = new Map<Id, User>(new UsersSelector().selectByOpportunityOwnerId(opportunity.get(0).OwnerId));

			Map<Id, Conflict_of_Interest__c> coiMap = new Map<Id, Conflict_of_Interest__c>();
			List<Conflict_of_Interest__c> coi = [SELECT Id, User__c, Has_Personal_COI__c, Personal_Conflict_of_Interest__c
			                                     FROM Conflict_of_Interest__c
			                                     WHERE User__c = :opportunity.get(0).OwnerId];

			for (Conflict_of_Interest__c c : coi){
				if (opportunity.get(0).OwnerId == c.User__c){
					coiMap.put(opportunity.get(0).OwnerId, c);
				}
			}

			//Generate FAIS XML
			Map<Id, sObject> objectMap = new Map<Id, sObject>();
			objectMap.put(account.get(opportunity.get(0).AccountId).Id, account.get(opportunity.get(0).AccountId));
			objectMap.put(user.get(opportunity.get(0).OwnerId).Id, user.get(opportunity.get(0).OwnerId));
			if (!coiMap.keyset().isEmpty() && coiMap.keyset().size() > 0 && coiMap.keyset() != null){
				objectMap.put(coiMap.get(opportunity.get(0).OwnerId).Id, coiMap.get(opportunity.get(0).OwnerId));
			}

			Map<String, String> lookupMappings = new Map<String, String>();
			lookupMappings.put('User.FAIS_Categories__c', 'Adviser__c');
			lookupMappings.put('User.FAIS_Qualification__c', 'User__c');
		}
	}

	/**
	 * @description generateContentRequest description
	 *
	 * @param fileName (String): fileName
	 * @param templateId (String): templateId
	 * @param ecmType (String): ecmType
	 * @param cifNum (String): cifNum
	 * @param accNum (String): accNum
	 * @param xmlTemplate (String): xmlTemplate
	 * @return CC_GenerateContentRequest: Return description
	 */
	public static CC_GenerateContentRequest generateContentRequest(String fileName, String templateId, String ecmType, String cifNum, String accNum, String xmlTemplate){
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();
		request.FileName = fileName;
		request.TemplateDataType = 'XML';
		request.LogLevel = 'Debug';
		request.ScheduleTimeStamp = String.valueOf(Date.today());
		request.RecordSystemFeedbackID = '123';
		request.ContentRequestType = 'PDF';
		request.ContentStoreType = 'ECM';
		request.ContentVersion = '1.0.0.0';
		request.Password = '';
		request.encodingType = '';
		request.ReturnEmptyContent = true;
		request.TemplateID = templateId;

		List<CC_GenerateContentRequest.ContentStoreParams> cspList = new List<CC_GenerateContentRequest.ContentStoreParams>();
		CC_GenerateContentRequest.ContentStoreParams params = new CC_GenerateContentRequest.ContentStoreParams();

		params.ItemType = 'Origin';
		params.ItemValue = 'Sales-Force Wimmi';
		cspList.add(params);

		params = new CC_GenerateContentRequest.ContentStoreParams();
		params.ItemType = 'ECMItemType';
		params.ItemValue = ecmType;
		cspList.add(params);

		params = new CC_GenerateContentRequest.ContentStoreParams();
		params.ItemType = 'BusinessUnit';
		params.ItemValue = 'Virtual Advisor';
		cspList.add(params);

		params = new CC_GenerateContentRequest.ContentStoreParams();
		params.ItemType = 'CIFNumer';
		params.ItemValue = cifNum;
		cspList.add(params);

		params = new CC_GenerateContentRequest.ContentStoreParams();
		params.ItemType = 'AccNumber';
		params.ItemValue = accNum;
		cspList.add(params);

		request.contentStoreParamaters = cspList;
		request.templateData = xmlTemplate;

		return request;
	}

	/**
	 * @description Method that checks if the casa screening has been done on init
	 *
	 * @param oppId - opportunity Id
	 * @return String - casa status i.e. valid, invalid etc.
	 */
	@AuraEnabled
	public static String checkCASAValidity(Id oppId){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

		//return opportunities.get(0).CASA_Status__c;
		return 'Valid';
	}
}