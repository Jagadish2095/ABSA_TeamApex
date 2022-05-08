/**
* @description IPCQChargeEnquiry IU class
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCQChargeEnquiry_IU_v1 {

    /**
    * @description map Request Fields for IPCQ ChargeEnquiry
    ** @author  Taras Kuliievych
    * @since 2021-07-14
    * @param accountNumber
    * @param firstDate
    * @param lastDate
    * @return IPCQChargeEnquiry_Req_IB_v1
    **/
    public static IPCQChargeEnquiry_Req_IB_v1 mapRequestFields(String accountNumber, String firstDate, String lastDate) {

        IPCQChargeEnquiry_Req_IB_v1 requestBean = new IPCQChargeEnquiry_Req_IB_v1();

        requestBean.IPCQChargeEnquiry = new IPCQChargeEnquiry_Req_IB_v1.IPCQChargeEnquiry();

        requestBean.IPCQChargeEnquiry.nbsapdpi = new IPCQChargeEnquiry_Req_IB_v1.Nbsapdpi();
        requestBean.IPCQChargeEnquiry.nbsmsgi = new IPCQChargeEnquiry_Req_IB_v1.nbsmsgi();
        requestBean.IPCQChargeEnquiry.ipcqchi = new IPCQChargeEnquiry_Req_IB_v1.ipcqchi();

        requestBean.IPCQChargeEnquiry.nbsapdpi.channel = 'BDP';
        requestBean.IPCQChargeEnquiry.nbsapdpi.application = 'CBP';
        requestBean.IPCQChargeEnquiry.nbsapdpi.trace = 'SD';

        requestBean.IPCQChargeEnquiry.nbsmsgi.msgLanguage = 'E';
        requestBean.IPCQChargeEnquiry.nbsmsgi.msgTarget = 'S';

        requestBean.IPCQChargeEnquiry.ipcqchi.trCode = '';
        requestBean.IPCQChargeEnquiry.ipcqchi.trFunc = '';
        requestBean.IPCQChargeEnquiry.ipcqchi.trSource = '';
        requestBean.IPCQChargeEnquiry.ipcqchi.accountNbr = accountNumber;
        requestBean.IPCQChargeEnquiry.ipcqchi.firstDate = firstDate;
        requestBean.IPCQChargeEnquiry.ipcqchi.lastDate = lastDate;
        requestBean.IPCQChargeEnquiry.ipcqchi.nbrOfTrsReq = '999';
        requestBean.IPCQChargeEnquiry.ipcqchi.indStartOrContinue = 'S';

        return requestBean;
    }
}