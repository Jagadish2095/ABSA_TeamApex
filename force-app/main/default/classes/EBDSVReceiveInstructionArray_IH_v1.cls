/**
 * @description Integartion handler for EBDSVReceiveInstructionArray class
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVReceiveInstructionArray_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Receive Instruction Request Array';
	/**
	 * @description Map Request field method for Branch and Knock n Drop delivery
	 * @param branchCode String
	 * @param cardIssueType String
	 * @param cellNumber String
	 * @param idPassportNumber String
	 * @param operatorName String
	 * @param noOfItems Integer
	 * @param secureItemNo String
	 * @param stockType String
	 * @param deliveryAddress1 String
	 * @param deliveryAddress2 String
	 * @param deliveryTown String
	 * @param deliverySuburb String
	 * @param postalCode String
	 * @param deliveryType String
	 * @param altNumber String
	 * @param splInstruction String
	 * @return responseBean object
	 */
	public static EBDSVReceiveInstructionArray_Resp_IB_v1 receiveInstructionArray(
		String branchCode,
		String cardIssueType,
		String cellNumber,
		String idPassportNumber,
		String operatorName,
		Integer noOfItems,
		String secureItemNo,
		String stockType,
		String deliveryAddress1,
		String deliveryAddress2,
		String deliveryTown,
		String deliverySuburb,
		String postalCode,
		String deliveryType,
        String altNumber,
     	String splInstruction
	) {
		EBDSVReceiveInstructionArray_Req_IB_v1 requestBean = EBDSVReceiveInstructionArray_IU_v1.mapRequestFields(
			branchCode,
			cardIssueType,
			cellNumber,
			idPassportNumber,
			operatorName,
			noOfItems,
			secureItemNo,
			stockType,
			deliveryAddress1,
			deliveryAddress2,
			deliveryTown,
			deliverySuburb,
			postalCode,
			deliveryType,
            altNumber,
            splInstruction
		);
		EBDSVReceiveInstructionArray_Resp_IB_v1 responseBean = (EBDSVReceiveInstructionArray_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			EBDSVReceiveInstructionArray_Resp_IB_v1.class
		);
		return responseBean;
	}
}