/**
 * @description Request Integration Bean for policyLoadByRefNo Service
 * @author chandra Bhushan Singh
 * @created 2021-02-04
 * @W-007776
 */

public class PolicyLoadByRefNo_Req_IB_v1 extends Base_IB {
    public Policy_LoadByRefNo Policy_LoadByRefNo;

    /**
     * @description Policy_LoadByRefNo wrapper class
     */
    public class Policy_LoadByRefNo {
        public String pstrSessionGID;
        public String pstrRefNo;
        public String pstrValidationMessage;
    }

    /**
     * @description dummy method for testing
     * @return requestBean
     */
    public static policyLoadByRefNo_Req_IB_v1 createDummyRequest() {
        policyLoadByRefNo_Req_IB_v1 requestBean = new policyLoadByRefNo_Req_IB_v1();
        requestBean.Policy_LoadByRefNo = new policyLoadByRefNo_Req_IB_v1.Policy_LoadByRefNo();
        requestBean.Policy_LoadByRefNo.pstrSessionGID = '18adf2f0-7366-4b50-807f-be93cfa21b95';
        requestBean.Policy_LoadByRefNo.pstrRefNo = '6633725447';
        requestBean.Policy_LoadByRefNo.pstrValidationMessage = 'test';

        return requestBean;
    }
}