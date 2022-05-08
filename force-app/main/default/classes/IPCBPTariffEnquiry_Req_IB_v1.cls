/**
* @description req for IPCBPTariffEnquiry
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCBPTariffEnquiry_Req_IB_v1 extends Base_IB {
    public IPCBPTariffEnquiry IPCBPTariffEnquiry;

    /**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
	public class IPCBPTariffEnquiry {
		public String AccountId;
        public String Scheme;
		public String EnquiryType;
		public String Customer;
		public String Language;
	}

    /**
     * @description dummy req for IPCBPTariffEnquiry
     * @author  Taras Kuliievych
     * @since 2021-07-15
     * @return IPCBPTariffEnquiry_Req_IB_v1
    */
    public static IPCBPTariffEnquiry_Req_IB_v1 createDummyRequest() {
        IPCBPTariffEnquiry_Req_IB_v1 requestBean = new IPCBPTariffEnquiry_Req_IB_v1();

        requestBean.IPCBPTariffEnquiry = new IPCBPTariffEnquiry_Req_IB_v1.IPCBPTariffEnquiry();

        requestBean.IPCBPTariffEnquiry.AccountId = 'test';
        requestBean.IPCBPTariffEnquiry.EnquiryType = 'O';
        requestBean.IPCBPTariffEnquiry.Customer = 'N';
        requestBean.IPCBPTariffEnquiry.Language = 'E';

        return requestBean;
    }
}