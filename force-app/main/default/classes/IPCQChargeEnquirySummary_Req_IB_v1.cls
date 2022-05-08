/**
* @description req for IPCQChargeEnquirySummary
* @author  Taras Kuliievych
* @since 2021-07-15
**/
public with sharing class IPCQChargeEnquirySummary_Req_IB_v1 extends Base_IB {
    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
    public class Ipcqchi {
		public String accountNbr;
		public String firstDate;
		public String lastDate;
		public String language;
		public String indReturnDescOfPricingScheme;
		public String indReturnDescOfChargeTypes;
		public String nbrOfTrsReq;
		public String indStartOrContinue;
		public String lastSearchPosition;
	}

	public IPCQChargeEnquirySummary IPCQChargeEnquirySummary;

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class IPCQChargeEnquirySummary {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ipcqchi ipcqchi;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public String finalMsgClass;
		public String finalMsgCode;
	}

    /**
    * @description dummy req for IPCQChargeEnquirySummary
    * @author  Taras Kuliievych
    * @since 2021-07-15
    * @return IPCQChargeEnquirySummary_Req_IB_v1
    */
    public static IPCQChargeEnquirySummary_Req_IB_v1 createDummyRequest() {

        IPCQChargeEnquirySummary_Req_IB_v1 requestBean = new IPCQChargeEnquirySummary_Req_IB_v1();

        requestBean.IPCQChargeEnquirySummary = new IPCQChargeEnquirySummary_Req_IB_v1.IPCQChargeEnquirySummary();

        requestBean.IPCQChargeEnquirySummary.ipcqchi = new IPCQChargeEnquirySummary_Req_IB_v1.Ipcqchi();
        requestBean.IPCQChargeEnquirySummary.nbsapdpi = new IPCQChargeEnquirySummary_Req_IB_v1.Nbsapdpi();
        requestBean.IPCQChargeEnquirySummary.nbsmsgi = new IPCQChargeEnquirySummary_Req_IB_v1.Nbsmsgi();

        requestBean.IPCQChargeEnquirySummary.nbsapdpi.channel = 'BDP';
        requestBean.IPCQChargeEnquirySummary.nbsapdpi.application = 'CBP';
        requestBean.IPCQChargeEnquirySummary.nbsapdpi.trace = 'SD';

        requestBean.IPCQChargeEnquirySummary.nbsmsgi.msgLanguage = 'E';
        requestBean.IPCQChargeEnquirySummary.nbsmsgi.msgTarget = 'S';
        requestBean.IPCQChargeEnquirySummary.nbsmsgi.finalMsgClass = '';
        requestBean.IPCQChargeEnquirySummary.nbsmsgi.finalMsgCode = '';

        requestBean.IPCQChargeEnquirySummary.ipcqchi.accountNbr = 'test';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.firstDate = 'test';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.lastDate = 'test';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.language = 'E';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indReturnDescOfPricingScheme = 'Y';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indReturnDescOfChargeTypes = 'Y';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.nbrOfTrsReq = '999';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indStartOrContinue = 'S';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.lastSearchPosition = '0';

        return requestBean;
    }

}