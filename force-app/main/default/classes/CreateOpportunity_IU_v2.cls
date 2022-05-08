/**
* Integration Handler for Create Opportunity function
* @author Danie Booysen and Jason Quevauvilliers
* @created 2019 - 07 - 29
*/
public class CreateOpportunity_IU_v2 {
    
    /* Map fields to an Opportunity
     * @param: Account Id
     * @param: CreateOpportunity_Req_IB_v1 instance
     * @param: Transaction Id Header
     * @param: Initiator Header
     * @param: Sender Header
     * @param: Advisor User
     * @return: Opportunity*/
	public static Opportunity mapOpportunityFields(Id accountIdP, CreateOpportunity_Req_IB_v1 createOpportunityPostP, String transactionIdP, String initiatorP, String senderP, User advisorUsrP){

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
    
    /* Map Response fields to CreateOpportunity_Resp_IB_v1
     * @param: Status
     * @param: Description
     * @param: Opportunity Id
     * @return: CreateOpportunity_Resp_IB_v1 object*/
    public static CreateOpportunity_Resp_IB_v1 mapCreateOpportunityResponseFields(String statusP, Integer statusCodeP, String messageP, String opportunityIdP){
		
		CreateOpportunity_Resp_IB_v1 createOpportunityResponse = new CreateOpportunity_Resp_IB_v1();
		
		createOpportunityResponse.status = statusP;
        createOpportunityResponse.statusCode = statusCodeP;
		createOpportunityResponse.description = messageP;
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