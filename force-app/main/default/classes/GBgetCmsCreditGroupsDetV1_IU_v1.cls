/**
 * Integration Utility for GBgetCmsCreditGroupsDetV1 Service
 * @author Englarmerdge Mongwe
 * @created 2020-10-13
 */

public class GBgetCmsCreditGroupsDetV1_IU_v1 {
    /** Creates a request bean
     * @param: clientCode;
     * @return: GBgetCmsCreditGroupsDetV1_Req_IB_v1 bean object
     */
    public static GBgetCmsCreditGroupsDetV1_Req_IB_v1 mapRequestFields(String clientCode) {

        GBgetCmsCreditGroupsDetV1_Req_IB_v1 requestBean = new GBgetCmsCreditGroupsDetV1_Req_IB_v1();
		requestBean.NBSAPDPI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSMSGI_Z();
		requestBean.GSB014I = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.GSB014I_Z();
		requestBean.NBSAPDPI.NBSAPLI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSAPLI();
		requestBean.NBSMSGI.NBSMSGI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSMSGI();
		requestBean.GSB014I.GSB014I = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.GSB014I();

		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';

		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		requestBean.GSB014I.GSB014I.GSB014I_CLIENT_CODE = clientCode;

		System.debug('GBgetCmsCreditGroupsDetV1 Request Bean: ' + requestBean);
		System.debug('GBgetCmsCreditGroupsDetV1 Request Bean: ' + JSON.serializePretty(requestBean));
        return requestBean;
	}
}