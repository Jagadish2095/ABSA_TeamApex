/**
 * @description Controller class for EBDSVCardDeliveryDetails cmp
 * @author Jason Quevauvilliers
 * @created 2021-03-25
 */
public class EBDSVCardDeliveryDetailsController {
	@AuraEnabled
	/**
	 * @description Calls CClistCardSummaryTrackingInfo Service
	 * @param cifCode
	 * @return List<CardDetails>
	 */
	public static List<CardDetails> getCardDeliveryDetails(String cifCode) {
		CClistCardSummaryTrackingInfo_Resp_IB_v1 response = CClistCardSummaryTrackingInfo_IH_v1.getCardDeliveryDetails(cifCode);
		List<CardDetails> cardList = new List<CardDetails>();
		if (response.body != null) {
			for (CClistCardSummaryTrackingInfo_Resp_IB_v1.Body_cls bean : response.body) {
				if (
					bean?.CClistAllTrackingEventsPerSpecificCardV2Response?.ccs402o?.cardStatus != null &&
					(bean.CClistAllTrackingEventsPerSpecificCardV2Response.ccs402o.cardStatus == 'ACKDSV' ||
					bean.CClistAllTrackingEventsPerSpecificCardV2Response.ccs402o.cardStatus == 'AWIDSV')
				) {
					CClistCardSummaryTrackingInfo_Resp_IB_v1.Ccs402o_cls ccs402o = bean.CClistAllTrackingEventsPerSpecificCardV2Response.ccs402o;
					CardDetails card = new CardDetails();
					//Field to be displayed in datatable
					card.cardNbr = ccs402o.cardNbr;
					card.persName = ccs402o.persName;
					card.regNbr = ccs402o.regNbr;
					card.reason = ccs402o.reason;
					card.deliveryType = ccs402o.deliveryType;
					card.issueType = ccs402o.issueType;
					//Fields needed for next screen
					card.delAddress1 = ccs402o.delAddress1;
					card.delAddress2 = ccs402o.delAddress2;
					card.delAddress3 = ccs402o.delAddress3;
					card.delAddress4 = ccs402o.delAddress4;
					card.postalCode = ccs402o.postalCode;
					card.idNbr = ccs402o.idNbr;
					card.contactNumber = ccs402o.cellPhone;
					//Get the Full Description Message from the event
					for (CClistCardSummaryTrackingInfo_Resp_IB_v1.Event_cls event : ccs402o.event) {
						if (event.eventStatus.length() >= 3 && event.eventStatus.left(3) == 'ACK') {
							card.cardStatus = event.eventDescr;
							break;
						}
					}
					cardList.add(card);
				}
			}
		}
		return cardList;
	}
	/**
	 * @description inner class
	 */
	public class CardDetails {
		@AuraEnabled
		public String cardNbr;
		@AuraEnabled
		public String persName;
		@AuraEnabled
		public String cardStatus;
		@AuraEnabled
		public String regNbr;
		@AuraEnabled
		public String reason;
		@AuraEnabled
		public String deliveryType;
		@AuraEnabled
		public String issueType;
		@AuraEnabled
		public String delAddress1;
		@AuraEnabled
		public String delAddress2;
		@AuraEnabled
		public String delAddress3;
		@AuraEnabled
		public String delAddress4;
		@AuraEnabled
		public String postalCode;
		@AuraEnabled
		public String idNbr;
		@AuraEnabled
		public String contactNumber;
	}
	/**
	 * @description Fetching the client address based on the account ID
	 * @param accountID
	 * @return addressLists
	 */
	@AuraEnabled
	public static List<Address__c> getAccountAddress(String accountID) {
		AddressesSelector dsvClientAddress = new AddressesSelector();
		List<Address__c> addressLists = dsvClientAddress.addressesRelatedToAcc(accountID);
		return addressLists;
	}
	/**
	 * @description Endpoit Suffix for the service is created
	 * @param townCode String
	 * @param suburbName String
	 * @param clientName String
	 * @param clientIDPassport String
	 * @param searchRefValue String //It is the regNumber from the CClistCardSummaryTrackingInfo
	 * @return jsonStr
	 */
	@AuraEnabled
	public static String bookingAvailSlots(String townCode, String suburbName, String clientName, String clientIDPassport, String searchRefValue) {
		townCode = townCode.toUpperCase();
		suburbName = suburbName.toUpperCase();
		EBDSVBookingAvailabilitySlots_Resp_IB_v1 responseBean = EBDSVBookingAvailabilitySlots_IH_v1.bookingAvailSlotsGet(
			townCode,
			suburbName,
			clientName,
			clientIDPassport,
			searchRefValue
		);
		return JSON.serialize(responseBean);
	}
	/**
	 * @description Getting the date and time (de-duplication from service values)
	 * @param deliveryResponse
	 * @return dateslots
	 */
	@AuraEnabled
	public static Map<String, List<String>> getDateTimeData(String deliveryResponse) {
		Map<String, List<String>> dateslots = new Map<String, List<String>>();
		Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(deliveryResponse);

		for (String key : responseMap.keyset()) {
			if (key.Contains('BookingAvailabilitySlots')) {
				Object bookingSlots = responseMap.get(key);
				String bookingSlotsString = JSON.serialize(bookingSlots);
				List<BookingDateSlotList> bookingDateSlotList = (List<BookingDateSlotList>) JSON.deserialize(
					bookingSlotsString,
					List<BookingDateSlotList>.class
				);
				for (BookingDateSlotList wrapperKey : bookingDateSlotList) {
					if (dateslots.containsKey(wrapperKey.ServiceDate)) {
						dateslots.get(wrapperKey.ServiceDate).add(wrapperKey.ServiceTime);
					} else {
						dateslots.put(wrapperKey.ServiceDate, new List<String>{ wrapperKey.ServiceTime });
					}
				}
			}
		}
		return dateslots;
	}
	/**
	 * @description Wrapper class to fetch the required fields from the resposnse
	 */
	public class BookingDateSlotList {
		String ServiceTime;
		String ServiceDate;
		String DailyTripID;
		String TownCode;
		String SuburbName;
		String AvailableSlots;
		String AdditionalSuburbNotes;
	}
	/**
	 * @description Endpoint suffix string for the handler class
	 * @param deliveryTownCode String
	 * @param deliverySuburb String
	 * @param clientName String
	 * @param clientIDPassport String
	 * @param clientContactNo String
	 * @param clientDelivery1 String
	 * @param clientDelivery2 String
	 * @param clientDelivery3 String
	 * @param referenceValue String
	 * @param productCode String
	 * @param deliveryPostalCode String
	 * @param deliveryCountryCode String
	 * @param deliveryDateTime String
	 * @param tripSheetID String
	 * @param tripServiceTime String
	 * @param notificationCellNo String
	 * @param clientSpecialInstructions String
	 * @param deliveryType Integer
	 * @param deliveryProvinceCode Integer
	 * @return responseBean object
	 */
	@AuraEnabled
	public static EBDSVBookingRequest_Resp_IB_v1 bookingRequest(
		String deliveryTownCode,
		String deliverySuburb,
		String clientName,
		String clientIDPassport,
		String clientContactNo,
		String clientDelivery1,
		String clientDelivery2,
		String clientDelivery3,
		String referenceValue,
		String productCode,
		String deliveryPostalCode,
		String deliveryCountryCode,
		String deliveryDateTime,
		String tripSheetID,
		String tripServiceTime,
		String notificationCellNo,
		String clientSpecialInstructions,
		Integer deliveryType,
		String deliveryProvinceCode
	) {
		EBDSVBookingRequest_Resp_IB_v1 responseBean = EBDSVBookingRequest_IH_v1.bookingRequestGet(
			deliveryTownCode,
			deliverySuburb,
			clientName,
			clientIDPassport,
			clientContactNo,
			clientDelivery1,
			clientDelivery2,
			clientDelivery3,
			referenceValue,
			productCode,
			deliveryPostalCode,
			deliveryCountryCode,
			deliveryDateTime,
			tripSheetID,
			tripServiceTime,
			notificationCellNo,
			clientSpecialInstructions,
			deliveryType,
			deliveryProvinceCode,
			UserInfo.getName()
		);
		return responseBean;
	}
	/**
	 * @description Service used for Knock and Drop and Branch delivery booking methods
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
	 * @param altNumber String
	 * @param splInstruction String
	 * @return responseBean
	 */
	@AuraEnabled
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
		String altNumber,
		String splInstruction
	) {
		EBDSVReceiveInstructionArray_Resp_IB_v1 responseBean;
		if (String.isBlank(branchCode)) {
			//Knock and Drop delivery Request
			responseBean = EBDSVReceiveInstructionArray_IH_v1.receiveInstructionArray(
				'',
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
				'K',
				altNumber,
				splInstruction
			);
		} else {
			//Branch delivery request
			branchCode = branchCode.leftPad(6, '0');
			responseBean = EBDSVReceiveInstructionArray_IH_v1.receiveInstructionArray(
				branchCode,
				cardIssueType,
				cellNumber,
				idPassportNumber,
				operatorName,
				noOfItems,
				secureItemNo,
				stockType,
				'',
				'',
				'',
				'',
				'',
				'U',
				'',
				''
			);
		}
		return responseBean;
	}

	/**
	 * @description sending email for urgent delivery function
	 * @param addressDetails
	 * @return String
	 */
	@AuraEnabled
	public static String sendEmailUrgentDelivery(Map<String, String> addressDetails) {
		String urgentDeliveryEmail = addressDetails.get('urgentDeliveryEmail');
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = urgentDeliveryEmail.split(';');
		mail.setToAddresses(toAddresses);
		mail.setSubject('DSV Urgent Card Delivery');
		String body = ' Good day DSV Team </br>';
		body += ' </br>';
		body += ' Please arrange for the below card to be delivered urgently to the customer </br>';
		body += '•	Customer name :' + addressDetails.get('perName') + '</br>';
		body += '•	Envelope number : ' + addressDetails.get('refValue') + '</br>';
		body += '•	Address: ' + addressDetails.get('deliveryLine1') + '</br>';
		body += '' + addressDetails.get('deliveryLine2') + '</br>';
		body += '' + addressDetails.get('suburb') + '</br>';
		body += '' + addressDetails.get('town') + '</br>';
		body += '' + addressDetails.get('province') + '</br>';
		body += '' + addressDetails.get('country') + '</br>';
		body += '' + addressDetails.get('postcode') + '</br>';
		body += '•	Special Instruction: ' + addressDetails.get('splInstruction') + '</br>';
		body += ' </br>';
		body += ' Kind regards </br>';
		body += ' Card delivery Team </br>';

		mail.setHtmlBody(body);
		List<Messaging.SendEmailResult> result = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
		if (result[0].isSuccess()) {
			return 'true';
		} else {
			return 'false';
		}
	}
}