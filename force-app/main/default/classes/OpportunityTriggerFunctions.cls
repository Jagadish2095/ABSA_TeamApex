/**
* @description Created by kylealexander on 2018/08/01.
*/
public class OpportunityTriggerFunctions {
    /**
* @description Probability calculator for all calls and marks whether an opportunity should be QA'ed
* @param opportunity
* @param users
*/
    
    public static void qualityAssuranceCalculation(Opportunity opportunity, Map<Id, User> users) {
        String successType = checkStageSuccess(opportunity.StageName);
        QualityAssuranceProbabilityCalculator.calculateIfQaSet(opportunity, users.get(opportunity.OwnerId), successType);
    }
    
    /**
* @description EPP Validation checks to check if opportunity main member is withing age bracket
* @param triggerNew - opp new record values
*/
    public static void eppInsertValidations(List<sObject> triggerNew) {
        List<Opportunity> oppTriggerNew = (List<Opportunity>) triggerNew;
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        
        Set<Id> opportunityAccountIds = new Set<Id>();
        Set<Id> userList = new Set<Id>();
        //Added By Divya
        Set<Id> opportunityCaseIds = new Set<Id>();
        for (Opportunity opportunity : oppTriggerNew) {
            opportunityAccountIds.add(opportunity.AccountId);
            userList.add(opportunity.OwnerId);
            //userList.add(opportunity.Who_is_receiving_the_opportunity__c);
            if(opportunity.case__c != null)
            {
                opportunityCaseIds.add(opportunity.Case__c);
            }
        }
        Map<Id, Account> accounts = new Map<Id, Account>(
            [SELECT Id, Name, Age__pc, ID_Number__pc, PersonBirthdate, PersonContact.Email,RecordType.Name,
             		BillingCity,BillingState,BillingStreet,BillingPostalCode,BillingCountry,
             		ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode
                 	FROM Account WHERE Id IN :opportunityAccountIds]
        );
        Map<Id,User> userMap = new  Map<Id,User>([select id,Name,Profile.Name from user where Id IN : userList]);
        //Added By Divya
        Map<Id, Case> cases = new Map<Id, Case>([select Id,Alternate_Phone1__c,Alternate_Phone2__c,Alternate_Phone3__c
                                                 from case where Id IN : opportunityCaseIds]);
        
        //Get min age and max age from metadata
        General_Rules__mdt rulesMdt = [
            SELECT Minimum_Age__c, Maximum_Age__c
            FROM General_Rules__mdt
            WHERE Product__c = 'Estate Provider Plan' AND Label = 'EPP Main Member'
        ];
        Decimal minAge = rulesMdt.Minimum_Age__c;
        Decimal maxAge = rulesMdt.Maximum_Age__c;
        
        for (Opportunity opportunity : oppTriggerNew) {
            //Check if record type is VA
            if (rtMap.get(opportunity.recordTypeId).getName().containsIgnoreCase('Virtual Advisor') && 
                opportunity.External_Lead_Ref_Number__c != 'Investment') {
                Account acc = accounts.get(opportunity.AccountId);
                if (acc.Age__pc == null) {
                    opportunity.addError('Please enter a birthdate or ID number for the main member as their age needs to be calculated to quote the client');
                } else if (acc.Age__pc < minAge) {
                    opportunity.addError('The clients age must be more than ' + minAge);
                } else if (acc.Age__pc >= maxAge) {
                    opportunity.addError('The clients age must be less than ' + maxAge);
                }
                
                if (opportunity.Originating_Agent__c == null) {
                    opportunity.Originating_Agent__c = UserInfo.getUserId();
                }
                
            }
            //Added By Divya
            Account acc;
        }
    }
    
    /**
* @description Updated by : Himanshu Nimje
* Updated Date: 13/09/2018
* future callout to Integration handler to siebel to update Opp Stage changed
* @param  opportunityId
* @param  stageName
* @param externalId
* @param opportunityProduct
*/
    @future(callout=true)
    public static void updateSiebelOfStageChange(Id opportunityId, String stageName, String externalId, String opportunityProduct) {
        String reasonWonLost = '';
        if (stageName == 'Not Interested' || stageName == 'Uncontactable' || stageName == 'Premium too High' || stageName == 'Sale Successful') {
            reasonWonLost = stageName;
            stageName = 'Closed';
        }
        
        UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(opportunityId, reasonWonLost, externalId, opportunityProduct, stageName);
    }
    
    /**
* @description Method that checks if the closed status is classified as successful or unsuccessful
* @param currentStage
* @return String
* if the stage is classified as successful or unsuccessful
*/
    public static String checkStageSuccess(String currentStage) {
        if (currentStage == 'Not Interested' || currentStage == 'Uncontactable' || currentStage == 'Premium too High') {
            return 'Unsuccessful';
        } else if (currentStage == 'Sale Successful') {
            return 'Successful';
        }
        
        return null;
    }
        
     /**
	 * @description Method to update existing account details 
	 * @param accountId existing account found
	 * @param leadId the lead record
	 *
	 */
	public static void upsertExistingAddressDetails(Id accountId, Id leadId) {
        Lead leadRecord = new LeadsSelector().selectLeadById(leadId);
        List<Address__c> postalAddresses = new List<Address__c>();
        List<Address__c> physicalAddresses = new List<Address__c>();
        if (accountId != null) {
        	//get the account related address
         	postalAddresses = new AddressesSelector().selectByAccountAndType(accountId, 'Postal');
         	physicalAddresses = new AddressesSelector().selectByAccountAndType(accountId, 'Physical Address');
            if(physicalAddresses.size() > 0){
            	physicalAddresses[0].Shipping_Street__c = leadRecord.Street;
            	physicalAddresses[0].Shipping_City__c = leadRecord.city;
            	physicalAddresses[0].Shipping_Suburb__c = leadRecord.state;
            	physicalAddresses[0].Shipping_Zip_Postal_Code__c = leadRecord.postalcode;
            	physicalAddresses[0].Address_Type__c = 'Physical Address';
            }
            else{
                Address__c newPhsical = new Address__c();
                newPhsical.Shipping_Street__c = leadRecord.Street;
            	newPhsical.Shipping_City__c = leadRecord.city;
            	newPhsical.Shipping_Suburb__c = leadRecord.state;
            	newPhsical.Shipping_Zip_Postal_Code__c = leadRecord.postalcode;
            	newPhsical.Address_Type__c = 'Physical Address';
                newPhsical.Account__c = accountId;
                newPhsical.Client_Entity_Type__c = 'Individual';
                physicalAddresses.add(newPhsical);
            }
            if(postalAddresses.size() > 0){
            	postalAddresses[0].Shipping_Street__c = leadRecord.Street;
            	postalAddresses[0].Shipping_City__c = leadRecord.city;
            	postalAddresses[0].Shipping_Suburb__c = leadRecord.state;
            	postalAddresses[0].Shipping_Zip_Postal_Code__c = leadRecord.postalcode;
            	postalAddresses[0].Address_Type__c = 'Postal';
            }
            else{
                Address__c newPostal = new Address__c();
                newPostal.Shipping_Street__c = leadRecord.Street;
            	newPostal.Shipping_City__c = leadRecord.city;
            	newPostal.Shipping_Suburb__c = leadRecord.state;
            	newPostal.Shipping_Zip_Postal_Code__c = leadRecord.postalcode;
            	newPostal.Address_Type__c = 'Postal';
                newPostal.Account__c = accountId;
                newPostal.Client_Entity_Type__c = 'Individual';
                postalAddresses.add(newPostal);
            }
        }
        upsert postalAddresses;
        upsert physicalAddresses;
    }
    
    /**
*@description Method that gets the Exergy Cover available
* Poulami - 07/11/2020
* @param oppId
*/
    @future(callout=true)
    public static void getExergyPolicyCover(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        Opportunity opp = opportunities[0];
        ExergyPolicyGetCover_Resp_IB_v1 exergyResponse;
        if (!Test.isRunningTest()) {
            exergyResponse = ExergyPolicyGetCover_IH_v1.ExergyPolicyGetCover('1', opp.ID_Number__c);
        }
        
        if (Test.isRunningTest()) {
            //For unit tests
            opp.Available_Cover__c = 10000.00;
            update opp;
        } else if (exergyResponse.Envelope.Body.ResponseMessage != null) {
            if (
                exergyResponse.Envelope.Body.ResponseMessage.Policy_GetClientExposureExergyResponse.Policy_GetClientExposureExergyResult.TotalCoverAvailable !=
                null
            ) {
                opp.Available_Cover__c = Double.valueOf(
                    exergyResponse.Envelope.Body.ResponseMessage.Policy_GetClientExposureExergyResponse.Policy_GetClientExposureExergyResult.TotalCoverAvailable
                );
                update opp;
            }
        }
    }
    
    /**
* @description Created by : Manoj Danthala
* Created Date: 08/04/2019
* future callout to Integration handler to ESP for onboarding process
* @param OpportunityId
*/
    @future(callout=true)
    public static void sendLeadsToESP(Id OpportunityId) {
        ESPOnboarding_IH_v1.callToESPOnboarding(OpportunityId);
    }
    
    /**
* @description Created by : Mbuyiseni Mbhokane
* Created Date: 25/06/2020
* future callout to Integration handler to lift the digital hold.
* @param oppId
*/
    @future(callout=true)
    public static void updateChequeHolds(Id oppId) {
        //call the selectors:
        OpportunityLineItem opportunityProduct = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
        //set the parameters that should be passed:
        String accountNumberP = opportunityProduct.Policy_number__c;
        String blocked = 'N';
        String courtOrder = 'N';
        String mandateRequired = 'N';
        String dormant = 'N';
        String semiDormant = 'N';
        String confiscated = 'N';
        String externalTransfer = 'N';
        String staff = 'N';
        String creditAccount = 'N';
        String excludeFromEstate = 'N';
        String blockAdhocDbt = 'N';
        String blockAdhocCrd = 'N';
        String specialRqpRedirect = 'N';
        String commercialPropFin = 'N';
        String misHold = 'N';
        String genSecMsg = 'N';
        String genSecNum = '0';
        String wapWildAccPickup = 'N';
        String exclFromInsolvent = 'N';
        String digitalHold = 'N';
        String odSwitchInd = 'N';
        
        //call update holds method
        Map<CQupdAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4(
            accountNumberP,
            blocked,
            courtOrder,
            mandateRequired,
            dormant,
            semiDormant,
            confiscated,
            externalTransfer,
            staff,
            creditAccount,
            excludeFromEstate,
            blockAdhocDbt,
            blockAdhocCrd,
            specialRqpRedirect,
            commercialPropFin,
            misHold,
            genSecMsg,
            wapWildAccPickup,
            exclFromInsolvent,
            digitalHold,
            odSwitchInd
        );
        CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (new List<CQupdAcctHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
        //response logs list
        List<Sys_Log_Integration__c> responseLogs = responseMap.values()[0];
        //List to upsert the logs
        List<Sys_Log_Integration__c> createSysLogs = new List<Sys_Log_Integration__c>();
        
        for (Sys_Log_Integration__c resLog : responseLogs) {
            resLog.Status__c = responseBean.message;
            resLog.Status_Code__c = responseBean.statusCode;
            //resLog.Response__c = nbsmsgo3Bean.msgEntry.msgTxt;
            resLog.Response__c = JSON.serialize(responseBean);
            createSysLogs.add(resLog);
        }
        
        if (createSysLogs != null && !createSysLogs.isEmpty()) {
            upsert createSysLogs;
        }
    }
    /*private static Date convertIdNumberToBirthdate(String idNum){
String year = idNum.substring(0, 2);
String month = idNum.substring(2, 4);
String day = idNum.substring(4, 6);

Integer currentYear = System.today().year();
String curYear = String.valueOf(currentYear).substring(0, 2);
String newYear;
if(Integer.valueOf(curYear) >= Integer.valueOf(year)){
newYear = '20' + year;
}
else{
newYear = '19' + year;
}

Date d = Date.newinstance(Integer.valueOf(newYear), Integer.valueOf(month), Integer.valueOf(day));
return d;
}*/
    
    /**
* @description Method to call Marble Service
* @param oppId
*/
    @future(callout=true)
    public static void marblecreateAccountService(Id oppId) {
        SPMMarbleCreateAccount_Req_IB_V1 requestBean = SPMBankingDetailsController.mapRequestFields(oppId);
        SPMMarbleCreateAccount_Resp_IB_V1 responseBean = SPMMarbleCreateAccount_IH_V1.getMarbleAccountNumber(requestBean);
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Account accRec = new AccountsSelector().selectByOpportunityId(OppId);
        Opportunity oppRec = new OpportunitiesSelector().selectByOppId(OppId);
        if ((responseBean != null) && (responseBean.statusCode == 200)) {
            if (responseBean.statusCode == 200 && responseBean.Result.status != 200) {
                //Error in Response
                string body =
                    '\n\n Marble ID for Account  ' +
                    accRec.Name +
                    ' has not been created.' +
                    '\n\n Opportunity Name: ' +
                    oppRec.Name +
                    '\n\n Error Message: ' +
                    responseBean.Result.status +
                    ' ' +
                    responseBean.Result.errorCode +
                    ' ' +
                    responseBean.Result.errorMessage +
                    '\n\n Please log in and generate the Marble number.' +
                    '\n\n Regards' +
                    '\n Absa Stockbrokers  & Portfolio Management | Wealth and Investment Management';
                
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(
                    Network.getNetworkId(),
                    oppId,
                    'Good day {' +
                    oppRec.OwnerId +
                    '} ,' +
                    body
                );
            } else {
                app[0].Account_Number__c = string.valueOf(responseBean.entityId);
                update app[0];
                oppRec.stageName = 'Closed Won';
                update oppRec;
                //Error in Response
                string body =
                    '\n Marble ID for Account ' +
                    accRec.Name +
                    ' has been successfully created.' +
                    'Marble ID: ' +
                    app[0].Account_Number__c +
                    '\n\n Opportunity Name: ' +
                    oppRec.Name +
                    '\n\n The opportunity has been closed with status: “Closed Won” ' +
                    '\n\n Regards' +
                    '\n Absa Stockbrokers  & Portfolio Management | Wealth and Investment Management';
                
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(
                    Network.getNetworkId(),
                    oppId,
                    'Good day {' +
                    oppRec.OwnerId +
                    '} ,' +
                    body
                );
            }
        }
    }
    
    /** @description checkCertificateApprovedValidation
     * @param Newopportunity
     * @param docMap
     **/
    public static void checkCertificateApprovedValidation(Opportunity Newopportunity,Map<Id,ContentDocumentLink> docMap)
    {
        boolean flag = true;
        for(Id DocId : docMap.keySet())
        {
            if(docMap.get(DocId).LinkedEntityId == Newopportunity.Id)
            {
                String title = docMap.get(DocId).ContentDocument.title;
                if(title.containsIgnoreCase('certificate'))
                {
                    flag = false;
                }
            }
        }
        if(flag)
        {
            Newopportunity.addError('Please upload QA Certificate under Opportunity. Please make sure Certificate should contain \'QA_Certificate\'');
        }
    }
     /** @description checkCertificateRejectValidation
     * @param Newopportunity
     * @param processMap
     **/
    public static void checkCertificateRejectValidation(Opportunity Newopportunity,Map<Id,ProcessInstance> processMap)
    {
        boolean flag = true;
        for(Id processId : processMap.keySet())
        {
            if(processMap.get(processId).TargetObjectId == Newopportunity.id)
            {
                for(ProcessInstanceStep step : processMap.get(processId).Steps)
                {
                    if(String.isBlank(step.Comments))
                    {
                        Newopportunity.addError('Pleae fill Comments before Rejection');
                    }
                }
            }
        }
    }
    /**
    * @description 
    * @author vineel.rudroju@absa.africa | 2021-11-30 
    * @param oppId 
    **/
    public static void callECPLeadService(Id oppId){
        List<Application__c> appRec = [SELECT id, Product_Interest__c FROM Application__c WHERE Opportunity__c =:oppId];
        
        Opportunity optyAccount = [SELECT Id, Name, AccountId FROM Opportunity WHERE Id =:oppId];
        if(appRec.size() > 0){
            if(appRec[0].Product_Interest__c == 'Protect your Employees'){
            EcpLeads_IH_v1.sendEcpLead(optyAccount.AccountId, appRec[0].Product_Interest__c, 'Active');
            }
        }
    }
    /** @description ristricDeletaionForVA
     * @param Mapofopp
     **/
    public static void ristricDeletaionForVA(Map<Id,Opportunity> Mapofopp){
        List<PermissionSetAssignment> uPermissionName = new PermissionSetAssignmentsSelector().selectByUserId(UserInfo.getUserId());
        boolean allowDelete = false;
        if (uPermissionName.size() > 0) {
            for (PermissionSetAssignment perName : uPermissionName) {
                if (perName.PermissionSet.Name.equals('Authority_for_Delete_Opportunities'))
                {
                    allowDelete=true;
                }
            }
        }
        if(!allowDelete)
        {
           for(Opportunity opp:[select id from Opportunity where recordtype.name = 'Investment Opportunity' and id IN : Mapofopp.keySet()])
            {
                 Mapofopp.get(opp.id).addError('You are restricted to delete Opportunities');
            }
        }
    }
}