/**
 * @description
 * @author Taras Kuliievych
 * @since 2021-06-09
**/
public class Enquiry_CBPTariffOptionsController {

    /**
    * @description
    * @author Igor Vasylevskyi
    * @param clientKey
    * @return List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE>
    **/
    @AuraEnabled
    public static List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> cqGetValueBundleOptions(String clientKey) {

        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = CQgetValueBundleOptionsV3_IH_v1.callToCQgetValueBundleOptionsV3(clientKey);
        List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> schemeCodes = responseBean.CQS044O.CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE;

        if (schemeCodes == null) {
            String message = 'Unhandled error in cqGetValueBandleOptions';
            if (responseBean.NBSMSGO3.NBSMSGO3 != null) {
                message = responseBean.NBSMSGO3.NBSMSGO3.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT;
            }
            AuraHandledException e = new AuraHandledException(message);
            e.setMessage(message);

            throw e;
        }

        return schemeCodes;
    }
}