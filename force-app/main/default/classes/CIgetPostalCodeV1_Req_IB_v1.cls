/*
 * Request Integration Bean for CIgetPostalCodeV1 Service
 * @author Prudence Shirindzi updated by  Satya Boyenepalli
 * @created 2020-10-05 updated on  2020-10-23
 */
public class CIgetPostalCodeV1_Req_IB_v1 extends Base_IB   {
    
    public CIgetPostalCodeV1 CIgetPostalCodeV1;

    public class CIgetPostalCodeV1 {
		public Nbsapli nbsapli;
		public Nbsmsgi nbsmsgi;
		public Cib603di cib603di;
	}

	public class Nbsapli {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
        public String finalMsgClass;
        public String finalMsgCode;   
    }

    public class Cib603di {
        public String postalCode;
		public String area;
		public String maxRecsToRtrv;
        public String startAfterSrchPos;
        public String languageInd;  
	}

    public static CIgetPostalCodeV1_Req_IB_v1 CreateDummyRequest(){
        CIgetPostalCodeV1_Req_IB_v1 requestBean = new CIgetPostalCodeV1_Req_IB_v1();
        CIgetPostalCodeV1_Req_IB_v1.Nbsapli NbsapliBean = new CIgetPostalCodeV1_Req_IB_v1.Nbsapli();
        CIgetPostalCodeV1_Req_IB_v1.Nbsmsgi NbsmsgiBean = new CIgetPostalCodeV1_Req_IB_v1.Nbsmsgi();
        CIgetPostalCodeV1_Req_IB_v1.Cib603di Cib603diBean = new CIgetPostalCodeV1_Req_IB_v1.Cib603di();
        CIgetPostalCodeV1_Req_IB_v1.CIgetPostalCodeV1 CIgetPostalCodeBean = new CIgetPostalCodeV1_Req_IB_v1.CIgetPostalCodeV1();
		NbsapliBean.channel = 'BRANCH';
        NbsapliBean.application = 'BDP';
        NbsapliBean.trace = 'N';
		
        NbsmsgiBean.msgLanguage = 'E';
        NbsmsgiBean.msgTarget = 'STD';
		NbsmsgiBean.finalMsgClass='';
        NbsmsgiBean.finalMsgCode='';       
        Cib603diBean.postalCode='2194';
        Cib603diBean.area = 'RANDBURG';
        Cib603diBean.maxRecsToRtrv = '100';
		Cib603diBean.startAfterSrchPos='';
        Cib603diBean.languageInd='E';
        
        CIgetPostalCodeBean.nbsapli = NbsapliBean;
        CIgetPostalCodeBean.nbsmsgi = NbsmsgiBean;
        CIgetPostalCodeBean.cib603di = Cib603diBean;
       requestBean.CIgetPostalCodeV1 = CIgetPostalCodeBean;

        return requestBean;

    }
    
}