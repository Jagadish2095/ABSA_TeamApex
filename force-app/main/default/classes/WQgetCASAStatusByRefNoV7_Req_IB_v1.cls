/**
 * @description       : Integration Bean for WQgetCASAStatusByRefNoV7 Service
 * @author            : Prudence Shirindzi
 * @last modified on  : 2021-08-12
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class WQgetCASAStatusByRefNoV7_Req_IB_v1 extends Base_IB {
	/**
	 * @description       : WQgetCASAStatusByRefNoV7 Prop
	 **/
	public WQgetCASAStatusByRefNoV7 WQgetCASAStatusByRefNoV7 { get; set; }

	/**
	 * @description       : WQgetCASAStatusByRefNoV7
	 **/
	public class WQgetCASAStatusByRefNoV7 {
		public wqp102i wqp102i;
	}

	/**
	 * @description       : wqp102i
	 **/
	public class wqp102i {
		public String refNo;
	}

	/**
	 * @description       : CreateInstance
	 * @return WQgetCASAStatusByRefNoV7_Req_IB_v1
	 **/
	public static WQgetCASAStatusByRefNoV7_Req_IB_v1 CreateInstance() {
		WQgetCASAStatusByRefNoV7_Req_IB_v1 request = new WQgetCASAStatusByRefNoV7_Req_IB_v1();
		request.WQgetCASAStatusByRefNoV7 = new WQgetCASAStatusByRefNoV7();
		request.WQgetCASAStatusByRefNoV7.wqp102i = new wqp102i();
		return request;
	}
}