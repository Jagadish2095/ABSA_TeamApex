/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-17
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-08-05   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class CIupdAuthV20API_Resp_IB_v1 extends Base_IB {
	
	//public CIupdAuthV20ResposeObj CIupdAuthV20Response ;

	/**
	 * @description  CIupdAuthV20ResponseData
	 *
	 */ public class CIupdAuthV20ResponseData {
		public string numberOfSignatoriesOld;
		public string clientCode;
		public integer numberOfSignDeleted;
		public string specialConditionsOld;
		public integer changeNumber;
	}
	/**
	 * @description  CIupdAuthV20Response
	 *
	 */
	public class CIupdAuthV20Response {
		public CIupdAuthV20ResponseData CIupdAuthV20ResponseData;
	}
	/**
	 * @description  OutputErrorHeaders
	 *
	 */
	public class outputErrorHeaders {
		public integer returnCode;
		public string outputServiceVersion;
		public integer reasonCode;
		public string version;
	}
	/**
	 * @description  OutputHeaders
	 *
	 */
	public class outputHeaders {
		public outputErrorHeaders outputErrorHeaders;
	}
	/**
	 * @description  MessageEntry
	 *
	 */
	public class messageEntry {
		public string messageText;
		public string messageErrorInd;
		public string messageClass;
		public string messageCode;
	}
	/**
	 * @description  OutputErrorMessage
	 *
	 */
	public class outputErrorMessage {
		public string systemErrorText;
		public List<messageEntry> messageEntry;
		public string version;
		public integer numberUserErrors;
		public integer numberUserMessages;
	}
	/**
	 * @description  OutputMessageHeader
	 *
	 */
	public class outputMessageHeader {
		public outputErrorMessage outputErrorMessage;
	}

	public CIupdAuthV20Response CIupdAuthV20Response;
	public outputHeaders outputHeaders;
	public outputMessageHeader outputMessageHeader;
}