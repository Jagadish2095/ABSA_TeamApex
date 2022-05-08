/**
 * @description       : RiskProfileNonIndividualClientV7_IH_v1
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-17
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class RiskProfileNonIndividualClientV7_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CASARiskProfileClientV7_IH_v1';
    /**
	 * @description       : CASARiskProfileClientV7
	 * @param requestBean
	 * @return CASARiskProfileClientV7_Resp_IB_v1
	 **/
    public static CASARiskProfileClientV7_Resp_IB_v1 RiskProfileNonIndividualClientV7(WQRiskProfileClientV7_Req_IB_v1 requestBean) {
      
        CASARiskProfileClientV7_Resp_IB_v1 responseBean = (CASARiskProfileClientV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CASARiskProfileClientV7_Resp_IB_v1.class);
      return responseBean;
  }
}