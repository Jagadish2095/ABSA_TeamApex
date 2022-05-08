/**
 * Integration Utility for CIlinkAccounttoClientV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-11-17
 */

public with sharing class CIlinkAccounttoClientV4_IU_V1 {
    /** Creates a request bean
     * @param: stockNumber
     * @param: cifNumber
     * @param: siteCode
     * @param: tellerOperatorCode
     * @return: CIlinkAccounttoClientV4_Req_IB_v1 bean object
     */
    public static CIlinkAccounttoClientV4_Req_IB_v1 mapRequestFields(String stockNumber, String cifNumber, String siteCode, String tellerOperatorCode) {

        CIlinkAccounttoClientV4_Req_IB_V1 requestBean = new CIlinkAccounttoClientV4_Req_IB_V1();
        requestBean.CIlinkAccountToClientV4 = new CIlinkAccounttoClientV4_Req_IB_V1.CIlinkAccountToClientV4();
        requestBean.CIlinkAccountToClientV4.Nbsapdpi = new CIlinkAccounttoClientV4_Req_IB_V1.Nbsapdpi();
        requestBean.CIlinkAccountToClientV4.Nbsmsgi  = new CIlinkAccounttoClientV4_Req_IB_V1.Nbsmsgi();
        requestBean.CIlinkAccountToClientV4.Cib015di = new CIlinkAccounttoClientV4_Req_IB_V1.Cib015di();
        requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId = new CIlinkAccounttoClientV4_Req_IB_V1.FinalMsgId();

        requestBean.CIlinkAccountToClientV4.Nbsapdpi.application = 'BDP';
        requestBean.CIlinkAccountToClientV4.Nbsapdpi.channel = 'BDP';
        requestBean.CIlinkAccountToClientV4.Nbsapdpi.trace = 'Y';

        requestBean.CIlinkAccountToClientV4.Nbsmsgi.msgLanguage = 'E';
        requestBean.CIlinkAccountToClientV4.Nbsmsgi.msgTarget = 'STD';

        requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId.finalMsgCode = '';

        requestBean.CIlinkAccountToClientV4.Cib015di.accountNo = stockNumber; //'41000069433';
        requestBean.CIlinkAccountToClientV4.Cib015di.casaRefNum = '123';
        requestBean.CIlinkAccountToClientV4.Cib015di.clientCode = cifNumber;//'KLAASG 014';//'CCC 531';// //cif 'TRACY123';
        requestBean.CIlinkAccountToClientV4.Cib015di.dateAccOpen = '20150401';
        requestBean.CIlinkAccountToClientV4.Cib015di.product = '09050';
        requestBean.CIlinkAccountToClientV4.Cib015di.sec129DeliveryAddr = '1';
        requestBean.CIlinkAccountToClientV4.Cib015di.siteAccOpen = siteCode; // '8198';
        requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds1 = '';
        requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds2 = '';
        requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds3 = '';
        requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds4 = '';
        requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds5 = '';
        requestBean.CIlinkAccountToClientV4.Cib015di.tellerNo = tellerOperatorCode; //Any other teller code causes issues

        System.debug('CIlinkAccounttoClientV4 Request Bean: ' + JSON.serializePretty(requestBean));
        return requestBean;
    }
}