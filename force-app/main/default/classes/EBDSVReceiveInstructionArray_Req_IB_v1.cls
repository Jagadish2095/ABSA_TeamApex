/**
 * @description Request bean for EBDSVReceiveInstructionArray
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVReceiveInstructionArray_Req_IB_v1 extends Base_IB {
	public ReceiveInstructionRequestArray ReceiveInstructionRequestArray;
	/**
	 * @description Inner class
	 */
	public class StockItems {
		public InstructionItemRequestArrayStockItem InstructionItemRequestArrayStockItem;
	}
	/**
	 * @description Inner class
	 */
	public class ReceiveInstructionRequestArray {
		public list<InstructionItems> instructionItems;
		public String customerGroupCode;
	}
	/**
	 * @description Inner class
	 */
	public class InstructionItems {
		public InstructionItemRequestArray InstructionItemRequestArray;
	}
	/**
	 * @description Inner class
	 */
	public class InstructionItemRequestArrayStockItem {
		public cartonDimension cartonDimension;
		public String cardNo;
		public Integer noOfItems;
		public String stockType;
		public Integer returnLocationCode;
		public String secureItemNo;
	}
	/**
	 * @description Inner class
	 */
	public class InstructionItemRequestArray {
		public String deliveryAddress5;
		public String deliverySuburb;
		public String deliveryTown;
		public String postalCode;
		public String deliveryAddress4;
		public String countryCode;
		public String deliveryAddress3;
		public String idPassportNumber;
		public String deliveryAddress2;
		public String specialInstructions;
		public String deliveryAddress1;
		public String reasonCode;
		public String cellNumber;
		public String urgent;
		public String contactNumber2;
		public String ebdsvdateTime;
		public String contactNumber1;
		public String ficaCode;
		public String consigneeName;
		public String linkID;
		public String branchCode;
		public String primary;
		public String deliveryType;
		public String emailAddress;
		public String corporateContactName;
		public String residentialAddress1;
		public String corporateName;
		public String residentialAddress2;
		public String corporateCard;
		public String residentialAddress3;
		public String cardIssueType;
		public String residentialPostalCode;
		public String clientSurname;
		public String clientUser;
		public String clientInitials;
		public String welcomePackRequired;
		public String clientTitle;
		public String callBackTime;
		public String operatorName;
		public String serviceType;
		public String operatorID;
		public String preferredCallingDateTime;
		public String userName;
		public String clientInternalRef;
		public StockItems stockItems;
		public String clientInternalRefType;
		public String itemRequiredDeliveryDateTime;
		public String itemRequiredDispatchDateTime;
		public String itemRequiredDateTime;
		public String doNotAllowAddressChange;
		public String instructionType;
		public String doNotAllowCalling;
		public String orderNumber;
	}
	/**
	 * @description Inner class
	 */
	public class CartonDimension {
		public Integer weight;
		public Integer width;
		public Integer length;
		public Integer height;
	}
	/**
	 * @description Method to substitute the service request variable with class variable
	 * to avoid the reserved keyword interruption with request variable where the request service variable is dateTime.
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('dateTime', 'ebdsvdateTime');
	}
	/**
	 * @description Dummy method
	 * @return requestBean object
	 */
	public static EBDSVReceiveInstructionArray_Req_IB_v1 createDummy() {
		EBDSVReceiveInstructionArray_Req_IB_v1 requestBean = new EBDSVReceiveInstructionArray_Req_IB_v1();
		requestBean.receiveInstructionRequestArray = new EBDSVReceiveInstructionArray_Req_IB_v1.ReceiveInstructionRequestArray();
		requestBean.receiveInstructionRequestArray.instructionItems = new List<InstructionItems>();
		InstructionItems ebdsvIntItem = new InstructionItems();
		ebdsvIntItem.InstructionItemRequestArray = new InstructionItemRequestArray();
		ebdsvIntItem.InstructionItemRequestArray.branchCode = '008913';
		ebdsvIntItem.InstructionItemRequestArray.callBackTime = '';
		ebdsvIntItem.InstructionItemRequestArray.cardIssueType = 'D';
		ebdsvIntItem.InstructionItemRequestArray.cellNumber = '0832342345';
		ebdsvIntItem.InstructionItemRequestArray.clientInitials = '';
		ebdsvIntItem.InstructionItemRequestArray.clientInternalRef = '';
		ebdsvIntItem.InstructionItemRequestArray.clientInternalRefType = '';
		ebdsvIntItem.InstructionItemRequestArray.clientSurname = '';
		ebdsvIntItem.InstructionItemRequestArray.clientTitle = '';
		ebdsvIntItem.InstructionItemRequestArray.clientUser = '';
		ebdsvIntItem.InstructionItemRequestArray.consigneeName = '';
		ebdsvIntItem.InstructionItemRequestArray.contactNumber1 = '';
		ebdsvIntItem.InstructionItemRequestArray.contactNumber2 = '';
		ebdsvIntItem.InstructionItemRequestArray.corporateCard = '';
		ebdsvIntItem.InstructionItemRequestArray.corporateContactName = '';
		ebdsvIntItem.InstructionItemRequestArray.corporateName = '';
		ebdsvIntItem.InstructionItemRequestArray.countryCode = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryAddress1 = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryAddress2 = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryAddress3 = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryAddress4 = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryAddress5 = '';
		ebdsvIntItem.InstructionItemRequestArray.deliverySuburb = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryTown = '';
		ebdsvIntItem.InstructionItemRequestArray.deliveryType = 'U';
		ebdsvIntItem.InstructionItemRequestArray.doNotAllowAddressChange = '';
		ebdsvIntItem.InstructionItemRequestArray.doNotAllowCalling = 'false';
		ebdsvIntItem.InstructionItemRequestArray.ebdsvdateTime = '2021-03-22';
		ebdsvIntItem.InstructionItemRequestArray.emailAddress = '';
		ebdsvIntItem.InstructionItemRequestArray.ficaCode = '';
		ebdsvIntItem.InstructionItemRequestArray.idPassportNumber = '92061704383083';
		ebdsvIntItem.InstructionItemRequestArray.instructionType = 'Deliver';
		ebdsvIntItem.InstructionItemRequestArray.itemRequiredDateTime = '';
		ebdsvIntItem.InstructionItemRequestArray.itemRequiredDeliveryDateTime = '';
		ebdsvIntItem.InstructionItemRequestArray.itemRequiredDispatchDateTime = '';
		ebdsvIntItem.InstructionItemRequestArray.linkID = '';
		ebdsvIntItem.InstructionItemRequestArray.operatorID = '';
		ebdsvIntItem.InstructionItemRequestArray.operatorName = 'MR J NORMANDY';
		ebdsvIntItem.InstructionItemRequestArray.orderNumber = '';
		ebdsvIntItem.InstructionItemRequestArray.postalCode = '';
		ebdsvIntItem.InstructionItemRequestArray.preferredCallingDateTime = '';
		ebdsvIntItem.InstructionItemRequestArray.primary = '';
		ebdsvIntItem.InstructionItemRequestArray.reasonCode = '';
		ebdsvIntItem.InstructionItemRequestArray.residentialAddress1 = '';
		ebdsvIntItem.InstructionItemRequestArray.residentialAddress2 = '';
		ebdsvIntItem.InstructionItemRequestArray.residentialAddress3 = '';
		ebdsvIntItem.InstructionItemRequestArray.residentialPostalCode = '';
		ebdsvIntItem.InstructionItemRequestArray.serviceType = '';
		ebdsvIntItem.InstructionItemRequestArray.specialInstructions = '';
		ebdsvIntItem.InstructionItemRequestArray.urgent = '';
		ebdsvIntItem.InstructionItemRequestArray.userName = '';
		ebdsvIntItem.InstructionItemRequestArray.welcomePackRequired = '';
		ebdsvIntItem.InstructionItemRequestArray.stockItems = new StockItems();
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem = new InstructionItemRequestArrayStockItem();
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cardNo = '4550270025154019';
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.noOfItems = 1;
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.returnLocationCode = 0;
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.secureItemNo = '10/03AVLA110013';
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.stockType = 'AMBB';
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cartonDimension = new CartonDimension();
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cartonDimension.height = 0;
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cartonDimension.length = 0;
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cartonDimension.weight = 0;
		ebdsvIntItem.InstructionItemRequestArray.stockItems.InstructionItemRequestArrayStockItem.cartonDimension.width = 0;
		requestBean.receiveInstructionRequestArray.instructionItems.add(ebdsvIntItem);
		requestBean.receiveInstructionRequestArray.customerGroupCode = 'ABSA';
		return requestBean;
	}
}