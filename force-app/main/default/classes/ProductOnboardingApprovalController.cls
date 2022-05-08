/**
* Created by : Manish
* Description : Class to submit approval request and assign approvers through code based on application region
* Created Date: 23/03/2021
*/
public class ProductOnboardingApprovalController {

    /**
    * Created by : Manish
    * Description : Method to submit approval request to Service Center Queue or Teller Queue afer QA Approval
    * Created Date: 23/03/2021
    * @param: Opportunity Id
    */
    /*@AuraEnabled
    public static void submitToServiceCenterOrTellerAfterQA(Id oppId, String comments){
        List<Application__c> applications = new List<Application__c>();
        List<OpportunityLineItem> opportunityLineItems =  new List<OpportunityLineItem>();
        Map<String, String> serviveCenterRegionQueueMap = new Map<String, String>{'Cape Region' => 'Service Centre Cape Region', 'Central Region' => 'Service Centre Central', 'KZN & Mpumalanga' => 'Service Centre KZN & Mpumalanga', 'Gauteng & Limpopo' => 'Service Centre Gauteng & Limpopo'};
        Map<String, String> tellerRegionQueueMap = new Map<String, String>{'Cape Region' => 'Service Centre Teller Cape Region', 'Central Region' => 'Service Centre Teller Central', 'KZN & Mpumalanga' => 'Service Centre Teller KZN & Mpumalanga', 'Gauteng & Limpopo' => 'Service Centre Teller Gauteng & Limpopo'};
        
        //fetching opportunity related applications
        ApplicationsSelector applicationSelector = new ApplicationsSelector();
        applications = applicationSelector.selectByOpportunityOnboardId(oppId);
        
        //fetching opportunity related opportunity line items
        OpportunityLineItemsSelector opportunityLineItemSelector = new OpportunityLineItemsSelector();
        opportunityLineItems = opportunityLineItemSelector.selectByOpportunityId(oppId);
        
        if(applications.size() > 0 && opportunityLineItems.size() > 0 && applications.get(0).Customer_Region__c != null && 
           applications.get(0).Is_there_a_Transfer_to_be_performed_for__c  == 'Yes' && !String.isBlank(opportunityLineItems.get(0).Policy_Number__c) && opportunityLineItems.get(0).ProductCode != '11029' &&  opportunityLineItems.get(0).ProductCode != '11046'){
               
               //fetching queues based on opportunity related application customer region
               GroupsSelector groupSelector = new GroupsSelector();
               List<Group> queues = groupSelector.selectByNameAndType(tellerRegionQueueMap.get(applications.get(0).Customer_Region__c), 'Queue');
               
               //submitting for Approval
               Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, 'Regional_Teller_Approval_Process', queues.get(0).Id);
               Approval.ProcessResult result = Approval.process(req);
           }
        else if(applications.size() > 0 && opportunityLineItems.size() > 0 && applications.get(0).Customer_Region__c != null && 
                applications.get(0).Is_there_a_Transfer_to_be_performed_for__c  != null && (String.isBlank(opportunityLineItems.get(0).Policy_Number__c) || (opportunityLineItems.get(0).ProductCode == '11029' ||  opportunityLineItems.get(0).ProductCode == '11046'))){
                    
                    //fetching queues based on opportunity related application customer region
                    GroupsSelector groupSelector = new GroupsSelector();
                    List<Group> queues = groupSelector.selectByNameAndType(serviveCenterRegionQueueMap.get(applications.get(0).Customer_Region__c), 'Queue');
                    
                    //submitting for Approval
                    Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, 'Regional_Service_Center_Approval_Process', queues.get(0).Id);
                    Approval.ProcessResult result = Approval.process(req);
                }
    }*/
    
    /**
    * Created by : Manish
    * Description : Method to submit for approval
    * Created Date: 23/03/2021
    * @param: oppId - Opportunity Id
    * @param: comments
    * @param: approvalprocess - Approval Process Name
    * @param: queueId - Queue Id based on Application Central Region
    */
    public static Approval.ProcessSubmitRequest submitForApproval(Id oppId, String comments, String approvalProcess, Id queueId ){
        // Create an approval request for Opportunity
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comments);
        req.setObjectId(oppId);
        if(!String.isBlank(approvalProcess)){
            req.setProcessDefinitionNameOrId(approvalProcess);
        }
        if(queueId != null){
            req.setNextApproverIds(new Id[] {queueId});
        }
        return req;
    }
    
     /**
    * Created by : Manish
    * Description : Method to submit for Teller to QC for Approval
    * Created Date: 18/03/2021
    * @param: oppId - Opportunity Id
    */
	/*@AuraEnabled
    public static void submitToTellerorQC(Id oppId, String comments){
        List<Application__c> applications = new List<Application__c>();
        List<OpportunityLineItem> opportunityLineItems =  new List<OpportunityLineItem>();
        Map<String, String> qcRegionQueueMap = new Map<String, String>{'Cape Region' => 'QC Service Centre Cape Region', 'Central Region' => 'QC Service Centre Central', 'KZN & Mpumalanga' => 'QC Service Centre Gauteng & Limpopo', 'Gauteng & Limpopo' => 'QC Service Centre Gauteng & Limpopo'};
        Map<String, String> tellerRegionQueueMap = new Map<String, String>{'Cape Region' => 'Service Centre Teller Cape Region', 'Central Region' => 'Service Centre Teller Central', 'KZN & Mpumalanga' => 'Service Centre Teller KZN & Mpumalanga', 'Gauteng & Limpopo' => 'Service Centre Teller Gauteng & Limpopo'};
                
                //fetching opportunity related applications
                ApplicationsSelector applicationSelector = new ApplicationsSelector();
        applications = applicationSelector.selectByOpportunityOnboardId(oppId);
        
        //fetching opportunity related opportunity line items
        OpportunityLineItemsSelector opportunityLineItemSelector = new OpportunityLineItemsSelector();
        opportunityLineItems = opportunityLineItemSelector.selectByOpportunityId(oppId);
        
        if(applications.size() > 0 && opportunityLineItems.size() > 0 && applications.get(0).Customer_Region__c != null && 
           applications.get(0).Is_there_a_Transfer_to_be_performed_for__c  == 'Yes' ){
               
               //fetching queues based on opportunity related application customer region
               GroupsSelector groupSelector = new GroupsSelector();
               List<Group> queues = groupSelector.selectByNameAndType(tellerRegionQueueMap.get(applications.get(0).Customer_Region__c), 'Queue');
               
               //submitting for Approval
               Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, 'Regional_Teller_Approval_Process', queues.get(0).Id);
               Approval.ProcessResult result = Approval.process(req);
           }
        else if(applications.size() > 0 && opportunityLineItems.size() > 0 && applications.get(0).Customer_Region__c != null && 
                applications.get(0).Is_there_a_Transfer_to_be_performed_for__c  == 'No' ){
                    
                    //fetching queues based on opportunity related application customer region
                    GroupsSelector groupSelector = new GroupsSelector();
                    List<Group> queues = groupSelector.selectByNameAndType(qcRegionQueueMap.get(applications.get(0).Customer_Region__c), 'Queue');
                    
                    //submitting for Approval
                    Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, 'Regional_QC_Approval_Process', queues.get(0).Id);
                    Approval.ProcessResult result = Approval.process(req);
                }
    }*/
    
    /**
    * Created by : Manish
    * Description : Method to submit to QC for Approval
    * Created Date: 23/03/2021
    * @param: oppId - Opportunity Id
    */
   /* @AuraEnabled
    public static void submitToQC(Id oppId, String comments){
        List<Application__c> applications = new List<Application__c>();
        List<OpportunityLineItem> opportunityLineItems =  new List<OpportunityLineItem>();
        Map<String, String> qcRegionQueueMap = new Map<String, String>{'Cape Region' => 'QC Service Centre Cape Region', 'Central Region' => 'QC Service Centre Central', 'KZN & Mpumalanga' => 'QC Service Centre KZN & Mpumalanga', 'Gauteng & Limpopo' => 'QC Service Centre Gauteng & Limpopo'};
        
        //fetching opportunity related applications
        ApplicationsSelector applicationSelector = new ApplicationsSelector();
        applications = applicationSelector.selectByOpportunityOnboardId(oppId);
        
        //fetching opportunity related opportunity line items
        OpportunityLineItemsSelector opportunityLineItemSelector = new OpportunityLineItemsSelector();
        opportunityLineItems = opportunityLineItemSelector.selectByOpportunityId(oppId);
        
        //fetching queues based on opportunity related application customer region
        GroupsSelector groupSelector = new GroupsSelector();
        List<Group> queues = groupSelector.selectByNameAndType(qcRegionQueueMap.get(applications.get(0).Customer_Region__c), 'Queue');
        
        //submitting for Approval
        Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, 'Regional_QC_Approval_Process', queues.get(0).Id);
        Approval.ProcessResult result = Approval.process(req);
    }*/
    
    @AuraEnabled
    public static String submitForQA(Id oppId, String comments){
        try{
            Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(oppId, comments, '', null);
            Approval.ProcessResult result = Approval.process(req);
            return '';
        }
        catch(Exception e){
            system.debug('error '+e.getMessage());
            throw new AuraHandledException(e.getMessage().substringAfter('_EXCEPTION,'));
        }
    }
    
    /**
    * Created by : Manish
    * Description : Method to submit to Disputed QA for Approval
    * Created Date: 26/03/2021
    * @param: oppId - Opportunity Id
    * @param: comments - string
    */
    @AuraEnabled
    public static String submitToDisputedQA(Opportunity opp, String comments){
        try{
            //fetching queues based on opportunity related application customer region
            GroupsSelector groupSelector = new GroupsSelector();
            List<Group> queues = groupSelector.selectByNameAndType('Disputed QA Queue', 'Queue');
            
            //submitting for Approval
            Approval.ProcessSubmitRequest req = ProductOnboardingApprovalController.submitForApproval(opp.Id, comments, 'Disputed_QA_Approval_Process', queues.get(0).Id);
            Approval.ProcessResult result = Approval.process(req);
            return '';
        }
        catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }
    }
}