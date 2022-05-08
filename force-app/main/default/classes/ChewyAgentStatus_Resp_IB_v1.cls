/*
 * Response Integration Bean for ChewyAgentStatus Service
 * @author Saurabh Pandey
 * @created 29/07/2020
 * @updated: 09/03/2021
 */

public class ChewyAgentStatus_Resp_IB_v1 extends Base_IB {
	public String userId;
	public String agentId;
	public String payload;
	public Boolean errors;
	public PayloadObj payloadObj;

	public class ActiveConnections {
		public List<Cifs> cifs;
		public Authentication authentication;
		public Boolean currentEvent;
		public String servicingCif;
		public String originator;
		public String progression;
		public SureCheck sureCheck;
		public Freespeech freespeech;
		public String transferReason;
		public String sessionId;
		public String methodLastUsed;
		public String sbuSegment;
		public String cellNumber;
		public String customerId;
		public String customerName;
		public String attachedData;
		public String connectionStatus;
		public String dnIs;
		public String ans;
		public String ucId;
		public String connectionId;
	}

	public class Cifs {
		public String cifType;
		public String cifKey;
	}

	public class Authentication {
		public List<String> authenticationType;
		public Boolean verified;
		public Boolean identified;
	}

	public class SureCheck {
		public String description;
		public String status;
	}

	public class PayloadObj {
		public List<ActiveConnections> activeConnections;
		public String disconnectConn;
		public String eventType;
		public String auxCode;
		public String agentStatus;
		public String agentId;
		public String id;
	}

	public class Freespeech {
		public String verifyResponseDTO;
		public String responseDTO;
		public String segmentId;
		public String progression;
		public String description;
	}

	public List<ErrorList> errorList;

	public class ErrorList {
	}
}