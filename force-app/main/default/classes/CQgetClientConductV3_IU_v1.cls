/**
 * Integration Utility for CQgetClientConductV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020-08-06
 */

public class CQgetClientConductV3_IU_v1 {
    /** Creates a request bean
     * @param: accountNbr;
	 * @param: branchCode;
	 * @param: branchSiteType;
	 * @param: tellerCode;
	 * @param: siteTypeAgency;
	 * @param: supervisorCode;
	 * @param: agencyCode;
	 * @param: corpCode;
     * @return: CQgetClientConductV3_Req_IB_v1 bean object
     */
    public static CQgetClientConductV3_Req_IB_v1 mapRequestFields(String accountNbr, String branchCode, String branchSiteType, String tellerCode, String siteTypeAgency, String supervisorCode, String agencyCode, String corpCode) {

        CQgetClientConductV3_Req_IB_v1 requestBean = new CQgetClientConductV3_Req_IB_v1();
		requestBean.CQgetClientConductV3 = new CQgetClientConductV3_Req_IB_v1.CQgetClientConductV3();
		requestBean.CQgetClientConductV3.nbsapdpi = new CQgetClientConductV3_Req_IB_v1.Nbsapdpi();
		requestBean.CQgetClientConductV3.nbsmsgi = new CQgetClientConductV3_Req_IB_v1.Nbsmsgi();
        requestBean.CQgetClientConductV3.cqh482i = new CQgetClientConductV3_Req_IB_v1.Cqh482i();

		requestBean.CQgetClientConductV3.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
		requestBean.CQgetClientConductV3.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
		requestBean.CQgetClientConductV3.nbsapdpi.trace = 'Y';

		requestBean.CQgetClientConductV3.nbsmsgi.msgLanguage = 'E';
		requestBean.CQgetClientConductV3.nbsmsgi.msgTarget = 'STD';

		requestBean.CQgetClientConductV3.cqh482i.accountNbr = accountNbr;
		requestBean.CQgetClientConductV3.cqh482i.branchCode = branchCode;
        requestBean.CQgetClientConductV3.cqh482i.branchSiteType = branchSiteType;
        requestBean.CQgetClientConductV3.cqh482i.tellerCode = tellerCode;
		requestBean.CQgetClientConductV3.cqh482i.siteTypeAgency = siteTypeAgency;
        requestBean.CQgetClientConductV3.cqh482i.supervisorCode = supervisorCode;
        requestBean.CQgetClientConductV3.cqh482i.agencyCode = agencyCode;
		requestBean.CQgetClientConductV3.cqh482i.corpCode = 'ABS'; ///corpCode; messes up when division is something else

        System.debug('CQgetClientConductV3 Request Bean: ' + requestBean);
        return requestBean;
	}
}