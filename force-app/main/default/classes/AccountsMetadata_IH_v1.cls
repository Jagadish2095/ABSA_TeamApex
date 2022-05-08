/**
 * @description       :
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-05-27
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Initial Version
**/
public class AccountsMetadata_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AccountsMetadataV1';

    /**
    * @description
    * @author André Pietersen (IQ Business) | 2021-05-27
    * @param requestBean
    * @return AccountsMetadata_Resp_IB_v1
    **/
    public static AccountsMetadata_Resp_IB_v1 submitAccountMetadata(AccountsMetadata_Req_IB_v1 requestBean) {
        AccountsMetadata_Resp_IB_v1 responseBean = (AccountsMetadata_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, AccountsMetadata_Resp_IB_v1.class);
        return responseBean;
    }
}