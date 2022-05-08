/**
 * Integration Utility for CQgetOverdraftDetailsV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-07-28
 */

public class CQgetOverdraftDetailsV4_IU_v1 {
    /** Creates a request bean
     * @param: accountNbr;
	 * @param: processingSite;
	 * @param: processingSiteType;
	 * @param: tellerNbr;
	 * @param: agencyCode;
	 * @param: agencyType;
	 * @param: controllerNbr;
	 * @param: corpCode;
     * @return: CQgetOverdraftDetailsV4_Req_IB_v1 bean object
     */
    public static CQgetOverdraftDetailsV4_Req_IB_v1 mapRequestFields(String accountNbr, String processingSite,String processingSiteType, String tellerNbr, String agencyCode, String agencyType, String controllerNbr, String corpCode) {

        CQgetOverdraftDetailsV4_Req_IB_v1 requestBean = new CQgetOverdraftDetailsV4_Req_IB_v1();
		requestBean.CQgetOverdraftDetailsV4 = new CQgetOverdraftDetailsV4_Req_IB_v1.CQgetOverdraftDetailsV4();
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi = new CQgetOverdraftDetailsV4_Req_IB_v1.Nbsapdpi();
		requestBean.CQgetOverdraftDetailsV4.nbsmsgi = new CQgetOverdraftDetailsV4_Req_IB_v1.Nbsmsgi();
        requestBean.CQgetOverdraftDetailsV4.cqh478i = new CQgetOverdraftDetailsV4_Req_IB_v1.Cqh478i();

		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.trace = 'Y';

		requestBean.CQgetOverdraftDetailsV4.nbsmsgi.msgLanguage = 'E';
		requestBean.CQgetOverdraftDetailsV4.nbsmsgi.msgTarget = 'STD';

		requestBean.CQgetOverdraftDetailsV4.cqh478i.accountNbr = accountNbr;
		requestBean.CQgetOverdraftDetailsV4.cqh478i.processingSite = processingSite;
        requestBean.CQgetOverdraftDetailsV4.cqh478i.processingSiteType = processingSiteType;
        requestBean.CQgetOverdraftDetailsV4.cqh478i.tellerNbr = tellerNbr;
		requestBean.CQgetOverdraftDetailsV4.cqh478i.agencyCode = agencyCode;
        requestBean.CQgetOverdraftDetailsV4.cqh478i.agencyType = agencyType;
        requestBean.CQgetOverdraftDetailsV4.cqh478i.controllerNbr = controllerNbr;
		requestBean.CQgetOverdraftDetailsV4.cqh478i.corpCode = 'ABS'; ///corpCode; messes up when division is something else

        System.debug('CQgetOverdraftDetailsV4 Request Bean: ' + requestBean);
        return requestBean;
	}
}