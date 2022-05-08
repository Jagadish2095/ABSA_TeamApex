/**
* @description Integration Utility for Create Leads function
* @Date: 2021-04-16
*/
public class CreateLeads_UI_v1 {
    /**
* @description Integration Utility for Create Leads function
* @param  createLeadsList
* @return : Leadlist
*/
    public static string createLeadRecord(List<CreateLeads_Req_IB_v1> createLeadsList){
       List<Lead> insertList = new List<Lead>();
       Lead newLeads = new Lead();
        Map<String,String> nameVSGroupIdMap = new Map<String,String>();
        for(Group gp : [Select Id,Name from Group where Type = 'Queue']){
            nameVSGroupIdMap.put(gp.Name,gp.Id);
        }
        for(CreateLeads_Req_IB_v1 leadRequest : createLeadsList){
            string QueueNameFromCampain = '';
            Id merchantLeadrecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('General').getRecordTypeId();
             
            if(nameVSGroupIdMap.containsKey(leadRequest.campaignName)){                        
                newLeads.OwnerId = nameVSGroupIdMap.get(leadRequest.campaignName);
                newLeads.RecordTypeId = merchantLeadrecTypeId;
                newLeads.FirstName = leadRequest.firstName;
                newLeads.LastName = leadRequest.lastName;
                newLeads.MobilePhone = leadRequest.mobileNumber;
                newLeads.Alternate_Phone1__c = leadRequest.alternativeNo;
                newLeads.Lead_Type__c = leadRequest.leadType;
                newLeads.Comments__c = leadRequest.comments;
                newLeads.Email = leadRequest.emailAddress;
                if(leadRequest.campaignType.contains('Customer One')){
               newLeads.LeadSource = 'Website';
                }
                newLeads.DD_Convenient_Time_To_Call__c = leadRequest.nextTry != null ? DateTime.valueOf(leadRequest.nextTry.replace('T',' ')) : null;
                newLeads.Source_Created_Date__c = leadRequest.leadCreationTime != null ? DateTime.valueOf(leadRequest.leadCreationTime.replace('T',' ')) : null;
                newLeads.DD_Policy_Number__c = leadRequest.accountNo;
                newLeads.CIF__c = leadRequest.cifKey;
                newLeads.Company = leadRequest.tradingName;
                insertList.add(newLeads);
            }
            
        }
        Database.SaveResult[] srList = Database.insert(insertList,false); 
        
        string response = getLeadNumber(srList);
                            
        return response;
    }
    /**
* @description Integration Utility for Create Leads function
* @param  status
* @param  statusCodeP
* @param  messagep
* @param  dataTable


* @return : Leadlist
*/
    public static CreateLeads_Resp_IB_v1 mapFieldsCreateLeadResponse(string status , Integer statusCodeP, string messagep , string dataTable){
        CreateLeads_Resp_IB_v1 createLeadsResponse = new CreateLeads_Resp_IB_v1();
        createLeadsResponse.status = status;
        createLeadsResponse.statusCode  = statusCodeP;
        createLeadsResponse.description = messagep;
        createLeadsResponse.dataTable = dataTable;
        return createLeadsResponse;
    }
    
    /**
* @description Integration Utility for Create Leads function
* @param  srList


* @return : Leadlist
*/
public static string getLeadNumber(Database.SaveResult[] srList){
    CreateLeads_Resp_IB_v1.Data oData = new CreateLeads_Resp_IB_v1.Data();
    List<CreateLeads_Resp_IB_v1.Data> dataList = new List<CreateLeads_Resp_IB_v1.Data>();
    string value;
    List<Lead> leads = new List<Lead>();
    Database.DMLOptions dmo = new Database.DMLOptions();
    for (Database.SaveResult sr : srList) {           
        if (sr.isSuccess()) {
            value = sr.getId(); 
          leads   = new LeadsSelector().selectByLeadNumber(value);
            if(!leads.isEmpty()){
             for(Lead leadObj : leads){
            
                if(string.isNotBlank(leadObj.Lead_Ref_No__c)){                       
                    oData.leadNumber = leadObj.Lead_Ref_No__c;
                    oData.Status = 'Created Successfully';
                    dataList.add(oData);
                    dmo.assignmentRuleHeader.useDefaultRule= true;          
                                            
                }
            }
          }               
        }
        else{
            for(Database.Error err : sr.getErrors()) {
                 oData.leadNumber = '';
                oData.Status = err.getStatusCode() + ': ' + err.getMessage();
                dataList.add(oData);
            }
        }
    }
    if(leads.size() > 0){
    Database.update(leads, dmo);
    }
    return JSON.serialize(dataList);
}
}