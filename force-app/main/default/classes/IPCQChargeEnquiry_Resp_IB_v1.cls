/**
* @description IPCQChargeEnquiry response class
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCQChargeEnquiry_Resp_IB_v1 extends Base_IB {
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

	public IPCQChargeEnquiryResponse IPCQChargeEnquiryResponse;

	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class ChargesList {
		/**
		 * @description
		 */
		public Double chargeAmount {get; set;}
		public String chargeType;
		/**
		 * @description
		 */
		public String chargeTypeDesc {get; set;}
	}

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
	public class Ipcqcho {
		public String indEndOfRetrieval;
		public String languageUsed;
		public Integer lastSearchPosition;
		public Integer nbrOfTrsRetrieved;
		public String pricingSchemeCode;
		public String pricingSchemeDesc;
		public String accountName;
		public List<TrList> trList;
	}

	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class IPCQChargeEnquiryResponse {
		public Ipcqcho ipcqcho;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
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
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class TrList {
		/**
		 * @description
		 */
		public ChargesList chargesList {get; set;}
		public Integer effectiveDate;
		public Integer eventNbr;
		public String indChargesCapOrAccrued;
		public Integer nbrOfCharges;

		/**
    	* @description
    	**/
		public Integer processDate {get; set;}

		/**
    	* @description
    	**/
		public Double trAmount {get; set;}

		/**
    	* @description
    	**/
		public String trDesc {get; set;}

		/**
    	* @description
    	**/
		public String trType {get; set;}

		/**
    	* @description
    	**/
		public Double vatAmountInCharges {get; set;}
		public Double acctBalPostTr;
	}

	/**
    @description dummy res for IPCQChargeEnquiry
    *@author  Taras Kuliievych
    *@since 2021-07-15
    *@return IPCQChargeEnquiry_Resp_IB_v1
    */
	public static IPCQChargeEnquiry_Resp_IB_v1 createDummyResponse() {
        IPCQChargeEnquiry_Resp_IB_v1 responseBean = new IPCQChargeEnquiry_Resp_IB_v1();

        responseBean.IPCQChargeEnquiryResponse = new IPCQChargeEnquiry_Resp_IB_v1.IPCQChargeEnquiryResponse();
        responseBean.IPCQChargeEnquiryResponse.ipcqcho = new IPCQChargeEnquiry_Resp_IB_v1.Ipcqcho();
		responseBean.IPCQChargeEnquiryResponse.nbsapdpo = new IPCQChargeEnquiry_Resp_IB_v1.nbsapdpo();
		responseBean.IPCQChargeEnquiryResponse.nbsmsgo = new IPCQChargeEnquiry_Resp_IB_v1.nbsmsgo();

		IPCQChargeEnquiry_Resp_IB_v1.ChargesList chargesList = new IPCQChargeEnquiry_Resp_IB_v1.ChargesList();
		chargesList.chargeAmount = 24;
		chargesList.chargeType = 'qe';
		chargesList.chargeTypeDesc = 'qw';

		IPCQChargeEnquiry_Resp_IB_v1.TrList trList = new IPCQChargeEnquiry_Resp_IB_v1.TrList();
		trList.chargesList = chargesList;
		trList.effectiveDate = 20201010;
		trList.eventNbr = 0;
		trList.indChargesCapOrAccrued = 'C';
		trList.nbrOfCharges = 1;
		trList.processDate = 20201010;
		trList.trAmount = 23;
		trList.trDesc = '11';
		trList.trType = '20201010';
		trList.vatAmountInCharges = 2;

		IPCQChargeEnquiry_Resp_IB_v1.MsgEntry msgEntry = new  IPCQChargeEnquiry_Resp_IB_v1.MsgEntry();
        msgEntry.msgClass = 'test';
        msgEntry.msgCode = 'test';
        msgEntry.msgErrInd ='test';
        msgEntry.msgTxt = 'test';

		responseBean.IPCQChargeEnquiryResponse.ipcqcho.indEndOfRetrieval = 'E';
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.languageUsed = 'E';
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.lastSearchPosition = 1;
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.nbrOfTrsRetrieved = 1;
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.pricingSchemeCode = 'E22';
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.pricingSchemeDesc = 'E';
		responseBean.IPCQChargeEnquiryResponse.ipcqcho.trList = new List<IPCQChargeEnquiry_Resp_IB_v1.TrList>{trList};

		responseBean.IPCQChargeEnquiryResponse.nbsapdpo.echoKey = 'test';
		responseBean.IPCQChargeEnquiryResponse.nbsapdpo.reasonCode = 1;
		responseBean.IPCQChargeEnquiryResponse.nbsapdpo.returnCode = 2;
		responseBean.IPCQChargeEnquiryResponse.nbsapdpo.serviceVersion = 'test';
		responseBean.IPCQChargeEnquiryResponse.nbsapdpo.version = 'test';

		responseBean.IPCQChargeEnquiryResponse.nbsmsgo.msgEntry = msgEntry;
		responseBean.IPCQChargeEnquiryResponse.nbsmsgo.nbrUserErrs = 0;
		responseBean.IPCQChargeEnquiryResponse.nbsmsgo.nbrUserMsgs = 0;
		responseBean.IPCQChargeEnquiryResponse.nbsmsgo.sysErrTxt = '2';
		responseBean.IPCQChargeEnquiryResponse.nbsmsgo.version = '2';

        return responseBean;
    }
}