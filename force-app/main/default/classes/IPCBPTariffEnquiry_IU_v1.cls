/**
* @description IU class for IPCBPTariffEnquiry
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCBPTariffEnquiry_IU_v1 {
    /**
    * @description  map Request Fields for PCBPTariffEnquiry
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @param accountNumber
    * @param scheme
    * @return IPCBPTariffEnquiry_Req_IB_v1
    **/
    public static IPCBPTariffEnquiry_Req_IB_v1 mapRequestFields(String accountNumber, String scheme) {
        IPCBPTariffEnquiry_Req_IB_v1 requestBean = new IPCBPTariffEnquiry_Req_IB_v1();

        requestBean.IPCBPTariffEnquiry = new IPCBPTariffEnquiry_Req_IB_v1.IPCBPTariffEnquiry();

        requestBean.IPCBPTariffEnquiry.AccountId = accountNumber;
        requestBean.IPCBPTariffEnquiry.Scheme = scheme;
        requestBean.IPCBPTariffEnquiry.EnquiryType = 'O';
        requestBean.IPCBPTariffEnquiry.Customer = 'N';
        requestBean.IPCBPTariffEnquiry.Language = 'E';

        return requestBean;
    }
}