/**
 * @description Integration Utility for Everyday Banking Card Delivery Booking Availability Slots
 * @author Bhanumurty Rayala
 * @created 2021-03-25
 */
public class EBDSVBookingAvailabilitySlots_IU_v1 {
	/**
	 * @description Endpoit Suffix for the service is created
	 * @param townCode String
	 * @param suburbName String
	 * @param clientName String
	 * @param clientIDPassport String
	 * @param searchRefValue String
	 * @return queryParams String
	 */
	public static String bookingAvailSlotEndPoint(String townCode, String suburbName, String clientName, String clientIDPassport, String searchRefValue) {
		townCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('DSV', 'Town', townCode, StringConstants.OUTBOUND_RECORD_TYPE);
		String queryParams =
			'?CustomerGroupCode=ABSA' +
			'&DivisionCode=MSD' +
			'&TownCode=' +
			EncodingUtil.urlEncode(townCode, 'UTF-8') +
			'&SuburbName=' +
			EncodingUtil.urlEncode(suburbName, 'UTF-8') +
			'&ClientName=' +
			EncodingUtil.urlEncode(clientName, 'UTF-8') +
			'&ClientIDPassport=' +
			EncodingUtil.urlEncode(clientIDPassport, 'UTF-8') +
			'&SearchRefType=1' +
			'&SearchRefValue=' +
			EncodingUtil.urlEncode(searchRefValue, 'UTF-8');
		return queryParams;
	}
}