/**
* @description resp class for IPCQChargeEnquirySummary
* @author  Taras Kuliievych
* @since 2021-07-15
**/
public with sharing class IPCQChargeEnquirySummary_Resp_IB_v1 extends Base_IB {
    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
    public class IPCQChargeEnquirySummaryResponse {
		public Ipcqcho ipcqcho;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class Nbsapdpo {
		public String echoKey;
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
		public String version;
	}

	public IPCQChargeEnquirySummaryResponse IPCQChargeEnquirySummaryResponse;

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class Nbsmsgo {
		public MsgEntry msgEntry;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class SummaryList {
		public Double chargeAmount;
		public String chargeType;
		public String chargeTypeDesc;
		public Double vatAmount;
		public Double vatableAmount;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class Ipcqcho {
		public String languageUsed;
		public String pricingSchemeCode;
		public String pricingSchemeDesc;
		public List<SummaryList> summaryList;
		public Double totalChargesAmounts;
		public Double totalVatAmounts;
		public Double totalVatableAmounts;
	}

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

    /**
    *@description dummy res for IPCQChargeEnquirySummary
    *@author  Taras Kuliievych
    *@since 2021-07-15
    *@return IPCQChargeEnquirySummary_Resp_IB_v1
    */
	public static IPCQChargeEnquirySummary_Resp_IB_v1 createDummyResponse() {
        IPCQChargeEnquirySummary_Resp_IB_v1 responseBean = new IPCQChargeEnquirySummary_Resp_IB_v1();

        responseBean.IPCQChargeEnquirySummaryResponse = new IPCQChargeEnquirySummary_Resp_IB_v1.IPCQChargeEnquirySummaryResponse();

        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho = new IPCQChargeEnquirySummary_Resp_IB_v1.Ipcqcho();
        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo = new IPCQChargeEnquirySummary_Resp_IB_v1.Nbsapdpo();
        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo = new IPCQChargeEnquirySummary_Resp_IB_v1.Nbsmsgo();

        IPCQChargeEnquirySummary_Resp_IB_v1.MsgEntry msgEntry = new  IPCQChargeEnquirySummary_Resp_IB_v1.MsgEntry();
        msgEntry.msgClass = 'test';
        msgEntry.msgCode = 'test';
        msgEntry.msgErrInd ='test';
        msgEntry.msgTxt = 'test';

        IPCQChargeEnquirySummary_Resp_IB_v1.SummaryList summaryList = new IPCQChargeEnquirySummary_Resp_IB_v1.SummaryList();
        summaryList.chargeAmount = 1;
        summaryList.chargeType = 'test';
        summaryList.chargeTypeDesc = 'test';
        summaryList.chargeAmount = 1;
        summaryList.vatableAmount = 1;

        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.languageUsed = 'test';
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.pricingSchemeCode = 'test';
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.pricingSchemeDesc ='test';
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.summaryList = new List<IPCQChargeEnquirySummary_Resp_IB_v1.SummaryList>{summaryList};
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.totalChargesAmounts = 13;
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.totalVatAmounts = 13;
        responseBean.IPCQChargeEnquirySummaryResponse.ipcqcho.totalVatableAmounts = 22;

        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo.echoKey = 'test';
        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo.reasonCode = 1;
        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo.returnCode = 1;
        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo.serviceVersion = '132';
        responseBean.IPCQChargeEnquirySummaryResponse.nbsapdpo.returnCode = 132;

        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo.msgEntry = msgEntry;
        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo.nbrUserErrs = 0;
        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo.nbrUserMsgs = 0;
        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo.sysErrTxt = '13';
        responseBean.IPCQChargeEnquirySummaryResponse.nbsmsgo.version = '3';

        return responseBean;
    }
}