/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Case objects
 *
 * @author  Rudolf Niehaus - CloudSmiths
 * @since   2018-07-17
 */
public class CasesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Case.sObjectType;
	}
	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Case.AccountId,
			Case.Id,
			Case.CaseNumber,
			Case.Status,
			Case.Reason,
			Case.Subject,
			Case.isClosed,
			Case.OwnerId,
			Case.Owner.Type,
			Case.Origin,
			Case.ContactId,
			Case.ParentId,
			Case.RecordTypeId,
			Case.LastModifiedDate,
			Case.CreatedDate,
			Case.Email_From_Address__c,
			Case.Email_From_Name__c,
			Case.Communication_Method__c,
			Case.Phone__c,
			Case.Mobile__c,
			Case.Email__c,
			Case.Postal_Address__c,
			Case.Incident_Date__c,
			Case.Expectation_of_the_Customer__c,
			Case.Deposit_Type__c,
			Case.Resolved_in_Favour_of__c,
			Case.Summary_of_Resolution__c,
			Case.Originated_By__c,
			Case.Service_Group_Search__c,
			Case.sd_Service_Group_Id__c,
			Case.Response_Body__c,
			Case.Extended_Request_Data__c,
			Case.Consultant_Notes_Comments__c,
			Case.Request_From_Absa_Business_Client__c,
			Case.Account_Conduct_Checked__c,
			Case.Account_Number_Confirmed__c,
			Case.Reference_Number__c,
			Case.Email_Address_Confirmed__c,
			Case.Request_From_Financial_Institution__c,
			Case.Name_Confirmed__c,
			Case.User_Type_Confirmed__c,
			Case.Working_History__c,
			Case.AB_number__c,
			Case.Request_Type__c,
			Case.ClosedDate,
			Case.Bank_Code_1__c,
			Case.Bank_Code_2__c,
			Case.Type__c,
			Case.Reason_Combination__c,
			Case.BusinessHoursId,
			Case.SLA_Extension_Approval__c,
			Case.External_SLA_Warning_Date__c,
			Case.External_SLA_End_Date__c,
			Case.Customer_Full_Name__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	//override the sort method to sort by created date and accountId
	public override String getOrderBy() {
		return 'CreatedDate DESC, AccountId';
	}
	//get cases by id's
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectById(Set<Id> idSet) {
		return (List<Case>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	//CUSTOM SELECTORS - START
	/**
	 * @description selectByAccountId description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByAccountId(Set<Id> idSet, Integer recordLimit) {
		return (List<Case>) Database.query(
			newQueryFactory()
				.selectField('Account.Name')
				.selectField('Subject')
				.selectField('RecordType.Name')
				.setCondition('AccountId IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
	/** Return Cases by Account Id's
	 * Custom selector USING the
	 * @description Base class queryFactory
	 *
	 * @param idSet Set<Id> Account Id's
	 * @param recordTypeId
	 * @return List<Case>
	 */
	public List<Case> selectByAccountIdSet(Set<Id> idSet, Id recordTypeId) {
		return (List<Case>) Database.query(
			newQueryFactory()
				.selectField('Account.Name')
				.selectField('AccountId')
				.selectField('Subject')
				.selectField('RecordType.Name')
				.setCondition('AccountId IN :idSet AND RecordType.Id=:recordTypeId')
				.toSOQL()
		);
	}

	/** Return Cases by Account Id's
	 * Custom selector USING the
	 * @description Base class queryFactory
	 *
	 * @param idSet Set<Id> Account Id's
	 * @param recordTypeId
	 * @param caseStatus
	 * @param caseCategory
	 * @description
	 * @return List<Case>
	 * @author : PRavin W.
	 * @date : 2021/07/19
	 */
	public List<Case> selectByAccountIdSetByCaseStatus(Set<Id> idSet, Id recordTypeId, string caseStatus, String caseCategory) {
		return (List<Case>) Database.query(
			newQueryFactory()
				.selectField('Account.Name')
				.selectField('AccountId')
				.selectField('Subject')
				.selectField('RecordType.Name')
				.setCondition('AccountId IN :idSet AND RecordType.Id=:recordTypeId AND Status =:caseStatus AND Category__c =: caseCategory')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdWithAccountInfo description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithAccountInfo(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Account.Name')
				.selectField('Account.AccountNumber')
				.selectField('Account.Owner.Name')
				.selectField('Account.Data_Privacy_Flag__c') // Added by: Ashish, @desc: for Data Privacy Stories, @ref: W-012769
				.selectField('Account.CIF__c') // Added by: Ashish, @desc: for Data Privacy Stories, @ref: W-012769
				.selectField('AccountId') // Added by: Ashish, @desc: for Data Privacy Stories, @ref: W-012769
				.setCondition('Id IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdWithSLAInfo description
	 *
	 * @param caseId (Id): caseId
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithSLAInfo(Id caseId, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('AccountId')
				.selectField('BusinessHoursId')
				.selectField('CreatedDate')
				.selectField('RecordTypeId')
				.selectField('Status')
				.selectField('RecordType.Name') // Added for NBFS Record Type
				.selectField('ClosedDate') // Added for NBFS Record Type
				.selectField('OwnerId') // Added for NBFS Record Type
				.selectField('is_level_1_SLA_done__c') // Added for NBFS Record Type
				.selectField('NBFS_Category__c') // Added for NBFS Record Type
				.selectField('Internal_SLA_Warning_Date__c')
				.selectField('Internal_SLA_End_Date__c')
				.selectField('External_SLA_Warning_Date__c')
				.selectField('External_SLA_End_Date__c')
				.selectField('SLA_Extension_Reason__c')
				.selectField('Extended_SLA_End_Date__c')
				.selectField('Extended_Warning_SLA_End_Date__c')
				.selectField('SLA_Extension_Approval_Required__c')
				.selectField('Max_SLA_Extension_Date__c')
				.selectField('Type__c')
				.selectField('sd_Pause_Statuses__c')
				.selectField('sd_Response_Email_Address__c')
				.selectField('sd_Original_Service_Group__c')
				.selectField('sd_Service_Group_Id__c')
				.selectField('sd_Service_Level_Id__c')
				.selectField('sd_Service_Group_Type_Id__c')
				.selectField('sd_Service_Type__c')
				.selectField('sd_Service_Type_Id__c')
				.selectField('sd_Service_Group__c')
				.selectField('sd_Email_Template_Case_Classification__c')
				.selectField('sd_Email_Template_Case_Closure__c')
				.selectField('sd_Email_Template_Case_Creation__c')
				.selectField('sd_Email_Rule_Template__c')
				.selectField('sd_Inbox_Name__c')
				.selectField('Email_From_Address__c')
				.selectField('Subject')
				.selectField('Description')
				.selectField('Subtype__c')
				.selectField('Service_Type_Search__c')
				.selectField('Service_Group_Search__c')
				.selectField('Sub_Type_Search__c')
				.selectField('Who_Caused_It__c')
				.selectField('Case_Record_Type_Name__c')
				.selectField('OwnerId')
				.selectField('ClosedDate')
				.selectField('RecordType.Name')
				.selectField('ID_Type__c')
				.selectField('Customer_ID__c')
				.selectField('Application_Product_Id__c') //Added By Himani Joshi
				.selectField('CaseNumber') //Added By Himani Joshi
				.selectField('Product__c') //Added by Raviteja
				.selectField('Relationship_Banker__c') //Added by Raviteja
				.selectField('Relationship_Banker__r.Name') //Added by Raviteja
				.selectField('RecordType.DeveloperName')
				.selectField('Owner.Email')
				.selectField('ContactId')
				.selectField('Case_Ownership__c') //Added by Raviteja
				.selectField('DD_Case_Outcome__c') //Ashok added for AIP
				.selectField('Related_Business_Area__c') //Ashok added for AIP
				.selectField('Category__c') //Ashok added for AIP
				.selectField('Product_Provider__c')
				.setCondition('Id = :caseId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
	/**
	 * @description selectByIdWithDecisionHistoryTracking description
	 *
	 * @param caseIds (Set<Id>): caseIds
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithDecisionHistoryTracking(Set<Id> caseIds) {
		fflib_QueryFactory query = newQueryFactory(false)
			.selectField('Id')
			.selectField('OwnerId')
			.selectField('BusinessHoursId')
			.selectField('Owner_User_Name__c')
			.selectField('Owner_Queue_Name__c')
			.selectField('Status')
			.selectField('Subtype__c')
			.selectField('Type__c')
			.selectField('IsClosed')
			.selectField('Opportunity__c')
			.selectField('Opportunity__r.Opportunity_Number__c') //Added by gulafsha for W-013655
			.selectField('Account.Name') //Added by gulafsha for W-013655
			.setCondition('Id IN :caseIds');
		// Comment By Himanshu Need to uncomment
		//fflib_QueryFactory oliQueryFactory = query.subselectQuery('Decision_Histories__r').selectFields(new DecisionHistoriesSelector().getSobjectFieldList());

		return (List<Case>) Database.query(query.toSOQL());
	}

	/*
	 * Return Cases by Id's with Account information
	 * Custom selector USING the Base class queryFactory
	 *
	 * @param idSet Set<Id> Account Id's
	 * @param recordLimit Integer max records to return
	 * @return List<Case>
	 */
	/**
	 * @description selectByIdForSitesUser description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdForSitesUser(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Status')
				.selectField('Client_Feedback__c')
				.setCondition('Id IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
	/**
	 * @description selectByIdWithClassification description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithClassification(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory(true)
				.selectField('ParentId')
				.selectField('Type__c')
				.selectField('Subtype__c')
				.selectField('Product__c')
				.selectField('RecordTypeId')
				.selectField('External_SLA_Status__c')
				.selectField('Unresolved_Reason__c')
				.selectField('sd_Email_Template_Case_Classification__c')
				.selectField('sd_Email_Template_Case_Closure__c')
				.selectField('sd_Email_Template_Case_Creation__c')
				.selectField('Owner_Queue_Name__c')
				.selectField('sd_Service_Group__c') // Added to fetch the service group of the NBFS case
				.selectField('NBFS_Category__c') // Added to fetch the category of the NBFS case
				.selectField('Source__c') // Added to fetch the source of the NBFS case
				.selectField('Claim_Amount__c') // Added to fetch the source of the NBFS case
				.selectField('RecordType.Name') // Added for NBFS Record Type
				.setCondition('Id IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description selectByAccountIdByCaseId description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByAccountIdByCaseId(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory(true)
				.selectField('AccountId')
				.selectField('CaseNumber')
				.selectField('Account.Name')
				.selectField('Account.CIF__c')
				.selectField('Account.SBU_Segment__c')
				.selectField('Client_Number__c')
                .selectField('Customer_Type__c')
				.setCondition('Id = :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description selectByAccountIdAndRelatedEmails description
	 *
	 * @param accountId (String): accountId
	 * @param suppliedEmail (String): suppliedEmail
	 * @param email (String): email
	 * @param emailFromAddress (String): emailFromAddress
	 * @param parentId (String): parentId
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByAccountIdAndRelatedEmails(
		String accountId,
		String suppliedEmail,
		String email,
		String emailFromAddress,
		String parentId,
		Integer recordLimit
	) {
		//String contactEmail,
		return Database.query(
			newQueryFactory(true)
				.selectField('ParentId')
				.selectField('Account.Name')
				.selectField('Contact.Name')
				.selectField('Owner.Name')
				.selectField('Email_From_Address__c')
				.selectField('Type__c')
				.selectField('Subtype__c')
				.selectField('RecordType.Name')
				.setCondition(
					'(AccountId = :accountId OR ' +
					'SuppliedEmail = :suppliedEmail OR ' +
					'Email__c = :email OR ' +
					'Email_From_Address__c = :emailFromAddress) AND ' +
					'isClosed = false AND ' +
					'ParentId = null AND ' +
					'Id != :parentId'
				)
				.setLimit(recordLimit)
				.toSOQL()
		);

		// 'ContactEmail = :contactEmail OR ' +
	}
	/**
	 * @description selectByIdWithEmailFields description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithEmailFields(Set<Id> idSet, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('AccountId')
				.selectField('Email__c')
				.selectField('Email_From_Address__c')
				.selectField('SuppliedEmail')
				.setCondition('Id IN :idSet')
				.setLimit(recordLimit)
				.toSOQL()
		);
		// selectField('ContactEmail').
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
		return [SELECT COUNT() FROM Case WHERE Email_From_Address__c = :fromAddress AND sd_Inbox_Name__c = :toAddress AND CreatedDate >= :timeThreshHold];
	}

	/**
	 * @description selectByIdWithProcessInstances description
	 *
	 * @param caseIds (Set<Id>): caseIds
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithProcessInstances(Set<Id> caseIds) {
		fflib_QueryFactory query = newQueryFactory(false).selectField('Id').setCondition('Id IN :caseIds');

		//new ProcessInstancesSelector().addQueryFactorySubselect(query,'ProcessInstances');

		fflib_QueryFactory oliQueryFactory = query.subselectQuery('ProcessInstances')
			.selectFields(new ProcessInstancesSelector().getSobjectFieldList())
			.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING, true)
			.setLimit(1);

		// System.debug('###query: ' + query);

		return (List<Case>) Database.query(query.toSOQL());
	}

	/**
	 * @description selectByIdWithCaseTransferTracking description
	 *
	 * @param caseIds (Set<Id>): caseIds
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithCaseTransferTracking(Set<Id> caseIds) {
		fflib_QueryFactory query = newQueryFactory(false)
			.selectField('Id')
			.selectField('OwnerId')
			.selectField('BusinessHoursId')
			.selectField('Owner_User_Name__c')
			.selectField('Owner_Queue_Name__c')
			.selectField('Status')
			.selectField('Subtype__c')
			.selectField('Type__c')
			.selectField('IsClosed')
			.setCondition('Id IN :caseIds');

		fflib_QueryFactory oliQueryFactory = query.subselectQuery('Case_Transfer_Tracking__r')
			.selectFields(new CaseTransferTrackingsSelector().getSobjectFieldList())
			.setCondition('Out__c = null');

		return (List<Case>) Database.query(query.toSOQL());
	}
	/**
	 * @description selectByIdWithCommunicationFields description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithCommunicationFields(Set<Id> idSet) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('isClosed')
				.selectField('Email__c')
				.selectField('Email_From_Address__c')
				.selectField('SuppliedEmail')
				.selectField('Logged_By_Email__c')
				.selectField('sd_Response_Email_Address__c')
				.selectField('BusinessHoursId')
				.selectField('ContactEmail')
				.selectField('Mobile__c')
				.selectField('Logged_By_Phone__c')
				.selectField('ContactMobile')
				.selectField('OwnerId')
				.selectField('AccountId')
				.selectField('ContactId')
				.selectField('Communication_Method__c')
				.selectField('Owner.Type')
				.selectField('External_SLA_Notification_User__c')
				.selectField('Internal_SLA_Notification_User__c')
				.setCondition('Id IN :idSet')
				.toSOQL()
		);
	}

	/**
	 * @description selectByExternalReferenceNo description
	 *
	 * @param referenceNo (String): referenceNo
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByExternalReferenceNo(String referenceNo, Integer recordLimit) {
		return Database.query(
			newQueryFactory(true)
				.selectField('External_Reference_Number__c')
				.setCondition('External_Reference_Number__c =  :referenceNo')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdWithRecordTypeDeveloperName description
	 *
	 * @param caseId (Id): caseId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithRecordTypeDeveloperName(Id caseId) {
		return Database.query(
			newQueryFactory(true)
				.selectField('RecordType.DeveloperName')
				.selectField('Unwanted_Type__c')
				.selectField('Account.ID_Number__pc') // added by divya
				.selectField('Customer_ID__c')
				.selectField('Id')
				.selectField('OwnerId')
				.selectField('Owner.Name')
				.selectField('Casenumber')
				.selectField('Customer_Type__c')
				.selectField('Account.Name')
				.selectField('Account.Salutation')
				.selectField('Initials__c')
				.selectField('Title__c')
				.selectField('Gender__c')
				.selectField('ID_Type__c')
				.selectField('CIF_Custom__c')
				.selectField('Birth_Date__c')
				.selectField('Nationality__c')
				.selectField('CIF__c')
				.selectField('First_Name__c')
				.selectField('Last_Name__c')
				.selectField('Mobile__c')
				.selectField('Alternate_Phone1__c')
				.selectField('Alternate_Phone2__c')
				.selectField('Alternate_Phone3__c')
				.selectField('Alternate_Phone4__c')
				.selectField('Alternate_Phone5__c')
				.selectField('Alternate_Phone6__c')
				.selectField('Alternate_Phone7__c')
				.selectField('Home_Phone__c')
				.selectField('Work_Phone__c')
				.selectField('Post_Addr_Line1__c')
				.selectField('Post_Addr_Line2__c')
				.selectField('Post_Addr_Line3__c')
				.selectField('Post_Addr_Line4__c')
				.selectField('Post_Addr_Post_Code__c')
				.selectField('Phys_Addr_Line1__c')
				.selectField('Phys_Addr_Line2__c')
				.selectField('Phys_Addr_Line3__c')
				.selectField('Phys_Addr_Line4__c')
				.selectField('Phys_Addr_Post_Code__c')
				.selectField('Physical_Address_Formula__c')
				.selectField('Postal_Address_Formula__c')
				.selectField('Description')
				.selectField('recordtype.name')
				.selectField('Comments')
				.selectField('Subject')
				.selectField('Email__c')
				.setCondition('Id = :caseId')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdWithComplaintInfoTOM description
	 *
	 * @param caseId (Id): caseId
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Case>: Return description
	 */

	public List<Case> selectByIdWithComplaintInfoTOM(Id caseId, Integer recordLimit) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('CIF__C')
				.selectField('opportunity__c')
				.selectField('CaseNumber')
				.selectField('type__c')
				.selectField('ATM_Service_Type__c')
				.selectField('Incident_Date__c')
				.selectField('IncidentTime__c')
				.selectField('Claim_Amount__c')
				.selectField('Amount_Withdrawn__c')
				.selectField('Amount_Received__c')
				.selectField('ATMNumber__c')
				.selectField('AbsaATM__c')
				.selectField('SequenceNumber__c')
				.selectField('NonAbsaATMText__c')
				.selectField('Receipt_Slip_Available__c')
				.selectField('ClientName__c')
				.selectField('ClientSurname__c')
				.selectField('Account_Number__c')
				.selectField('TOM_Response__c')
				.selectField('Is_Sent_To_TOM__c')
				.selectField('TOM_Sent_Time__c')
				.selectField('TomDecision__c')
				.selectField('TomReason__c')
				.selectField('TomCaseNumber__c')
				.selectField('Status')
				.selectField('Responsible_Site__r.Name')
				.setCondition('Id = :caseId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
	/**
	 * @description selectByCaseId description
	 *
	 * @param caseId (string): caseId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByCaseId(string caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Consultant_Notes_Comments__c')
				.selectField('Request_From_Absa_Business_Client__c')
				.selectField('Account_Conduct_Checked__c')
				.selectField('Account_Number_Confirmed__c')
				.selectField('Email_Address_Confirmed__c')
				.selectField('Request_From_Financial_Institution__c')
				.selectField('Name_Confirmed__c')
				.selectField('User_Type_Confirmed__c')
				.selectField('Response_Body__c')
				.selectField('Extended_Request_Data__c')
				.selectField('Consultant_Notes_Comments__c')
				.selectField('Type__c')
				.selectField('Request_Type__c')
				.selectField('Working_History__c')
				.selectField('ClosedDate')
				.selectField('Bank_Code_1__c')
				.selectField('Bank_Code_2__c')
				.selectField('RecordType.Name')
				.selectField('Refund_Approval_Stage__c')
				.selectField('Amount_Refunded__c')
				.selectField('Account.PersonContactId') // Add by Himan
				.selectField('Email__c') // Add by Himan for Email Issue
				.selectField('Amount__c') //Added by Bhanumurty
				.selectField('Product_Search__c') //Added by Bhanumurty
				.selectField('Refund_Transaction_Type_Id__c') //Added by Bhanumurty
				.selectField('Mandate_Level_4_Approver__c') //Added by Bhanumurty
				.selectField('Mandate_Level_3_Approver__c') //Added by Bhanumurty
				.selectField('Mandate_Level_2_Approver__c') //Added by Bhanumurty
				.selectField('Business_Account_Number__c') //Added by Bhanumurty
				.selectField('Additional_Information__c') //Added by Manish
				.selectField('AccountId') //Added by Manish
				.selectField('Category__c') //Added for AIP
				.selectField('DD_Sub_Category__c') //Added for AIP
				.selectField('CreatedDate') //Added for AIP
				.selectField('Inception_Date_of_the_Policy__c') //Added for AIP
				.selectField('Client_Absa_Account_Number__c') //Added for AIP
				.selectField('SequenceNumber__c') //Added for AIP
				.selectField('Product_Number__c') //Added for AIP
				.selectField('Number_of_Requests__c') //Added for AIP
				.selectField('X3rd_Party_Payment_Processed__c') //Added for AIP
				.selectField('Indemnity_Verified__c') //Added for AIP
				.selectField('Where_Did_This_Happen__c') //Added for AIP
				.selectField('Incident_Date__c') //Added for AIP
				.selectField('Cause_of_problem__c') //Added for AIP
				.selectField('Financial_Advisor__c') //Added for AIP
				.selectField('isConsentConfirmed__c') //Added for AIP
				.selectField('Policy_Number__c') //Added for AIP
				.selectField('Extended_Request_Data__c') // Added by Mohammed Junaid U
                .selectField('OwnerId') //Added by Mohammed Junaid U
				.selectField('Account.Compliance_Status__c') //Added by Mohammed Junaid U
				.selectField('AccountId') //added by Mohammed Junaid u
            	.selectField('FIC_Refresh_Reason__c') //added by Mohammed Junaid u
				.setCondition('Id = :caseId')
				.toSOQL()
		);
	}

	/*
   *    //TK Senkomane added on 01/04/2020
     public List<Case> selectByCaseNumber(Id caseId) {
         return Database.query(
                 newQueryFactory().
                         selectField('Id').
                         selectField('CaseNumber').
                         setCondition('Id = :caseId').
                         toSOQL()
         );
     }

     */
	/**
	 * @description selectcasebyAccountId description
	 *
	 * @param caseids (set<id>): caseids
	 * @return Return List<Case>: Return description
	 */

	public List<Case> selectcasebyAccountId(set<id> caseids) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('ownerid')
				.selectField('Opportunity__c')
				.selectField('status')
				.selectField('CreatedDate')
				.selectField('subject')
				.selectField('description')
				.selectField('AccountId')
				.selectField('Account.Ownerid')
				.selectField('Account.Owner.name')
				.selectField('Responsible_Site__r.Site_Code__c')
				.selectField('Responsible_Site__r.name')
				.selectField('Client_CIF_Number__c')
				.selectField('CreatedById')
				.selectField('RecordType.DeveloperName')
				.selectField('Opportunity__r.Opportunity_Number__c')
				.selectField('Account.Name')
				.selectField('Relationship_Banker__c')
				.selectField('Application_Product_Id__c')
				.selectField('Product__c')
				.selectField('Account_Number__c')
				.setCondition('id in:caseids')
				.toSOQL()
		);
	}

	/**
	 * @description selectCasebyOppId description
	 *
	 * @param oppId (set<string>): caseIdsSet
	 * @return Return List<Case>: Return description
	 */

	public List<Case> selectCasebyOppId(id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('ownerid')
				.selectField('Opportunity__c')
				.selectField('status')
				.selectField('CreatedDate')
				.selectField('subject')
				.selectField('description')
				.selectField('AccountId')
				.selectField('Account.Ownerid')
				.selectField('Account.Owner.name')
				.selectField('Responsible_Site__r.Site_Code__c')
				.selectField('Responsible_Site__r.name')
				.selectField('Client_CIF_Number__c')
				.selectField('CreatedById')
				.selectField('RecordType.DeveloperName')
				.setCondition('Opportunity__c =:oppId')
				.toSOQL()
		);
	}
	/**
	 * @description casesListForEmailsSend description
	 *
	 * @param caseIdsSet (set<string>): caseIdsSet
	 * @return Return List<Case>: Return description
	 */

	public List<Case> casesListForEmailsSend(set<string> caseIdsSet) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Status')
				.selectField('recordTypeId')
				.selectField('AccountId')
				.selectField('Type__c')
				.selectField('External_SLA_Status__c')
				.selectField('Out_Of_SLA_Reason__c')
				.selectField('Out_Of_SLA_Comments__c')
				.selectField('ParentId')
				.setCondition('Id IN :caseIdsSet')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdContentVersion description
	 *
	 * @param docIds (set<Id>): docIds
	 * @return Return List<ContentVersion>: Return description
	 */

	public List<ContentVersion> selectByIdContentVersion(set<Id> docIds) {
		return [
			SELECT id, Title, FileType, LastModifiedBy.Name, ContentSize, Description, Owner.Name, LastModifiedDate, Comments__c, ContentDocumentId
			FROM ContentVersion
			WHERE ContentDocumentId IN :docIds
		];
	}

	/**
	 * @description selectByIdContentDocLink description
	 *
	 * @param caseId (Id): caseId
	 * @return Return List<ContentDocumentLink>: Return description
	 */
	public List<ContentDocumentLink> selectByIdContentDocLink(Id caseId) {
		return [SELECT id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :caseId];
	}
	/**
	 * @description selectSecuritiesValidation description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case selectSecuritiesValidation(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('SV_2nd_Tier__c')
				.selectField('SV_Annual_POA_1_Year__c')
				.selectField('SV_Credit_AGMT_Name_Registration_CIF__c')
				.selectField('SV_Drafted_By_Business_Bank_Not_On_SMS__c')
				.selectField('SV_Drafted_By_CAF_PC_Capture_On_SMS__c')
				.selectField('SV_Exchange_Regulation_3_1__c')
				.selectField('SV_Existing_Client_CIF_Address_Validated__c')
				.selectField('SV_Existing_Client_CIF_Val_CIF07__c')
				.selectField('SV_ID_Number_All_Related_Parties_Checked__c')
				.selectField('SV_Independent_CIPRO_Document_Obtained__c')
				.selectField('SV_Is_Valid_Has_Not_Expired__c')
				.selectField('SV_Monthly_POA_3_Months__c')
				.selectField('SV_Muni_Bills_Sent_Address_Email__c')
				.selectField('SV_Other_Security_Documentation_In_Order__c')
				.selectField('SV_POI_Certified_Copies__c')
				.selectField('SV_POI_Copies_Must_Be_Clear_And_Legible__c')
				.selectField('SV_POI_Dealership_And_FI_Certifying__c')
				.selectField('SV_POI_Names_Match_ID_Document__c')
				.selectField('SV_POI_Validated_And_Signed_True_Copy__c')
				.selectField('SV_POI_Verification_Date__c')
				.selectField('SV_Primary_Customer_Screening_Complete__c')
				.selectField('SV_Proof_Of_Address__c')
				.selectField('SV_QA__c')
				.selectField('SV_Reason_for_More_Info__c')
				.selectField('SV_Related_Parties_Screening_Completed__c')
				.selectField('SV_Reserve_Bank_Approval_Received__c')
				.selectField('SV_Section_45_Letters_Obtained__c')
				.selectField('SV_Security_Resolution_S_Is_Are_In_Order__c')
				.selectField('SV_Signed_By_Mandated_Sanctioner__c')
				.selectField('SV_SMS_Securities_Approval_Conditions__c')
				.selectField('SV_SOA_Rec_By_Email_With_Copy_NCA_Reg__c')
				.selectField('SV_SOA_Rec_By_POBOX_Private_Bag_Name__c')
				.selectField('SV_Status_Captured_On_CIF__c')
				.selectField('SV_Suretyship_Legally_Correct_All_Sigs__c')
				.selectField('SV_Transaction_Resolution_Obtained__c')
				.selectField('SV_Verification_Docs_Validated_As_ID_Doc__c')
				.selectField('OwnerId')
				.setCondition('Id = :caseId')
				.toSOQL()
		);
	}

	// Added for DD STI Case to retrieve cases assigned to Queue
	/**
	 * @description selectCasesByQueueName description
	 *
	 * @param queuename (string): queuename
	 * @description
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectCasesByQueueName(string queuename) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition('Owner_Queue_Name__c = :queuename')
				.toSOQL()
		);
	}
	/**
	 * @description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case selectPayoutValidation(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('pv_Names_of_address_of_landlord_received__c')
				.selectField('pv_Form_25_completed_in_full_and_signed__c')
				.selectField('pv_Pricing_document_received__c')
				.selectField('pv_Doc_fee_as_per_credit_approval__c')
				.selectField('pv_Amount_financed_not_credit_approval__c')
				.selectField('pv_Debit_order_not_R500000_p_a__c')
				.selectField('pv_Signed_Debit_Order__c')
				.selectField('pv_Original_signed_agreement_and_t_c__c')
				.selectField('pv_Term_on_Credit_agrees_with_credit_app__c')
				.selectField('pv_Type_of_agreement_as_credit_approval__c')
				.selectField('pv_Article_financed_per_credit_approval__c')
				.selectField('pv_Non_VAT_registered_VAT_264_form__c')
				.selectField('pv_VAT_registered_valid_tax_invoice__c')
				.selectField('pv_Invoice_signed_by_client__c')
				.selectField('pv_Invoice_correspond_with_contract__c')
				.selectField('pv_Confirm_from_sales_of_dealer_banking__c')
				.selectField('pv_Year_model_and_description_of_goods__c')
				.selectField('pv_Bank_interest_with_insurance_company__c')
				.selectField('pv_Freedom_of_choice_form_completed__c')
				.selectField('Form_23_completed_in_full_and_signed__c')
				.selectField('pv_FAIS_documents_completed_clause_1_5__c')
				.selectField('pv_DIC_to_be_paid_in_dealer__c')
				.selectField('pv_Dealer_correspond_Credit_Approval__c')
				.selectField('pv_Signed_by_mandate_holder__c')
				.selectField('pv_Inspection_Report_completed_in_full__c')
				.selectField('pv_Proof_that_goods_are_paid_in_full__c')
				.selectField('pv_Deposit_correspond_credit_approval__c')
				.selectField('pv_Signed_customer_communication__c')
				.selectField('pv_CASA_Reference_number_on_header__c')
				.selectField('pv_Engine_Chassis_number_corresponds__c')
				.selectField('pv_Client_name_correspond_with_agreement__c')
				.selectField('pv_CIF07_Screen_Information_Corresponds__c')
				.selectField('pv_New_FICA_information_has_been_loaded__c')
				.selectField('pv_Signed_acknowledgement_of_receipts__c')
				.selectField('pv_All_info_on_Signed_Credit_Agreement__c')
				.selectField('pv_Debit_order_information_SAP__c')
				.selectField('pv_Monthly_debit_order_does_not_exceed__c')
				.selectField('pv_Insurance_info_is_updated_on_SAP__c')
				.selectField('pv_Affordability_information_loaded__c')
				.selectField('pv_Service_fee_has_been_loaded_correctly__c')
				.selectField('pv_Doc_fee_has_been_loaded_correctly__c')
				.selectField('pv_DIC_payable_and_reflects_in_condition__c')
				.selectField('pv_No_DIC_is_payable_and_it_was_deleted__c')
				.selectField('pv_Client_communication_info_is_updated__c')
				.selectField('pv_VAPS_loaded_on_SAP_have_signed_docs__c')
				.selectField('pv_Cancelled_VAPS_policy_docs_deleted__c')
				.selectField('PR_Payment_method_is_loaded_as_E_EFT__c')
				.selectField('PR_Invoice_information_corresp_with_SAP__c')
				.selectField('PR_Payment_is_made_to_the_correct_dealer__c')
				.selectField('PR_The_amount_of_the_invoice_corresponds__c')
				.selectField('PR_Service_fee_has_been_loaded_correctly__c')
				.selectField('PR_Documentation_fee_has_been_loaded__c')
				.selectField('PR_Dealer_name_of_invoice_corresponds__c')
				.selectField('PR_Payment_detail_of_dealer_is_loaded__c')
				.selectField('PR_Proof_of_Deposit_is_on_file_Deposit__c')
				.setCondition('Id = :caseId')
				.toSOQL()
		);
	}

	// Added for DD STI Case to retrieve cases by Case Number
	/**
	 * @description selectCasesByCaseNumber description
	 *
	 * @param caseNumber (string): caseNumber
	 * @return Return Case: Return description
	 */
	public Case selectCasesByCaseNumber(string caseNumber) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('IsClosed')
				.setCondition('CaseNumber = :caseNumber')
				.toSOQL()
		);
	}
	/**
	 * @description caseQAChecklist description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case caseQAChecklist(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Guarantee_Number_Contract_Created__c')
				.selectField('Guarantee_Documents_Issued__c')
				.selectField('Collateral_Captured_on_SMS_to_O_status__c')
				.selectField('CMS_Limit_Loaded__c')
				.selectField('SMS_CINA_Journal_Notes_Captured__c')
				.selectField('Journal_Prepared__c')
				.selectField('CMS_Limit_Approved__c')
				.selectField('SMS_CINA_Message_Captured__c')
				.selectField('Status_Change_from_U_to_IMG_U_status__c')
				.selectField('Y_status_Removed__c')
				.selectField('SMS_CINA_Message_Captured__c')
				.selectField('Securities_Collateral_on_SMS_Captured__c')
				.setCondition('Id = :caseId')
				.toSOQL()
		);
	}
	/**
	 * @description selectByIdWithCaseChecklist description
	 *
	 * @param caseIds (Set<Id>): caseIds
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithCaseChecklist(Set<Id> caseIds) {
		fflib_QueryFactory query = newQueryFactory(false)
			.selectField('Id')
			.selectField('OwnerId')
			.selectField('BusinessHoursId')
			.selectField('Owner_User_Name__c')
			.selectField('Owner_Queue_Name__c')
			.selectField('Status')
			.selectField('Subtype__c')
			.selectField('Type__c')
			.selectField('IsClosed')
			.setCondition('Id IN :caseIds');

		fflib_QueryFactory oliQueryFactory = query.subselectQuery('Case_Checklists__r').selectFields(new CaseQAChecklistSelector().getSobjectFieldList());

		return (List<Case>) Database.query(query.toSOQL());
	}
	/**
	 * @description selectQueueByCaseId description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectQueueByCaseId(Set<Id> idSet) {
		return (List<Case>) Database.query(
			newQueryFactory()
				.selectField('Banker_RE__r.Name')
				.selectField('Relationship_Banker__r.Name')
				.selectField('Collateral_Consultant__r.Name')
				.selectField('Collateral_Validator__r.Name')
				.selectField('Fulfilment_Consultant__r.Name')
				.selectField('Collateral_Processing_Consultant__r.Name')
				.selectField('Product__c')
				.selectField('Application_Product_Id__c')
				.setCondition('Id IN :idSet')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdWithCustomerInfo description
	 *
	 * @param caseIdsSet (set<string>): caseIdsSet
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByIdWithCustomerInfo(set<string> caseIdsSet) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('AccountId')
				.selectField('ID_Type__c')
				.selectField('CIF_Custom__c')
				.selectField('Customer_Full_Name__c')
				.selectField('Customer_ID__c')
				.selectField('Adviser_Name__c')
				.selectField('Adviser_Code__c')
				.selectField('OwnerId')
				.selectField('Consent_Choice__c')
				.selectField('New_Alternate_Contact__c')
				.selectField('Mobile__c')
				.selectField('Home_Phone__c')
				.selectField('Work_Phone__c')
				.selectField('Alternate_Phone1__c')
				.selectField('Alternate_Phone2__c')
				.selectField('Alternate_Phone3__c')
				.selectField('Alternate_Phone4__c')
				.selectField('Alternate_Phone5__c')
				.selectField('Alternate_Phone6__c')
				.selectField('Alternate_Phone7__c')
				.selectField('ID_V_Completed__c')
				.selectField('Virtual_Advisor_Selected__c')
				.selectField('Status')
				.selectField('Outcome__c')
				.selectField('ClientName__c')
				.selectField('SelectedPoliciesID__c') //added by vk
				.setCondition('Id IN :caseIdsSet')
				.toSOQL()
		);
	}

	/**
	 * @description selectByTaskWhatId description
	 *
	 * @param caseId (String): caseId
	 * @return Return case: Return description
	 */
	public case selectByTaskWhatId(String caseId) {
		return [SELECT id, RecordType.DeveloperName, RecordTypeId FROM Case WHERE Id = :caseId];
	}
	/**
	 * @description selectSelectedPolicyByCaseID description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case selectSelectedPolicyByCaseID(String caseId) {
		return Database.query(newQueryFactory().selectField('Id').selectField('SelectedPoliciesID__c').setCondition('Id = : caseId').toSOQL());
	}
	/**
	 * @description selectCaseFieldForBrokerNote description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case selectCaseFieldForBrokerNote(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Adviser_Code__c')
				.selectField('CaseNumber')
				.selectField('First_Name__c')
				.selectField('Last_Name__c')
				.selectField('Adviser__c')
				.selectField('Adviser_First_Name__c')
				.selectField('Adviser_Last_Name__c')
				.selectField('AccountId')
				.selectField('ID_Number__c')
				.selectField('Customer_ID__c')
				.selectField('Birth_Date__c')
				.selectField('Home_Phone__c')
				.selectField('Work_Phone__c')
				.selectField('Mobile__c')
				.selectField('Email__c')
				.setCondition('Id = : caseId')
				.toSOQL()
		);
	}
	/**
	 * @description selectCaseDetailsForBrokerNote description
	 *
	 * @param caseId (String): caseId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectCaseDetailsForBrokerNote(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Adviser_Code__c') //Added By Vj -25/11/2020
				.selectField('Description') //Himan
				.selectField('Account.PersonContactId') //Himan
				.selectField('Adviser__c') // vj--25/11/2020
				.selectField('SelectedPoliciesID__c')
				.selectField('Outcome__c')
				.selectField('Status')
				.selectField('Customer_Full_Name__c')
				.selectField('Customer_ID__c')
				.selectField('Email__c')
				.selectField('Mobile__c')
				.selectField('RecordType.name')
				.selectField('RecordType.DeveloperName')
				.selectField('Owner.Email')
				.selectField('ContactId')
				.selectField('Owner.Id')
				.selectField('SelectedAdvisorIdF2F__c')
				.setCondition('Id = : caseId')
				.toSOQL()
		);
	}
	/**
	 * @description CaseDetailsByQuery description
	 *
	 * @param caseId (String): caseId
	 * @return Return Case: Return description
	 */
	public Case CaseDetailsByQuery(String caseId) {
		return [
			SELECT id, ContactEmail, Email__c, contactid, AccountId, Account.PersonEmail, Account.PersonContactId, Cross_Sell_Products_Broker_Note__c
			FROM case
			WHERE id = :caseid
		];
	}
	/**
	 * @description getCasesWithOppId description
	 *
	 * @param oppId (Id): oppId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> getCasesWithOppId(Id oppId) {
		return Database.query(newQueryFactory().selectField('Id').selectField('opportunity__c').setCondition('opportunity__c =:oppId').toSOQL());
	}

	/**
	 * W-008372 : Rob McLean
	 * @description Get all records where Case is still open and linked to a specifc user and account
	 *
	 * @param userId
	 * @param accountId
	 * @return List<Case>
	 */
	public List<Case> selectIsOpenByOwnerByAccount(Id userId, Id accountId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Status')
				.selectField('OwnerId')
				.selectField('External_Reference_Number__c')
				.setCondition('OwnerId = :userId and AccountId = :accountId and ClosedDate = null ')
				.toSOQL()
		);
	}

	/**
	 * @description selectByServiceTypeROT description
	 *
	 * @param serviceType (String): serviceType
	 * @param status (String): status
	 * @param rotApproval (String): rotApproval
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectByServiceTypeROT(String serviceType, String status, String rotApproval) {
		// return [Select id,Restriction_Group__c from Case where ROT_Approval_Status__c = :rotApproval and Status = :status and Type__c = :serviceType];
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Status')
				.selectField('Type__c')
				.selectField('ROT_Approval_Status__c')
				//selectField('Restriction_Group__c').
				.selectField('Pre_Lapse_Start_Date__c')
				.selectField('Pre_Lapse_End_Date__c')
				.selectField('ROT_Start_Date__c')
				.selectField('ROT_End_Date__c')
				.setCondition('ROT_Approval_Status__c = :rotApproval and Status = :status and Type__c = :serviceType')
				.toSOQL()
		);
	}

	/**
	 * @description
	 * @param caseId
	 * @return Case
	 **/
	public Case selectCaseByMaintenance(String caseId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Adverse_Media_Report__c')
				.selectField('Reason_for_Adverse_Media_Report__c')
				.setCondition('Id = : caseId')
				.toSOQL()
		);
	}

	/**
	 * @description
	 * @param accountId
	 * @param statusValues
	 * @param caseSubject
	 * @return List<Case>
	 **/
	public List<Case> selectCaseByFICStatusAndSubject(String accountId, set<string> statusValues, string caseSubject) {
		string caseSubjectVar = '%' + caseSubject + '%';
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Subject')
				.selectField('status')
				.selectField('createddate')
				.selectField('AccountId')
				.setCondition('AccountId = :accountId AND status != :statusValues AND Subject like : caseSubjectVar')
				/*.setCondition(
                    'Subject LIKE \' %' +
                    caseSubject +'%'+
                    '\' AND AccountId = :accountId AND status != :caseStatus'
                ) */
				.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.toSOQL()
		);
	}

	/**
	 * @description
	 * @param accountId
	 * @param caseStatus
	 * @param caseSubject
	 * @return List<Case>
	 **/
	public List<Case> selectCaseByStatusAndSubject(String accountId, string caseStatus, string caseSubject) {
		string caseSubjectVar = '%' + caseSubject + '%';
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Subject')
				.selectField('status')
				.selectField('createddate')
				.selectField('AccountId')
				.setCondition('AccountId = :accountId AND status != :caseStatus AND Subject like : caseSubjectVar')
				/*.setCondition(
                    'Subject LIKE \' %' +
                    caseSubject +'%'+
                    '\' AND AccountId = :accountId AND status != :caseStatus'
                ) */
				.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.toSOQL()
		);
	}
	/**
	 * @description get case based on userId
	 * @param userId
	 * @return List<Case>
	 **/
	public List<Case> selectIsOpenByOwnerByAccount(Id userId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.setCondition('OwnerId = :userId')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.toSOQL()
		);
	}

	/**
	 * @description get case based on userId
	 * @param queuename
	 * @param searchKeyWord
	 * @return List<Case>
	 **/
	public List<Case> selectCasesByQueueNameAndKeyWord(string queuename, String searchKeyWord) {
		String quw = queuename;
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition(
					'Owner_Queue_Name__c =: queuename   AND (CaseNumber Like  \'%' +
					searchKeyWord +
					'%\' OR Status LIKE \'%' +
					searchKeyWord +
					'%\' OR CIF__c LIKE \'%' +
					searchKeyWord +
					'%\')'
				)
				.toSOQL()
		);
	}

	/**
	 * @description
	 * @author Sandeep Golla | 2021-07-07
	 * @param caseId
	 * @param accId
	 * @param caseSubject
	 * @return List<Case>
	 **/
	public List<Case> selectByDataPrivacyRBCase(String caseId, String accId, String caseSubject) {
		string caseSubjectVar = '%' + caseSubject + '%';
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Status')
				.selectField('Type')
				.selectField('Type__c')
				.selectField('Subtype__c')
				.selectField('ParentId')
				.selectField('AccountId')
				.selectField('Subject')
				.setCondition('ParentId = :caseId AND AccountId = :accId AND Subject like : caseSubjectVar')
				.toSOQL()
		);
	}
	/**
	 * @description get case based on userId
	 * @param userId
	 * @param searchKeyWord
	 * @return List<Case>
	 **/

	public List<Case> selectIsOpenByOwnerAndSearchKeyWordByAccount(Id userId, string searchKeyWord) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition(
					'OwnerId =: userId   AND (CaseNumber Like  \'%' +
					searchKeyWord +
					'%\' OR Status LIKE \'%' +
					searchKeyWord +
					'%\' OR CIF__c LIKE \'%' +
					searchKeyWord +
					'%\')'
				)
				.toSOQL()
		);
	}

	/**
	 * @description get case based on userId
	 * @param searchKeyWord
	 * @return List<Case>
	 **/

	public List<Case> selectCasesByKeyWord(String searchKeyWord) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition(
					'(CaseNumber Like  \'%' +
					searchKeyWord +
					'%\' OR Status LIKE \'%' +
					searchKeyWord +
					'%\' OR CIF__c LIKE \'%' +
					searchKeyWord +
					'%\')'
				)
				.toSOQL()
		);
	}
	/**
	 * @description selectCasesById description
	 *
	 * @param caseId (Id): caseId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectCasesById(Id caseId) {
		return Database.query(newQueryFactory().selectField('Id').selectField('RecordType.DeveloperName').setCondition('Id = : caseId').toSOQL());
	}

	// Added for DD STI Case to retrieve cases assigned to Queue
	/**
	 * @description selectCasesByQueueName description
	 *
	 * @param queuename (string): queuename
	 * @param campaignId
	 * @return Return List<Case>: Return description
	 */
	public List<Case> selectCasesByQueueName(string queuename, String campaignId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('CaseNumber')
				.selectField('Reference_Number__c')
				.selectField('Status')
				.selectField('Reason')
				.selectField('Owner_Queue_Name__c')
				.selectField('CreatedDate')
				.selectField('ClosedDate')
				.selectField('Type__c')
				.selectField('CIF__c')
				.selectField('Account_Number__c')
				.selectField('Priority')
				.selectField('FIC_CASA_Reference_Number__c')
				.selectField('FIC_CASA_Sequence_Number__c')
				.selectField('OwnerId')
				.selectField('Subject')
				.selectField('ClientName__c')
				.selectField('RecordType.Name')
				.selectField('FIC_Case_returned_to_queue__c')
				.selectField('FIC_DateTimeAssignedToCurrentOwner__c')
				.addOrdering('FIC_Case_returned_to_queue__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.addOrdering('FIC_DateTimeAssignedToCurrentOwner__c', fflib_QueryFactory.SortOrder.DESCENDING, true)
				.setCondition('Owner_Queue_Name__c = :queuename and Direct_Delivery_Campaign__c = :campaignId')
				.toSOQL()
		);
	}
	
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-10-19 
    * @param caseId 
    * @return Case 
    **/
    public Case selectCaseDetailsForDeferral(String caseId) {
        
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('OwnerId')
            .selectField('Reported_Date__c')
            .selectField('Advice_Date__c')
            .selectField('Email__c')
            .selectField('Responsible_Person__c')
            .selectField('Account.SUIN__c')
            .selectField('Account.CIF__c')            
            .selectField('Account_Number__c')
            .selectField('Name_Confirmed__c')
            .selectField('Comments__c')
            .selectField('Is_Case_Reopened__c')
            .selectField('AccountId')
            .selectField('Account.Next_Refresh_Date__c')
            .selectField('Approval_Status__c')
            .selectField('Previous_Owner__c')
            .selectField('Expiry_Date__c')
            .selectField('Add_Case_Comment__c')
            .selectField('Consultant_Notes_Comments__c')
            .selectField('FICA_Check__c')
            .selectField('Extended_Request_Data__c')
            .selectField('Account.Compliance_Status__c')
            .selectField('Account.Risk_Rating__c')
            .selectField('Status')
            .setCondition('Id = : caseId')
            .toSOQL()
        );
    }
	//CUSTOM SELECTORS - END
}