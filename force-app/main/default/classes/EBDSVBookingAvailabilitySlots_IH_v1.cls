/**
 * @description Integration Handler for Everyday Banking Card Delivery Booking Availability Slots
 * @author Bhanumurty Rayala
 * @created 2021-03-25
 */
public class EBDSVBookingAvailabilitySlots_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Booking Availability Slots';
	/**
	 * @description Endpoit Suffix for the service is created
	 * @param townCode String
	 * @param suburbName String
	 * @param clientName String
	 * @param clientIDPassport String
	 * @param searchRefValue String
	 * @return responseBean Object
	 */

	public static EBDSVBookingAvailabilitySlots_Resp_IB_v1 bookingAvailSlotsGet(
		String townCode,
		String suburbName,
		String clientName,
		String clientIDPassport,
		String searchRefValue
	) {
		String endPointSuffixD = EBDSVBookingAvailabilitySlots_IU_v1.bookingAvailSlotEndPoint(
			townCode,
			suburbName,
			clientName,
			clientIDPassport,
			searchRefValue
		);
		EBDSVBookingAvailabilitySlots_Resp_IB_v1 responseBean = (EBDSVBookingAvailabilitySlots_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			endPointSuffixD,
			INTEGRATION_SERVICE_NAME,
			EBDSVBookingAvailabilitySlots_Resp_IB_v1.class
		);
		return responseBean;
	}
}