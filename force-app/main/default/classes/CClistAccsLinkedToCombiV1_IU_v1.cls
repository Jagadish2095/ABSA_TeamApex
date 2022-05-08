/**
 * @description Integration Utility class for CClistAccsLinkedToCombiV1 Service
 * @author: Humbelani Denge
 * @created: 2021-02-12
 */
public class CClistAccsLinkedToCombiV1_IU_v1 {
    /**
     * @description maps request call field values
     * @return CClistAccsLinkedToCombiV1_Req_IB_v1
     * @param combiNbr
     */
	public static CClistAccsLinkedToCombiV1_Req_IB_v1 mapRequestFields(String combiNbr) {
		CClistAccsLinkedToCombiV1_Req_IB_v1 requestBean = new CClistAccsLinkedToCombiV1_Req_IB_v1();
		requestBean.CClistAccsLinkedToACombiCardV1 = new CClistAccsLinkedToCombiV1_Req_IB_v1.CClistAccsLinkedToACombiCardV1();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi = new CClistAccsLinkedToCombiV1_Req_IB_v1.Nbsapdpi();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.channel = 'BDP';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.application = 'BDP';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.trace = 'Y';

		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi = new CClistAccsLinkedToCombiV1_Req_IB_v1.nbsmsgi();

		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi.msgLanguage = 'STD';
		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi.msgTarget = 'E';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId = new CClistAccsLinkedToCombiV1_Req_IB_v1.finalMsgId();

		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId = new CClistAccsLinkedToCombiV1_Req_IB_v1.FinalMsgId();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId.finalMsgClass = '';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId.finalMsgCode = '';
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i = new CClistAccsLinkedToCombiV1_Req_IB_v1.Ccp308i();
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.combiNbr = combiNbr;
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.inpAccntNbr = '0';
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.nbrAccntReq = '0';

		return requestBean;
	}
}