/**@description fflib_SObjectSelector description
 * Apex Enterprise Design Patterns
 * Selector Layer for Opportunity objects
 *
 * @author  Kyle Alexander
 * @since   2018-07-17 
 */
public class OpportunitiesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Opportunity.sObjectType;
	}
    /**
* @description Returns all opportunities compliance fields
* @param opportunityId - Opportunity Id
* @return List<Opportunity> - returns a list of opportunities with compliance fields
*/
    public List<Opportunity> selectComplianceSummaryFields(Id opportunityId) {
        return Database.query(
            newQueryFactory()
                .selectField('OwnerId')
                .selectField('AccountId')
                .selectField('CASA_Screening_Status__c')
                .selectField('Risk_Rating__c')
                .selectField('Account_Status__c')
                .selectField('Sub_Status__c')
                .selectField('Next_Refresh_Date__c')
                .selectField('FICA_Address_Attested_Date__c')
                .selectField('FICA_Address_Updated_Date__c')
                .selectField('Identification_Attested_Date__c')
                .selectField('Identification_Updated_Date__c')
                .selectField('Source_of_Income_Attested_Date__c')
                .setCondition('Id = :opportunityId')
                .toSOQL()
        );
    }

       /**
* @description Returns  opportunity
* @param accIds
* @param userIds
* @return List<Opportunity>
*/
    public List<Opportunity> selectOpenOppByAccountAndUserId(Set<Id> accIds, Set<Id> userIds) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('OwnerId').
            selectField('AccountId').
            selectField('isClosed').
            setCondition('isClosed = false AND AccountId IN :accIds AND OwnerId IN :userIds').
            toSOQL()
        );
    }

    /**
* W-005792
*  @description Returns  opportunity with Origination validation fields details
*
* @param oppId
* Added by : Saurabh :Absa
* @since : 2020-10-05
*
* @return Opportunity
**/
    public Opportunity selectOpportunityValidationFields(Id oppId){
        return Database.query(
            newQueryFactory().
            selectField('id').
            selectField('AccountId').
            selectField('Is_Spouse_Captured__c').
            setCondition('Id = :oppId').
            toSOQL()
        );
    }

    // * Added by : Saiteja :Absa
        /**
     *
     * @description Get all records where opportunity is still open and linked to a specifc user and account
     *
     *
     * @param accountId accountId
     * @return Opportunity
     */
        public Opportunity selectOppByAccount(Id accountId) {
            List<Opportunity> opp = new List<Opportunity>();
            String processtype = 'Remediate Existing Customer'; 
            String RecType = 'Customer_Remediation';
            String Stage = 'Closed';
            opp = Database.query(
                newQueryFactory().
                selectField('CreatedDate').
                selectField('RecordTypeName__c').
                selectField('Process_Type__c').
                selectField('StageName').
                selectField('ownerId.Name').
                setCondition('AccountId =:accountId AND RecordTypeName__c =:RecType AND Process_Type__c =:processtype AND StageName !=:Stage' ).
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                setLimit(1).
                toSOQL()
            );
            if(opp.size()>0)
            {
                return opp[0];
            }
            else{
                return null;
            }
        }
    //CUSTOM SELECTORS - END

	/**
	 * @description Field List
	 * @param
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Opportunity.Id,
			Opportunity.StageName,
			Opportunity.OwnerId,
			Opportunity.Name,
			Opportunity.CIF_Number__c,
			Opportunity.Debit_Order_Account_Type__c,
			Opportunity.Debit_Order_Bank_Name__c,
			Opportunity.Debit_Order_Branch_Name__c,
			Opportunity.Debit_Order_Account_Type__c,
			Opportunity.Debit_Order_Branch_Code__c,
			Opportunity.Debit_Order_Account_Number__c,
			Opportunity.Debit_Order_Date__c,
			Opportunity.Debit_Order_Debit_Day__c,
			Opportunity.Debit_Order_Salary_Day__c,
			Opportunity.DebitOrderThirdParty__c,
			Opportunity.CreatedDate,
			Opportunity.Commission_1st_Year__c,
			Opportunity.Commission_2nd_Year__c,
			Opportunity.Risk_Rating_Date__c,
			Opportunity.Risk_Rating__c,
			Opportunity.Will_Number__c,
			Opportunity.Commencement_Date__c,
			Opportunity.PRI_Number__c,
			Opportunity.Site__c,
			Opportunity.Spouse_Account_Id__c
		};
	}

	/*** @description selectById description
    
    * @param idSet (Set<Id>): idSet
   
    * @return Return List<Opportunity>
    */

	public List<Opportunity> selectById(Set<Id> idSet) {
		return (List<Opportunity>) selectSObjectsById(idSet);
	}

	/**@description selectByActivityId description
	 *
	 * @param activityId (Id)
	 * @param recordLimit (Integer): recordLimit
	 * @return Opportunity
	 */
	public Opportunity selectByActivityId(Id activityId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Product__c')
				.selectField('AccountId')
				.selectField('Account')
				.selectField('Number_of_Calls__c')
				.selectField('Financial_Needs_Analysis__c')
				.selectField('RecordTypeId')
				.selectField('CreatedBy.Name')
				.setCondition('id = :activityId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**@description selectByAccountIdset description
	 * Opportunity query by set of AccountIds without a limit
	 * @param accountIds (Set<Id>) - set of account Id's
	 * @param recordTypeId (Id)
	 * @return List<Opportunity> - returns a list of opportunities
	 */
	public List<Opportunity> selectByAccountIdset(Set<Id> accountIds, Id recordTypeId) {
		return Database.query(
			newQueryFactory(false)
				.selectField('AccountId')
				.selectField('StageName')
				.selectField('FICA_Message__c')
				.selectField('Process_Type__c')
				.selectField('DigitalHoldSuccess__c')
				.selectField('Digital_Hold_Response__c')
				.selectField('Branch_Region_Site__c')
				.selectField('Opportunity_Number__c')
				.selectField('Annual_turnover__c')
				.selectField('Regional_office_address_for_notices__c')
				.selectField('Regional_Manager__c')
				.selectField('Regional_Manager__r.Name')
				.selectField('Regional_Manager__r.Phone')
				.selectField('Regional_Manager__r.MobilePhone')
				.selectField('Form_Status__c')
				.selectField('Was_the_credit_request_approved__c')
				.selectField('Process_Type__c')
				.selectField('Business_Unit__c') // for ce the change
				.setCondition('Id = :opportunityId')
				.selectField('RecordTypeId')
				.selectField('Id')
				.setCondition('AccountId IN :accountIds AND RecordTypeId=:recordTypeId')
				.toSOQL()
		);
	}

	/**@description selectByOppRecIdset description
	 * Opportunity query by set of opp without a limit
	 * @param oppIds (Set<Id>) - set of opp Id's
	 * @param recordTypeId (Id)
	 * @return List<Opportunity> - returns a list of opportunities
	 */
	public List<Opportunity> selectByOppRecIdset(Set<Id> oppIds, Id recordTypeId) {
		return Database.query(
			newQueryFactory(false)
				.selectField('AccountId')
				.selectField('StageName')
				.selectField('RecordTypeId')
				.selectField('Id')
				.setCondition('Id IN :oppIds AND RecordTypeId=:recordTypeId')
				.toSOQL()
		);
	}
    /**
	 * @description selectByOpportunityId description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<Opportunity>: Return description
	 */
    public List<Opportunity> selectByOpportunityId(Id opportunityId, Integer recordLimit) {
        return Database.query(
            newQueryFactory().
            selectField('External_Call_Outcome__c').
            selectField('Declaration_Status__c').
            selectField('OwnerId').
            selectField('Owner.Email'). //Added for STI Referral
            selectField('ContactName__c'). //Added for STI Referral
            selectField('Account.PersonContactId'). //Added for STI Referral
            selectField('Account').
            selectField('AccountId').
            selectField('CIF_Number__c').
            selectField('Selected_Email__c').
            selectField('SyncedQuoteId').
            selectField('FICA_Address_Attested__c').
            selectField('Identification_Attested__c').
            selectField('Email_Status__c').
            selectField('WBIF_Policy_Number__c').
            selectField('Adviser__c').
            selectField('Spouse_Account_Id__c').
            selectField('Site__c').
            selectField('Adviser_Employee__c').
            selectField('Adviser__r.Advisor_Code__c').
            selectField('Financial_Needs_Analysis__c').
            selectField('FraudRiskAlert__c').
            selectField('Process_Type__c').
            selectField('Opportunity_Record_Type_Name__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Account_First_Name__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Account_Last_Name__c').// Added for Direct Delivery Sales Record type
            selectField('ID_Number__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Account_Age__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Account_Gender__c').// Added for Direct Delivery Sales Record type
            selectField('Product_Interest__r.Product__c').// Added for Direct Delivery Sales Record type
            selectField('Product_Interest__c').// Added for Direct Delivery Sales Record type
            selectField('Quote_on_Spouse__c').// Added for Direct Delivery Sales Record type
            selectField('Quote_on_Child__c').// Added for Direct Delivery Sales Record type
            selectField('Quote_on_Extended_Family__c').// Added for Direct Delivery Sales Record type
            selectField('Person_BirthDate__c').// Added for Direct Delivery Sales Record type
            selectField('Law_For_U_Plan__c').// Added for Direct Delivery Sales Record type
            selectField('Card_Life_Plan__c').// Added for Direct Delivery Sales Record type
            selectField('DD_Absa_Credit_Card_Number__c').// Added for Direct Delivery Sales Record type
            selectField('CIF_Number__c').// Added for Direct Delivery Sales Record type
            selectField('Email__c').// Added for Direct Delivery Sales Record type
            selectField('Phone__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Preffered_Communication__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Id_Type__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Passport_Number__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Occupation__c').// Added for Direct Delivery Sales Record type
            selectField('Person_Language__c').// Added for Direct Delivery Sales Record type
            selectField('CASA_Reference_Number__c').// Added for Direct Delivery Sales Record type
            selectField('Available_Cover__c').// Added for Direct Delivery Sales Record type
            selectField('Income_Source__c').// Added for Direct Delivery Sales Record type
            selectField('AVAF_Account_Number__c').// Added for Direct Delivery Sales Record type
            selectField('Source_Of_Fund__c').// Added for Direct Delivery Sales Record type
            selectField('Account.PersonContactId').// Added for Direct Delivery Sales Record type
            selectField('Account.CASA_Reference_Number__pc').// Added for Direct Delivery Sales Record type
            selectField('Account.CASA_Screening_Status__pc').// Added for Direct Delivery Sales Record type
            selectField('Account.DD_Market_Value__c').// Added for Direct Delivery Sales Record type
            selectField('Market_Value__c').// Added for Direct Delivery Sales Record type
            selectField('Outstanding_Capital__c').// Added for Direct Delivery Sales Record type
            selectField('Risk_Rating__c').// Added for Direct Delivery Sales Record type
            selectField('Annual_turnover__c').// Added for Direct Delivery Sales Record type
            selectField('Intial_Loan_Amount__c').// Added for Direct Delivery Sales Record type
            selectField('CreditLife_Plans__c').// Added for Direct Delivery Sales Record type
            selectField('Absa_Staff_Member__c').// Added for Direct Delivery Sales Record type
            selectField('Secondary_Life__c').// Added for Direct Delivery Sales Record type
            selectField('Commission__c').// Added for Direct Delivery Sales Record type
            selectField('Vehicle_Description__c').// Added for Direct Delivery Sales Record type
            selectField('Contract_Start_Date__c').// Added for Direct Delivery Sales Record type
            selectField('Interest_Rate__c').// Added for Direct Delivery Sales Record type
            selectField('Monthly_Instalment__c').// Added for Direct Delivery Sales Record type
            selectField('staff_Member__c').// Added for Direct Delivery Sales Record type
            selectField('DD_Additional_Cover_Selected__c').// Added for Direct Delivery Sales Record type
            selectField('DD_PhotoFinishSelected__c').// Added for Direct Delivery Sales Record type
            selectField('DD_Premium__c').// Added for Direct Delivery Sales Record type
            selectField('Photo_Finish_Premium__c').// Added for Direct Delivery Sales Record type
            selectField('AVAF_Account_Number__c').// Added for Direct Delivery Sales Record type
			selectField('Converted_Lead__c').// Added for Direct Delivery Sales Record type
			selectField('STI_Policy_Number__c').//Added for DD STI
            selectField('Policy_Inception_Date__c').//Added for DD STI
            selectField('Product_Provider__c').//Added for DD STI
            selectField('Policy_Income_Type__c').//Added for DD STI
            selectField('PRI_Number__c').//Added for DD STI
            selectField('Account.Salutation').
            selectField('Account.FirstName').
            selectField('Account.LastName').
            selectField('Account.PersonEmail').
            selectField('Account.Phone').
            selectField('Account.PersonMobilePhone').
            selectField('Account.Nationality__pc').
            selectField('Account.ID_Number__pc').
            selectField('Account.RecordTypeId').
            selectField('Account.Name').
            selectField('Account.CIF__c').
            selectField('Account.Company_Registration_Number__c').
            selectField('Account.ID_Type__pc').
            selectField('Account.Alternate_Phone1__pc').
            selectField('Account.Alternate_Phone2__pc').
            selectField('Account.Alternate_Phone3__pc').
            selectField('Account.Initials__pc').
            selectField('Account.PersonBirthdate').
			selectField('Business_Unit__c'). // for ce the change
			selectField('Is_Referred_System__c').
            selectField('Account.Id').
            setCondition('Id = :opportunityId').
            setLimit(recordLimit).
            toSOQL()
        );
    }

	/**@description selectByListOpportunityIds description
	 * Method that takes a set of opportunity ID's
	 * @param opportunityIds (Set<Id>)
	 * @return List<Opportunity> - returns a list of opportunities
	 */
	public List<Opportunity> selectByListOpportunityIds(Set<Id> opportunityIds) {
		return Database.query(
			newQueryFactory()
				.selectField('CreatedDate')
				.selectField('OwnerId')
				.selectField('Quote_Number__c')
				.selectField('Quote_Status__c') // Tinashe W-004373
				.setCondition('Id in :opportunityIds')
				.toSOQL()
		);
	}

	

	/**@description selectByOpportunityId description
	 * Opportunity query by Opportunity Id without a limit
	 * Method that takes a opportunity Id
	 * @param opportunityId (Id)
	 * @return List<Opportunity> - returns a list of opportunities
	 */
	public List<Opportunity> selectByOpportunityId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('Adviser_Employee__c')
				.selectField('External_Call_Outcome__c')
				.selectField('AccountId')
				.selectField('Client_type__c')
				.selectField('Account.RecordType.DeveloperName') //PJAIN: 20200426
				.selectField('Account.Entity_type__c')
				.selectField('Account.Standard_Industry_SIC_Code__c')
				.selectField('Account.Date_Established__c')
				.selectField('Account.Trust_Number_New_format__c')
				.selectField('Account.Client_NCA_Status__c')
				.selectField('Account.Trust_Number__c')
				.selectField('Account.Country_of_Incorporation__c')
				.selectField('Account.Client_Type__c')
				.selectField('Account.Registration_Number__c')
				.selectField('Account.CIF__c')
				.selectField('Account.Name')//15225
				.selectField('Selected_Email__c')
				.selectField('Application_Status__c')
				.selectField('CASA_Status__c')
				.selectField('Fraud_Status__c')
				.selectField('CASA_Reference_Number__c')
				.selectField('CASA_Screening_Date__c')
				.selectField('PEP_Status__c')
				.selectField('CASA_Screening_Status_Value__c')
				.selectField('Material_Disclosure_Status__c')
				.selectField('Risk_Status__c')
				.selectField('Risk_Rating__c')
				.selectField('Risk_Rating_Date__c')
				.selectField('Risk_Rating_Message__c')
				.selectField('Material_Disclosures__c')
				.selectField('Material_Disclosure_Status__c')
				.selectField('Declaration_Status__c')
				.selectField('WIBF_Status__c')
				.selectField('Email_Status__c')
				.selectField('Product__c')
				.selectField('CIF_Number__c')
				.selectField('Commencement_Date__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Adviser_BRID_Number__c')
				.selectField('Spouse_Date_of_Birth__c')
				.selectField('WBIF_Last_Error_Message__c')
				.selectField('WBIF_Last_Error_Date__c')
				.selectField('WBIF_Validate_Status__c')
				.selectField('WBIF_Submit_Status__c')
				.selectField('WBIF_Submit_Message__c')
				.selectField('WBIF_Policy_Number__c')
				.selectField('OwnerId')
				.selectField('SyncedQuoteId')
				.selectField('Selected_Email__c')
				.selectField('RecordTypeId')
				.selectField('Adviser__c')
				.selectField('Site__c')
				.selectField('Financial_Needs_Analysis__c')
				.selectField('Lead_Number__c')
				.selectField('RecordType.Name')
				.selectField('RecordType.DeveloperName')
				.selectField('Entity_Type__c')
				.selectField('IsClosed')
				.selectField('Case__c')
				.selectField('Case__r.Status')
				.selectField('Case__r.RecordType.Name')
				.selectField('Digital_Hold_Response__c')
				.selectField('Domicile_Response__c')
				.selectField('IsClosed')
				.selectField('FraudRiskAlert__c')
				.selectField('FraudRiskActionTaken__c')
				.selectField('Opportunity_Number__c')
				.selectField('SiteCode__c')
				.selectField('Application_Source__c')
				.selectField('Account.SPM_region__c')
				.selectField('Account.Passport_Expiry_Date__c')
				.selectField('Relationship_Manager__c')
				.selectField('Linked_Private_Banker_Wealth_Manager__c')
				.selectField('Client_Group__c')
				.selectField('Country_Of_Registration__c')
				.selectField('Platform__c')
				.selectField('Product_Wrapper__c')
				.selectField('House_Portfolio__c')
				.selectField('Independent_Financial_Advisor__c')
				.selectField('Portfolio_Manager__c')
				.selectField('Merchant_TransUnion_Inquiry_Passed__c')
				.selectField('Merchant_Experian_Inquiry_Passed__c')
				.selectField('Merchant_Match_Inquiry_Passed__c')
				.selectField('RecordType.DeveloperName')
				.selectField('Website_URL__c')
				.selectField('Site_Terms_Conditions_URL__c')
				.selectField('Privacy_Policy_URL__c')
				.selectField('Refund_Policy_URL__c')
				.selectField('MotivationDocURL__c')
				.selectField('SelectedProduct__c') //Absa 5306 doc
				.selectField('DomicileChangeSuccess__c')
				.selectField('Domicile_Response__c')
				.selectField('StageName')
				.selectField('FICA_Message__c')
				.selectField('Process_Type__c')
				.selectField('DigitalHoldSuccess__c')
				.selectField('Digital_Hold_Response__c')
				.selectField('Branch_Region_Site__c')
				.selectField('Opportunity_Number__c')
				.selectField('Annual_turnover__c')
				.selectField('Regional_office_address_for_notices__c')
				.selectField('Regional_Manager__c')
				.selectField('Regional_Manager__r.Name')
				.selectField('Regional_Manager__r.Phone')
				.selectField('Regional_Manager__r.MobilePhone')
				.selectField('Form_Status__c')
				.selectField('Was_the_credit_request_approved__c')
				.selectField('Business_Unit__c') // for ce the change
				.selectField('Product_Interest__r.Product__c')// Added for Direct Delivery Sales Record type
            	.selectField('Product_Interest__c')// Added for Direct Delivery Sales Record type
				.selectField('Marital_Status__c')//added by short term insurance
            	.selectField('STIMarital_Contract_Type__c') //added by short term insurance
            	.selectField('addressLine1C__c') //added by short term insurance
            	.selectField('addressLine2__c') //added by short term insurance
            	.selectField('Person_Account_Age__c') //added by short term insurance
            	.selectField('CampaignId') //added by short term insurance
				.selectField('Mobile__c') //added by short term insurance
				.selectField('Physical_Address_city__c') //added by short term insurance
				.selectField('Person_BirthDate__c') //added by short term insurance
				.selectField('Occupational_Status__c') //added by short term insurance
				.selectField('Person_Account_First_Name__c') //added by short term insurance
				.selectField('STIGender__c') //added by short term insurance
				.selectField('Home_Phone__c') //added by short term insurance
				.selectField('ID_Number__c') //added by short term insurance
				.selectField('STIId_Type__c') //added by short term insurance
				.selectField('Initials__c') //added by short term insurance
				.selectField('Person_Account_Last_Name__c') //added by short term insurance
				.selectField('Lead_Id__c') //added by short term insurance
				.selectField('Nationality__c') //added by short term insurance
				.selectField('STIPerson_Occupation__c') //added by short term insurance
				.selectField('PostalAddressLine1C__c') //added by short term insurance
				.selectField('postalAddressLine2C__c') //added by short term insurance
				.selectField('postalCityC__c') //added by short term insurance
				.selectField('postalCodeC__c') //added by short term insurance
				.selectField('postalPostalCode__c') //added by short term insurance
				.selectField('postalSuburb__c') //added by short term insurance
				.selectField('Staff_Flag__c') //added by short term insurance
				.selectField('suburb__c') //added by short term insurance
				.selectField('Person_Title__c') //added by short term insurance
				.selectField('Work_Phone__c') //added by short term insurance
				.selectField('AccountId') //added by short term insurance
				.selectField('ExecutionLayerRequestID_Text__c')
            	.selectField('ExecutionLayerRequestID__c')
				.selectField('Lead_Branch_Employee_Number__c') //added by DD WBIF Requirement
				.selectField('Lead_Branch_Site_Code__c') //added by DD WBIF Requirement
				.selectField('ExecutionLayerRequestID_Text__c')
            	.selectField('ExecutionLayerRequestID__c')
				.selectField('Source_of_Wealth_Capitalization__c')
				.selectField('Digital_Onboarding_Type__c')//15736
				.setCondition('Id = :opportunityId')
				.toSOQL()
		);
	}

	/**@description selectbyopportunityidwithCommission description
	 * Opportunity query by Opportunity Id without a limit
	 * Method that takes a opportunity Id
	 * @param opportunityId (Id)
	 * @param recordLimit (Integer)
	 * @return List<Opportunity> - returns a list of opportunities
	 */
	public List<Opportunity> selectByOpportunityIdWithCommission(Id opportunityId, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Commission_1st_Year__c')
				.selectField('Commission_2nd_Year__c')
				.setCondition('Id = :opportunityId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**@description selectBySetAccountIds description
	 * Opportunity query by set of AccountIds without a limit
	 * @param accountIds (Set<Id>) - set of account Id's
	 * @return List<Opportunity> - returns a list of opportunities
	 */

	 
	public List<Opportunity> selectBySetAccountIds(Set<Id> accountIds) {
		return Database.query(
			newQueryFactory(false)
				.selectField('AccountId')
				.selectField('CASA_Status__c')
				.selectField('Risk_Status__c')
				.selectField('Process_Type__c')
				.selectField('ByPassValidationInApex__c')
				.selectField('IsFutureExecute__c')
                 .selectField('StageName')
				.setCondition('AccountId IN :accountIds')
				.toSOQL()
		);
	}

	/**@description Returns a map of all opportunities based on a set of Ids @description
	 *
	 * @param opptyIdsSet (Set<Id>)    A set of opportunity Ids
	 * @return Map<Id, Opportunity> a map of opportunities as well as their Id
	 */
	public Map<Id, Opportunity> selectOpportunitiesById(Set<Id> opptyIdsSet) {
		return new Map<Id, Opportunity>(
			(List<Opportunity>) Database.query(
				newQueryFactory(false)
					.selectField('Id')
					.selectField('AccountId')
					.selectField('Account.IsPersonAccount')
					.selectField('Account.PersonContactId')
					.setCondition('Id IN: opptyIdsSet')
					.toSOQL()
			)
		);
	}
	/**@description selectByOppId @description
	 *
	 * @param opportunityId (Id)    A set of opportunity Ids
	 * @return Map<Id, Opportunity> a map of opportunities as well as their Id
	 */
	public Opportunity selectByOppId(Id opportunityId) {
		return Database.query(
			newQueryFactory()
				.selectField('StageName')
				.selectField('Name')
				.selectField('AccountId')
				.selectField('RecordType.Name')
				.selectField('Client_type__c')
				.selectField('Account.CIF__c')
				.selectField('Account.Entity_type__c')
				.selectField('Account.Standard_Industry_SIC_Code__c')
				.selectField('Account.Date_Established__c')
				.selectField('Account.Trust_Number_New_format__c')
				.selectField('Account.Trust_Number__c')
				.selectField('Account.Registration_Number__c')
				.selectField('Account.Client_NCA_Status__c')
				.selectField('Account.Client_Type__c')
				.selectField('Account.Company_Registration_Number__c')
				.selectField('Account.Country_of_Incorporation__c')
				.selectField('Account.Date_Established__c')
				.selectField('Account.Employer_Name__pc')
				.selectField('Account.Client_Type__c')
				.selectField('Account.Registration_Number__c')
				.selectField('Account.FirstName')
				.selectField('Account.ID_Number__pc')
				.selectField('Account.CIF__c')
				.selectField('Account.ID_Type__pc')
				.selectField('Account.LastName')
				.selectField('Account.MiddleName')
				.selectField('Account.Name')
				.selectField('Account.Occupation__pc')
				.selectField('Account.Passport_Number__pc')
				.selectField('Account.PersonBirthdate')
				.selectField('Account.PersonMobilePhone')
				.selectField('Account.PersonMobilePhone')
				.selectField('Account.PersonOtherPhone')
				.selectField('Account.PersonOtherPhone')
				.selectField('Account.Registration_Number__c')
				.selectField('Account.Standard_Industry_SIC_Code__c')
				.selectField('Account.Trading_Name__c')
				.selectField('Account.Trust_Number__c')
				.selectField('Account.Trust_Number_New_format__c')
				.selectField('Account.VAT_Registration_Number__c')
				.selectField('Site__c')
				.selectField('SiteCode__c')
				.selectField('Illustrative_Decision__c')
				.selectField('Is_Spouse_Captured__c')
				.selectField('Spouse_Account_Id__c')
				.selectField('Account.SPM_region__c')
				.selectField('Account.SPM_region__c')
				.selectField('Merchant_Match_Inquiry_Passed__c')
				.selectField('Relationship_Manager__c')
				.selectField('Linked_Private_Banker_Wealth_Manager__c')
				.selectField('Platform__c')
				.selectField('Approval_Required__c')
				.selectField('Application_Source__c')
				.selectField('Account.Passport_Expiry_Date__c')
				.selectField('Trigger_Approval_Process__c')
				.selectField('Approval_Status__c')
				.selectField('Product_Wrapper__c')
				.selectField('House_Portfolio__c')
				.selectField('StageName')
				.selectField('Independent_Financial_Advisor__c')
				.selectField('Portfolio_Manager__c')
				.selectField('Complex_Application_Approval__c')
				.selectField('Passport_Expiry_Date__c')
				.selectField('PRI_Number__c')
				.selectField('Selected_Product_Family__c') //Saurabh :20210420 Added this for Vertical tabs
				.selectField('Application_Product_Facility_JSON__c')
				.selectField('Website_URL__c')
				.selectField('Annual_turnover__c')
				.selectField('Site_Terms_Conditions_URL__c')
				.selectField('Privacy_Policy_URL__c')
				.selectField('Refund_Policy_URL__c')
				.selectField('QA_Complex_Approval_Status__c')
				.selectField('Complex_Application__c')
				.selectField('Secured_by_mortgage__c')
				.selectField('Sanctioning_SLA_Start_Date__c')
				.selectField('Pricing_Refer_DateTime__c')
				.selectField('Approval_Owner__c')
				.selectField('Reprocessing__c')
				.selectField('Customer_Compliant__c')
				.selectField('Account.ID_Type__c')
				.selectField('Account.Entity_type__c')
				.selectField('Account.FirstName')
				.selectField('Client_Has_Accs_Prdcts_Relationship_Bank__c')
				.selectField('Client_Or_Person_On_US_Citizenship__c')
				.selectField('Owner')
				.selectField('Owner.FirstName')
				.selectField('Owner.LastName')
				.selectField('Owner.Profile')
				.selectField('Owner.Id')
				.selectField('PEP_Status__c')
            	.selectField('Mobile__c')
				.selectField('Email__c')
            	.selectField('Sys_BypassValidation__c')
            	.selectField('CloseDate')
                .selectField('Account.The_Client_is_involved_in_High_Risk_Indu__c')
				.selectField('Case__c')
				.setCondition('Id = :opportunityId')
				.toSOQL()
		);
	}

	/**@description selectByOpptId description
	 * @return  opportunity
	 *
	 * @param oppId (Id) for GeneratingCQAcctNumber
	 *
	 */
	public Opportunity selectByOpptId(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('id')
				.selectField('CBPIndicator__c')
				.selectField('AccountId')
				.selectField('Cif_Number__c')
				.selectField('site__r.site_code__c')
				.selectField('product__c')
				.selectField('OwnerId')
				.selectField('Control_Officer_Type__c')
				.selectField('Control_Officer_Number__c')
				.selectField('Employee_Number__c')
				.selectField('Branch_Region_Site__c')
				.selectField('Group_or_Individual__c')
				.selectField('Overall_Site_Code__c')
				.selectField('Business_Segment_Indicator__c')
				.selectField('Business_Sub_Segment_Indicator__c')
				.selectField('Banking_Sector__c')
				.selectField('Franchise_Sector__c')
				.selectField('Approved_by_Employee__c')
				.selectField('Captured_by_Employee__c')
				.selectField('Approval_Required__c')
				.selectField('Trigger_Approval_Process__c')
				.selectField('Approval_Status__c')
				.selectField('Risk_Rating__c')
				.selectField('Account.Agricultural_Sub_Type__c')
				.selectField('CMS_Linking_Status__c')
				.setCondition('Id = :oppId')
				.toSOQL()
		);
	}

	/**@description selectOpportunityWithSpouseDetails description
	 * W-003818
	 * Returns  opportunity with Spouse person account Id for sole trader
	 *
	 * @param oppId (Id)
	 * @return Opportunity
	 * Added by : Almas Aleem :Absa
	 * @since : 2020-07-13
	 */
	public Opportunity selectOpportunityWithSpouseDetails(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('id')
				.selectField('AccountId')
				.selectField('Is_Spouse_Captured__c')
				.selectField('Spouse_Account_Id__c')
				.setCondition('Id = :oppId')
				.toSOQL()
		);
	}

	/**@description selectBySanctioningSLAInfoById description
	 * W-004682
	 * Returns  opportunity with sanctioning SLA Tracking
	 * @param oppId (Id)
	 * @return Opportunity
	 * Added by : Almas Aleem :Absa
	 * @since : 2020-07-20
	 */
	public Opportunity selectBySanctioningSLAInfoById(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('id')
				.selectField('Sanctioning_SLA_Start_Date__c')
				.selectField('Sanctioning_SLA_Hours_Calculated__c')
				.selectField('Sanctioning_SLA_End_Date__c')
				.selectField('Sanctioning_SLA_Temp_Start_Date__c')
				.selectField('Sanctioning_SLA_Temp_End_Date__c')
				.selectField('More_Info_Decision__c')
				.selectField('More_Info_Category__c')
				.selectField('More_Info_Comment__c')
				.selectField('Trigger_Approval_Process__c')
				.selectField('Sanctioning_Refer_DateTime__c')
				.selectField('Pricing_Refer_DateTime__c')
				.selectField('Approval_Owner__c')
				.selectField('Is_Referred_Pricing__c')
				.selectField('ownerId')
				.selectField('ownerId.Name')
				.selectField('Name')
				.setCondition('Id= :oppId')
				.toSOQL()
		);
	}

	/**
	 * @description selectIsOpenByOwnerByAccount description
	 *
	 * @param userId (Id): userId
	 * @param accountId (Id): accountId
	 * @return Return List<Opportunity>: Return description
	 */
	public List<Opportunity> selectIsOpenByOwnerByAccount(Id userId, Id accountId) {
		String status = 'Closed';
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('StageName')
				.selectField('OwnerId')
				.selectField('AccountId')
				.setCondition('OwnerId = :userId and AccountId = :accountId and StageName != :status ')
				.toSOQL()
		);
	}
	//CUSTOM SELECTORS - END
}