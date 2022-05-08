/**
 * @description Response Bean for Everyday Banking Card Delivery Booking Availability Slots
 * @author Bhanumurty Rayala
 * @created 2021-03-25
 */
public class EBDSVBookingAvailabilitySlots_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String Status;
	@AuraEnabled
	public Integer StatusCode;
	@AuraEnabled
	public String Message;

	@AuraEnabled
	public list<BookingAvailabilitySlots> BookingAvailabilitySlots;
	@AuraEnabled
	public list<String> ErrorMessages;
	@AuraEnabled
	public list<ServiceDays> ServiceDays;
	@AuraEnabled
	public String Successful;
	/**
	 * @description Inner class for reponse bean
	 */
	public class WedServiceTimes {
		@AuraEnabled
		public list<String> TimeSlot;
	}
	/**
	 * @description Inner class for reponse bean
	 */
	public class TueServiceTimes {
		@AuraEnabled
		public list<String> TimeSlot;
	}
	/**
	 * @description Inner class for reponse bean
	 */
	public class ThuServiceTimes {
		@AuraEnabled
		public list<String> TimeSlot;
	}
	/**
	 * @description Inner class for reponse bean
	 */
	public class ServiceDays {
		@AuraEnabled
		public String Sun;
		@AuraEnabled
		public String Fri;
		@AuraEnabled
		public String Thu;
		@AuraEnabled
		public String Sat;
		@AuraEnabled
		public String Wed;
		@AuraEnabled
		public String PubHol;
		@AuraEnabled
		public String Tue;
		@AuraEnabled
		public ThuServiceTimes ThuServiceTimes;
		@AuraEnabled
		public FriServiceTimes FriServiceTimes;
		@AuraEnabled
		public WedServiceTimes WedServiceTimes;
		@AuraEnabled
		public SatServiceTimes SatServiceTimes;
		@AuraEnabled
		public TueServiceTimes TueServiceTimes;
		@AuraEnabled
		public String SunServiceTimes;
		@AuraEnabled
		public MonServiceTimes MonServiceTimes;
		@AuraEnabled
		public String PhServiceTimes;
		@AuraEnabled
		public String Mon;
		@AuraEnabled
		public String CreatedDate;
		@AuraEnabled
		public String Version;
	}

	/**
	 * @description Inner class for reponse bean
	 */
	public class SatServiceTimes{
		@AuraEnabled
		public list<String> TimeSlot;
	}

	/**
	 * @description Inner class for reponse bean
	 */
	public class MonServiceTimes {
		@AuraEnabled
		public list<String> TimeSlot;
	}
	/**
	 * @description Inner class for reponse bean
	 */
	public class FriServiceTimes {
		@AuraEnabled
		public list<String> TimeSlot;
	}
	/**
	 * @description Inner class for reponse bean
	 */
	public class BookingAvailabilitySlots {
		@AuraEnabled
		public String ServiceTime;
		@AuraEnabled
		public String ServiceDate;
		@AuraEnabled
		public String SuburbName;
		@AuraEnabled
		public Integer AvailableSlots;
		@AuraEnabled
		public String TownCode;
		@AuraEnabled
		public String AdditionalSuburbNotes;
		@AuraEnabled
		public String DailyTripID;
	}
}