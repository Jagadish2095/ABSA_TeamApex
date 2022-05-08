/**
* @description iu for IPCQChargeEnquirySummary
* @author  Taras Kuliievych
* @since 2021-07-15
**/
public with sharing class IPCQChargeEnquirySummary_IU_v1 {
    /**
    * @description map request fields for IPCQChargeEnquirySummary
    * @author  Taras Kuliievych
    * @since 2021-07-15
    * @param accountNumber
    * @param firstDate
    * @param lastDate
    * @return IPCQChargeEnquirySummary_Req_IB_v1
    **/
    public static IPCQChargeEnquirySummary_Req_IB_v1 mapRequestFields(String accountNumber, String firstDate, String lastDate) {

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

        requestBean.IPCQChargeEnquirySummary.ipcqchi.accountNbr = accountNumber;
        requestBean.IPCQChargeEnquirySummary.ipcqchi.firstDate = firstDate;
        requestBean.IPCQChargeEnquirySummary.ipcqchi.lastDate = lastDate;
        requestBean.IPCQChargeEnquirySummary.ipcqchi.language = 'E';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indReturnDescOfPricingScheme = 'Y';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indReturnDescOfChargeTypes = 'Y';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.nbrOfTrsReq = '999';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.indStartOrContinue = 'S';
        requestBean.IPCQChargeEnquirySummary.ipcqchi.lastSearchPosition = '0';

        return requestBean;
    }
}