/**
* @description Handler for the opportunity trigger
* @author  Kyle Alexander
* @created 2018-07-18
*/
public with sharing class TriggerHandlerOpportunity extends TriggerHandler{
    
    
    /**
* @description 
* @param triggerNew 
* @param triggerOld 
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    public virtual override void beforeUpdate(Map<Id, sObject> triggerNew, Map<Id, sObject> triggerOld) {
        //Cast sObject maps to Opportunity maps
        Map<Id, Opportunity> oppTriggerNew = (Map<Id, Opportunity>)triggerNew;
        Map<Id, Opportunity> oppTriggerOld = (Map<Id, Opportunity>)triggerOld;
        
        List<Opportunity> opportunities = convertMapToList(oppTriggerNew);
        
        Set<Id> opportunityOwnerIds = new Set<Id>();
        for(Opportunity opportunity : opportunities){
            opportunityOwnerIds.add(opportunity.OwnerId);
        }
        
        //get the opportunity record type
        Map<ID,Schema.RecordTypeInfo> rtMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<Id,ContentDocumentLink> docMap = new Map<Id,ContentDocumentLink>([SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.title 
                                                                              FROM ContentDocumentLink where LinkedEntityId IN :oppTriggerNew.keySet()]);
        Map<Id,ProcessInstance> approvalMap =new Map<Id,ProcessInstance>([SELECT id,TargetObjectId,(SELECT Id, Comments, StepStatus, Actor.Name, ProcessInstanceId,createdDate FROM Steps where StepStatus='Rejected' order by createddate desc limit 1) 
                                                                          FROM ProcessInstance where TargetObjectId IN :oppTriggerNew.keySet()]);
        Map<Id, User> users = new Map<Id, User>(new UsersSelector().selectByOpportunityOwnerId(opportunityOwnerIds));
        for(Opportunity opportunity : opportunities){
            //Check if stage has changed
            if(oppTriggerOld.get(opportunity.id).StageName != opportunity.StageName){
                
                //Update Siebel of Stage Change
                // OpportunityTriggerFunctions.updateSiebelOfStageChange(opportunity); This method used in after update method .
                // Added by Poulami to remove the validation for Direct Delivery Record Type
                if(opportunity.Opportunity_Record_Type_Name__c != 'Direct Delivery Sales Opportunity'){
                    if(opportunity.StageName == 'Not Interested' || opportunity.StageName == 'Uncontactable' || opportunity.StageName == 'Premium too High' || opportunity.StageName == 'Sale Successful'){
                        
                        //QA Calculation
                        OpportunityTriggerFunctions.qualityAssuranceCalculation(opportunity, users);
                    }
                    
                    if(opportunity.StageName == 'Sale Successful'){
                        if(opportunity.WBIF_Policy_Number__c == null && opportunity.Email_Status__c != 'Valid'){
                            opportunity.addError('Opportunity cannot be closed with Sale Successful unless a valid Policy Number is added and the required documents have been emailed to the customer!');
                        }
                        opportunity.CloseDate = system.today();
                    }
                }
            }
            
            //Opportunity Owner Check
            if(rtMap.get(opportunity.recordTypeId).getName().containsIgnoreCase('Investment Opportunity')){
                if(oppTriggerOld.get(opportunity.id).Ownerid != opportunity.Ownerid &&  users.get(opportunity.Ownerid).Profile.Name == 'Standard User (WIMI Advisor & Contact Center)')
                {
                    opportunity.addError('Please assign Opportunity to Advisors');
                }
            }
            
            //QA Approval Status Validation if Rejected AA user story W-005065
            if(oppTriggerOld.get(opportunity.id).QA_Complex_Approval_Status__c  != opportunity.QA_Complex_Approval_Status__c &&  opportunity.QA_Complex_Approval_Status__c == 'Rejected' &&
               opportunity.Rejection_Reasons__c == null){
                   opportunity.addError('Please enter a Rejection Reason before you reject the approval');
                   
                   
               }
            
            
            //QA Approval Status Validation if Recalled After a consultant has already started work on it
            //Added by Masechaba Maseli user story W-005227
            //further updated by Manish for W-009983
            if((oppTriggerOld.get(opportunity.id).QA_Complex_Approval_Status__c  != opportunity.QA_Complex_Approval_Status__c &&  opportunity.QA_Complex_Approval_Status__c == 'Not Submitted' &&
                oppTriggerOld.get(opportunity.id).QA_Complex_Approval_Status__c == 'Accepted By Approver') ||
               (oppTriggerOld.get(opportunity.id).Disputed_QA_Approval_Status__c  != opportunity.Disputed_QA_Approval_Status__c &&  opportunity.QA_Complex_Approval_Status__c == 'Not Submitted' &&
                oppTriggerOld.get(opportunity.id).Disputed_QA_Approval_Status__c == 'Accepted By Approver')
              ){
                  opportunity.addError('You cannot recall this approval as it is already being assessed');
              }
            
            //Added by Anka Ganta user story W-007479
            if(oppTriggerOld.get(opportunity.id).QA_Complex_Approval_Status__c  != opportunity.QA_Complex_Approval_Status__c &&  opportunity.QA_Complex_Approval_Status__c == 'Approved' ){
                opportunity.StageName = 'Closed';
                opportunity.Opportunity_Closed_Date__c = System.now();
                opportunity.ByPassValidationInApex__c = true;
                opportunity.IsFutureExecute__c = false;
                
            }//END
            //Added by Anka Ganta user story W-010665
            if(oppTriggerOld.get(opportunity.id).StageName  != opportunity.StageName &&  opportunity.StageName == 'Closed'){
                if(opportunity.Welcome_Package_Email_Sent__c == false) {
                    opportunity.ByPassValidationInApex__c = true;
                    opportunity.IsFutureExecute__c = false;
                    opportunity.Welcome_Package_Email_Sent__c = productOnboardingController.sendWelcomePackage(opportunity.id);
                }
                if(opportunity.CreatedById != null){
                    getDocumentsCasaTiersAsync(opportunity.id);
                }
                
            }
            
            //QA Approval Status Validation if Submitted to check for documents
            //Added by Masechaba Maseli user story W-005222
            if((oppTriggerOld.get(opportunity.id).QA_Complex_Approval_Status__c != opportunity.QA_Complex_Approval_Status__c &&  opportunity.QA_Complex_Approval_Status__c == 'Submitted') ||
               (oppTriggerOld.get(opportunity.id).StageName != opportunity.StageName &&  opportunity.StageName == 'Closed')){
                   
                   List <String> RelDocValidation = OnboardingCASAScreeningController.getAllRelatedMandatoryDocuments(opportunity.Entity_Type__c,opportunity.Id );
                   
                   If(opportunity.CheckMandatoryDocuments__c && !RelDocValidation.isEmpty() && opportunity.process_type__c != 'SIC Code Change'){
                       
                       opportunity.addError('Please upload all mandatory documents for the Primary Client and'+ ' ' + String.valueOf(RelDocValidation));
                       
                   }
                   
                   If(opportunity.CheckMandatoryDocuments__c && RelDocValidation.isEmpty() && opportunity.process_type__c != 'Voice Sales Product Onboarding' && opportunity.process_type__c != 'SIC Code Change' && opportunity.Opportunity_Record_Type_Name__c != 'Investment Opportunity'){
                       
                       opportunity.addError('Please upload all mandatory documents for the Primary Client');
                       
                   }
                   
                   If(!opportunity.CheckMandatoryDocuments__c && !RelDocValidation.isEmpty() && opportunity.Opportunity_Record_Type_Name__c != 'Investment Opportunity'){
                       
                       opportunity.addError(String.valueOf(RelDocValidation));
                       
                   }
                   If(opportunity.CheckMandatoryDocuments__c && !RelDocValidation.isEmpty() && opportunity.process_type__c == 'SIC Code Change'){
                       
                       opportunity.addError(String.valueOf(RelDocValidation));      
                       
                   }
                   
                   //TdB - Add validation for CMS Linking
                   if(opportunity.CMS_Linking_Status__c != 'CAPTURED' && opportunity.process_type__c != 'Voice Sales Product Onboarding' && opportunity.process_type__c != 'SIC Code Change' && opportunity.Opportunity_Record_Type_Name__c != 'Investment Opportunity') {
                       if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId() != opportunity.RecordTypeId){
                           opportunity.addError('Please complete Control Officer Linking Banker Details before Submitting for QA');
                       }
                   }
               }
            //Added By Divya
            //IF Opportunity Type is Investment
            //Modified By Vinod
            if(opportunity.Opportunity_Record_Type_Name__c == 'Investment Opportunity'){
                if(oppTriggerOld.get(opportunity.id).Approval_Status__c  != 'Approved'  
                   && opportunity.Approval_Status__c  == 'Approved'){
                       System.debug('Inside Approval Status Validation Check');
                       OpportunityTriggerFunctions.checkCertificateApprovedValidation(opportunity,docMap);
                   }
                if(oppTriggerOld.get(opportunity.id).Approval_Status__c  != 'Rejected'  
                   && opportunity.Approval_Status__c  == 'Rejected'){
                       System.debug('Inside Approval Status Rejected Validation Check');
                       OpportunityTriggerFunctions.checkCertificateRejectValidation(opportunity,approvalMap);
                   }
            }
        }
        // Changed the snippet inorder to pass spm story validation and apex PMD validation.
        //Lift the digital hold when product onboarding opportunity is closed.
        if((rtMap.get(opportunities[0].recordTypeId).getName().containsIgnoreCase('Product Onboarding') && opportunities[0].StageName == 'Closed') && oppTriggerOld.get(opportunities[0].id).StageName != opportunities[0].StageName){
            try{
                //Call the queueable class
                //System.enqueueJob(new DigitalHoldUpdate(opportunity.Id));
                System.enqueueJob(new DelFromFicaLockout(opportunities[0].Id));
            }
            catch(Exception e){
                System.debug(LoggingLevel.ERROR, 'Could not update digital hold: Line Number' + e.getLineNumber() + '; Cause: ' + e.getCause() + '; Message: ' + e.getMessage());
            }
            
        } 
        //Added by Manish user story W-009983
        if(oppTriggerOld.get(opportunities[0].id).Disputed_QA_Approval_Status__c !=  opportunities[0].Disputed_QA_Approval_Status__c && opportunities[0].Disputed_QA_Approval_Status__c == 'Accepted By Approver'){
            List<ProcessInstanceStep> processInstanceSteps = [SELECT Id, ActorId, ProcessInstanceId, ProcessInstance.TargetObjectId,StepStatus FROM ProcessInstanceStep where ProcessInstance.TargetObjectId =: opportunities[0].Id and  StepStatus = 'Rejected' order by createddate desc];
            if(processInstanceSteps[0].ActorId == userinfo.getUserId() || (opportunities[0].QA_Approver__c != null && opportunities[0].QA_Approver__c == userinfo.getUserId())){
                opportunities[0].addError('Same QA Can\'t Approve or Reject for Disputed QA');
            }
        } // END changed Snippet
    }
    
    /**
* @description Method for After update in opportiunity
* Updated by : Himanshu Nimje
* Updated Date: 13/09/2018
* @param triggerNew
* @param triggerOld
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    public virtual override void afterUpdate(Map<Id, sObject> triggerNew, Map<Id, sObject> triggerOld) {
        //Cast sObject maps to Opportunity maps
        Map<Id, Opportunity> oppTriggerNew = (Map<Id, Opportunity>)triggerNew;
        Map<Id, Opportunity> oppTriggerOld = (Map<Id, Opportunity>)triggerOld;
        
        List<Opportunity> listNewOpportunities = convertMapToList(oppTriggerNew);
        
        Set<Id> oppAccountIds = new Set<Id>();
        for(Opportunity opp : listNewOpportunities){
            oppAccountIds.add(opp.AccountId);
        }
        
        for(Opportunity opportunity : listNewOpportunities){
            
            // Added by Poulami to remove the validation for Direct Delivery Record Type
            if(opportunity.Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity' && opportunity.Available_Cover__c == null){
                try{
                    OpportunityTriggerFunctions.getExergyPolicyCover(opportunity.id);
                }
                catch(Exception e){
                    System.debug(LoggingLevel.ERROR, 'Could not get the Exergy Cover' + e.getLineNumber() + '; Cause: ' + e.getCause() + '; Message: ' + e.getMessage());
                }
                
            }
            if(opportunity.Opportunity_Record_Type_Name__c == 'DD STI Opportunity' && !Test.isRunningTest()){
            	OpportunityTriggerFunctions.upsertExistingAddressDetails(opportunity.AccountId,opportunity.Converted_Lead__c);
    		}
            //Check if stage has changed
            if(oppTriggerOld.get(opportunity.id).StageName != opportunity.StageName){
                
                try{
                    OpportunityTriggerFunctions.updateSiebelOfStageChange(opportunity.id,opportunity.StageName,opportunity.External_Lead_Ref_Number__c,opportunity.Product__c);
                }
                catch(Exception e){
                    System.debug(LoggingLevel.ERROR, 'Could not update Siebel stage: Line Number' + e.getLineNumber() + '; Cause: ' + e.getCause() + '; Message: ' + e.getMessage());
                }
            }
            
            
            //check if Disputed QA Approved and Submit to QA for Approval - W-009983
            if(oppTriggerOld.get(opportunity.id).Disputed_QA_Approval_Status__c !=  opportunity.Disputed_QA_Approval_Status__c && opportunity.Disputed_QA_Approval_Status__c == 'Approved'){
                ProductOnboardingApprovalController.submitForQA(opportunity.Id, '');
            }
            
            //coded added by Haritha for SPM Marble Create Account Service.
            if(opportunity.Opportunity_Record_Type_Name__c == 'SPM Onboarding' && opportunity.Approval_Status__c == 'Approved' &&  opportunity.stageName == 'Vet Application' && oppTriggerOld.get(opportunity.id).Approval_Status__c !=  opportunity.Approval_Status__c){
                OpportunityTriggerFunctions.marblecreateAccountService(opportunity.Id);
            }
            if(opportunity.Opportunity_Record_Type_Name__c == 'Product Onboarding' && opportunity.IsClosed ){
                OpportunityTriggerFunctions.callECPLeadService(opportunity.Id);
             } // Added by Vineel for ECP
            
        }
        
        //coded added by Almas aleem for pricing decision
        for(Opportunity opportunity : listNewOpportunities){
            if(opportunity.Pricing_Decision__c !=null && opportunity.Pricing_Decision__c.equalsIgnoreCase('Approve')){
                PricingAndFeesController.updateApprovePricing(opportunity.Id);
            }
        }
    }
    
    /**
* @description Method for before insert
* @param triggerNew - List of new opp records
*/
    public virtual override void beforeInsert(List<sObject> triggerNew) {
        OpportunityTriggerFunctions.eppInsertValidations(triggerNew);
    }
    
    /**
*@description Method for After Insert in opportiunity
* Updated by : Manoj Danthala
* Updated Date: 08/04/2019
* @param newRecords
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    public virtual override void AfterInsert(Map<Id, sObject> newRecords) {
        //Cast sObject maps to Opportunity maps
        Map<Id, Opportunity> oppTriggerNew = (Map<Id, Opportunity>)newRecords;
        List<Opportunity> listNewOpportunities = convertMapToList(oppTriggerNew);
        
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
        Id bussinessBankRecTypeId = rtInfo.get('Opportunity_Business_Bank').getRecordTypeId();
        
        for(Opportunity opportunity : listNewOpportunities){
            try{
                if(opportunity.RecordTypeId == bussinessBankRecTypeId && opportunity.Lead_Number__c!=null && !opportunity.Is_Sent_To_ESP__c){
                    OpportunityTriggerFunctions.sendLeadsToESP(opportunity.id);
                }
            }catch(Exception e){
                System.debug(LoggingLevel.ERROR, 'Could not send ESP callout: Line Number' + e.getLineNumber() + '; Cause: ' + e.getCause() + '; Message: ' + e.getMessage());
            }
        }
        // Changed the snippet inorder to pass spm story validation and apex PMD validation
        try{
            if(listNewOpportunities[0].ExecutionLayerRequestID__c != NULL && listNewOpportunities[0].VC_Application_Number__c.startsWith('RB')){ 
                Boolean hasAccountNumber;    
                List<OpportunityLineItem> lineItems =new OpportunityLineItemsSelector().selectByOpportunityId(listNewOpportunities[0].Id);   
                String opportunityId =  listNewOpportunities[0].Id;  
                String accountRecordType = listNewOpportunities[0].Account.recordtype.Name;   
                String cifCheck = listNewOpportunities[0].CIF_Number__c;
                String accountId= listNewOpportunities[0].AccountId;
                System.enqueueJob(new queableCASAScreening(opportunityId,accountRecordType,cifCheck, accountId));
            }     
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, e.getLineNumber() + '; Cause: ' + e.getCause() + '; Message: ' + e.getMessage());
        }  // END changed Snippet
        
    }
    
    /**
*@description Method for before delete in opportiunity
* Updated by : Divya Podila
* Updated Date: 19/10/2021
* @param oldRecords
*/
    //Added By Divya
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        Map<Id, Opportunity> oppTriggerold = (Map<Id, Opportunity>)oldRecords;
        OpportunityTriggerFunctions.ristricDeletaionForVA(oppTriggerold);
    }
    /**
* @description Method that converts Map of values into a List
* @param triggerMap Map of values
* @return List of opportunities from map values
*/
    private static List<Opportunity> convertMapToList(Map<Id, Opportunity> triggerMap){
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Opportunity opportunity : triggerMap.values()){
            opportunities.add(opportunity);
        }
        return opportunities;
    }
    /**
* @description Method that 
* @param oppId Map of values
*/
    @future(callout=true)
    public static void getDocumentsCasaTiersAsync(String oppId){
        OnboardingGenerateCIFController.getDocumentsCasaTiers(oppId);
    }
    
}