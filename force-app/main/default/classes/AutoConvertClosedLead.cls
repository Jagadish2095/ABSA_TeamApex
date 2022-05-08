/**
 * @description Class for converting closed leads
 * @author  Koketso Mpshane
 * @date    09/04/2020
 */
public class AutoConvertClosedLead {
	public final static String STI_REC_TYPE_LEAD = 'STI_Lead';
	public final static String STI_REC_TYPE_OPP = 'STI';
	public final static String DD_STI_OPP_VALUE_STAGE = 'In Progress';
	public final static String STI_OPP_VALUE_STAGE = 'New';
	public final static String DD_SALES_REC_TYPE_LEAD = 'Direct_Delivery_Sales_Lead';
	public final static String DD_STI_REC_TYPE_LEAD = 'DD_STI_Lead';
	public final static String DD_SALES_REC_TYPE_OPP = 'Direct_Delivery_Sales_Opportunity';
	public final static String DD_STI_REC_TYPE_OPP = 'DD_STI_Opportunity';
	public final static String OPP_VALUE_STAGE = 'Proposal';
	public final static String OPP_PROPOSAL_STAGE = 'Proposal';
	public final static String LEAD_SUB_STATUS_CONVERTED_TO_SALES = 'Converted to Sales Lead';
	public final static String LEAD_OBJ = Lead.SObjectType.getDescribe().name;
	public final static String OPPORTUNITY_OBJ = Opportunity.SObjectType.getDescribe().name;
    /* Vinay P : 06/11/2021: AHP Prodcut Changes*/
    //public final static String DD_AHP_REC_TYPE_LEAD = 'DD_AHP_Lead';
    //public final static String DD_AHP_REC_TYPE_OPP = 'DD_AHP_Opportunity';
    public final static String INV_REC_TYPE_LEAD = 'Investment_Lead';
    public final static String INV_REC_TYPE_OPP = 'Investment_Opportunity';
    public final static String INV_REC_TYPE_Lead_STI = 'STI_Lead';
	@TestVisible
	private static Boolean throwError = false;
	/**
	 * @description
	 */
	public class leadException extends Exception {
	}
	/**
	 * @description convertLead description
	 *
	 * @param leadIds (List<Id>): leadIds
	 */
	@InvocableMethod
	public static void convertLead(List<Id> leadIds) {
		try {
			//Get Recordtypes for conversion
			Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Map<String, Schema.RecordTypeInfo> oppRecordTypeMap = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Id ddSTILeadRecType = leadRecordTypeMap.get(DD_STI_REC_TYPE_LEAD).getRecordTypeId();
			Id directDeliveryLeadRecType = leadRecordTypeMap.get(DD_SALES_REC_TYPE_LEAD).getRecordTypeId();
			Id stiLeadRecType = leadRecordTypeMap.get(STI_REC_TYPE_LEAD).getRecordTypeId();
            //Id ddAHPLeadRecType = leadRecordTypeMap.get(DD_AHP_REC_TYPE_LEAD).getRecordTypeId();
			String invLeadRecType = RecordTypeIdController.getRecordTypeId(INV_REC_TYPE_LEAD, LEAD_OBJ);
			Database.LeadConvert leadConv = new Database.LeadConvert();
			leadConv.setLeadId(leadIds[0]);
			Lead leadRecord = new LeadsSelector().getLeadsById(leadIds)[0];
			List<Account> existingAccount = new List<Account>();
			AccountsSelector accSelector = new AccountsSelector();
			List<Id> personAccountIds = new List<Id>();
			personAccountIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId());
			personAccountIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId());
			//Added by Minal 2020-10-09
			//Try find existing person account based on CIF or ID number
			if (directDeliveryLeadRecType == leadRecord.RecordTypeId || leadRecord.RecordTypeId == ddSTILeadRecType) {
				if (leadRecord.DD_Remove_from_Time_Dependent_Action__c == false) {
					leadRecord.DD_Remove_from_Time_Dependent_Action__c = true;
					update leadRecord;
				}
				if (String.isNotEmpty(leadRecord.CIF__c)) {
					existingAccount = accSelector.selectByCIF(new Set<String>{ leadRecord.CIF__c }, 1);
					if (!existingAccount.isEmpty()) {
						existingAccount[0] = updateExistingAccountDetails(existingAccount[0], leadRecord, personAccountIds);
						update existingAccount[0];
					}
				}
				if (existingAccount.isEmpty()) {
					//Updating due to row limits faced on the account selector
					existingAccount = accSelector.searchByValueOnAllFields(leadRecord.ID_Number__c, 1);
					//Added by Minal
					//Compare values on the lead and person account, if there is a change update the account
					if (!existingAccount.isEmpty()) {
						existingAccount[0] = updateExistingAccountDetails(existingAccount[0], leadRecord, personAccountIds);
						update existingAccount[0];
					}
				}
			}
			//Added for VA STI
			//Will the parent account always contain a value?
			//WHy cant you find an existing account in the entire org?
			if (stiLeadRecType == leadRecord.RecordTypeId) {
				if (existingAccount.isEmpty()) {
					existingAccount = [SELECT Id FROM Account WHERE id = :leadRecord.Parent_Account__c];
				}
			}
			if (stiLeadRecType == leadRecord.RecordTypeId) {
				leadConv.setConvertedStatus('Converted'); //Status IsConverted must be true
            } else if(leadRecord.RecordTypeId == ddSTILeadRecType){
                leadConv.setConvertedStatus('Closed');
            }
            else if(leadRecord.Direct_Delivery_Campaign__c != null){
                   if(leadRecord.Direct_Delivery_Campaign__r.Name.contains('Upgrade')){
						leadConv.setConvertedStatus(leadRecord.Status); //Status IsConverted must be true
            		}
                	else {
						leadConv.setConvertedStatus('Closed'); //Status IsConverted must be true
					}
			}else {
				leadConv.setConvertedStatus('Closed'); //Status IsConverted must be true
			}
            //Added for VA Investment Lead
            if(invLeadRecType == leadRecord.RecordTypeId){
            	if(existingAccount.isEmpty()) {
            		existingAccount = [Select Id from Account where id = :leadRecord.Parent_Account__c ];
            	}
            	leadConv.setConvertedStatus('Converted');//Status IsConverted must be true
            }
			if (leadRecord.FinServ__RelatedAccount__c != null && stiLeadRecType != leadRecord.RecordTypeId) {
				leadConv.setAccountId(leadRecord.FinServ__RelatedAccount__c);
			} else if ((directDeliveryLeadRecType == leadRecord.RecordTypeId || leadRecord.RecordTypeId == ddSTILeadRecType) && !existingAccount.isEmpty()) {
				leadConv.setAccountId(existingAccount[0].Id);
			} else if (stiLeadRecType == leadRecord.RecordTypeId && !existingAccount.isEmpty()) {
				//PLease explain this logic because above you set the account id
				Account accRecord = accSelector.selectAccountPhoneDetailsByID(existingAccount[0].Id);
				if (personAccountIds.contains(accRecord.RecordTypeId)) {
					leadConv.setAccountId(existingAccount[0].Id);
				} else {
					if (leadRecord.Parent_Account__c != null && leadRecord.Parent_Contact_Id__c != null) {
						leadConv.setAccountId(leadRecord.Parent_Account__c);
						leadConv.setContactId(leadRecord.Parent_Contact_Id__c);
					}
				}
			}
			else if(invLeadRecType == leadRecord.RecordTypeId && !existingAccount.isEmpty()){
				Account accRecord = accSelector.selectAccountPhoneDetailsByID(existingAccount[0].Id);
				if(personAccountIds.contains(accRecord.RecordTypeId)){
					leadConv.setAccountId(existingAccount[0].Id);
				}else{
					if(leadRecord.Parent_Account__c != null && leadRecord.Parent_Contact_Id__c!= null){
						leadConv.setAccountId(leadRecord.Parent_Account__c);
						leadConv.setContactId(leadRecord.Parent_Contact_Id__c);
					}
				}
			}
			Database.LeadConvertResult leadConvRes = Database.convertLead(leadConv);
			if (leadConvRes.isSuccess()) {
				//Added by Minal 2020-10-09
				// Created condition to create opportunities for Direct Delivery specific record type
				if (directDeliveryLeadRecType == leadRecord.RecordTypeId || leadRecord.RecordTypeId == ddSTILeadRecType) {
					Id newOppId = leadConvRes.getOpportunityId();
					Opportunity convertedOpp = [
						SELECT Id, OwnerId, Name, RecordTypeId, ID_Number__c, Opportunity_Number__c, CampaignId
						FROM Opportunity
						WHERE Id = :newOppId
					];
					Id directDeliveryOppRecType = oppRecordTypeMap.get(DD_SALES_REC_TYPE_OPP).getRecordTypeId();
					Id ddSTIOppRecType = oppRecordTypeMap.get(DD_STI_REC_TYPE_OPP).getRecordTypeId();
                    //Id ddAHPOppRecType = oppRecordTypeMap.get(DD_AHP_REC_TYPE_OPP).getRecordTypeId();   
					String newOppName;
					String campaignName = '';
					String oppNumber = convertedOpp.Opportunity_Number__c;
					if (convertedOpp.CampaignId != null) {
						campaignName = [SELECT Name FROM Campaign WHERE Id = :convertedOpp.CampaignId].Name;
						newOppName = convertedOpp.Name + ' - ' + oppNumber + ' (' + campaignName + ')';
					} else {
						newOppName = convertedOpp.Name + ' - ' + oppNumber;
					}
					//Added by Minal 2020-10-09
					//Updating record type off Opportunity to Direct Delivery Sales Opportunity
					// Standard fields cannot be mapped so updating through Apex
					if (leadRecord.RecordTypeId == directDeliveryLeadRecType) {
						convertedOpp.RecordTypeId = directDeliveryOppRecType;
						convertedOpp.StageName = OPP_VALUE_STAGE;
					} else if (leadRecord.RecordTypeId == ddSTILeadRecType) {
						convertedOpp.RecordTypeId = ddSTIOppRecType;
						convertedOpp.StageName = DD_STI_OPP_VALUE_STAGE;
                        convertedOpp.Lead_Id__c = leadRecord.Id;// Added for Portal Applicaton
                        convertedOpp.Marital_Status__c = leadRecord.Marital_Status__c;// Added for Portal Applicaton
                        convertedOpp.STIMarital_Contract_Type__c = leadRecord.DD_Marital_Contract_Type__c;


                        leadRecord.Status = 'Closed';                       
					}
                    /*else if (leadRecord.RecordTypeId == ddAHPLeadRecType) {
						convertedOpp.RecordTypeId = ddAHPOppRecType;
						convertedOpp.StageName = DD_STI_OPP_VALUE_STAGE;
					}   */
					convertedOpp.Name = newOppName;
					convertedOpp.OwnerId = leadRecord.OwnerId;
					convertedOpp.Converted_Lead__c = leadRecord.Id;
					update convertedOpp;
					if (existingAccount.isEmpty()) {
						//Added by Minal 2020-10-09
						// Standard fields cannot be mapped so updating through Apex
						Id newAccountId = leadConvRes.getAccountId();
						Account convertedAccount = [SELECT Id, PersonBirthdate, Converted_Lead__pc FROM Account WHERE Id = :newAccountId];
						convertedAccount.PersonBirthdate = leadRecord.DD_Date_of_Birth__c;
						convertedAccount.Converted_Lead__pc = leadRecord.Id;
						update convertedAccount;
					}
					//set Lead Substatus
					leadRecord.SubStatus__c = LEAD_SUB_STATUS_CONVERTED_TO_SALES;
				}
				//Added for VA STI
				if ((String.isNotBlank(stiLeadRecType) && stiLeadRecType == leadRecord.RecordTypeId) || (invLeadRecType !='' && invLeadRecType == leadRecord.RecordTypeId)) {
					//duplication of code
					Id newOppId = leadConvRes.getOpportunityId();
					Opportunity convertedOpp = [
						SELECT
							Id,
							OwnerId,
							Type_Of_Asset__c,
							Lead_Sub_Source_VA_STI__c,
							Other_Asset__c,
							Lead_Source_VA_STI__c,
							STI_CIF__c,
							AIC_Relationship_Consultant_Name__c,
							Lead_Originator__c,
							Lead_Originator_Phone__c,
							STI_Phone__c,
							Lead_Originator_Email__c,
							Name,
							Company_Registration_Number__c,
							Preferred_Language__c,
							VA_STI_Email__c,
							Preferred_Communication_Channel__c,
							RecordTypeId,
							ID_Number__c,
							Opportunity_Number__c,
							CampaignId
						FROM Opportunity
						WHERE Id = :newOppId
					];
					String stiOppRecType = RecordTypeIdController.getRecordTypeId(STI_REC_TYPE_OPP, OPPORTUNITY_OBJ);
					String invOppRecType = RecordTypeIdController.getRecordTypeId(INV_REC_TYPE_OPP, OPPORTUNITY_OBJ);
					String newOppName;
					String campaignName = '';
					String oppNumber = convertedOpp.Opportunity_Number__c;
					if (convertedOpp.CampaignId != null) {
						campaignName = [SELECT Name FROM Campaign WHERE Id = :convertedOpp.CampaignId].Name;
						newOppName = convertedOpp.Name + ' - ' + oppNumber + ' (' + campaignName + ')';
					} else {
						newOppName = convertedOpp.Name + ' - ' + oppNumber;
					}
					// Why are the fields being manually mapped?
						if (stiOppRecType != '' || invOppRecType !='') {
							if(stiLeadRecType == leadRecord.RecordTypeId)
							convertedOpp.RecordTypeId = stiOppRecType;
						else
						{
						convertedOpp.RecordTypeId = invOppRecType;
						convertedOpp.Sys_BypassValidation__c = true;
						}
						convertedOpp.Name = newOppName;
						convertedOpp.StageName = STI_OPP_VALUE_STAGE;
						convertedOpp.OwnerId = leadRecord.OwnerId;
						convertedOpp.Converted_Lead__c = leadRecord.Id;
						convertedOpp.STI_Client_Name__c = leadRecord.Name;
						convertedOpp.Company_Registration_Number__c = leadRecord.Company_Registration_Number__c;
						convertedOpp.Preferred_Language__c = leadRecord.Language_Preference__c;
						convertedOpp.VA_STI_Email__c = leadRecord.Email;
						convertedOpp.Preferred_Communication_Channel__c = leadRecord.Preferred_Communication_Channel__c;
						convertedOpp.STI_CIF__c = leadRecord.CIF__c;
						convertedOpp.Lead_Originator_Email__c = leadRecord.Lead_Email__c;
						convertedOpp.Lead_Originator_Phone__c = leadRecord.Lead_Phone__c;
						convertedOpp.STI_Phone__c = leadRecord.Phone;
						convertedOpp.AIC_Relationship_Consultant_Name__c = leadRecord.AIC_Relationship_Consultant_Name__c;
						convertedOpp.Lead_Originator__c = leadRecord.Lead_Name__c;
						convertedOpp.Type_Of_Asset__c = leadRecord.Type_of_Asset_to_be_Insured__c;
						convertedOpp.Other_Asset__c = leadRecord.Please_Specify__c;
						convertedOpp.Lead_Source_VA_STI__c = leadRecord.Lead_Source__c;
						convertedOpp.Lead_Sub_Source_VA_STI__c = leadRecord.STI_Sub_Source__c;
						update convertedOpp;
					}
					//is this needed for VA?
					if (existingAccount.isEmpty()) {
						Id newAccountId = leadConvRes.getAccountId();
						Account convertedAccount = [SELECT Id, PersonBirthdate, Converted_Lead__pc FROM Account WHERE Id = :newAccountId];
						convertedAccount.PersonBirthdate = leadRecord.DD_Date_of_Birth__c;
						update convertedAccount;
					}
					//set Lead Substatus
					leadRecord.SubStatus__c = LEAD_SUB_STATUS_CONVERTED_TO_SALES;
				}
				leadRecord.Converted__c = 'YES';
				leadRecord.Converted_Status_Date__c = system.now();
				leadRecord.Closed_Date__c = system.now();
				update leadRecord;
				if (Test.isRunningTest() && throwError == true) {
					throw new system.DmlException();
				}
			} else {
				for (Database.Error err : leadConvRes.getErrors()) {
					AuditTrailLog.logException(
						new DMLException(),
						'New',
						'Error',
						'AutoConvertClosedLead',
						'convertLead',
						'There was an error converting a lead record\n ' + err.getMessage()
					);
				}
			}
		} catch (Exception ex) {
			AuditTrailLog.logException(
				new DMLException(),
				'New',
				'Error',
				'AutoConvertClosedLead',
				'convertLead',
				'There was an error converting a lead record\n ' + ex.getMessage()
			);
			throw new leadException(
				'There was an error converting the lead in AutoConvertClosedLead ' +
				ex.getMessage() +
				'Line: ' +
				ex.getLineNumber() +
				' Cause :' +
				ex.getCause() +
				'  type:' +
				ex.getTypeName(),
				ex
			);
		}
	}
	/**
	 * @description Method to update existing account details as we assume the information from the lead is the most up to date
	 * @param existingAccount existing account found
	 * @param leadRecord the lead record
	 * @param personAccountIds list of person account Ids
	 *
	 * @return account record for update
	 */
	private static Account updateExistingAccountDetails(Account existingAccount, Lead leadRecord, List<Id> personAccountIds) {
		if (String.isNotBlank(leadRecord.Preferred_Communication_Channel__c)) {
			if (
				(existingAccount.Preferred_Communication_Method__pc != leadRecord.Preferred_Communication_Channel__c ||
				String.isBlank(existingAccount.Preferred_Communication_Method__pc)) && personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.Preferred_Communication_Method__pc = leadRecord.Preferred_Communication_Channel__c;
			}
		}
		if (String.isNotBlank(leadRecord.DD_Initials__c)) {
			if (
				(existingAccount.Initials__pc != leadRecord.DD_Initials__c || String.isBlank(existingAccount.Initials__pc)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.Initials__pc = leadRecord.DD_Initials__c;
			}
		}
		if (leadRecord.DD_Date_of_Birth__c != null) {
			if (
				(existingAccount.PersonBirthdate != leadRecord.DD_Date_of_Birth__c || existingAccount.PersonBirthdate == null) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.PersonBirthdate = leadRecord.DD_Date_of_Birth__c;
			}
		}
		if (String.isNotBlank(leadRecord.FirstName)) {
			if (
				(existingAccount.FirstName != leadRecord.FirstName || String.isBlank(existingAccount.FirstName)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.FirstName = leadRecord.FirstName;
			}
		}
		if (String.isNotBlank(leadRecord.LastName)) {
			if (
				(existingAccount.LastName != leadRecord.LastName || String.isBlank(existingAccount.LastName)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.LastName = leadRecord.LastName;
			}
		}
		if (String.isNotBlank(leadRecord.DD_Marital_Status__c)) {
			if (
				(existingAccount.Marital_Status__pc != leadRecord.DD_Marital_Status__c || String.isBlank(existingAccount.Marital_Status__pc)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.Marital_Status__pc = leadRecord.DD_Marital_Status__c;
			}
		}
		if (String.isNotBlank(leadRecord.DD_Gender__c)) {
			if (
				(existingAccount.Gender__pc != leadRecord.DD_Gender__c || String.isBlank(existingAccount.Gender__pc)) &&
				personAccountIds.contains(existingAccount.RecordTypeId) && 
                (existingAccount.FinServ__Gender__pc != leadRecord.DD_Gender__c || String.isBlank(existingAccount.FinServ__Gender__pc)))
			{
				existingAccount.Gender__pc = leadRecord.DD_Gender__c;
                existingAccount.FinServ__Gender__pc = leadRecord.DD_Gender__c;
			}
		}
		if (String.isNotBlank(leadRecord.ID_Type__c)) {
			if ((String.isBlank(existingAccount.ID_Type__pc)) && personAccountIds.contains(existingAccount.RecordTypeId)) {
				existingAccount.ID_Type__pc = leadRecord.ID_Type__c;
			}
		}
		if (String.isNotBlank(leadRecord.Salutation)) {
			if ((String.isBlank(existingAccount.Salutation)) && personAccountIds.contains(existingAccount.RecordTypeId)) {
				existingAccount.Salutation = leadRecord.Salutation;
			}
		}
		if (String.isNotBlank(leadRecord.DD_Source_of_Funds__c)) {
			if (
				(existingAccount.DD_Source_of_Funds__pc != leadRecord.DD_Source_of_Funds__c || String.isBlank(existingAccount.DD_Source_of_Funds__pc)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.DD_Source_of_Funds__pc = leadRecord.DD_Source_of_Funds__c;
			}
		}
		if (String.isNotBlank(leadRecord.DD_Source_of_Income__c)) {
			if (
				(existingAccount.Income_Source__pc != leadRecord.DD_Source_of_Income__c || String.isBlank(existingAccount.Income_Source__pc)) &&
				personAccountIds.contains(existingAccount.RecordTypeId)
			) {
				existingAccount.Income_Source__pc = leadRecord.DD_Source_of_Income__c;
			}
		}
        // Added for sending SMS on updated phone number for DD
        if (leadRecord.MobilePhone != '') {
			if (existingAccount.PersonMobilePhone != leadRecord.MobilePhone && personAccountIds.contains(existingAccount.RecordTypeId)) {
				existingAccount.PersonMobilePhone = leadRecord.MobilePhone;
			}
		}
		// Added for sending Email on updated email address for DD
        if (leadRecord.Email != '') {
			if (existingAccount.PersonEmail != leadRecord.Email && personAccountIds.contains(existingAccount.RecordTypeId)) {
				existingAccount.PersonEmail = leadRecord.Email;
			}
		}
		existingAccount.Converted_Lead__pc = leadRecord.Id;
		return existingAccount;
	}
}