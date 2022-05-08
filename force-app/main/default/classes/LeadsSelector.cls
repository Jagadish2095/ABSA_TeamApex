/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Leads object
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2019-01-31
 */
public class LeadsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Lead.sObjectType;
	}
	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Lead.Id,
			Lead.Name,
			Lead.FirstName,
			Lead.LastName,
			Lead.Id,
			Lead.Company,
			Lead.Email,
			Lead.Phone,
			Lead.MobilePhone,
			Lead.CreatedDate,
			Lead.Status,
            Lead.SubStatus__c,
			Lead.Preferred_Communication_Channel__c,
			Lead.Language_Preference__c,
			Lead.Manager__c,
			Lead.sd_Service_Group__c,
			Lead.RecordTypeId,
			Lead.sd_Response_Email_Address__c,
			Lead.Transfer_Count__c,
			Lead.Single_Transfer__c,
			Lead.OwnerId,
			Lead.DD_Mandatory_Fields_Completed__c,
			Lead.DD_Verification_Passed__c,
			Lead.DD_ITC_Passed__c,
			Lead.DD_Remove_from_Time_Dependent_Action__c,
			Lead.Lead_Email__c,
            Lead.Unsuccessful_Calls__c,
            Lead.DoNotCall,
            Lead.Marital_Status__c,
            Lead.DD_Marital_Contract_Type__c,
            Lead.DD_Marital_Status__c,
			Lead.Marital_Contract_Type__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	//override the sort method to sort by created date and accountId
	public override String getOrderBy() {
		return 'CreatedDate DESC';
	}
	/**
	 * @description selectByIdsWithActivityTracking description
	 *
	 * @param leadId (Set<Id>): leadIds
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectByLeadNumber(Id leadId) {
        return Database.query(
                newQueryFactory().
            			selectField('Id').
                        selectField('Lead_Ref_No__c').      
                        setCondition('Id = :leadId').
                        toSOQL()
        );
	}
	//get cases by id's
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectById(Set<Id> idSet) {
		return (List<Lead>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	//CUSTOM SELECTORS - START
	/**
	 * @description selectByAccountId description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectByAccountId(Set<Id> idSet, Integer recordLimit) {
		return (List<Lead>) Database.query(newQueryFactory().setCondition('FinServ__RelatedAccount__c IN :idSet').setLimit(recordLimit).toSOQL());
	}

	/**
	 * @description selectByLeadId description
	 *
	 * @param leadNumber (String): leadNumber
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectByLeadId(String leadNumber) {
		return Database.query(
			newQueryFactory()
				.selectField('Lead_Ref_No__c')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('OwnerId')
				.selectField('Company_Registration_Number__c')
				.selectField('Entity_Type__c')
				.selectField('MobilePhone')
				.selectField('Financial_Product__c')
				.selectField('CIF__c')
				.selectField('Is_Banker_From_ESTPM__c')
				.setCondition('Lead_Ref_No__c = :leadNumber')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdsWithActivityTracking description
	 *
	 * @param leadIds (Set<Id>): leadIds
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectByIdsWithActivityTracking(Set<Id> leadIds) {
		fflib_QueryFactory query = newQueryFactory(false)
			.selectField('Id')
			.selectField('Status')
			.selectField('Business_Hours__c')
			.selectField('sd_Track_Status_Changes__c')
			.setCondition('Id IN :leadIds');

		fflib_QueryFactory oliQueryFactory = query.subselectQuery('Activity_Tracking__r')
			.selectFields(new ActivityTrackingSelector().getSobjectFieldList())
			.setCondition('End_Time__c = null');

		return (List<Lead>) Database.query(query.toSOQL());
	}

	/**
	 * W-001774 : Saurabh
	 * @description Get all records where Lead owner has not looked at the record
	 *
	 * @param status
	 * @param recordLimit
	 * @param bussinessBankRecTypeId recordType
	 * @return List<Lead>
	 */
	public List<Lead> selectIsUnreadByOwner(Boolean status, Integer recordLimit, Id bussinessBankRecTypeId) {
		return Database.query(
			newQueryFactory()
				.selectField('OwnerId')
				.setCondition('isUnreadByOwner = :status and RecordtypeId = :bussinessBankRecTypeId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description selectCountByFromAndToAddress description
	 *
	 * @param fromAddress (String): fromAddress
	 * @param toAddress (String): toAddress
	 * @param timeThreshHold (DateTime): timeThreshHold
	 * @return Return Integer: Return description
	 */
	public Integer selectCountByFromAndToAddress(String fromAddress, String toAddress, DateTime timeThreshHold) {
		return [SELECT COUNT() FROM Lead WHERE Email = :fromAddress AND sd_Inbox_Name__c = :toAddress AND CreatedDate >= :timeThreshHold];
	}

	/**
	 * @description selectLeadById description
	 *
	 * @param leadIds (Set<Id>): leadIds
	 * @return Return List<lead>: Return description
	 */
	public List<lead> selectLeadById(Set<Id> leadIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Owner.name')
				.selectField('Owner.Email')
				.selectField('Lead_Email__c')
				.selectField('Owner_Type__c')
				.selectField('RecordTypeId')
				.selectField('Email')
                .selectField('FinServ__RelatedAccount__c')
				.selectField('AIC_Relationship_Consultant_Name__c')
				.setCondition('id in :leadIds')
				.toSOQL()
		);
	}

	/**
	 * W-008372 : Rob McLean
	 * @description Get all records where lead is still open and linked to a specifc user and account
	 *
	 * @param userId
	 * @param accountId
	 * @return List<Lead>
	 */
	public List<Lead> selectIsOpenByOwnerByAccount(Id userId, Id accountId) {
		String status = 'Closed';
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Status')
				.selectField('OwnerId')
				.selectField('FinServ__RelatedAccount__c')
				.selectField('Lead_Ref_No__c')
				.setCondition('OwnerId = :userId and FinServ__RelatedAccount__c = :accountId and Status != :status ')
				.toSOQL()
		);
	}

	// Added for DD STI Lead to retrieve cases assigned to Queue
	/**
	 * @description selectLeadsByQueueName description
	 *
	 * @param queuename (string): queuename
	 * @param campaignId (String): campaignId
	 * @return Return List<Lead>: Return description
	 */
	public List<Lead> selectLeadsByQueueName(string queuename, String campaignId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('OwnerId')
				.selectField('NO_UI_Owner_Name__c')
				.selectField('Owner_Type__c')
				.selectField('CreatedDate')
				.selectField('Owner.Name')
				.selectField('Status')
				.selectField('Direct_Delivery_Campaign__c')
				.setCondition('Owner.Name = :queuename and Direct_Delivery_Campaign__c = :campaignId')
				.toSOQL()
		);
	}

	//CUSTOM SELECTORS - END

	/**
	 * @description selectLeadById description
	 *
	 * @param leadId (String): leadId
	 * @return Return lead: Return description
	 */
	public lead selectLeadById(String leadId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Owner.name')
				.selectField('Owner')
				.selectField('Name')
				.selectField('MobilePhone')
				.selectField('Phone')
				.selectField('Email')
				.selectField('Parent_Account__c')
                .selectField('FinServ__RelatedAccount__c')
            	.selectField('FinServ__RelatedAccount__r.Titles__pc')// added for AIP
            	.selectField('RecordType.Name')// added for AIP
            	.selectField('RecordType.DeveloperName') // added for AIP
            	.selectField('FirstName')// added for AIP
            	.selectField('LastName')// added for AIP
            	.selectField('DD_AVAF_Account_Number__c')// added for AIP
            	.selectField('ID_Number__c') // added for AIP
            	.selectField('Title')
				.selectField('Preferred_Communication_Channel__c')
				.selectField('DD_Initials__c')
				.selectField('DD_Marital_Status__c')
				.selectField('ID_Type__c')
            	.selectField('CIF__c')
            	.selectField('DD_Existing_Products_Within_Absa__c')
            	.selectField('DD_Marketing_Consent__c')
				.selectField('DD_Gender__c')
				.selectField('DD_Source_of_Funds__c')
				.selectField('DD_Source_of_Income__c')
				.selectField('Converted__c')
				.selectField('Converted_Status_Date__c')
				.selectField('DD_Date_of_Birth__c')
				.selectField('RecordTypeId')
				.selectField('OwnerId')
				.selectField('DD_Verification_Passed__c')
				.selectField('DD_ITC_Passed__c')
				.selectField('Type_of_Asset_to_be_Insured__c')
				.selectField('Please_Specify__c')
				.selectField('Lead_Source__c')
				.selectField('STI_Sub_Source__c')
				.selectField('AIC_Relationship_Consultant_Name__c')
				.selectField('Lead_Name__c')
				.selectField('Lead_Email__c')
				.selectField('Parent_Contact_Id__c')
				.selectField('Parent_Opportunity__c')
				.selectField('Company_Registration_Number__c')
				.selectField('Language_Preference__c')
            	.selectField('Campaign__c')
            	.selectField('Direct_Delivery_Campaign__c')
            	.selectField('Direct_Delivery_Campaign__r.Name')
            	.selectField('Status')
            	.selectField('DD_Market_Value__c')
            	.selectField('Contract_Start_Date__c')
            	.selectField('Plan_type__c')
            	.selectField('Marital_status__c')
            	.selectField('Marital_Contract_Type__c')
            	.selectField('DD_Additional_Cell_Phone__c')
            	.selectField('DD_Work_Phone__c')
            	.selectField('DD_Home_Phone__c')
            	.selectField('Email')
            	.selectField('Vehicle_Name__c')
            	.selectField('DD_Premium__c')
            	.selectField('Description')
            	.selectField('DD_Vehicle_Year__c') 
            	.selectField('Name')
            	.selectField('Street')
            	.selectField('state') 
            	.selectField('city')
            	.selectField('postalcode')
            	.selectField('country')
            	.selectField('CreatedDate')
            	.selectField('Salutation')
				.setCondition('id = :leadId')
				.toSOQL()
		);
	}

	/**
	 * @param leadIds Id of the lead
	 *@description getLeadsById
	 * @return List of leads
	 */
	public List<Lead> getLeadsById(List<Id> leadIds) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('ID_Number__c')
				.selectField('CIF__c')
				.selectField('FinServ__RelatedAccount__c')
				.selectField('Closed_Date__c')
				.selectField('Salutation')
            	.selectField('Title')
				.selectField('Preferred_Communication_Channel__c')
				.selectField('DD_Initials__c')
				.selectField('DD_Marital_Status__c')
				.selectField('ID_Type__c')
				.selectField('FirstName')
				.selectField('LastName')
				.selectField('DD_Gender__c')
				.selectField('DD_Source_of_Funds__c')
				.selectField('DD_Source_of_Income__c')
				.selectField('Converted__c')
				.selectField('Converted_Status_Date__c')
				.selectField('DD_Date_of_Birth__c')
				.selectField('RecordTypeId')
				.selectField('OwnerId')
				.selectField('DD_Verification_Passed__c')
				.selectField('DD_ITC_Passed__c')
				.selectField('Type_of_Asset_to_be_Insured__c')
				.selectField('Please_Specify__c')
				.selectField('Lead_Source__c')
				.selectField('STI_Sub_Source__c')
				.selectField('AIC_Relationship_Consultant_Name__c')
				.selectField('Lead_Name__c')
				.selectField('Parent_Account__c')
				.selectField('Lead_Email__c')
				.selectField('Parent_Contact_Id__c')
				.selectField('Parent_Opportunity__c')
				.selectField('Company_Registration_Number__c')
				.selectField('Language_Preference__c')
				.selectField('Email')
				.selectField('Lead_Phone__c')
            	.selectField('Campaign__c')
            	.selectField('Direct_Delivery_Campaign__c')
            	.selectField('Direct_Delivery_Campaign__r.Name')
            	.selectField('Status')
            	.selectField('DD_Market_Value__c')
				.setCondition('id IN :leadIds')
				.toSOQL()
		);
	}
}