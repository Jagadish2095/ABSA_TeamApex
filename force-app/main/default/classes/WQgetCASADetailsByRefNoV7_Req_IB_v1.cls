/**
* Apex Integration Request Bean class for WQgetCASADetailsByRefNoV7 service
* @author  Anka Ganta : Absa
* @since   2020-07-20
*
**/
public class WQgetCASADetailsByRefNoV7_Req_IB_v1 extends Base_IB{
    public WQgetCASADetailsByRefNoV7 WQgetCASADetailsByRefNoV7;

	public class WQgetCASADetailsByRefNoV7 {
		public String refNo;
		public String startFrom;
	}
    
    public static WQgetCASADetailsByRefNoV7_Req_IB_v1 createDummyRequest(){
        WQgetCASADetailsByRefNoV7_Req_IB_v1 requestBean = new WQgetCASADetailsByRefNoV7_Req_IB_v1();
        WQgetCASADetailsByRefNoV7_Req_IB_v1.WQgetCASADetailsByRefNoV7 WQgetCASADetailsByRefNoV7Bean = new WQgetCASADetailsByRefNoV7_Req_IB_v1.WQgetCASADetailsByRefNoV7();
        WQgetCASADetailsByRefNoV7Bean.refNo = '121116973';
        WQgetCASADetailsByRefNoV7Bean.startFrom = '1111';
        requestBean.WQgetCASADetailsByRefNoV7 = WQgetCASADetailsByRefNoV7Bean;
        return requestBean;
    }
}