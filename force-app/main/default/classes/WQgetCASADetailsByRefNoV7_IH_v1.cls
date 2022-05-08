public class WQgetCASADetailsByRefNoV7_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'WQgetCASADetailsByRefNoV7';
    
    public static WQgetCASADetailsByRefNoV7_Resp_IB_v1 getRelatedPartyListByPrimaryRefNo(String casaRefNum) {
        WQgetCASADetailsByRefNoV7_Req_IB_v1 requestBean = WQgetCASADetailsByRefNoV7_IU_v1.mapRequestFields(casaRefNum);
        WQgetCASADetailsByRefNoV7_Resp_IB_v1 responseBean = (WQgetCASADetailsByRefNoV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, WQgetCASADetailsByRefNoV7_Resp_IB_v1.class);
        return responseBean;
    }
}