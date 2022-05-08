/**
 * @description Controller class for BranchCustomer components
 * @author  Clifford Willers
 * @created 2021-10-20
 */
public without sharing class CustomerCaseController {
    /**
    * @description createServiceRequestCase
    * @return Case
    * @param recordId
    * @param serviceGroupName
    * @param serviceGroupTypeName
    */
    @AuraEnabled
    public static Case createServiceRequestCase(String recordId, String serviceGroupName, String serviceGroupTypeName)
    {
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service_Request').getRecordTypeId();
        List<Service_Group__c> serviceGroup = new ServiceGroupsSelector().selectByName(new Set<String>{serviceGroupName});
        List<Service_Group_Type__c> serviceGroupTypeList = new ServiceGroupTypesSelector().selectByServiceGroupWithGroupAndServiceInfo(new Set<Id>{serviceGroup[0].Id});
        Service_Group_Type__c serviceGroupType = null;
		for (Service_Group_Type__c serviceGroupData : serviceGroupTypeList) {
            if (serviceGroupData.Service_Type__r.Name == serviceGroupTypeName) {
                serviceGroupType = serviceGroupData;
            }
		}
        User user = new UsersSelector().selectById(UserInfo.getUserId());

        Case serviceRequestCase = new Case();
        serviceRequestCase.AccountId = recordId;
        serviceRequestCase.OwnerId = user.Id;
        serviceRequestCase.Origin = 'Web';
        serviceRequestCase.Status = 'Open';
        serviceRequestCase.Priority = 'Low';
        serviceRequestCase.RecordTypeId = recordTypeId;
        serviceRequestCase.Subject = serviceGroupType.Service_Type__r.Name;
        serviceRequestCase.Type__c = serviceGroupType.Service_Type__r.Name;
        serviceRequestCase.Type = serviceGroupType.Service_Type__r.Name;
        serviceRequestCase.sd_Communication_Plan_Id__c = serviceGroupType.sd_Communication_Plan__c;
        serviceRequestCase.sd_Service_Group_Id__c = serviceGroupType.Service_Group__r.Id;
        serviceRequestCase.sd_Service_Group_Type_Id__c = serviceGroupType.Id;
        serviceRequestCase.sd_Original_Service_Group__c = serviceGroupType.Service_Group__r.Name;
        serviceRequestCase.sd_Original_Service_Queue__c = serviceGroupType.Service_Group__r.Queue__c;
        serviceRequestCase.sd_Service_Type_Id__c = serviceGroupType.Service_Type__r.Id;
        serviceRequestCase.sd_Service_Type__c = serviceGroupType.Service_Type__c;
        serviceRequestCase.sd_Service_Level_Id__c = serviceGroupType.Service_Level__c;
        serviceRequestCase.sd_Service_Group__c = serviceGroupType.Service_Group__r.Name;
        serviceRequestCase.sd_Response_Email_Address__c = serviceGroupType.Service_Group__r.Response_Email_Address__c;
        serviceRequestCase.sd_Email_Template_Case_Creation__c = serviceGroupType.Service_Group__r.Email_Template_Case_Creation__c;
        serviceRequestCase.BusinessHoursId = serviceGroupType.Service_Group__r.Business_Hours__c;
        serviceRequestCase.Internal_SLA_Notification_User__c = serviceGroupType.Service_Group__r.Internal_SLA_Notification_User__c;
        serviceRequestCase.External_SLA_Notification_User__c = serviceGroupType.Service_Level__r.External_SLA_Notification_User__c;
        insert serviceRequestCase;
        return serviceRequestCase;
    }

    /**
    * @description updateCaseStatus
    * @return Case
    * @param caseRecord
    * @param caseStatus
    */
    @AuraEnabled
    public static Case updateCaseStatus(Case caseRecord, String caseStatus)
    {
        caseRecord.Status = caseStatus;
        update caseRecord;
        return caseRecord;
    }
}