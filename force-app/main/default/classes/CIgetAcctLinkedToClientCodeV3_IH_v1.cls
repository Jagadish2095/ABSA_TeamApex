/*
* Integration from CIgetAcctLinkedToClientCodeV3 Service
* @author Khaliq Abdul
* @created 2021-02-27
*/
public class CIgetAcctLinkedToClientCodeV3_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'CIgetAcctLinkedToClientCodeV3';
    
    public static CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 CIgetAcctLinkedToClientCode(CIgetAcctLinkedToClientCodeV3_Req_IB_v1 requestBean) {
        system.debug('igor 1 CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode');
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.class);
        system.debug('igor 2 CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode ' + JSON.serialize(responseBean));
        return responseBean;
    }
}