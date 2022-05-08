public class CQgetChargesDetailsMaintV9_IU_v1 {
    //Techmagic - Igor

    public static CQgetChargesDetailsMaintV9_Req_IB_v1 mapRequestFields(String accountNumber){

        CQgetChargesDetailsMaintV9_Req_IB_v1 requestBean = new CQgetChargesDetailsMaintV9_Req_IB_v1();

        CQgetChargesDetailsMaintV9_Req_IB_v1.NBSAPDPI NBSAPDPI_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.NBSAPDPI();
        CQgetChargesDetailsMaintV9_Req_IB_v1.NBSAPLI NBSAPLI_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.NBSAPLI();
        NBSAPDPI_bean.NBSAPLI = NBSAPLI_bean;

        NBSAPLI_bean.channelName = 'Cheques';
        NBSAPLI_bean.applicationName = 'API';
        NBSAPLI_bean.traceIndicator = 'Y';

        CQgetChargesDetailsMaintV9_Req_IB_v1.NBSMSGI NBSMSGI_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.NBSMSGI();
        CQgetChargesDetailsMaintV9_Req_IB_v1.NBSMSGI_internal NBSMSGI_internal_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.NBSMSGI_internal();
        NBSMSGI_bean.NBSMSGI = NBSMSGI_internal_bean;

        NBSMSGI_internal_bean.NBNMSGI_MSG_LANGUAGE = 'E';
        NBSMSGI_internal_bean.NBNMSGI_MSG_TARGET = 'STD';

        CQgetChargesDetailsMaintV9_Req_IB_v1.CQS445I CQS445I_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.CQS445I();
        CQgetChargesDetailsMaintV9_Req_IB_v1.CQS445I_INPUT_AREA CQS445I_INPUT_AREA_bean = new CQgetChargesDetailsMaintV9_Req_IB_v1.CQS445I_INPUT_AREA();
        CQS445I_bean.CQS445I_INPUT_AREA = CQS445I_INPUT_AREA_bean;

        CQS445I_INPUT_AREA_bean.CQS445I_ACCOUNT_NBR = accountNumber;
        CQS445I_INPUT_AREA_bean.CQS445I_PROCESSING_SITE = '8198';
        CQS445I_INPUT_AREA_bean.CQS445I_PROCESSING_SITE_TYPE = '034';
        CQS445I_INPUT_AREA_bean.CQS445I_TELLER_NBR = '2334';
        CQS445I_INPUT_AREA_bean.CQS445I_AGENCY_CODE = '0';
        CQS445I_INPUT_AREA_bean.CQS445I_AGENCY_TYPE = '';
        CQS445I_INPUT_AREA_bean.CQS445I_CONTROLLER_NBR = '2334';
        CQS445I_INPUT_AREA_bean.CQS445I_CORP_CODE = 'ABS';
        CQS445I_INPUT_AREA_bean.CQS445I_NEW_CHARGE_CAT = '';

        requestBean.NBSAPDPI = NBSAPDPI_bean;
        requestBean.NBSMSGI = NBSMSGI_bean;
        requestBean.CQS445I = CQS445I_bean;

        /*CQgetChargesDetailsMaintV9_Req_IB_v1.nbsapdpi nbsapdpiBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.nbsapdpi();
        CQgetChargesDetailsMaintV9_Req_IB_v1.nbsmsgi nbsmsgiBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.nbsmsgi();
        CQgetChargesDetailsMaintV9_Req_IB_v1.cqh445i cqh445iBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.cqh445i();
        CQgetChargesDetailsMaintV9_Req_IB_v1.finalMsgId finalMsgIdBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.finalMsgId();

        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'N';

        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'BDP';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';

        cqh445iBean.accountNbr = accountNumber;//'4049681885'; //Techmagic - Mrs A L Fourie
        cqh445iBean.processingSite = '8198';
        cqh445iBean.processingSiteType = '034';
        cqh445iBean.tellerNbr = '878';
        cqh445iBean.agencyCode = '0';
        cqh445iBean.agencyType = '';
        cqh445iBean.controllerNbr = '878';
        cqh445iBean.corpCode = 'ABS';
        cqh445iBean.newChargeCat = '';

        CQgetChargesDetailsMaintV9_Req_IB_v1.CQgetChargesDetailsMaintV9 CQgetChargesDetailsMaintV9bean  = new CQgetChargesDetailsMaintV9_Req_IB_v1.CQgetChargesDetailsMaintV9();
        CQgetChargesDetailsMaintV9bean.nbsapdpi = nbsapdpiBean;
        CQgetChargesDetailsMaintV9bean.nbsmsgi = nbsmsgiBean;
        CQgetChargesDetailsMaintV9bean.cqh445i = cqh445iBean;
        
        requestBean.CQgetChargesDetailsMaintV9 = CQgetChargesDetailsMaintV9bean;*/

        return requestBean;
    }

    /**
     * Creates a bean from the reponse
     * @param HttpResponse
     * @return CQgetChargesDetailsMaintV9_Resp_IB_v1 bean object
     */
    
    public static CQgetChargesDetailsMaintV9_Resp_IB_v1 mapResponseFields(HttpResponse response) {
        CQgetChargesDetailsMaintV9_Resp_IB_v1 responseBean = (CQgetChargesDetailsMaintV9_Resp_IB_v1) JSON.deserialize(response.getBody(), CQgetChargesDetailsMaintV9_Resp_IB_v1.class);
        //responseBean.status = response.getStatus();
        //responseBean.statusCode = response.getStatusCode();
        
        return responseBean;
    }

    /**
     * Creates a custom bean with the parameters mapped to their respective fields (for creating failed response beans)
     * @param statusCode
     * @param status
     * @param message
     * @return CQgetChargesDetailsMaintV9_Resp_IB_v1 bean object
     */

    public static CQgetChargesDetailsMaintV9_Resp_IB_v1 mapFailedResponseFields(String status, Integer statusCode, String message){
        CQgetChargesDetailsMaintV9_Resp_IB_v1 responseBean = new CQgetChargesDetailsMaintV9_Resp_IB_v1();
        responseBean.status = status;
        responseBean.statusCode = statusCode;
        responseBean.message = message;
        
        return responseBean;
    }
}