/**
 * @description Integration Utility for EBDSVReceiveInstructionArray
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVReceiveInstructionArray_IU_v1 {
	
	/**
	 * @description Map Request field method
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
	 * @return requestBean object
	 */
	public static EBDSVReceiveInstructionArray_Req_IB_v1 mapRequestFields(
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
		String cardIssueTypeExt = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'DSV',
			'Issue Type',
			cardIssueType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		EBDSVReceiveInstructionArray_Req_IB_v1 requestBean = new EBDSVReceiveInstructionArray_Req_IB_v1();
		requestBean.receiveInstructionRequestArray = new EBDSVReceiveInstructionArray_Req_IB_v1.ReceiveInstructionRequestArray();
		requestBean.receiveInstructionRequestArray.instructionItems = new List<EBDSVReceiveInstructionArray_Req_IB_v1.InstructionItems>();
		EBDSVReceiveInstructionArray_Req_IB_v1.InstructionItems ebdsvIntItem = new EBDSVReceiveInstructionArray_Req_IB_v1.InstructionItems();
		ebdsvIntItem.instructionItemRequestArray = new EBDSVReceiveInstructionArray_Req_IB_v1.InstructionItemRequestArray();
		ebdsvIntItem.instructionItemRequestArray.branchCode = branchCode;
		ebdsvIntItem.instructionItemRequestArray.callBackTime = '';
		ebdsvIntItem.instructionItemRequestArray.cardIssueType = cardIssueTypeExt;
		ebdsvIntItem.instructionItemRequestArray.cellNumber = cellNumber;
		ebdsvIntItem.instructionItemRequestArray.clientInitials = '';
		ebdsvIntItem.instructionItemRequestArray.clientInternalRef = '';
		ebdsvIntItem.instructionItemRequestArray.clientInternalRefType = '';
		ebdsvIntItem.instructionItemRequestArray.clientSurname = '';
		ebdsvIntItem.instructionItemRequestArray.clientTitle = '';
		ebdsvIntItem.instructionItemRequestArray.clientUser = '';
		ebdsvIntItem.instructionItemRequestArray.consigneeName = '';
		ebdsvIntItem.instructionItemRequestArray.contactNumber1 = altNumber;
		ebdsvIntItem.instructionItemRequestArray.contactNumber2 = '';
		ebdsvIntItem.instructionItemRequestArray.corporateCard = '';
		ebdsvIntItem.instructionItemRequestArray.corporateContactName = '';
		ebdsvIntItem.instructionItemRequestArray.corporateName = '';
		ebdsvIntItem.instructionItemRequestArray.countryCode = '';
		ebdsvIntItem.instructionItemRequestArray.deliveryAddress1 = deliveryAddress1;
		ebdsvIntItem.instructionItemRequestArray.deliveryAddress2 = deliveryAddress2;
		ebdsvIntItem.instructionItemRequestArray.deliveryAddress3 = '';
		ebdsvIntItem.instructionItemRequestArray.deliveryAddress4 = '';
		ebdsvIntItem.instructionItemRequestArray.deliveryAddress5 = '';
		ebdsvIntItem.instructionItemRequestArray.deliverySuburb = deliverySuburb;
		ebdsvIntItem.instructionItemRequestArray.deliveryTown = deliveryTown;
		ebdsvIntItem.instructionItemRequestArray.deliveryType = deliveryType;
		ebdsvIntItem.instructionItemRequestArray.doNotAllowAddressChange = '';
		ebdsvIntItem.instructionItemRequestArray.doNotAllowCalling = 'false';
		ebdsvIntItem.instructionItemRequestArray.ebdsvdateTime = String.valueOf(System.today().format()).replaceAll('/', '-');
		ebdsvIntItem.instructionItemRequestArray.emailAddress = '';
		ebdsvIntItem.instructionItemRequestArray.ficaCode = '';
		ebdsvIntItem.instructionItemRequestArray.idPassportNumber = idPassportNumber;
		ebdsvIntItem.instructionItemRequestArray.instructionType = 'Delivery';
		ebdsvIntItem.instructionItemRequestArray.itemRequiredDateTime = '';
		ebdsvIntItem.instructionItemRequestArray.itemRequiredDeliveryDateTime = '';
		ebdsvIntItem.instructionItemRequestArray.itemRequiredDispatchDateTime = '';
		ebdsvIntItem.instructionItemRequestArray.linkID = '';
		ebdsvIntItem.instructionItemRequestArray.operatorID = '';
		ebdsvIntItem.instructionItemRequestArray.operatorName = operatorName;
		ebdsvIntItem.instructionItemRequestArray.orderNumber = '';
		ebdsvIntItem.instructionItemRequestArray.postalCode = postalCode;
		ebdsvIntItem.instructionItemRequestArray.preferredCallingDateTime = '';
		ebdsvIntItem.instructionItemRequestArray.primary = '';
		ebdsvIntItem.instructionItemRequestArray.reasonCode = '';
		ebdsvIntItem.instructionItemRequestArray.residentialAddress1 = '';
		ebdsvIntItem.instructionItemRequestArray.residentialAddress2 = '';
		ebdsvIntItem.instructionItemRequestArray.residentialAddress3 = '';
		ebdsvIntItem.instructionItemRequestArray.residentialPostalCode = '';
		ebdsvIntItem.instructionItemRequestArray.serviceType = '';
		ebdsvIntItem.instructionItemRequestArray.specialInstructions = splInstruction;
		ebdsvIntItem.instructionItemRequestArray.urgent = '';
		ebdsvIntItem.instructionItemRequestArray.userName = '';
		ebdsvIntItem.instructionItemRequestArray.welcomePackRequired = '';
		ebdsvIntItem.instructionItemRequestArray.stockItems = new EBDSVReceiveInstructionArray_Req_IB_v1.StockItems();
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem = new EBDSVReceiveInstructionArray_Req_IB_v1.InstructionItemRequestArrayStockItem();
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cardNo = '';
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.noOfItems = noOfItems;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.returnLocationCode = 0;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.secureItemNo = secureItemNo;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.stockType = stockType;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cartonDimension = new EBDSVReceiveInstructionArray_Req_IB_v1.CartonDimension();
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cartonDimension.height = 0;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cartonDimension.length = 0;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cartonDimension.weight = 0;
		ebdsvIntItem.instructionItemRequestArray.stockItems.instructionItemRequestArrayStockItem.cartonDimension.width = 0;

		requestBean.receiveInstructionRequestArray.instructionItems.add(ebdsvIntItem);

		requestBean.receiveInstructionRequestArray.customerGroupCode = 'ABSA';
		return requestBean;
	}
}