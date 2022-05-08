/**
 * @description CaseDiscountApprovalExt Description
 *
 */
public without sharing class CaseDiscountApprovalExt {
	/**
	 * @description approvalProccessChecks description
	 *
	 * @param recId (String): recId
	 * @return Return Boolean: Return description
	 */
	@AuraEnabled
	public static Boolean approvalProccessChecks(String recId) {
		return CaseExtendSlaActionExt.approvalProccessChecks(recId);
	}

	/**
	 * @description submitapproval description
	 *
	 * @param recId (String): recId
	 */
	@AuraEnabled
	public static void submitapproval(String recId) {
		List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo(recId, 1);
		try {
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Discount');
			req1.setObjectId(recId);

			// Submit the approval request for the account
			Approval.ProcessResult result = Approval.process(req1);

			// Verify the result
			System.assert(result.isSuccess());

			Approval.UnlockResult lrList = Approval.unlock(caseRecord[0], true);
		} catch (Exception ex) {
			System.debug(LoggingLevel.Finest, 'Exception : CaseExtendSlaActionExt : extendExternalSLA - ' + ex.getMessage());
			throw new AuraHandledException(ex.getMessage());
		}
	}
}