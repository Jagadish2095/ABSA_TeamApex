/**
* Controller used by lightning components for the Merchant Onboarding
*
* @author  PJAIN for Lerato's QA story.
* @version v1.0
* @since   2020-06-03
*/
public with sharing class MerchantOnboardingQualityAssuranceCntrlr {

    @AuraEnabled
    public static Map<String, String> getData(String opportunityIdP, String permissionSetName) {

        Map<String, String> responseMap;

        List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityOnboardId(opportunityIdP);
        if(applicationList != null && !applicationList.isEmpty()){
            Application__c application = applicationList[0];
            responseMap = new Map<String, String>();

            responseMap.put('applicationId', application.Id);
            responseMap.put('applicationRecordTypeId', application.RecordTypeId);

            List<PermissionSetAssignment> permissionSetAssignments = new PermissionSetAssignmentsSelector().selectByNameAndUserId(permissionSetName, UserInfo.getUserId());
            if (permissionSetAssignments != null && !permissionSetAssignments.isEmpty()) {
                responseMap.put('isPermissionSetAssigned', 'true');
            } else {
                responseMap.put('isPermissionSetAssigned', 'false');
            }
        }
        return responseMap;
    }
}