/**
 * @description       : Client detail by Id
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-31
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class GetClientDetailsByIdCIF_IH_v2 {
    public static final String INTEGRATION_SERVICE_NAME = 'cigetclientdetailsbyidnov2';

    /**
     * @description GetCIFCodebyId
     * @author PaulJohn.duRand@absa.africa | 2021-08-31
     * @param clientIdDetails
     * @return GetClientDetailsByIdCIF_Resp_IB_v2
     **/
    public static GetClientDetailsByIdCIF_Resp_IB_v2 GetCIFCodebyId(GetClientDetailsByIdCIF_Req_IB_v2.Cip008i clientIdDetails) {
        return GetCIFCodebyId(clientIdDetails, 'BRANCH');
    }

    /**
     * @description GetCIFCodebyId
     * @author PaulJohn.duRand@absa.africa | 2021-08-31
     * @param clientIdDetails
     * @param channel
     * @return GetClientDetailsByIdCIF_Resp_IB_v2
     **/
    public static GetClientDetailsByIdCIF_Resp_IB_v2 GetCIFCodebyId(GetClientDetailsByIdCIF_Req_IB_v2.Cip008i clientIdDetails, String channel) {
        return GetCIFCodebyId(clientIdDetails, channel, 'SFRET');
    }

    /**
     * @description GetCIFCodebyId
     * @author PaulJohn.duRand@absa.africa | 2021-08-31
     * @param clientIdDetails
     * @param channel
     * @param application
     * @return GetClientDetailsByIdCIF_Resp_IB_v2
     **/
    public static GetClientDetailsByIdCIF_Resp_IB_v2 GetCIFCodebyId(
        GetClientDetailsByIdCIF_Req_IB_v2.Cip008i clientIdDetails,
        String channel,
        String application
    ) {
        GetClientDetailsByIdCIF_Req_IB_v2 requestBean = new GetClientDetailsByIdCIF_Req_IB_v2();
        requestBean.CIgetClientDetailsByIDNOV2 = requestBean.getNewInstance();
        requestBean.CIgetClientDetailsByIDNOV2.cip008i = clientIdDetails;
        requestBean.CIgetClientDetailsByIDNOV2.nbsapdpi.channel = channel;
        requestBean.CIgetClientDetailsByIDNOV2.nbsapdpi.application = application;
        requestBean.CIgetClientDetailsByIDNOV2.cip008i.maxRecsToRtrv = '10';
        requestBean.CIgetClientDetailsByIDNOV2.cip008i.startAfterSearchPos = '';
        GetClientDetailsByIdCIF_Resp_IB_v2 responseBean = (GetClientDetailsByIdCIF_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            null,
            INTEGRATION_SERVICE_NAME,
            GetClientDetailsByIdCIF_Resp_IB_v2.class
        );
        return responseBean;
    }
}