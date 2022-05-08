/**
 * @description Controller class for VAPSInsuranceCancellation cmp
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 * @modified 2021-04-19 by Jason Quevauvilliers (W-011270)
 */
public class VAPSInsuranceCancellationController {
	/**
	 * @description Method called via init on VAPSInsuranceCancellation cmp
	 * @param accountNumber
	 * @return AvafVapsGetList_Resp_IB_v1
	 */
	@AuraEnabled
	public static AvafVapsGetList_Resp_IB_v1 getVAPSInsuranceList(String accountNumber) {
		AvafVapsGetList_Resp_IB_v1 responseBean = AvafVapsGetList_IH_v1.getVAPSList(accountNumber.leftPad(11, '0').right(11)); //Will always get the last 11 digits on the right. If its shorter then 11 it will pad 0 on the left
		return responseBean;
	}

	/**
	 * @description Method to Cancel the selected VAPS Product
	 * @param selectedVAPS
	 * @param authOverride
	 * @return AvafVapsCancel_Resp_IB_v1
	 */
	@AuraEnabled
	public static AvafVapsCancel_Resp_IB_v1 cancelVAPSInsurance(String selectedVAPS, Boolean authOverride) {
		AvafVapsCancel_Resp_IB_v1 responseBean = AvafVapsCancel_IH_v1.cancelInsurance(selectedVAPS, authOverride);
		return responseBean;
	}

	/**
	 * @description Method to transfer the case to the selected queue/team
	 * @param serviceGroupName
	 * @param serviceTypeName
	 * @param caseId
	 */
	@AuraEnabled
	public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId) {
		CaseTransferActionExt.transferCase(serviceGroupName, serviceTypeName, caseId);
	}
}