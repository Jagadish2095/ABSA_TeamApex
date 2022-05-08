public class WQgetCASADetailsByRefNoV7_IU_v1 {
    /* Creates a request bean
* @return: WQgetCASADetailsByRefNoV7_Req_IB_v1 bean object
*/
    public static WQgetCASADetailsByRefNoV7_Req_IB_v1 mapRequestFields(String primaryCasaRefNum) {
        WQgetCASADetailsByRefNoV7_Req_IB_v1 requestBean = new WQgetCASADetailsByRefNoV7_Req_IB_v1();
        WQgetCASADetailsByRefNoV7_Req_IB_v1.WQgetCASADetailsByRefNoV7 WQgetCASADetailsByRefNoV7bean = new WQgetCASADetailsByRefNoV7_Req_IB_v1.WQgetCASADetailsByRefNoV7();
        WQgetCASADetailsByRefNoV7bean.refNo = primaryCasaRefNum;//'121116973';//;
        WQgetCASADetailsByRefNoV7bean.startFrom = '1111';
        requestBean.WQgetCASADetailsByRefNoV7 = WQgetCASADetailsByRefNoV7bean;
        return requestBean;
    }
    
}