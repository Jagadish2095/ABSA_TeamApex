/**
* @description IPCQChargeEnquiry request class
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCQChargeEnquiry_Req_IB_v1 extends Base_IB {
	/**
     * @description
     * @author  Taras Kuliievych
     * @since 2021-07-15
    **/
    public class Ipcqchi {
		public String trCode;
		public String trFunc;
		public String trSource;
		public String accountNbr;
		public String firstDate;
		public String lastDate;
		public String nbrOfTrsReq;
		public String indStartOrContinue;
	}

	public IPCQChargeEnquiry IPCQChargeEnquiry;

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
	public class IPCQChargeEnquiry {
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
	}
	/**
    * @description dummy req for IPCQChargeEnquiry
    * @author  Taras Kuliievych
    * @since 2021-07-15
	* @return IPCQChargeEnquiry_Req_IB_v1
    */
	public static IPCQChargeEnquiry_Req_IB_v1 createDummyRequest() {

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
        requestBean.IPCQChargeEnquiry.ipcqchi.accountNbr = 'test';
        requestBean.IPCQChargeEnquiry.ipcqchi.firstDate = '321';
        requestBean.IPCQChargeEnquiry.ipcqchi.lastDate = '123';
        requestBean.IPCQChargeEnquiry.ipcqchi.nbrOfTrsReq = '999';
        requestBean.IPCQChargeEnquiry.ipcqchi.indStartOrContinue = 'S';

        return requestBean;
    }
}