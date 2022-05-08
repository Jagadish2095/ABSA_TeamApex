/**
* Integration Handler for Create Opportunity function
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-08-22
* @Updated by Jason Quevauvilliers
* @Updated Date 2018-08-23
*/
public class CreateOpportunity_IU_v1 {
    
    /* Map fields to an Opportunity
     * @param: Account Id
     * @param: CreateOpportunity_Req_IB_v1 instance
     * @param: Transaction Id Header
     * @param: Initiator Header
     * @param: Sender Header
     * @param: Advisor User
     * @return: Opportunity*/
	public static Opportunity mapFieldsOpportunity(Id accountIdP, CreateOpportunity_Req_IB_v1 createOpportunityPostP, String transactionIdP, String initiatorP, String senderP, User advisorUsrP){

        //Set record type to the value passed by opptySalesChannel variable
        Id virtualAdvisorRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(createOpportunityPostP.opptySalesChannel).getRecordTypeId();

        //Map fields to Opportunity
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Adviser_AB_Number__c = createOpportunityPostP.adviserABNumber;
        newOpportunity.Adviser_BRID_Number__c = createOpportunityPostP.adviserBRID;
        newOpportunity.Campaign_Code__c = createOpportunityPostP.campaignCode;
        newOpportunity.Campaign_Name__c = createOpportunityPostP.campaignName;
        newOpportunity.Name = createOpportunityPostP.opptyName;
        newOpportunity.AccountId = accountIdP;
        newOpportunity.Product__c = createOpportunityPostP.opptyProduct;
        newOpportunity.RecordTypeId = virtualAdvisorRecordType;
        newOpportunity.LeadSource = createOpportunityPostP.opptySouceType;
        newOpportunity.Sub_Product__c = createOpportunityPostP.opptySubProduct;
        newOpportunity.Type = createOpportunityPostP.opptyType;
        newOpportunity.Originating_Adviser_AB_Number__c = createOpportunityPostP.origAdviserABNumber;
        newOpportunity.Originating_Adviser_BRID_Number__c = createOpportunityPostP.origAdviserBRID;
        newOpportunity.External_Siebel_ID__c = createOpportunityPostP.origLeadId;
        newOpportunity.External_Lead_Ref_Number__c = createOpportunityPostP.origLeadId;
        newOpportunity.Will_Number__c = createOpportunityPostP.willNumber;
        newOpportunity.OwnerId = advisorUsrP.id;
        newOpportunity.StageName = 'Value Proposition/Qualification';
        newOpportunity.CloseDate = Date.today() + 10;
        
        //Try link Siebel Agent to Salesforce user by BRID number if they exist
        List<User> originatingUsers = new UsersSelector().selectByBridNumber(createOpportunityPostP.origAdviserBRID);
        if(originatingUsers.size() == 1){
            
            newOpportunity.Originating_Agent__c = originatingUsers[0].id;
        }
        //Audit Fields
        newOpportunity.Last_External_Update_Reference__c = transactionIdP;
        newOpportunity.Last_External_Update_User__c  = initiatorP;
        newOpportunity.Last_External_Update_System__c  = senderP;
        newOpportunity.Last_External_Update_Time__c  = System.now();

        return newOpportunity;

    }
    
    //Not using to map account fields since AccountCreateGetInvolvedParty now maps and creates the account
    /* Map fields to an Account
     * @param: CreateOpportunity_Req_IB_v1 instance
     * @param: Transaction Id Header
     * @param: Initiator Header
     * @param: Sender Header
     * @param: Advisor User
     * @return: Account*/
    /*public static Account mapFieldsAccount(CreateOpportunity_Req_IB_v1 createOpportunityPostP, String transactionIdP, String initiatorP, String senderP, User advisorUsrP){
		
		//Set as Person Account / Individual Client
        Id personRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(StringConstants.ACCOUNT_RECORD_TYPE_INDIVIDUAL_CLIENT).getRecordTypeId();
		
        //If Call start time passed is null, then set the DateTime to null otherwise parse the String to a DateTime
		Date casaScreeningDate;
		if(createOpportunityPostP.CASAScreeningDate == null || String.isBlank(createOpportunityPostP.CASAScreeningDate)){
			casaScreeningDate = null;
		}
		else{
			casaScreeningDate = Date.valueOf(createOpportunityPostP.CASAScreeningDate);
		}
		//Map Account Fields
		Account newAccount = new Account();
		newAccount.CASA_Reference_Number__c = createOpportunityPostP.CASAReferenceNumber;
		newAccount.CASA_Risk_Status__c = createOpportunityPostP.CASARiskStatus;
		newAccount.CASA_Screening_Date__c = casaScreeningDate;
		newAccount.CASA_Screening_Status__c = createOpportunityPostP.CASAScreeningStatus;
		newAccount.CASA_Analyst_Comments__c = createOpportunityPostP.CASAAnalystComments;
		newAccount.PersonMobilePhone = createOpportunityPostP.clientCellNumber;
		newAccount.CIF__c = createOpportunityPostP.clientCIFCode;
		newAccount.Country_of_Residence__pc = createOpportunityPostP.clientCountryofResidence;
		newAccount.PersonBirthdate = Date.valueOf(createOpportunityPostP.clientDOB);
		newAccount.PersonEmail = createOpportunityPostP.clientEmail;
		newAccount.FirstName = createOpportunityPostP.clientFirstName.substring(0,Math.min(createOpportunityPostP.clientFirstName.length(), 40));
		newAccount.PersonHomePhone = createOpportunityPostP.clientHomeNumber;
		newAccount.External_Siebel_ID__c = createOpportunityPostP.clientId;
		newAccount.ID_Number__pc = createOpportunityPostP.clientIdNumber;
		newAccount.ID_Type__pc = createOpportunityPostP.clientIdType;
		newAccount.LastName = createOpportunityPostP.clientLastName;
		newAccount.Nationality__pc = createOpportunityPostP.clientNationality;
		newAccount.Occupation__pc = createOpportunityPostP.clientOccupation.substring(0,Math.min(createOpportunityPostP.clientOccupation.length(), 80));
		newAccount.Onboarding_Channel__c = createOpportunityPostP.clientOnboardingChannel;
		newAccount.Communication_Language__pc = createOpportunityPostP.clientPrefLanguage;
		newAccount.PersonTitle = createOpportunityPostP.clientTitle;
		newAccount.Client_Type__c = createOpportunityPostP.clientType;
		newAccount.Phone = createOpportunityPostP.clientWorkNumber;
		newAccount.Gender__pc = createOpportunityPostP.clientGender;
		newAccount.Initials__pc = createOpportunityPostP.clientInitials;
		newAccount.Marital_Status__pc = createOpportunityPostP.clientMaritalStatus;
		newAccount.Marital_Contract_Type__pc = createOpportunityPostP.clientMaritalContractType;
		newAccount.Income_Source__pc = createOpportunityPostP.clientSourceofIncome;
		newAccount.Occupation_Status__pc = createOpportunityPostP.clientOccupationStatus;
		newAccount.Income_Bracket__pc = createOpportunityPostP.clientIncomeBracket;
		newAccount.Occupation_Category__pc = createOpportunityPostP.clientOccupationCategory;
		newAccount.ShippingCity = createOpportunityPostP.physicalAddressCity.substring(0,Math.min(createOpportunityPostP.physicalAddressCity.length(), 40));
		newAccount.ShippingCountry = createOpportunityPostP.physicalAddressCountry;
        newAccount.ShippingStreet = (createOpportunityPostP.physicalAddressLine1 + ' ' + createOpportunityPostP.physicalAddressLine2 + ' ' + createOpportunityPostP.physicalAddressSuburb).substring(0,Math.min((createOpportunityPostP.physicalAddressLine1 + ' ' + createOpportunityPostP.physicalAddressLine2 + ' ' + createOpportunityPostP.physicalAddressSuburb).length(), 255));
		newAccount.ShippingPostalCode = createOpportunityPostP.physicalAddressPostalCode;
		newAccount.BillingCity = createOpportunityPostP.postalAddressCity.substring(0,Math.min(createOpportunityPostP.postalAddressCity.length(), 40));
		newAccount.BillingCountry = createOpportunityPostP.postalAddressCountry;
		newAccount.BillingStreet = (createOpportunityPostP.postalAddressLine1 + ' ' + createOpportunityPostP.postalAddressLine2 + ' ' + createOpportunityPostP.postalAddressSuburb).substring(0,Math.min((createOpportunityPostP.postalAddressLine1 + ' ' + createOpportunityPostP.postalAddressLine2 + ' ' + createOpportunityPostP.postalAddressSuburb).length(), 255));		
		newAccount.BillingPostalCode = createOpportunityPostP.postalAddressPostalCode;
		newAccount.RecordTypeId = personRecordType;
		newAccount.Person_Unique_Identifier__pc = createOpportunityPostP.clientIdType + createOpportunityPostP.clientIdNumber;
		newAccount.OwnerId = advisorUsrP.id;
		//Needs to be changed when mappings are finalized
		//Try map value and if it fails i.e. is not a valid picklist option then set it to null
		Schema.DescribeFieldResult fieldResult = Account.Country_of_Birth__pc.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		Boolean countryExists = false;
		for (Schema.PicklistEntry t : ple) {
			if (t.getValue().equals(createOpportunityPostP.clientCountryofBirth)) {
				countryExists = true;
			}
		}
		if(countryExists){
			newAccount.Country_of_Birth__pc = createOpportunityPostP.clientCountryofBirth;
		}else{
			newAccount.Country_of_Birth__pc = null;
		}
		//Audit Fields
		newAccount.Last_External_Update_Reference__c = transactionIdP;
		newAccount.Last_External_Update_User__c  = initiatorP;
		newAccount.Last_External_Update_System__c  = senderP;
		newAccount.Last_External_Update_Time__c = System.now();
		
		return newAccount;
	}*/
    
    /* Map Response fields to CreateOpportunity_Resp_IB_v1
     * @param: Status
     * @param: Description
     * @param: Opportunity Id
     * @return: CreateOpportunity_Resp_IB_v1 object*/
    public static CreateOpportunity_Resp_IB_v1 mapFieldsCreateOpportunityResponse(String statusP, Integer statusCodeP, String descriptionP, String opportunityIdP){
		
		CreateOpportunity_Resp_IB_v1 createOpportunityResponse = new CreateOpportunity_Resp_IB_v1();
		
		createOpportunityResponse.status = statusP;
        createOpportunityResponse.statusCode = statusCodeP;
		createOpportunityResponse.description = descriptionP;
		if(opportunityIdP != null ){
			createOpportunityResponse.opportunityId = opportunityIdP;
		}
		
		return createOpportunityResponse;
	}
    
    public static Task mapTaskFields(CreateOpportunity_Req_IB_v1 createOpportunityPostP){
		//If Call start time passed is null, then set the DateTime to null otherwise parse the String to a DateTime
		Datetime callStartTimeDate;
		if(createOpportunityPostP.callStartDateTime == null || String.isBlank(createOpportunityPostP.callStartDateTime)){
			callStartTimeDate = null;
		}else{
			callStartTimeDate = Datetime.valueOf(createOpportunityPostP.callStartDateTime);
		}

		//Create Task
		Task task = new Task();
		task.Call_ID__c = createOpportunityPostP.callId;
		task.Call_Start_Time__c = callStartTimeDate;
		task.Subject = 'Call';

		return task;
	}
}