/**
 * @description       : IPCBPTariffEnquiry_Resp_IB_v1
 * @author            : Taras Kuliievych
 * @last modified on  : 2021-10-18
 * @last modified by  : André Pietersen (IQ Business)
**/

public with sharing class IPCBPTariffEnquiry_Resp_IB_v1 extends Base_IB {

	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
    public class ChargeCode {

        /**
    	* @description
    	**/
		public String BaseFee {get; set;}

        /**
    	* @description
    	**/
		public String ChargeDescription {get; set;}

        /**
    	* @description
    	**/
		public String MaxCharge {get; set;}

        /**
    	* @description
    	**/
		public String MinCharge {get; set;}

        /**
    	* @description
    	**/
		public String MinTierMaxTier {get; set;}

        /**
    	* @description
    	**/
		public String Rate {get; set;}
	}

	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class IPCBPTariffEnquiryResponse {

        /**
    	* @description
    	**/
        public String sysErrTxt {get; set;}

        /**
    	* @description
    	**/
        public Integer returnCode {get; set;}

        /**
    	* @description
    	**/
		public List<GroupCode> GroupCode {get; set;}

        /**
    	* @description
    	**/
		public String accountId {get; set;}

        /**
    	* @description
    	**/
		public String accountName {get; set;}

        /**
    	* @description
    	**/
		public String accountType {get; set;}

        /**
    	* @description
    	**/
		public String cifKey {get; set;}

        /**
    	* @description
    	**/
		public String clientName {get; set;}

        /**
    	* @description
    	**/
		public String enquiryDate {get; set;}

        /**
    	* @description
    	**/
		public String groupLeaderkey {get; set;}

        /**
    	* @description
    	**/
		public String negScheme {get; set;}

        /**
    	* @description
    	**/
		public String nextCapDate {get; set;}

        /**
    	* @description
    	**/
		public String pricingScheme {get; set;}
	}

    /**
    * @description
    **/
	public IPCBPTariffEnquiryResponse IPCBPTariffEnquiryResponse {get; set;}

    /**
    * @description
    **/
	public Integer errorCode {get; set;}

    /**
    * @description
    **/
	public String message {get; set;}

	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class GroupCode {

        /**
    	* @description
    	**/
		public ChargeCode ChargeCodeObject {get; set;}

        /**
    	* @description
    	**/
        public List<ChargeCode> ChargeCodesList {get; set;}

        /**
    	* @description
    	**/
        public ChargeCode ChargeCode {get; set;}

        /**
    	* @description
    	**/
		public String GroupDescription {get; set;}
    }

    /**
    @description dummy res for IPCBPTariffEnquiry
    *@author  Taras Kuliievych
    *@since 2021-07-15
    *@return IPCBPTariffEnquiry_Resp_IB_v1
    */
	public static IPCBPTariffEnquiry_Resp_IB_v1 createDummyResponse() {
        IPCBPTariffEnquiry_Resp_IB_v1 responseBean = new IPCBPTariffEnquiry_Resp_IB_v1();

        responseBean.IPCBPTariffEnquiryResponse = new IPCBPTariffEnquiry_Resp_IB_v1.IPCBPTariffEnquiryResponse();
        responseBean.IPCBPTariffEnquiryResponse.sysErrTxt = '123';
        responseBean.IPCBPTariffEnquiryResponse.returnCode = 1;
        responseBean.errorCode = 1;
        responseBean.message = '123';

        IPCBPTariffEnquiry_Resp_IB_v1.GroupCode groupCode = new IPCBPTariffEnquiry_Resp_IB_v1.GroupCode();
        IPCBPTariffEnquiry_Resp_IB_v1.ChargeCode chargeCode = new IPCBPTariffEnquiry_Resp_IB_v1.ChargeCode();
        chargeCode.BaseFee = 'test';
        chargeCode.ChargeDescription = 'test';
        chargeCode.MaxCharge = 'test';
        chargeCode.MinCharge = 'test';
        chargeCode.MinTierMaxTier = 'test';
        chargeCode.Rate = 'test';
        groupCode.ChargeCodeObject = chargeCode;
        groupCode.ChargeCodesList = new List<IPCBPTariffEnquiry_Resp_IB_v1.ChargeCode>{chargeCode};
        groupCode.GroupDescription = 'testDesc';
        groupCode.ChargeCode = chargeCode;

        responseBean.IPCBPTariffEnquiryResponse.GroupCode = new List<IPCBPTariffEnquiry_Resp_IB_v1.GroupCode>{groupCode};
        responseBean.IPCBPTariffEnquiryResponse.accountId = 'test';
        responseBean.IPCBPTariffEnquiryResponse.accountName = 'TEST LIMITED';
        responseBean.IPCBPTariffEnquiryResponse.accountType = 'test';
        responseBean.IPCBPTariffEnquiryResponse.cifKey = 'test';
        responseBean.IPCBPTariffEnquiryResponse.groupLeaderkey = 'test';
        responseBean.IPCBPTariffEnquiryResponse.negScheme = 'test';
        responseBean.IPCBPTariffEnquiryResponse.clientName = 'test';
        responseBean.IPCBPTariffEnquiryResponse.enquiryDate = 'test';
        responseBean.IPCBPTariffEnquiryResponse.nextCapDate = 'test';
        responseBean.IPCBPTariffEnquiryResponse.pricingScheme = 'test';

        return responseBean;
    }
}