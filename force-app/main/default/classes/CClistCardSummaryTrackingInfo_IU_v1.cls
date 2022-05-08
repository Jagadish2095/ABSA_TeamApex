/**
 * @description Integration Utilities for CClistCardSummaryTrackingInfo Service
 * @author Jason Quevauvilliers
 * @created 2021-03-24
 */
public class CClistCardSummaryTrackingInfo_IU_v1 {
	/**
	 * @description Map Request Fields
	 * @param cifCode
	 * @return CClistCardSummaryTrackingInfo_Req_IB_v1 Object
	 */
	public static CClistCardSummaryTrackingInfo_Req_IB_v1 mapRequestFields(String cifCode) {
		CClistCardSummaryTrackingInfo_Req_IB_v1 requestBean = new CClistCardSummaryTrackingInfo_Req_IB_v1();
		requestBean.CClistCardSummaryTrackingInfoV2 = new CClistCardSummaryTrackingInfo_Req_IB_v1.CClistCardSummaryTrackingInfoV2_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi = new CClistCardSummaryTrackingInfo_Req_IB_v1.Nbsapdpi_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.channel = 'BDP';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.application = 'BDP';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.trace = 'Y';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi = new CClistCardSummaryTrackingInfo_Req_IB_v1.Nbsmsgi_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.msgLanguage = 'E';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.msgTarget = 'STD';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.finalMsgId = new CClistCardSummaryTrackingInfo_Req_IB_v1.FinalMsgId_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.ccp401i = new CClistCardSummaryTrackingInfo_Req_IB_v1.Ccp401i_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.ccp401i.clientCode = cifCode;
		return requestBean;
	}
}