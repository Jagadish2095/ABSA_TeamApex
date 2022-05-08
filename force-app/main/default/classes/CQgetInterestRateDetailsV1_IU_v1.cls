/**
 * @description       : 
 * @author            : aJason Q
 * @last modified on  : 2021-06-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-12   almas.aleem@absa.africa   Initial Version
**/


public class CQgetInterestRateDetailsV1_IU_v1 {

    /**
    * @description 
    * @author Jason Q| 2021-06-12 
    * @param acctnumber 
    * @return CQgetInterestRateDetailsV1_Req_IB_v1 
    **/
    public static CQgetInterestRateDetailsV1_Req_IB_v1 mapRequestFields(String acctnumber) {
        //CQgetInterestRateDetailsV1_Req_IB_v1 requestBean = CQgetInterestRateDetailsV1_Req_IB_v1.createDummyRequest();
        CQgetInterestRateDetailsV1_Req_IB_v1 requestBean = new CQgetInterestRateDetailsV1_Req_IB_v1();
        requestBean.CQgetInterestRateDetailsV1 = new CQgetInterestRateDetailsV1_Req_IB_v1.CQgetInterestRateDetailsV1();
		requestBean.CQgetInterestRateDetailsV1.nbsapdpi = new CQgetInterestRateDetailsV1_Req_IB_v1.Nbsapdpi();
		requestBean.CQgetInterestRateDetailsV1.nbsmsgi = new CQgetInterestRateDetailsV1_Req_IB_v1.Nbsmsgi();
		requestBean.CQgetInterestRateDetailsV1.nbsmsgi.finalMsgId = new CQgetInterestRateDetailsV1_Req_IB_v1.FinalMsgId();
		requestBean.CQgetInterestRateDetailsV1.cqh451i = new CQgetInterestRateDetailsV1_Req_IB_v1.Cqh451i();

		requestBean.CQgetInterestRateDetailsV1.nbsapdpi.channel = 'BDP';
		requestBean.CQgetInterestRateDetailsV1.nbsapdpi.application = 'BDP';
		requestBean.CQgetInterestRateDetailsV1.nbsapdpi.trace = 'Y';

		requestBean.CQgetInterestRateDetailsV1.nbsmsgi.msgLanguage = 'E';
		requestBean.CQgetInterestRateDetailsV1.nbsmsgi.msgTarget = 'STD';

		requestBean.CQgetInterestRateDetailsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CQgetInterestRateDetailsV1.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.CQgetInterestRateDetailsV1.cqh451i.accountNbr = acctnumber;
		requestBean.CQgetInterestRateDetailsV1.cqh451i.processingSite = '8392';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.processingSiteType = '034';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.tellerNbr = '2479519';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.agencyCode = '5920';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.agencyType = '034';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.controllerNbr = '2479519';
		requestBean.CQgetInterestRateDetailsV1.cqh451i.corpCode = '034';

        
        return requestBean;
    }
}