/**
 * @description Controller class for Home loans 90 days notice and Bond cancellation
 * @author  Koketso Mpshane
 * @date    03/06/2021
 */
public class HLBondCancellationRequestController {
    /**
	 * @description Method to get Account Information
	 * @param accountNumber
	 * @return String
	 */
	@AuraEnabled
	public static String getAccountInformation(String accountNumber) {

        MLgetAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLgetAcctInfoCUS1V1_IH_v1.getAccountInfo(accountNumber, 'NOA');

		//check if response is null
		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}
        //check if the response is not successful
		if (responseBean.MLB854O?.MLB854O_OUTPUT_AREA?.MLB854O_RETURN_CODE != 0) {
			return 'Error: MLgetAcctInfoCUS1V1 service returned error code (' + responseBean.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_RETURN_CODE + '), please log with home loans support team';
		}

		return JSON.serialize(responseBean);
    }

    /**
	* @description Method to update the due date
	* @param accountNumber
	* @param primaryAccountId
	* @param refNumber
	* @param schemaCode
	* @return String
	*/
	@AuraEnabled
	public static String updateAccountInformation(String accountNumber, String primaryAccountId, Integer refNumber, Double schemaCode) {
        MLupdAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLupdAcctInfoCUS1V1_IH_v1.doUpdate(accountNumber, primaryAccountId, 0, refNumber, schemaCode, 'NOA');
		//check if response is null
		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}
        //check if the response is not successful
		if (responseBean.MLB855O?.MLB855O_OUTPUT_AREA?.MLB855O_RETURN_CODE != 0) {
			return 'Error: MLupdAcctInfoCUS1V1 service returned error code (' + responseBean.MLB855O.MLB855O_OUTPUT_AREA.MLB855O_RETURN_CODE + '), please log with home loans support team';
		}

		return JSON.serialize(responseBean);
    }

    /**
	* @description Method to update case account number field
	* @param caseId
	* @param accountNumber
	*/
	@AuraEnabled
	public static void updateAccountNumberField(String caseId, String accountNumber) {

        List<Case> caseRecord = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId, 1);
        caseRecord[0].Account_Number__c = accountNumber;
        update caseRecord;

    }

    /**
	* @description Method to create case
	* @param parentId
	* @param accountId
	* @param subject
	* @param description
	* @param serviceGroup
	* @param queueName
	*/
	@AuraEnabled
	public static void createServiceRequestCase(String parentId, String accountId, String subject, String description, String serviceGroup, String queueName) {

        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        List<Group> caseQueue = new GroupsSelector().selectByNameAndType(queueName, 'Queue');

        Case newCase = new Case();
        newCase.RecordTypeId = recTypeId;
        newCase.OwnerId = caseQueue[0].Id;
        newCase.ParentId = parentId;
        newCase.AccountId = accountId;
        newCase.Subject = subject;
        newCase.Description = description;
        newCase.sd_Original_Service_Group__c = serviceGroup;
        newCase.sd_Service_Group__c = serviceGroup;
        newCase.sd_Original_Service_Queue__c = queueName;
        insert newCase;

    }

}