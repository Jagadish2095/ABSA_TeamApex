/** 
 * @description Response Integration Bean for Retrieve Tags Service
 * @author manideep kenche
 * @created 2021-08-18
 */
public class RetreiveTag_Resp_IB_v1 extends Base_IB{
	public String status;	//success
	public list<data> Data;
	/**
	 * @description Data
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class Data {
		public consumerAccountIdentifier consumerAccountIdentifier;
		public long assignedDate;	
		public orderNumber orderNumber;
		public tag tag;
	}
	/**
	 * @description consumerAccountIdentifier
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class consumerAccountIdentifier {
		public Integer consumerAccountAgencyIdentifier;	
		public String creditorReferenceNumber;	
		public String creditorAccountLegacyIdentifier;	
		public String creditorExternalAccountId;	
		public String businessKey;	//170305299
	}
	/**
	 * @description orderNumber
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class orderNumber {
	}
	/**
	 * @description tag
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class tag {
		public Integer priority;	
		public tagType tagType;
		public uiStyle uiStyle;
		public String name;	
		public String shortName;	
		public String description;	
		public boolean active;
		public Integer version;	
		public String businessKey;	
	}
	/**
	 * @description tagType
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class tagType {
		public String name;	
		public String shortName;	
		public String description;	
		public boolean active;
		public String businessKey;	
	}
	/**
	 * @description uiStyle
	 * @author manideep kenche
	 * @created 2021-08-18
	 */
	public class uiStyle {
	}
	
}