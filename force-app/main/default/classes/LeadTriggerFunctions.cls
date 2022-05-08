/**
* Descripton: LeadTriggerFunctions that will invoked based on the Lead Trigger Events
* Test Class Name: LeadTriggerFunctionsTest
* @Author:  Rakesh Byri(Absa)
* @CreateDate: 2019-02-18
* CHANGE LOG:
*=========================================================================================================================
* Author                CreatedDate             Change
* Manoj Danthala        2019-03-07              Updated afterUpdate method to make Callout to ESP when lead qualified
* Manoj Danthala        2019-03-12              Added isUnsuccesfullCall method and Modified beforeUpdate method
* Manoj Danthala        2019-03-18              BeforeInsert, BeforeUpdate - Added logic to validate the ID number field
* Rudolf Niehaus        2019-05-14              Add afterInsert method
Add logic to link and execute a communication plan for Leads
Add logic to STAMP a service group type with related objects values
on a Lead
* Rudolf Niehaus        2019-07-09              Add the tacking of status changes
* Almas Aleem           2019-07-17              US: W-001774 Added getAndAssignLeadBankerFromEstpm method in after insert
to assign lead from estpm service
* Kyle Alexander        2019-09-04              Extended functionality to work for WIMI
* Kyle Alexander        2020-02-05              Added Auto response funtionality for leads
* Rudolf Niehaus        2020/11                 Exclude product SLA assigment for External Sales
*=========================================================================================================================
**/
/**
  * @description LeadTriggerFunctions
  *
  */
  public class LeadTriggerFunctions {
    public static Map<String, Lead> masterRecIdOfMergeMap = new Map<String, Lead>();
    /**
     * @description beforeInsert description
     *
     * @param newRecords (List<sObject>): newRecords
     */
    public static void beforeInsert(List<sObject> newRecords) {
      //F2F validation checks
      //f2fValidations(newRecords);

      Set<Id> productIds = new Set<Id>();
      Set<String> productIdStrings = new Set<String>();

      Set<String> leadQueueNames = new Set<String>();
      Set<String> leadServiceGroupNames = new Set<String>();

      Map<String, String> serviceGroupManagerMap = new Map<String, String>();
      Map<String, String> serviceGroupQueueMap = new Map<String, String>();
      Map<String, String> leadQueueMap = new Map<String, String>();
      Map<String, String> leadIdServiceGroupMap = new Map<String, String>();
      Map<String, String> leadServiceGroupNameMap = new Map<String, String>();

      Set<String> ibServiceGroupNames = new Set<String>();
      Map<String, String> retailIBServiceGroupNameMap = new Map<String, String>();
      Map<String, Service_Group__c> ibServiceGroupMap = new Map<String, Service_Group__c>();
      Map<String, String> leadServiceGroupMap = new Map<String, String>();
      Id virtualstiRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Virtual_STI_Lead').getRecordTypeId();
      Id directDeliveryOppRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
      Id stiRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead').getRecordTypeId();
      Id aipRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('AIP_Lead').getRecordTypeId();
      Id stiLeadRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
      Id investmentRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Investment_Lead').getRecordTypeId();
      Id maturityRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Maturity_Retention').getRecordTypeId();
      /* Validating the ID Number field on Lead */
      for (Lead currentLead : (List<Lead>) newRecords) {
        // Added for AOL Web to Lead for DD
        if (
          currentLead.Campaign_Code__c != null &&
          (currentLead.Campaign_Code__c == 'FlexiOnline' ||
          currentLead.Campaign_Code__c == 'HealthOnline' ||
          currentLead.Campaign_Code__c == 'lifelongweb' ||
          currentLead.Campaign_Code__c == 'lawforyou' ||
          currentLead.Campaign_Code__c == '1-12720772021')
        ) {
          //Campaign campaignData = [SELECT Id, Name,Description FROM Campaign WHERE Campaign_Code__c = :currentLead.Campaign_Code__c LIMIT 1];
          Campaign campaignData = new CampaignsSelector().selectByCodeName(currentLead.Campaign_Code__c);
          if (campaignData != null) {
            List<Financial_Product__c> ddProduct = new FinancialProductsSelector().selectByProductName(campaignData.Description);
            currentLead.Financial_Product__c = ddProduct[0].Id;
          }
          currentLead.Status = 'Unallocated';
          currentLead.DD_Work_Phone__c = currentLead.Work_Phone__c;
          currentLead.Direct_Delivery_Campaign__c = campaignData.Id;
          currentLead.RecordTypeId = directDeliveryOppRecTypeId;
        }
        //Added by Minal to check the DD functionality
        //Check DD nationality for ID verification

        if (
          currentLead.RecordTypeId == directDeliveryOppRecTypeId ||
          currentLead.RecordTypeId == stiRecTypeId ||
          currentLead.RecordTypeId == virtualstiRecTypeId ||
          currentLead.RecordTypeId == aipRecTypeId
        ) {
          if (currentLead.ID_Number__c != null && currentLead.DD_Nationality__c == 'South African') {
            if (!SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, currentLead.ID_Number__c)) {
              //System.debug(System.Label.IDValidationError);
              currentLead.ID_Number__c.addError(System.Label.IDValidationError);
            }
          }
        } else if (currentLead.RecordTypeId == stiLeadRecTypeId) {
          if (
            currentLead.ID_Number__c != null &&
            currentLead.Nationality__c == 'South Africa' &&
            !SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, currentLead.ID_Number__c) &&
            currentLead.ID_Type__c == 'SA Identity Document'
          ) {
            // System.debug(System.Label.IDValidationError);
            //System.debug(currentLead.ID_Number__c);
            currentLead.ID_Number__c.addError(System.Label.IDValidationError);
          }
        }else if (currentLead.ID_Number__c != null && currentLead.Nationality__c == 'South Africa'
              && currentLead.RecordTypeId != investmentRecTypeId && currentLead.RecordTypeId != maturityRecTypeId) {
          if (!SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, currentLead.ID_Number__c)) {
            // System.debug(System.Label.IDValidationError);
            // System.debug(currentLead.ID_Number__c);
            currentLead.ID_Number__c.addError(System.Label.IDValidationError);
          }
        }

        //RN : Get all the product ids for all leads in order to get the
        //Product Business units later, we cannot use the formula field on the lead
        //as formula fields are not populated in before insert events
        if (String.isNotBlank(currentLead.Financial_Product__c)) {
          productIds.add(currentLead.Financial_Product__c);
          productIdStrings.add(currentLead.Financial_Product__c);
        }
         // Added for Investment Record for Lead Reference Number
         if(currentLead.RecordTypeId == investmentRecTypeId)
         currentLead.External_Reference_Number__c = 'Investment';
        //Koketso - get list of service group ids
        if (currentLead.sd_Service_Group__c != null) {
          if (currentLead.LeadSource == 'IB Campaign') {
            String serviceGroup = (currentLead.sd_Service_Group__c).trim();
            if (!serviceGroup.startsWith('IB - ')) {
              String ibServiceGroupName = 'IB - ' + serviceGroup;
              leadServiceGroupNames.add(ibServiceGroupName);
              leadServiceGroupMap.put(currentLead.Id, ibServiceGroupName);
            }
          } else {
            leadServiceGroupNames.add(currentLead.sd_Service_Group__c);
            leadServiceGroupMap.put(currentLead.Id, currentLead.sd_Service_Group__c);
            leadIdServiceGroupMap.put(currentLead.Id, currentLead.sd_Service_Group__c);
            leadServiceGroupNameMap.put(currentLead.sd_Service_Group__c, currentLead.sd_Service_Group__c);
          }
        }
      }

      //RN : Get all the business unit names from the related product records in order to get the
      //correct servicegrouptype with comms plan
      Set<String> productBusinessUnitNames = new Set<String>();

      for (Financial_Product__c finProd : [SELECT Id, Business_Unit__c FROM Financial_Product__c WHERE Id IN :productIds]) {
        productBusinessUnitNames.add(finProd.Business_Unit__c);
      }

      Map<Id, Service_Group_Type__c> serviceNameGroupMap = new Map<Id, Service_Group_Type__c>();

      //for(Service_Group_Type__c srvGroup :new ServiceGroupTypesSelector().selectByLeadProductBusinessUnitNames( productBusinessUnitNames )){
      for (Service_Group_Type__c srvGroup : new ServiceGroupTypesSelector().selectByLeadProductBusinessUnitNames(productIdStrings)) {
        //map product id and servicegrouptype
        serviceNameGroupMap.put(srvGroup.Financial_Product__c, srvGroup);
      }
      //System.debug('serviceNameGroupMap : ' + serviceNameGroupMap);

      //Koketso - get retail lead service groups
      if (leadServiceGroupNames.size() > 0) {
        List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectByName(leadServiceGroupNames);
        if (serviceGroups.size() > 0) {
          for (Service_Group__c sg : serviceGroups) {
            serviceGroupManagerMap.put(sg.Name, sg.Manager__c);
            serviceGroupQueueMap.put(sg.Name, sg.Queue__c);
            leadQueueNames.add(sg.Queue__c);
            if (!leadServiceGroupNameMap.get(sg.Name).startsWith('IB - ')) {
              if (sg.IB_Service_Group_Name__c != null) {
                ibServiceGroupNames.add(sg.IB_Service_Group_Name__c);
                retailIBServiceGroupNameMap.put(sg.Name, sg.IB_Service_Group_Name__c);
              }
            }
          }
          if (ibServiceGroupNames.size() > 0) {
            List<Service_Group__c> ibServiceGroups = new ServiceGroupsSelector().selectByName(ibServiceGroupNames);
            if (serviceGroups.size() > 0) {
              for (Service_Group__c sg : ibServiceGroups) {
                ibServiceGroupMap.put(sg.Name, sg);
                leadQueueNames.add(sg.Queue__c);
              }
            }
          }
        }

        if (leadQueueNames.size() > 0) {
          List<Group> leadQueues = [SELECT Id, Name, DeveloperName FROM Group WHERE Name IN :leadQueueNames AND Type = :'Queue'];
          if (leadQueues.size() > 0) {
            for (Group queue : leadQueues) {
              leadQueueMap.put(queue.Name, queue.Id);
            }
          }
        }
      }

      for (Lead newLead : (List<Lead>) newRecords) {
        if (serviceNameGroupMap.containsKey(newLead.Financial_Product__c)) {
          //RNIEHAUS : Skip External Sales for B2C and B2B -
          //This value for Lead_Type__c is set on the LeadOverride controller per profile i.e. External Sales as creator
          if (newLead.Lead_Type__c != 'External Sales (B2C and B2B)') {
            newLead.sd_Track_Status_Changes__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Track_Status_Changes__c;
            newLead.sd_Communication_Plan_Id__c = serviceNameGroupMap.get(newLead.Financial_Product__c).sd_Communication_Plan__c;
            newLead.sd_Service_Group_Id__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__c;
            newLead.sd_Service_Group_Type_Id__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Id;
            newLead.sd_Service_Level_Id__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__c;
            newLead.Business_Hours__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Business_Hours__c;
            newLead.sd_Service_Group__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Name;
            newLead.sd_Response_Email_Address__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Response_Email_Address__c;
            newLead.sd_Internal_SLA_Time_Measure__c = serviceNameGroupMap.get(newLead.Financial_Product__c)
              .Service_Group__r.Internal_SLA_Time_Measure__c;
            newLead.sd_Internal_SLA_Units__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Internal_SLA_Units__c;
            newLead.sd_External_SLA_Units__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__r.External_SLA_Units__c;
            newLead.sd_External_SLA_Time_Measure__c = serviceNameGroupMap.get(newLead.Financial_Product__c)
              .Service_Level__r.External_SLA_Time_Measure__c;
            newLead.Manager__c = serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Manager__c;

            //Calculate Internal SLA
            if (
              serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Internal_SLA_Time_Measure__c != null &&
              serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Internal_SLA_Units__c != null
            ) {
              Map<String, DateTime> internalSLA = calculateSLADateTime(
                System.now(),
                newLead.Business_Hours__c,
                serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Internal_SLA_Time_Measure__c,
                integer.valueof(serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Group__r.Internal_SLA_Units__c)
              );
              newLead.SLA_1_Warning_Date__c = internalSLA.get('slaWarningDate');
              newLead.SLA_1_Target_Date__c = internalSLA.get('slaEndDate');
            }

            //Calculate External SLA
            if (
              serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__r.External_SLA_Units__c != null &&
              serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__r.External_SLA_Time_Measure__c != null
            ) {
              Map<String, DateTime> externalSLA = calculateSLADateTime(
                System.now(),
                newLead.Business_Hours__c,
                serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__r.External_SLA_Time_Measure__c,
                integer.valueof(serviceNameGroupMap.get(newLead.Financial_Product__c).Service_Level__r.External_SLA_Units__c)
              );
              newLead.SLA_2_Warning_Date__c = externalSLA.get('slaWarningDate');
              newLead.SLA_2_Target_Date__c = externalSLA.get('slaEndDate');
            }
          }
        }
        //Koketso - assign top 100 retail leads to service group branch manager
        if (serviceGroupManagerMap.containsKey(newLead.sd_Service_Group__c) && newLead.LeadSource == 'Top100') {
          if (
            serviceGroupManagerMap.get(newLead.sd_Service_Group__c) != null && !String.isBlank(serviceGroupManagerMap.get(newLead.sd_Service_Group__c))
          ) {
            newLead.OwnerId = serviceGroupManagerMap.get(newLead.sd_Service_Group__c);
          }
        }

        //Sipho - Change service group of if lead source is IB campaign

        if (newLead.LeadSource == 'IB Campaign') {
          if (ibServiceGroupMap.containsKey(leadServiceGroupMap.get(newLead.Id))) {
            newLead.sd_Service_Group__c = ibServiceGroupMap.get(leadServiceGroupMap.get(newLead.Id)).Name;
            newLead.Service_Group_Search__c = ibServiceGroupMap.get(leadServiceGroupMap.get(newLead.Id)).Id;
            newLead.sd_Original_Service_Group__c = ibServiceGroupMap.get(leadServiceGroupMap.get(newLead.Id)).Name;
            newLead.sd_Service_Group_Id__c = ibServiceGroupMap.get(leadServiceGroupMap.get(newLead.Id)).Id;
          }
        }
        //Koketso - Change service group if lead source is IB campaign
        if (newLead.sd_Service_Group__c != null) {
          if (newLead.LeadSource == 'IB Campaign' && !newLead.sd_Service_Group__c.startsWith('IB - ')) {
            if (retailIBServiceGroupNameMap.containsKey(newLead.sd_Service_Group__c)) {
              if (ibServiceGroupMap.get(retailIBServiceGroupNameMap.get(newLead.sd_Service_Group__c)) != null) {
                String serviceGroupName = ibServiceGroupMap.get(retailIBServiceGroupNameMap.get(newLead.sd_Service_Group__c)).Name;
                String serviceGroupId = ibServiceGroupMap.get(retailIBServiceGroupNameMap.get(newLead.sd_Service_Group__c)).Id;
                String serviceGroupQueueId = leadQueueMap.get(
                  ibServiceGroupMap.get(retailIBServiceGroupNameMap.get(newLead.sd_Service_Group__c)).Queue__c
                );

                newLead.sd_Service_Group__c = serviceGroupName;
                newLead.sd_Original_Service_Group__c = serviceGroupName;
                newLead.sd_Service_Group_Id__c = serviceGroupId;
                newLead.Service_Group_Search__c = serviceGroupId;
                newLead.OwnerId = serviceGroupQueueId;
                newLead.Status = 'Unallocated';
              }
            }
          }
        }
      }

      //Calculate offers taken and declined for lead
      rollupLeadOffers((List<Lead>) newRecords);
    }
    /**
     * @description beforeUpdate description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
      Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
      Id bussinessBankRecTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();
      Id wimiRecTypeId = rtInfo.get('WIMI_Lead').getRecordTypeId();
      Id virtualstiRecTypeId = rtInfo.get('Virtual_STI_Lead').getRecordTypeId();
      Id stiRecTypeId = rtInfo.get('DD_STI_Lead').getRecordTypeId();
      Id aipRecTypeId = rtInfo.get('AIP_Lead').getRecordTypeId();
      Id directDeliveryOppRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
      //Commented By Divya On 12-10-2021
      //Id InvestmentOppRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Investment_Lead').getRecordTypeId();
      Id stiLeadRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
      Id maturityRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Maturity_Retention').getRecordTypeId();
      Boolean DDLead = true;
      Boolean InvstLead = true;
      Boolean MRAgent= false;
      Id MaturityQueueId;
      Set<Id> serviceGroupIds = new Set<Id>();
      List<Lead> bulkleadRecords = new List<Lead>();
      List<String> permissionNames = new List<String>();

      Map<String, LeadStatus> mapToLeadStatus = new Map<String, LeadStatus>();
      for (LeadStatus ldObj : [SELECT id, ApiName, isConverted FROM leadStatus]) {
        mapToLeadStatus.put(ldObj.ApiName, ldObj);
      }

      for (Lead newLead : (List<Lead>) newRecords.values()) {
        Lead oldLead = (Lead) oldRecords.get(newLead.Id);
        String uRoleId = UserInfo.getUserRoleId();
        User loggedUser = new UsersSelector().selectById(UserInfo.getUserId());
        List<GroupMember> queueGroup;
        // Records does'nt enter into this during merge activity.
        if (masterRecIdOfMergeMap == null || (masterRecIdOfMergeMap != null && !masterRecIdOfMergeMap.containsKey(newLead.Id))) {
          //Added by Minal 20201127 for DD
          //Check DD nationality on lead
          Map<Id, Service_Group_Type__c> serviceGroupTypeMap = new Map<Id, Service_Group_Type__c>();
          //Commented By Divya On 12-10-2021
          //  if(newLead.RecordTypeId == stiRecTypeId || newLead.RecordTypeId == InvestmentOppRecTypeId){
          if (newLead.RecordTypeId == stiRecTypeId || newLead.RecordTypeId == maturityRecTypeId) {
            Boolean stiTeamLead = false;
            Boolean stiAgent = false;
            if (newLead.ID_Number__c != null && newLead.DD_Nationality__c == 'South African') {
              if (!SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, newLead.ID_Number__c)) {
                //System.debug(System.Label.IDValidationError);
                newLead.ID_Number__c.addError(System.Label.IDValidationError);
              }
            }
            if (DDLead == true) {
              //queueGroup  = [SELECT Id,Group.DeveloperName FROM GroupMember where UserOrGroupId =:UserInfo.getUserId() and (group.type = 'Queue' or group.type = 'Regular')];
              queueGroup = new GroupMemberSelector().selectByGroupType(UserInfo.getUserId());
              if (queueGroup.size() > 0) {
                for (GroupMember groupName : queueGroup) {
                  //System.debug('groupName.Group.DeveloperName' + groupName.Group.DeveloperName);
                  if (groupName.Group.DeveloperName == 'DD_Advice_STI_Team_Leaders')
                    stiTeamLead = true;
                  else if (groupName.Group.DeveloperName == 'DD_Advice_STI' && stiTeamLead == false)
                    stiAgent = true;
                  else if(groupName.Group.DeveloperName == 'Maturity_Retention_Queue'){
                    MRAgent = true;
                    MaturityQueueId=groupName.Group.Id;
                    }
                }
              }
            }
            System.debug('newLead' + newLead);
            if (newLead.OwnerId != oldLead.OwnerId) {
              List<Lead> queueLeads = new LeadsSelector().selectLeadsByQueueName('DD Advice STI', newLead.Direct_Delivery_Campaign__c);
              if (queueLeads.size() > 0) {
                for (Lead queueLead : queueLeads) {
                  //System.debug('newLead.CreatedDate' + newLead.CreatedDate);
                  //System.debug('queueLead.CreatedDate' + newLead.CreatedDate);
                  if (newLead.CreatedDate > queueLead.CreatedDate && queueLead.Status != 'Closed' && stiTeamLead == false) {
                    newLead.adderror('Please select previous Lead.');
                    break;
                  }
                }
              }
              if (String.valueOf(newLead.OwnerId).startsWith('005') && stiTeamLead == false && oldLead.OwnerId == UserInfo.getUserId())
                newLead.adderror('You cannot update the Lead Owner.');
              else if(stiTeamLead == false && oldLead.OwnerId != UserInfo.getUserId() && !String.valueOf(oldLead.OwnerId).startsWith('00G') && newLead.OwnerId == UserInfo.getUserId())
                  newLead.adderror('You cannot take others Lead.');
              else if(stiTeamLead == false && oldLead.OwnerId != UserInfo.getUserId() && newLead.OwnerId != UserInfo.getUserId())
                  newLead.adderror('You cannot change owner for others Lead.');
              else if (stiTeamLead == false && stiAgent == true && String.valueOf(newLead.OwnerId).startsWith('00G'))
                newLead.adderror('You cannot update the Lead Owner to Queue.');
            }
            //DDLead = false;
            if (newLead.Status != oldLead.Status && stiTeamLead == true && oldLead.Status == 'Closed')
              newLead.Closed_Date__c = null;
            // VA Maturity retention Owner assignment start Added by Sulochana
            if (!loggedUser.profile.name.equals('System Administrator (Custom)') || Test.isRunningTest()) {
                if(!Test.isRunningTest()){
                if(MRAgent == false && maturityRecTypeId == newLead.RecordTypeId )
                  newLead.adderror('You cannot update the Lead Record as you are not the Maturity Queue Memeber');
                }
                if(MRAgent == true && maturityRecTypeId == newLead.RecordTypeId
                && (newLead.Status != oldLead.Status || newLead.SubStatus__c != oldLead.SubStatus__c) || Test.isRunningTest())
                {
                  if(oldLead.Status == 'Closed')
                    newLead.adderror('You Cannot work on closed Lead');
                  if(newLead.Status != 'Closed' && newLead.SubStatus__c != oldLead.SubStatus__c
                  && newLead.SubStatus__c == 'Work In Progress' && newLead.OwnerId == MaturityQueueId)
                      newLead.OwnerId= UserInfo.getUserId();
                  if((newLead.Status == 'Closed' || newLead.Status == 'In Progress' ) && (newLead.SubStatus__c == Null || newLead.SubStatus__c == ''))
                      newLead.adderror('You Cannot Close the lead without valid SubStatus');
                  if(newLead.Status == 'Closed' && newLead.Status != oldLead.Status){
                      if(MaturityQueueId != NULL)
                        newLead.OwnerId= MaturityQueueId;
                  }
                }
              }
              System.debug('newLead after assignment' + newLead);
            // VA Maturity retention Owner assignment start end
          } else if (newLead.RecordTypeId == directDeliveryOppRecTypeId || newLead.RecordTypeId == aipRecTypeId) {
            //Commented By Divya On 12-10-2021
            //else if(newLead.RecordTypeId == directDeliveryOppRecTypeId || newLead.RecordTypeId == InvestmentOppRecTypeId) {
            if (newLead.ID_Number__c != null && newLead.DD_Nationality__c == 'South African') {
              if (!SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, newLead.ID_Number__c)) {
                //System.debug(System.Label.IDValidationError);
                newLead.ID_Number__c.addError(System.Label.IDValidationError);
              }
            }
            //Added as part of DD-Inbound Leads Owner Change Validation on 15/02/2021
            if (DDLead == true || InvstLead == true) {
              //User loggedUser = [select id, name, profile.name, userrole.name from user where Id =: UserInfo.getUserId()];
              //System.debug('loggedUser.profile.name' + loggedUser.profile.name);
              if (!loggedUser.profile.name.equals('System Administrator (Custom)')) {
                //List<PermissionSetAssignment> uPermissionName = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId()];
                List<PermissionSetAssignment> uPermissionName = new PermissionSetAssignmentsSelector().selectByUserId(UserInfo.getUserId());
                //System.debug('uPermissionName' + uPermissionName);
                if (uPermissionName.size() > 0) {
                  for (PermissionSetAssignment perName : uPermissionName) {
                    if (
                      perName.PermissionSet.Name.equals('DD_Flexi_Funeral_Outbound_Team_Leader') ||
                      perName.PermissionSet.Name.equals('DD_Support')
                    )
                      permissionNames.add(perName.PermissionSet.Name);
                    //Commented By Divya On 12-10-2021
                    //Added By Divya
                    /* if(perName.PermissionSet.Name.equals('VA_Investment_Team_Leader') || perName.PermissionSet.Name.equals('VA_Investment_Manager'))
                    {
                      permissionNames.add(perName.PermissionSet.Name);
                    }*/
                  }
                }
                //System.debug('permissionNames' + permissionNames);
                if (
                  oldLead.OwnerId != newLead.OwnerId &&
                  newLead.Single_Transfer__c == false &&
                  (newLead.Is_Inbound__c == true ||
                  newLead.Product__c == 'Extended Cover' ||
                  newLead.Product__c == 'AVAF Credit Life' ||
                  newLead.Product__c == 'Investment Product') &&
                  !permissionNames.contains('DD_Support')
                ) {
                  //List<Group> groupWithRole=[Select Id From Group where RelatedId=:uRoleId and type= 'Role'];
                  List<Group> groupWithRole = new GroupsSelector().selectByGroupRole(uRoleId, 'Role');
                  if (newLead.Is_Inbound__c == true && newLead.Product__c != 'Extended Cover' && newLead.Product__c != 'AVAF Credit Life')
                    //queueGroup  = [SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and group.type = 'Queue' and Group.DeveloperName='DD_Non_Advice_Inbound'];
                    queueGroup = new GroupMemberSelector().selectByGroupTypeInbound(groupWithRole[0].Id, UserInfo.getUserId());
                  else if (newLead.Product__c == 'Extended Cover')
                    //queueGroup = [SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and group.type = 'Queue' and Group.DeveloperName='DD_Extended_Cover'];
                    queueGroup = new GroupMemberSelector().selectByGroupTypeExtendedCover(groupWithRole[0].Id, UserInfo.getUserId());
                  else if (newLead.Product__c == 'AVAF Credit Life')
                    //queueGroup = [SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and group.type = 'Queue' and Group.DeveloperName='DD_AVAF_Credit_Life'];
                    queueGroup = new GroupMemberSelector().selectByGroupTypeCreditLife(groupWithRole[0].Id, UserInfo.getUserId());
                  //System.debug('queueGroup' + queueGroup);
                  //System.debug('newLead.Product__c' + newLead.Product__c);
                  if (permissionNames.isEmpty())
                    newLead.adderror('You cannot update the Lead.Only Team Leaders are allowed to assign Lead Owner');
                  else if (
                    newLead.Product__c != 'Investment Product' &&
                    (queueGroup.isEmpty() &&
                    (newLead.Is_Inbound__c == true ||
                    newLead.Product__c == 'Extended Cover' ||
                    newLead.Product__c == 'AVAF Credit Life'))
                  )
                    newLead.adderror('You cannot update the Lead.');
                } else if (
                  oldLead.OwnerId != newLead.OwnerId &&
                  newLead.Single_Transfer__c == false &&
                  newLead.Is_Inbound__c == false &&
                  permissionNames.isEmpty()
                )
                  newLead.adderror('You cannot update the Lead.Only Team Leaders are allowed to assign Lead Owner');
              }
            }
            DDLead = false;
            newLead.Single_Transfer__c = false;
          } else if (newLead.RecordTypeId == stiLeadRecTypeId) {
            /* Validating the ID Number field on Lead */
            if (
              newLead.ID_Number__c != null &&
              newLead.Nationality__c == 'South Africa' &&
              !SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, newLead.ID_Number__c) &&
              newLead.ID_Type__c == 'SA Identity Document'
            ) {
              //System.debug(System.Label.IDValidationError);
              newLead.ID_Number__c.addError(System.Label.IDValidationError);
            }
          } else if (
            newLead.ID_Number__c != null &&
            newLead.Nationality__c == 'South Africa' &&
            newLead.RecordTypeId != virtualstiRecTypeId &&
            newLead.RecordTypeId != aipRecTypeId &&
            newLead.RecordTypeId != maturityRecTypeId
          ) {
            if (!SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, newLead.ID_Number__c)) {
              //System.debug(System.Label.IDValidationError);
              newLead.ID_Number__c.addError(System.Label.IDValidationError);
            }
          }

          /* Added by @Kyle Alexander
           * If record type is WIMI Lead and lead status being changed from New
           * Change the Owner from the Queue to the current running user and the status to Accepted
           */
          if (newLead.RecordTypeId == wimiRecTypeId && oldLead.Status == 'New') {
            newLead.Status = 'Assigned';
          } else if (newLead.RecordTypeId == wimiRecTypeId && oldLead.Status == 'Assigned') {
            newLead.OwnerId = UserInfo.getUserId();
            newLead.Status = 'Accepted';
          } else if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            oldLead.Status == 'New' &&
            newLead.OwnerId != oldLead.OwnerId &&
            newLead.OwnerId != UserInfo.getUserId()
          ) {
            /* Lead is Owner is changed to User/Queue and the previous status is "New" change Status to "Assigned" */
            /* Lead is Owner is changed to User/Queue and the previous status is "New" change Status to "Assigned" */
            //system.debug('coming here while batch modification 135');
            newLead.Status = 'Assigned';
          } else if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            oldLead.Status == 'Assigned' &&
            newLead.Status == 'Accepted' &&
            oldLead.OwnerId != UserInfo.getUserId()
          ) {
            /* Lead status is changed from "Assigned" to "Accepted" then change owner of the lead to the current user
             * if current user is not the Owner.
             */
            newLead.OwnerId = UserInfo.getUserId();
          } else if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            oldLead.Status == 'Assigned' &&
            isLogaCallRecCreated(newLead, oldLead) &&
            oldLead.OwnerId != UserInfo.getUserId()
          ) {
            newLead.Status = 'Accepted';
            newLead.OwnerId = UserInfo.getUserId();
          } else if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            newLead.OwnerId == UserInfo.getUserId() &&
            oldLead.Status == 'Assigned'
          ) {
            newLead.Status = 'Accepted';
          } else if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            newLead.OwnerId == oldLead.OwnerId &&
            newLead.OwnerId != UserInfo.getUserId() &&
            oldLead.Status == 'Assigned'
          ) {
            newLead.Status = 'Accepted';
            newLead.OwnerId = UserInfo.getUserId();
          }

          //IF Lead is edited regardless of status and the currect owner
          //is a queue, then change the owner to the currect user
          if (String.valueOf(newLead.OwnerId).startsWith('00G') && newLead.RecordTypeId == bussinessBankRecTypeId) {
            newLead.Status = 'Accepted';
          }

          /* To Update the First Call logged and Last call logged times on Lead record
           *  for Unsuccessfull Calls
           */
          if (newLead.First_Call_Logged__c == null && isUnsuccesfullCall(newLead, oldLead)) {
            //Update First Call and Last Call logs
            newLead.First_Call_Logged__c = System.Now();
            newLead.Last_Call_Logged__c = System.Now();
          } else if (newLead.First_Call_Logged__c != null && isUnsuccesfullCall(newLead, oldLead)) {
            //Update Last call Log
            newLead.Last_Call_Logged__c = System.Now();
          }

          /* To Populate First Response time on Lead record when successfull call happens
           */
          if (newLead.First_Response_Date__c == null && isSuccesfullCall(newLead, oldLead)) {
            newLead.First_Response_Date__c = System.Now();
          }

          /* To populate Lead qualified time and ESP Status on Lead
           */
          if (newLead.Status != oldLead.Status && mapToLeadStatus.get(newLead.Status).isConverted) {
            //newLead.Status=='Qualified'
            newLead.Converted_Status_Date__c = System.Now();
          }

          /* To populate SLA 1 Actual Date when status changed to 'Assigned' or 'Accepted' T-04352,T-04359 */
          if ((newLead.RecordTypeId == bussinessBankRecTypeId || newLead.RecordTypeId == wimiRecTypeId) && newLead.Status == 'Assigned') {
            newLead.SLA_1_Actual_Date__c = System.Now();
          } else if ((newLead.RecordTypeId == bussinessBankRecTypeId || newLead.RecordTypeId == wimiRecTypeId) && newLead.Status == 'Accepted') {
            newLead.SLA_2_Actual_Date__c = System.Now();
          }
          /* To populate SLA 3 Actual Date when one successful call happened - T-04361*/
          if (
            (newLead.RecordTypeId == bussinessBankRecTypeId ||
            newLead.RecordTypeId == wimiRecTypeId) &&
            oldLead.Successful_Calls__c == 0 &&
            newLead.Successful_Calls__c == 1
          ) {
            newLead.SLA_3_Actual_Date__c = System.Now();
          }
          /* To populate SLA 4 Actual Date when Converted Status is TRUE - T-04362 */
          if ((newLead.RecordTypeId == bussinessBankRecTypeId || newLead.RecordTypeId == wimiRecTypeId) && newLead.Converted_Status_formula__c == true) {
            newLead.SLA_4_Actual_Date__c = System.Now();
          }
          /* To populate SLA 5 Actual Date when Call sent to ESP is TRUE - T-04363 */
          if ((newLead.RecordTypeId == bussinessBankRecTypeId || newLead.RecordTypeId == wimiRecTypeId) && newLead.Is_sent_to_ESP__c == true) {
            newLead.SLA_5_Actual_Date__c = System.Now();
          }
        }

        //Koketso - Determine if the lead was Bulk transferred
        if (newLead.Bulk_Transfer_Selected_Leads__c) {
          serviceGroupIds.add(newLead.Service_Group_Search__c);
          newLead.sd_Service_Group_Id__c = newLead.Service_Group_Search__c;
          newLead.Bypass_Validation_Rules__c = true;

          //Reset service type and levels as we now use a new service group
          newLead.sd_Service_Level_Id__c = null;
          newLead.sd_Service_Type_Id__c = null;
          bulkleadRecords.add(newLead);
        }
      }
      DDLead = false;

      if (bulkleadRecords.size() > 0) {
        bulkTransferLeads(bulkleadRecords, serviceGroupIds);
      }

      //Calculate offers taken and declined for lead
      rollupLeadOffers((List<Lead>) newRecords.values());
    }

    /*Method: Method to verify whether Log a Call record is created for this particular lead
     * @params: Lead - newLead record and Lead - oldLead record
     * @return: boolean
     * @author: Rakesh Byri(Absa)
     * @created date: 2019-03-04
     * */

    private static boolean isLogaCallRecCreated(Lead newLead, Lead oldLead) {
      Decimal oldSuccessfulCount = oldLead.Successful_Calls__c != null ? oldLead.Successful_Calls__c : 0;
      Decimal oldUnSuccessfulCount = oldLead.Unsuccessful_Calls__c != null ? oldLead.Unsuccessful_Calls__c : 0;
      if (
        (newLead.Successful_Calls__c == oldSuccessfulCount + 1 && newLead.Unsuccessful_Calls__c == oldUnSuccessfulCount) ||
        (newLead.Successful_Calls__c == oldSuccessfulCount &&
        newLead.Unsuccessful_Calls__c == oldUnSuccessfulCount + 1)
      ) {
        return true;
      }
      return false;
    }

    /*Method: Method to verify whether Log a Call record is created for this particular lead is unsuccessful
     * @params: Lead - newLead record and Lead - oldLead record
     * @return: boolean
     * @author: Manoj Danthala(Absa)
     * @created date: 2019-03-12
     * */

    private static boolean isUnsuccesfullCall(Lead newLead, Lead oldLead) {
      Decimal oldUnSuccessfulCount = oldLead.Unsuccessful_Calls__c != null ? oldLead.Unsuccessful_Calls__c : 0;
      if (newLead.Unsuccessful_Calls__c > oldUnSuccessfulCount) {
        return true;
      }
      return false;
    }

    /*Method: Method to verify whether Log a Call record is created for this particular lead is Successful
     * @params: Lead - newLead record and Lead - oldLead record
     * @return: boolean
     * @author: Manoj Danthala(Absa)
     * @created date: 2019-03-13
     * */

    private static boolean isSuccesfullCall(Lead newLead, Lead oldLead) {
      Decimal oldSuccessfulCount = oldLead.Successful_Calls__c != null ? oldLead.Successful_Calls__c : 0;
      if (newLead.Successful_Calls__c > oldSuccessfulCount) {
        return true;
      }
      return false;
    }

    /**
     * @description afterUpdate description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
      handleOwnerChange(newRecords.values(), oldRecords); //vk
      List<Lead> leadListToSend = new List<Lead>();

      Set<Id> prospectIds = new Set<Id>();
      Map<Id, String> prospectsIdMap = new Map<Id, String>();
      List<Account> prospectsToUpdate = new List<Account>();
      List<Lead> bulkTransferList = new List<Lead>();

      for (Lead newLead : (List<Lead>) newRecords.values()) {
        Lead oldLead = (Lead) oldRecords.get(newLead.Id);

        if (newLead.Status != oldLead.Status && newLead.Status == 'Qualified' && !newLead.Is_sent_to_ESP__c) {
          leadListToSend.add(newLead);
        }

        //Koketso - get the prospects related to the lead where Id number is changed
        if (newLead.ID_Number__c != oldLead.ID_Number__c) {
          if (
            newLead.FinServ__RelatedAccount__r.ID_Number__pc != newLead.ID_Number__c &&
            (newLead.FinServ__RelatedAccount__r.CIF__c == null ||
            newLead.FinServ__RelatedAccount__r.RecordType.DeveloperName == 'Individual_Prospect')
          ) {
            prospectIds.add(newLead.FinServ__RelatedAccount__c);
            prospectsIdMap.put(newLead.FinServ__RelatedAccount__c, newLead.ID_Number__c);
          }
        }

        //Sipho Mbulawa - Get leads that are bulk transferred
        if (newLead.Bulk_Transfer_Selected_Leads__c) {
          bulkTransferList.add(newLead);
        }
      }

      if (!leadListToSend.isEmpty()) {
        //Serializing Lead records to JSON
        String leadsJson = JSON.serialize(leadListToSend);
        //ESPOnboarding_IH_v1.retrieveESPStatus(leadsJson);         //ESP Onboarding Callout
      }

      //Evalute existing comm rules agianst the records that changed
      CommunicationPlanFunctions.evaluateCommunicationTasks(newRecords.values(), oldRecords.values());

      //Update status tracking
      ActivityTrackingAndSLAManagement.trackStatus(newRecords.values(), oldRecords);

      //Koketso - update the prospects related to the lead where Id number is changed
      if (prospectIds.size() > 0) {
        List<Account> accountList = [SELECT Id, ID_Number__pc FROM Account WHERE Id IN :prospectIds];
        if (accountList.size() > 0) {
          for (Account acc : accountList) {
            acc.ID_Number__pc = prospectsIdMap.get(acc.Id);
            prospectsToUpdate.add(acc);
          }
          update prospectsToUpdate;
        }
      }

      //Sipho Mbulawa Check Bulk Transferred Leads
      if (!bulkTransferList.isEmpty()) {
        SendEmailNofication.sendEmailToManager(bulkTransferList, oldRecords);
      }
    }

    /**
     * @description afterInsert description
     *
     * @param newRecords (Map<IdsObject>): newRecords
     */
    public static void afterInsert(Map<Id, sObject> newRecords) {
      //Call the communication plan class and pass through all new leads
      CommunicationPlanFunctions.createCommunicationTasks(newRecords.values());

      //Start the status tracking process
      ActivityTrackingAndSLAManagement.insertStatusTracking(newRecords.values());

      Map<Id, Lead> leadTriggerNew = (Map<Id, Lead>) newRecords;
      List<Lead> listNewLeads = convertMapToList(leadTriggerNew);
      emailResponse(listNewLeads, null, 'create');
      // Added for AOL Web to Lead for DD
      if (
        listNewLeads[0].Campaign_Code__c != null &&
        (listNewLeads[0].Campaign_Code__c == 'FlexiOnline' ||
        listNewLeads[0].Campaign_Code__c == 'HealthOnline' ||
        listNewLeads[0].Campaign_Code__c == 'lifelongweb' ||
        listNewLeads[0].Campaign_Code__c == 'lawforyou' ||
        listNewLeads[0].Campaign_Code__c == '1-12720772021')
      ) {
        CampaignMember leadCampaignMember = new CampaignMember();
        leadCampaignMember.CampaignId = listNewLeads[0].Direct_Delivery_Campaign__c;
        leadCampaignMember.LeadId = listNewLeads[0].Id;
        insert leadCampaignMember;
      }
      //DH 19-07-22 Review Notes - Changes Required
      //  THis code is not bulkified and only proceses the first record in the list
      //  Therefore we need to throw an exception if there are more than 1 records in the list
      //  Also I dont think this should be done for all leads ... only for business banking leads
      //

      /* Added by Almas Aleem --Assign Banker to LeadOwner from estpm if lead is existing client  */
      //RN : Didnt pass code review - need redesign for next Sprint
      //Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
      ///Id bussinessBankRecTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();

      //List<Lead> leads = (List<Lead>) newRecords.values();

      //RN : Didnt pass code review - need redesign for next Sprint
      //if(Leads[0].RecordTypeId == bussinessBankRecTypeId && (leads[0].CIF__c !='' || leads[0].CIF__c !=null)){ //If cif number
      //getAndAssignLeadBankerFromEstpm(leads[0].Id,Leads[0].CIF__c);
      //}
      // handleAICNotification(List<Lead> newLeads);
    }

    /**
     * @description calculateSLADateTime description
     *
     * @param dateTimeCalc (DateTime): dateTimeCalc
     * @param busHoursId (Id): busHoursId
     * @param timesMeasure (String): timesMeasure
     * @param units (Integer): units
     * @return Return Map<String,DateTime>: Return description
     */
    public static Map<String, DateTime> calculateSLADateTime(DateTime dateTimeCalc, Id busHoursId, String timesMeasure, Integer units) {
      Map<String, DateTime> slaDateTimeMap = new Map<String, DateTime>();

      String timeMeasure = timesMeasure;
      Integer timeUnits = units;
      Integer warningTime = 0;

      //hours in milliseconds
      if (timeMeasure.contains('Hour')) {
        timeUnits = timeUnits * 60 * 60 * 1000;
      } else if (timeMeasure.contains('Day')) {
        timeUnits = timeUnits * 8; //8 hour day
        timeUnits = timeUnits * 60 * 60 * 1000;
      } else if (timeMeasure.contains('Week')) {
        timeUnits = timeUnits * 40; //5 day week at 8 hours per day
        timeUnits = timeUnits * 60 * 60 * 1000;
      }

      //If SLA is 1 hour use 30min as warning else 60min
      if (timeUnits == (60 * 60 * 1000)) {
        warningTime = 30 * 60 * 1000; //30min
      } else if (timeUnits > (60 * 60 * 1000)) {
        warningTime = 60 * 60 * 1000; //60min
      }

      //This should be the Team Classifications SLA dates
      DateTime finalSLADate = BusinessHours.add(busHoursId, dateTimeCalc, timeUnits);
      DateTime warningSLADate = BusinessHours.add(busHoursId, finalSLADate, (warningTime * -1));

      slaDateTimeMap.put('slaEndDate', finalSLADate);
      slaDateTimeMap.put('slaWarningDate', warningSLADate);

      return slaDateTimeMap;
    }

    /**
     * @description beforeDelete description
     *
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void beforeDelete(Map<Id, sObject> oldRecords) {
      // W - 002473
      Set<Id> leadsTodeleteIdsSet = new Set<Id>();
      List<Task> tasksListTobeUpdatedDuringMerge = new List<Task>();
      for (Lead oldRec : (List<Lead>) oldRecords.values()) {
        leadsTodeleteIdsSet.add(oldRec.id);
      }
      for (Task t : new TasksSelector().selectTasksByWhoIdForMergeLeads(leadsTodeleteIdsSet)) {
        t.Status = 'Cancelled';
        t.Is_Merged_Task__c = true;
        tasksListTobeUpdatedDuringMerge.add(t);
      }
      if (!tasksListTobeUpdatedDuringMerge.isEmpty()) {
        update tasksListTobeUpdatedDuringMerge;
      }
    }

    /**
     * @description afterDelete description
     *
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void afterDelete(Map<Id, sObject> oldRecords) {
      // W - 002474
      masterRecIdOfMergeMap = new Map<String, Lead>();
      for (Lead oldRec : (List<Lead>) oldRecords.values()) {
        if (oldRec.MasterRecordId != null || oldRec.MasterRecordId != '') {
          masterRecIdOfMergeMap.put(oldRec.MasterRecordId, oldRec);
        }
      }
    }

    /**
     * @description emailResponse description
     *
     * @param newLeads (List<Lead>): newLeads
     * @param oldRecords (Map<IdsObject>): oldRecords
     * @param responseType (String): responseType
     */
    public static void emailResponse(List<Lead> newLeads, Map<Id, sObject> oldRecords, String responseType) {
      //get any contact with a valid email address. We need this because you cannot send an email with a template without
      //the Target Object ID, and this can only be a Lead, Contact or user. The WhatId is the Case and this
      //will populate the merged fields as we use the case.email_sender_name in the templates.

      map<String, Id> OWDIdMap = new Map<String, Id>();
      String defaultOWD = '';

      //RN : TESTING A THEORY
      //Cannot use the selector layer as it inforces CRUD access, this prevents
      //site users to query org wide email addresses
      for (OrgWideEmailAddress owd : [SELECT Id, Address FROM OrgWideEmailAddress]) {
        OWDIdMap.put(owd.Address, owd.Id);
        //add the first owd address as the default should we not find any match
        if (defaultOWD == '') {
          defaultOWD = owd.Id;
        }
      }

      //list of emails
      List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
      list<EmailMessage> emailMsgList = new List<EmailMessage>();

      //loop through the new cases and constructed a list of emails to send out
      for (Lead l : newLeads) {
        //Check response type against polulated email template

        String emailTemplateName = '';

        if (responseType.equals('create')) {
          //skip auto responses if true, as this case was created as part of an infinit loop email
          //This will hopefully break the loop
          //if(!l.Skip_Auto_Response__c ){
          emailTemplateName = l.sd_Email_Template_Lead_Creation__c;
          //}
        }

        if (String.isNotBlank(l.Email) && String.isNotBlank(emailTemplateName)) {
          //create a list with the original senders email address (Email From Address)
          list<String> toAddress = new List<String>{ l.Email };
          Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();

          if (OWDIdMap.containsKey(l.sd_Response_Email_Address__c)) {
            emailOut.setOrgWideEmailAddressId(OWDIdMap.get(l.sd_Response_Email_Address__c));
          } else {
            emailOut.setSenderDisplayName('ABSA Support');
          }

          emailOut.setTargetObjectId(l.Id);  emailOut.setTreatTargetObjectAsRecipient(false);
          emailOut.setToAddresses(toAddress);emailOut.setSaveAsActivity(false);

          //RN HOT FIX - FFLIB not returning any email templates back if the user is not a system admin
          //List<EmailTemplate> emailTemps = [Select Id, DeveloperName From EmailTemplate Where Name = :emailTemplateName];
          List<EmailTemplate> emailTemps = new EmailTemplatesSelector().selectByName(emailTemplateName);

          if (!emailTemps.isEmpty()) {
            emailOut.setTemplateId(emailTemps[0].Id);

            emailsOutList.add(emailOut);
          }
        }
      }

      //now send the list of emails
      if (!emailsOutList.isEmpty()) {
        Messaging.sendEmail(emailsOutList);

        //System.debug('*** ' + emailsOutList);
        for (Messaging.SingleEmailMessage eachEmail : emailsOutList) {
          //Create Email Message - to store on Lead
          EmailMessage emailMsg = new EmailMessage();

          emailMsg.FromAddress = newLeads.get(0).sd_Response_Email_Address__c;
          emailMsg.ToAddress = (eachEmail.getToAddresses()[0]);
          emailMsg.Subject = eachEmail.getSubject();
          emailMsg.HtmlBody = eachEmail.getHtmlBody();
          emailMsg.Lead__c = eachEmail.getTargetObjectId();
          emailMsg.MessageDate = system.now();
          emailMsg.Status = '0';
          emailMsg.Is_Auto_Response__c = true;
          emailMsgList.add(emailMsg);
        }

        try {
          if (!emailMsgList.isEmpty()) {
            insert emailMsgList;
          }
        } catch (DMLException e) {
          AuditTrailLog.logException(
            e,
            'New',
            'Warning',
            'Lead_Trigger_Functions',
            'emailResponse',
            'There was an error while inserting the Lead email message Task'
          );
        }
      }
    }

    /**
     * @description convertMapToList description
     *
     * @param triggerMap (Map<IdLead>): triggerMap
     * @return Return List<Lead>: Return description
     */
    private static List<Lead> convertMapToList(Map<Id, Lead> triggerMap) {
      List<Lead> leads = new List<Lead>();
      for (Lead l : triggerMap.values()) {
        leads.add(l);
      }
      return leads;
    }

    /**
     * @description bulkTransferLeads description
     *
     * @param leadRecords (List<Lead>): leadRecords
     * @param serviceGroupIds (Set<Id>): serviceGroupIds
     */
    public static void bulkTransferLeads(List<Lead> leadRecords, Set<Id> serviceGroupIds) {
      Map<String, Service_Group_Type__c> serviceGroupTypeMap = new Map<String, Service_Group_Type__c>();
      Map<String, Id> leadsQueueMap = new Map<String, Id>();

      if (serviceGroupIds.size() > 0) {
        List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(serviceGroupIds);
        //Add Service Group types to map with Service Group
        if (!serviceGroupTypes.isEmpty()) {
          for (Service_Group_Type__c sgType : serviceGroupTypes) {
            serviceGroupTypeMap.put(sgType.Service_Group__c, sgType);
          }
        }

        List<Group> leadQueues = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'];
        //Add all Queues to a Map
        for (Group queue : leadQueues) {
          leadsQueueMap.put(queue.Name, queue.Id);
        }

        for (Lead newLead : leadRecords) {
          if (newLead.Bulk_Transfer_Selected_Leads__c == true && newLead.sd_Service_Group_Id__c != null) {
            if (serviceGroupTypeMap.containsKey(newLead.sd_Service_Group_Id__c)) {
              //update SLA notification user fields on bulk transfer leads
              newLead.Internal_SLA_Notification_User__c = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c)
                .Service_Group__r.Internal_SLA_Notification_User__c;
              newLead.External_SLA_Notification_User__c = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c)
                .Service_Level__r.External_SLA_Notification_User__c;
              newLead.Previous_Manager__c = newLead.Manager__c;
              newLead.Manager__c = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c).Service_Group__r.Manager__c;

              newLead.Previous_Branch__c = newLead.sd_Service_Group__c;
              newLead.sd_Service_Group__c = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c).Service_Group__r.Name;
              newLead.sd_Service_Group_Type_Id__c = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c).Id;

              if (newLead.Transfer_Count__c == null) {
                newLead.Transfer_Count__c = 0;
              }
              newLead.Transfer_Count__c = newLead.Transfer_Count__c + 1;

              String queueName = serviceGroupTypeMap.get(newLead.sd_Service_Group_Id__c).Service_Group__r.Queue__c;
              //System.debug('###transfer queue:#### ' + queueName);

              if (queueName != null && leadsQueueMap.containsKey(queueName)) {
                newLead.OwnerId = leadsQueueMap.get(queueName);
              }
            }

            //Clear bulk indicator and bulk transfer indicator
            //newLead.Bulk_Transfer_Selected_Leads__c = false;
            newLead.Service_Group_Search__c = null;
          }
        }
      }
    }

    /**
     * @description rollupLeadOffers description
     *
     * @param leadRecords (List<Lead>): leadRecords
     */
    public static void rollupLeadOffers(List<Lead> leadRecords) {
      Integer takenOffers = 0;
      Integer declinedOffers = 0;
      Integer totalOffers = 0;

      for (Lead ld : leadRecords) {
        if (ld.Product_Interest_1__c != null) {
          totalOffers = totalOffers + 1;
          if (ld.Product_Offer_Status_1__c == 'Offer Taken Up') {
            takenOffers = takenOffers + 1;
          } else if (ld.Product_Offer_Status_1__c == 'Offer Declined') {
            declinedOffers = declinedOffers + 1;
          }
        }
        if (ld.Product_Interest_2__c != null) {
          totalOffers = totalOffers + 1;
          if (ld.Product_Offer_Status_2__c == 'Offer Taken Up') {
            takenOffers = takenOffers + 1;
          } else if (ld.Product_Offer_Status_2__c == 'Offer Declined') {
            declinedOffers = declinedOffers + 1;
          }
        }
        if (ld.Product_Interest_3__c != null) {
          totalOffers = totalOffers + 1;
          if (ld.Product_Offer_Status_3__c == 'Offer Taken Up') {
            takenOffers = takenOffers + 1;
          } else if (ld.Product_Offer_Status_3__c == 'Offer Declined') {
            declinedOffers = declinedOffers + 1;
          }
        }
        if (ld.Product_Interest_4__c != null) {
          totalOffers = totalOffers + 1;
          if (ld.Product_Offer_Status_4__c == 'Offer Taken Up') {
            takenOffers = takenOffers + 1;
          } else if (ld.Product_Offer_Status_4__c == 'Offer Declined') {
            declinedOffers = declinedOffers + 1;
          }
        }
        if (ld.Product_Interest_5__c != null) {
          totalOffers = totalOffers + 1;
          if (ld.Product_Offer_Status_5__c == 'Offer Taken Up') {
            takenOffers = takenOffers + 1;
          } else if (ld.Product_Offer_Status_5__c == 'Offer Declined') {
            declinedOffers = declinedOffers + 1;
          }
        }

        ld.Total_Offers_Taken__c = takenOffers;  ld.Total_Offers_Declined__c = declinedOffers;
        ld.Total_Offers__c = totalOffers;
      }
    }

    /**
     * @description handleOwnerChange description
     * @param newLeads (List<Lead>): newLeads
     * @param oldRecords (Map<IdsObject>): oldRecords
     */
    public static void handleOwnerChange(List<Lead> newLeads, Map<Id, sObject> oldRecords) {
      Set<Id> idset = new Set<Id>();
      for (Lead data : newLeads) {
        idset.add(data.Id);
      }
      LeadsSelector lselector = new LeadsSelector();
      List<Lead> finalLeads = lselector.selectLeadById(idset);
      /* Set<string> queueMembersId = new Set<String>();
          for(GroupMember queueMember : [Select UserOrGroupId From GroupMember
                      Where
                      GroupId IN (SELECT Id FROM Group WHERE DeveloperName='Virtual_STI_Bancassurance' AND Type='Queue')])
      {
        queueMembersId.add(queueMember.UserOrGroupId);
      }*/
      //Id leadRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType='Lead' AND RecordType.DeveloperName='STI_Lead'].Id;
      //defect
      OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'virtualshortterm@absa.co.za'];
      Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
      //map<Id,User> userIdToData = new map<id,User>([SELECT Id,Email FROM User WHERE Id IN: queueMembersId]);

      List<EmailTemplate> emailTemps = [
        SELECT Id, DeveloperName
        FROM EmailTemplate
        WHERE DeveloperName = 'Short_term_Insurance_Lead_acknowledgement_and_assignment'
      ];
      List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
      for (Lead data : finalLeads) {
        Lead oldLead = (Lead) Trigger.oldMap.get(data.Id);
        //(Lead)Trigger.newMap.get(data.Id) = (Lead)Trigger.oldMap.get(data.Id);
        //System.debug('old record owner test123' + oldLead.OwnerId);
        //System.debug('new record owner test123' + data.OwnerId);
        if (
          data.RecordTypeId == leadRecordTypeId && (data.OwnerId != oldLead.OwnerId) && data.Owner_Type__c == 'User' && string.isNotEmpty(data.AIC_Relationship_Consultant_Name__c)
        ) {
          string AIC_Email = data.AIC_Relationship_Consultant_Name__c.split('\\(')[1].split('\\)')[0];
          string AIC_Name = data.AIC_Relationship_Consultant_Name__c.split('\\(')[0];
          String userEmail = data.Lead_Email__c;String emailTemplateName = '';
          Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();

          if (emailTemps <> null && emailTemps.size() > 0) {
            emailOut.setOrgWideEmailAddressId(owd.Id);emailOut.setTargetObjectId(data.Id);emailOut.setTreatTargetObjectAsRecipient(false);  emailOut.setToAddresses(new List<String>{ userEmail });            //if(userIdToData.containsKey(data.OwnerId))
            emailOut.setCcAddresses(new List<String>{ AIC_Email, data.owner.Email });emailOut.setSaveAsActivity(true);  emailOut.setTemplateId(emailTemps[0].Id);
            emailsOutList.add(emailOut);
          }
        }
      }
      if (!emailsOutList.isEmpty()) {
        //System.debug('emailsOutList' + emailsOutList);
        Messaging.sendEmail(emailsOutList);
      }
    }
  }