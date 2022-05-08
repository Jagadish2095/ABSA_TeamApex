/*
 * Integration Utility class for ExergyPolicyGetCover Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class ExergyPolicyGetCover_IU_v1 {

    /* Creates a request bean
     * @return: ExergyPolicyGetCover_Req_IB_v1 bean object
     */
    public static ExergyPolicyGetCover_Req_IB_v1 mapRequestFields(String IdType, String IdNumber) {
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
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.plngIdentifierType = IdType;
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrIdentifier = IdNumber;
		requestBean.Service.RequestMessage.Policy_GetClientExposureExergy.pstrValidationMessage = '?';

        return requestBean;
    }
}