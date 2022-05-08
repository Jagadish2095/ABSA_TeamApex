/**
 * @description Integration Utility for Everyday Banking Card Delivery Booking Request
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVBookingRequest_IU_v1 {
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
	 * @param deliveryDateTime Date
	 * @param tripSheetID String
	 * @param tripServiceTime String
	 * @param notificationCellNo String
	 * @param clientSpecialInstructions String
	 * @param deliveryType Integer
	 * @param deliveryProvinceCode Integer
	 * @param bookedBy String
	 * @return queryParams String
	 */
	public static String bookingRequestEndPoint(
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
		String deliveryProvinceCode,
		String bookedBy
	) {
		deliveryCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'DSV',
			'Country',
			deliveryCountryCode,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		deliveryProvinceCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'DSV',
			'Province',
			deliveryProvinceCode,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		String queryParams =
			'?RequestType=2' +
			'&DivisionCode=MSD' +
			'&CustomerGroupCode=ABSA' +
			'&DeliveryTownCode=' +
			EncodingUtil.urlEncode(deliveryTownCode, 'UTF-8') +
			'&DeliverySuburb=' +
			EncodingUtil.urlEncode(deliverySuburb, 'UTF-8') +
			'&ClientName=' +
			EncodingUtil.urlEncode(clientName, 'UTF-8') +
			'&ClientIDPassport=' +
			EncodingUtil.urlEncode(clientIDPassport, 'UTF-8') +
			'&ClientContactNo=' +
			EncodingUtil.urlEncode(clientContactNo, 'UTF-8') +
			'&ClientDeliveryAddress1=' +
			EncodingUtil.urlEncode(clientDelivery1, 'UTF-8') +
			'&ClientDeliveryAddress2=' +
			EncodingUtil.urlEncode(clientDelivery2, 'UTF-8') +
			'&ClientDeliveryAddress3=' +
			EncodingUtil.urlEncode(clientDelivery3, 'UTF-8') +
			'&ReferenceType=1' +
			'&ReferenceValue=' +
			EncodingUtil.urlEncode(referenceValue, 'UTF-8') +
			'&ProductCode=' +
			EncodingUtil.urlEncode(productCode, 'UTF-8') +
			'&DeliveryPostalCode=' +
			EncodingUtil.urlEncode(deliveryPostalCode, 'UTF-8') +
			'&DeliveryCountryCode=' +
			EncodingUtil.urlEncode(deliveryCountryCode, 'UTF-8') +
			'&DeliveryDateTime=' +
			EncodingUtil.urlEncode(deliveryDateTime, 'UTF-8') +
			'&TripSheetID=' +
			EncodingUtil.urlEncode(tripSheetID, 'UTF-8') +
			'&TripServiceTime=' +
			EncodingUtil.urlEncode(tripServiceTime, 'UTF-8') +
			'&NotificationSMS=true' +
			'&NotificationCellNo=' +
			EncodingUtil.urlEncode(notificationCellNo, 'UTF-8') +
			'&ClientSpecialInstructions=' +
			EncodingUtil.urlEncode(clientSpecialInstructions, 'UTF-8') +
			'&DeliveryType=' +
			deliveryType +
			'&DeliveryProvinceCode=' +
			EncodingUtil.urlEncode(deliveryProvinceCode, 'UTF-8') +
			'&BookedBy=' +
			EncodingUtil.urlEncode(bookedBy, 'UTF-8');

		return queryParams;
	}
}