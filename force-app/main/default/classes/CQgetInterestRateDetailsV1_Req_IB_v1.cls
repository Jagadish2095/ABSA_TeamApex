/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 * @author ::Jason Q
 * @last modified on  : 2021-06-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-12   almas.aleem@absa.africa   Initial Version
**/


public class CQgetInterestRateDetailsV1_Req_IB_v1 extends Base_IB{

	public CQgetInterestRateDetailsV1 CQgetInterestRateDetailsV1;

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 * @author ::Jason Q
 * */public class CQgetInterestRateDetailsV1 {
        public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cqh451i cqh451i;
    }

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Nbsapdpi {
        public String channel;
		public String application;
		public String trace;
    }

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Nbsmsgi {
        public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
    }

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Cqh451i {
        public String accountNbr;
		public String processingSite;
		public String processingSiteType;
		public String tellerNbr;
		public String agencyCode;
		public String agencyType;
		public String controllerNbr;
		public String corpCode;
    }

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class FinalMsgId {
        public String finalMsgClass;
		public String finalMsgCode;
    }

	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-06-12 
	* @return CQgetInterestRateDetailsV1_Req_IB_v1 
	**/
	public static CQgetInterestRateDetailsV1_Req_IB_v1 createDummyRequest() {
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

		requestBean.CQgetInterestRateDetailsV1.cqh451i.accountNbr = '4050797102';
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