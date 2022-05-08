/**
 * @description       : Integration Utiity class
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-24   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class GBgetCmsCreditGroups_IU_v1 {
	/**
	 * @description Map Request with Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 * @param clientCode
	 * @return GBgetCmsFullCrGroups_Req_IB_v1
	 **/
	public static GBgetCmsFullCrGroups_Req_IB_v1 mapRequestFields(String clientCode) {
		GBgetCmsFullCrGroups_Req_IB_v1 requestBean = new GBgetCmsFullCrGroups_Req_IB_v1();
		requestBean.NBSAPDPI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSMSGI_Z();
		requestBean.GSB025I = new GBgetCmsFullCrGroups_Req_IB_v1.GSB025I_Z();
		requestBean.NBSAPDPI.NBSAPLI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSAPLI();
		requestBean.NBSMSGI.NBSMSGI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSMSGI();
		requestBean.GSB025I.GSB025I = new GBgetCmsFullCrGroups_Req_IB_v1.GSB025I();

		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'API';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'CMS';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'T';

		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		requestBean.GSB025I.GSB025I.GSB025I_CLIENT_CODE = clientCode;

		System.debug('GBgetCmsFullCrGroups_Req_IB_v1 Request Bean: ' + JSON.serializePretty(requestBean));
		return requestBean;
	}
}