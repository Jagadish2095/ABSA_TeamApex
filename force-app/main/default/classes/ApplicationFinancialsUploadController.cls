/**
 * Lightning Component Controller for  Application Financial Upload  for main Client and Principals
 *
 * @author  Saurabh : Absa
 * @version v1.0
 * @since   2020-09-15
 * @UserStory W:005850
 *
 * @update Englarmerdge Mongwe
 * @date 2021-01-05
 * edited task creation to case creation.
 */
public class ApplicationFinancialsUploadController {
	@AuraEnabled
	public static void createCaseforCreditSupportConsultant(String accId) {
		Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Financial_Capture_Request').getRecordTypeId();
		Account acc = new AccountsSelector().selectByAccountId(accId,1);
		List<Service_Group__c> serviceGroup = new ServiceGroupsSelector().selectByName(new Set<String>{'Financial Capture Group'});
		List<Case> finCaptureCaseList = new CasesSelector().selectByAccountId(new Set<Id>{acc.Id}, 1);
		List<Service_Group_Type__c> serviceGroupTypesList = new ServiceGroupTypesSelector().selectByServiceGroupWithGroupAndServiceInfo(new Set<Id>{serviceGroup[0].Id});
		List<Group> groupDetail = new GroupsSelector().selectByNameSetAndType(new Set<String>{'Credit Support Consultant'},'Queue');
		Id groupId = (groupDetail?.size() > 0 ? groupDetail[0].Id : null);
		User user = new UsersSelector().selectById(UserInfo.getUserId());

		//if (finCaptureCaseList?.size() == 0) {
			Service_Group_Type__c serviceGroupTypes = (serviceGroupTypesList?.size() > 0 ? serviceGroupTypesList[0] : null);
			Case finCaptureCase = new Case();
			finCaptureCase.AccountId = acc.Id;
			//finCaptureCase.Opportunity__c = oppId;
			finCaptureCase.Relationship_Banker__c = user.Id;
			finCaptureCase.OwnerId = user.Id;
			finCaptureCase.Origin = 'Web';
			finCaptureCase.Status = 'New';
			finCaptureCase.Priority = 'High';
			finCaptureCase.RecordTypeId = recordTypeId;
			finCaptureCase.Subject = serviceGroupTypes.Service_Type__r.Name; // 'Financial Capture Request';
			finCaptureCase.Type__c = serviceGroupTypes.Service_Type__r.Name;
			finCaptureCase.Type = serviceGroupTypes.Service_Type__r.Name;
			finCaptureCase.sd_Communication_Plan_Id__c = serviceGroupTypes.sd_Communication_Plan__c;
			finCaptureCase.sd_Service_Group_Id__c = serviceGroupTypes.Service_Group__r.Id;
			finCaptureCase.sd_Service_Group_Type_Id__c = serviceGroupTypes.Id;
			finCaptureCase.sd_Original_Service_Group__c = serviceGroupTypes.Service_Group__r.Name;
			finCaptureCase.sd_Original_Service_Queue__c = serviceGroupTypes.Service_Group__r.Queue__c;
			finCaptureCase.sd_Service_Type_Id__c = serviceGroupTypes.Service_Type__r.Id;
			finCaptureCase.sd_Service_Type__c = serviceGroupTypes.Service_Type__c;
			finCaptureCase.sd_Service_Level_Id__c = serviceGroupTypes.Service_Level__c;
			finCaptureCase.sd_Service_Group__c = serviceGroupTypes.Service_Group__r.Name;
			finCaptureCase.sd_Response_Email_Address__c = serviceGroupTypes.Service_Group__r.Response_Email_Address__c;
			finCaptureCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes.Service_Group__r.Email_Template_Case_Creation__c;
			finCaptureCase.BusinessHoursId = serviceGroupTypes.Service_Group__r.Business_Hours__c;
			finCaptureCase.Internal_SLA_Notification_User__c = serviceGroupTypes.Service_Group__r.Internal_SLA_Notification_User__c;
			finCaptureCase.External_SLA_Notification_User__c = serviceGroupTypes.Service_Level__r.External_SLA_Notification_User__c;

			try {
				insert finCaptureCase;
			}
			catch (Exception ex) {
				throw new AuraException('Error inserting case: ' + ex.getDmlMessage(0));
			}
		//}

		Task taskrec = new task();
		if(groupId != null) {
			taskrec.WhatId = acc.Id;
			taskrec.Description = 'Capture Financial Document';
			taskrec.Subject = 'Capture Financial Document';
			taskrec.Status = 'Open';
			taskrec.Priority = 'Normal';
			//taskrec.OwnerId = groupId;
			taskrec.ActivityDate = date.today();

			try {
				insert taskrec;
			}
			catch (Exception ex) {
				throw new AuraException('Error inserting task: ' + ex.getDmlMessage(0));
			}
		}
	}

	@AuraEnabled
	public static Account returnClientDetails(String oppId) {
		setAppFinValidation(oppId);
		Account mainClient = new AccountsSelector().selectByOpportunityId(oppId);
		return mainClient;
	}

	public static void setAppFinValidation(String oppId) {
		Map<String, Boolean> mapValidations = PowerCurveController.getValidationMap(oppId);

		if(mapValidations?.get('Applicant_Financials_Captured') == false) {
			Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
			Financial_Information__c accFin = PowerCurveUpdateController3And5.getFinacials(app.Id);
			PowerCurveController.setValidationFields(oppId, 'Applicant_Financials_Captured', (accFin != null ? true : false));
		}
	}
}