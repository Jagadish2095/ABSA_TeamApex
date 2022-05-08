/**
 * @description Integration Utility for BAPISFAccntDescr Service
 * @author  Koketso Mpshane
 * @date    17/05/2021
 */
public class BAPISFAccntDescr_IU_v1 {
    /**
	 * @description mapRequestFields method
	 * @param accountList
     * @param iUser
	 * @return BAPISFAccntDescr_Req_IB_v1
 	 */
    public static BAPISFAccntDescr_Req_IB_v1 mapRequestFields(List<String> accountList, String iUser) {
		BAPISFAccntDescr_Req_IB_v1 requestBean = new BAPISFAccntDescr_Req_IB_v1();
		requestBean.BAPI_SF_ACCNT_DESCR = new BAPISFAccntDescr_Req_IB_v1.BAPI_SF_ACCNT_DESCR();

        List<BAPISFAccntDescr_Req_IB_v1.ACCOUNT_REQ> accountReqList = new List<BAPISFAccntDescr_Req_IB_v1.ACCOUNT_REQ>();

        for(String accNum: accountList){
            BAPISFAccntDescr_Req_IB_v1.ACCOUNT_REQ accReq = new BAPISFAccntDescr_Req_IB_v1.ACCOUNT_REQ();
            accReq.ACCOUNT = accNum;
            accReq.I_USER = iUser;
            accountReqList.add(accReq);
        }

        requestBean.BAPI_SF_ACCNT_DESCR.ACCOUNT_REQ = accountReqList;

        return requestBean;
	}

}