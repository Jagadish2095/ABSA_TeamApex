public class CQgetValueBundleOptionsV3_IU_v1 {
    
    //Techmagic - Igor
    public static CQgetValueBundleOptionsV3_Req_IB_v1 mapRequestFields(String clientKey) {

        User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());

        CQgetValueBundleOptionsV3_Req_IB_v1 requestBean = new CQgetValueBundleOptionsV3_Req_IB_v1();

        CQgetValueBundleOptionsV3_Req_IB_v1.NBSAPDPI NBSAPDPI_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.NBSAPDPI();
        CQgetValueBundleOptionsV3_Req_IB_v1.NBSAPLI NBSAPLI_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.NBSAPLI();
        NBSAPDPI_Bean.NBSAPLI = NBSAPLI_Bean;

        NBSAPLI_Bean.channelName = 'BDP';
        NBSAPLI_Bean.applicationName = 'BDP';
        NBSAPLI_Bean.traceIndicator = 'N';

        CQgetValueBundleOptionsV3_Req_IB_v1.NBSMSGI NBSMSGI_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.NBSMSGI();
        CQgetValueBundleOptionsV3_Req_IB_v1.NBSMSGI_internal NBSMSGI_internal_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.NBSMSGI_internal();
        
        NBSMSGI_Bean.NBSMSGI = NBSMSGI_internal_Bean;

        NBSMSGI_internal_Bean.NBNMSGI_MSG_LANGUAGE = 'E';
        NBSMSGI_internal_Bean.NBNMSGI_MSG_TARGET = 'STD';

        CQgetValueBundleOptionsV3_Req_IB_v1.CQS044I CQS044I_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.CQS044I();
        CQgetValueBundleOptionsV3_Req_IB_v1.CQS044I_INPUT_AREA CQS044I_INPUT_AREA_Bean = new CQgetValueBundleOptionsV3_Req_IB_v1.CQS044I_INPUT_AREA();
        CQS044I_Bean.CQS044I_INPUT_AREA = CQS044I_INPUT_AREA_Bean;

        CQS044I_INPUT_AREA_Bean.productType = '11032';
        CQS044I_INPUT_AREA_Bean.processingSiteCode = loggedInUserInfo.SiteCode__c;//'8198'
        CQS044I_INPUT_AREA_Bean.processingSiteType = '034';
        CQS044I_INPUT_AREA_Bean.tellerNumber = '2641';
        CQS044I_INPUT_AREA_Bean.agencySiteCode = '0';
        CQS044I_INPUT_AREA_Bean.agencySiteType = '034';
        CQS044I_INPUT_AREA_Bean.controllerNumber = '0';
        CQS044I_INPUT_AREA_Bean.corpCode = 'ABS';
        CQS044I_INPUT_AREA_Bean.clientKey = clientKey;//OPHFEAS001
        CQS044I_INPUT_AREA_Bean.packageIndicator = 'N';

        requestBean.NBSAPDPI = NBSAPDPI_Bean;
        requestBean.NBSMSGI = NBSMSGI_Bean;
        requestBean.CQS044I = CQS044I_Bean;

        return requestBean;
    }

    public static void mapResponseFields() {

    }
}