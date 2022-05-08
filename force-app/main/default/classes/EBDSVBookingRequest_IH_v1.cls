/**
 * @description Integration Handler for Everyday Banking Card Delivery Booking Request
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVBookingRequest_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Booking Request';
	/**
	 * @description Integration Handler method
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
	 * @param deliveryProvinceCode String
	 * @param bookedBy String
	 * @return responseBean Object
	 */
	public static EBDSVBookingRequest_Resp_IB_v1 bookingRequestGet(
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
		String endpointSuffix = EBDSVBookingRequest_IU_v1.bookingRequestEndPoint(
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
			bookedBy
		);
		EBDSVBookingRequest_Resp_IB_v1 responseBean = (EBDSVBookingRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			endpointSuffix,
			INTEGRATION_SERVICE_NAME,
			EBDSVBookingRequest_Resp_IB_v1.class
		);
		return responseBean;
	}
}