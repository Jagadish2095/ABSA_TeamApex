/**
 * @description Request Integration Bean for SAPCancel Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */
public class AvafVapsCancel_Req_IB_v1 extends Base_IB {
	public List<BAPI_SF_VAPS> BAPI_SF_VAPS_CANCEL;
	public String I_USER;

	/**
	 * @description inner class
	 */
	public class BAPI_SF_VAPS {
		public String ACCOUNT;
		public String ZZPRDCODE;
		public String ZZPRDDESC;
		public String ITM_TYPE;
		public String ZZUNIQUE_ID;
		public String ZZINSCODE;
		public String ZZINSCOMP;
		public String POLICY;
		public String ZZPOLIDATE;
		public String ZZPOLEDATE;
		public String ZZINSAMT;
		public String ZZINSTRM;
		public String RESP_DATE;
		public String RESP_TIME;
		public String INS_AUTH_REQ; //W-011270
		public String AUTH_OVERRIDE; //W-011270
	}

	/**
	 * @description creates a dummy request bean for testing
	 * @return AvafVapsCancel_Req_IB_v1
	 */
	public static AvafVapsCancel_Req_IB_v1 createDummyRequest() {
		AvafVapsCancel_Req_IB_v1 requestBean = new AvafVapsCancel_Req_IB_v1();
		List<AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS> vapsList = new List<AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS>();

		AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS vaps = new AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS();
		vaps.ACCOUNT = '00073556860';
		vaps.ZZPRDCODE = 'G72';
		vaps.ZZPRDDESC = 'FPP - PSI PLAN B MONTHLY';
		vaps.ITM_TYPE = 'ZCLM';
		vaps.ZZUNIQUE_ID = '011';
		vaps.ZZINSCODE = 'ABSAL039';
		vaps.ZZINSCOMP = 'ABSA LIFE LIMITED';
		vaps.POLICY = '00073556860';
		vaps.ZZPOLIDATE = '2019-03-11';
		vaps.ZZPOLEDATE = '2025-05-01';
		vaps.ZZINSAMT = '235872.5';
		vaps.ZZINSTRM = '073';
		vaps.RESP_DATE = '2020-10-24';
		vaps.RESP_TIME = '1970-01-01 12:03:25';
		vapsList.add(vaps);

		requestBean.BAPI_SF_VAPS_CANCEL = vapsList;
		requestBean.I_USER = 'ab0131R';

		return requestBean;
	}
}