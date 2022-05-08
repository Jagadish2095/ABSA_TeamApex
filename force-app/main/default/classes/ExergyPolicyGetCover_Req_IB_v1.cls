/*
 * Request Integration Bean for ExergyPolicyGetCover Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class ExergyPolicyGetCover_Req_IB_v1 extends Base_IB {

	public class Policy_GetClientExposureExergy {
		public String pstrSessionGID;
		public String plngIdentifierType;
		public String pstrIdentifier;
		public String pstrValidationMessage;
	}

	public Service Service;

	public class RequestMessage {
		public Policy_GetClientExposureExergy Policy_GetClientExposureExergy;
	}
	
	public class RequestHeader {
		public String TransId;
		public String SourceName;
		public String ServiceName;
		public String Operation;
	}
	
	public class Service {
		public RequestHeader RequestHeader;
		public RequestMessage RequestMessage;
	}

    public static ExergyPolicyGetCover_Req_IB_v1 createDummyRequest() {
        ExergyPolicyGetCover_Req_IB_v1 requestBean = new ExergyPolicyGetCover_Req_IB_v1();
        requestBean.Service = new ExergyPolicyGetCover_Req_IB_v1.Service();
		requestBean.Service.RequestHeader = new ExergyPolicyGetCover_Req_IB_v1.RequestHeader();
		requestBean.Service.RequestMessage = new ExergyPolicyGetCover_Req_IB_v1.RequestMessage();
        requestBean.Service.RequestMessage.Policy_GetClientExposureExergy = new ExergyPolicyGetCover_Req_IB_v1.Policy_GetClientExposureExergy();
        requestBean.Service.RequestHeader.TransId = '?';
        requestBean.Service.RequestHeader.SourceName = 'Salesforce';
        requestBean.Service.RequestHeader.ServiceName = 'ExergyService';
		requestBean.Service.RequestHeader.Operation = 'Policy_GetClientExposureExergy';
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrSessionGID = '';
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.plngIdentifierType = '1';
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrIdentifier = '9601065200087';
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrValidationMessage = '?';

        return requestBean;
    }
}