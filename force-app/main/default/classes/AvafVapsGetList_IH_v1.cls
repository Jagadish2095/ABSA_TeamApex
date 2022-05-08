/*
 * Integration Handler for SAPGetList Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 */
public class AvafVapsGetList_IH_v1 extends Base_IB {
    public static final String INTEGRATION_SERVICE_NAME = 'Avaf Vaps Get List';

    public static AvafVapsGetList_Resp_IB_v1 getVAPSList(String accountNumber) {
        AvafVapsGetList_Req_IB_v1 requestBean = AvafVapsGetList_IU_v1.mapRequestFields(accountNumber);
        // System.debug('avafvaps get requestBean: ' + requestBean);
        AvafVapsGetList_Resp_IB_v1 responseBean = (AvafVapsGetList_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafVapsGetList_Resp_IB_v1.class);

        // String body = '{"BAPI_SF_VAPS_LIST":[{"ACCOUNT":"00073556860","ZZPRDCODE":"G72","ZZPRDDESC":"FPP-PSIPLANBMONTHLY","ITM_TYPE_":"ZCLM","ZZUNIQUE_ID":"011","ZZINSCODE___":"ABSAL039","ZZINSCOMP_":"ABSALIFELIMITED","POLICY______":"00073556860","ZZPOLIDATE":"2019-03-11","ZZPOLEDATE_":"2025-05-01","ZZINSAMT_":"235872.5","ZZINSTRM__":"073","RESP_DATE_":"2020-11-05","RESP_DATE":"2020-11-05","RESP_TIME_":"1970-01-0109:35:26"},{"ACCOUNT":"00073556860","ZZPRDCODE":"PB5","ZZPRDDESC":"PSIPlanN-2Year","ITM_TYPE_":"ZVAP","ZZUNIQUE_ID":"010","ZZINSCODE___":"SAWAR307","ZZINSCOMP_":"SAWARRANTIES(PTY)LTD","POLICY______":"00073556860","ZZPOLIDATE":"2019-03-11","ZZPOLEDATE_":"2021-03-10","ZZINSAMT_":"0","ZZINSTRM__":"024","RESP_DATE_":"2020-11-05","RESP_DATE":"2020-11-05","RESP_TIME_":"1970-01-0109:35:26"}],"E_RESPONSE":"{0}","E_RESPONSE_DESC":"{}"}';
        // AvafVapsGetList_Resp_IB_v1 responseBean = new AvafVapsGetList_Resp_IB_v1();
        // responseBean = (AvafVapsGetList_Resp_IB_v1)responseBean.deserialize(body, AvafVapsGetList_Resp_IB_v1.class);
        // responseBean.statusCode = 200;
        return responseBean;
    }
}