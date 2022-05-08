/**
* Apex Extention class for the sites page "SitesLogComplaint"
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-02-26
*
**/
public class SitesLogComplaintExt {
    
    private ApexPages.StandardController controller;
    public String userMessages {get;set;}
    public boolean showMessages {get;set;}
    public boolean showCase {get;set;}
    public Case newCase {get;set;}
    public Time incidentTime { get; set; }
    public String accountInput { get; set; }

    public SitesLogComplaintExt(ApexPages.StandardController controller){
        this.newCase = (Case)controller.getRecord();
        showMessages = false;
        showCase = true;
	}
    
    public PageReference save(){
        
        String clientId;
        
        String accId = ApexPages.currentPage().getParameters().get('accountId');
        String groupId = ApexPages.currentPage().getParameters().get('groupId');
        String siteId = ApexPages.currentPage().getParameters().get('siteId');

        try{
            //Koketso - create a new prospect if client not found
            if(String.isBlank(accId)){
                RecordType accType = [Select Id, Name From RecordType Where Name =:'Individual' And sObjectType =:'Account']; 
                Account acc = new Account();
                acc.Name = accountInput;
                if(accType != null){
                    acc.RecordTypeId = accType.Id;
                }
                insert acc;
                
                clientId = acc.Id;
            }else{
                clientId = accId;
            }
            system.debug(LoggingLevel.FINE, 'clientId:'+clientId);
            system.debug(LoggingLevel.FINE, 'groupId:'+groupId);
            if(groupId != null) {
                //Get Service Group Type Record
                Set<Id> idSet = new Set<Id>();
                idSet.add(groupId);
                List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);               
                system.debug(LoggingLevel.FINE, 'serviceGroupTypes:'+serviceGroupTypes);
                if( serviceGroupTypes.size() > 0 ){
                    
                    //this.newCase.AccountId = accId;
                    this.newCase.AccountId = clientId;
                    this.newCase.sd_Service_Group_Id__c = groupId;
                    this.newCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                    this.newCase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
                    this.newCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                    this.newCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c; 
                    this.newCase.sd_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                    this.newCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                    this.newCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
                    this.newCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
                    this.newCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
                    this.newCase.Internal_SLA_Notification_User__c  = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;     
                    this.newCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                    
                    Map<String, Id> queueMap = new Map<String, Id>();
                    
                    //RN - CloudSmiths 2020-01-22 - Remove FFLIB query from the selector layer and do an inline query
                    //to resolve the sites user from not access the group object due to strickter security mesures in the new SF release
                    //
                    //List<Group> caseQueues = new GroupsSelector().selectByType('Queue');
                    List<Group> caseQueues = [Select Id, Name, DeveloperName From Group Where Type = 'Queue'];
                    
                    system.debug(LoggingLevel.FINE, 'caseQueues:'+caseQueues);
                    //Add all Queues to a Map
                    for(Group eachQueue : caseQueues) {
                        queueMap.put(eachQueue.Name, eachQueue.id);
                    }
                    
                    String queueName = serviceGroupTypes[0].Service_Group__r.Queue__c;
                    if (queueName != null && queueMap.containsKey(queueName)) {
                        this.newCase.OwnerId = queueMap.get(queueName);
                    }
                    
                    //Site
                    if(String.isEmpty(siteId) || String.isBlank(siteId) || siteId == null) {
                        this.newCase.Responsible_Site__c = null;
                    }else{
                        this.newCase.Responsible_Site__c = siteId;
                    }

                    this.newCase.IncidentTime__c = incidentTime;
                    
                    insert this.newCase;
                    
                    //Have to query the DB in order to get the Case Number back, not available after insert
                    Case dbCase = [Select CaseNumber From Case Where Id = :this.newCase.Id];
                    userMessages = 'The Complaint was successfully submitted. Your Case Number is : ' + dbCase.CaseNumber;
                    
                }else{
                     userMessages = 'You have selected an invalid Service Group. Please contact your administrator';
                }
            }else{
                userMessages = 'You have selected an invalid Service Group. Please contact your administrator';
            }
            
        }catch(Exception ex){
            
            System.debug(ex.getMessage());
            userMessages = 'There was an error Submitting this complaint.  Please see additional information  :  ' + ex.getMessage();
            
        }
        
		showCase = false;
        showMessages = true;

        return null;
	}
	public PageReference done(){
        
		showCase = true;
        showMessages = false;
        
        List<Org_Wide_Lookup_Value__mdt> mdt = [Select Value__c From Org_Wide_Lookup_Value__mdt Where Label = 'Complaints Sites Redirect URL'];

        if(mdt.size() > 0){
            return new PageReference(mdt[0].Value__c);
        }else{
            return null;
        }
	}
}