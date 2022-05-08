/*
 * Integration Utility class for policyLoadByRefNo Service
 * @author chandra Bhushan Singh
 * @created 2021-02-04
 * @W-007776
 */

public class PolicyLoadByRefNo_IU_v1 {

    /* Creates a request bean
     * @return: policyLoadByRefNo bean object
     */
    public static PolicyLoadByRefNo_Req_IB_v1 mapRequestFields(String policyNumber) {
        policyLoadByRefNo_Req_IB_v1 requestBean = new policyLoadByRefNo_Req_IB_v1();
        requestBean.Policy_LoadByRefNo = new policyLoadByRefNo_Req_IB_v1.Policy_LoadByRefNo();
        requestBean.Policy_LoadByRefNo.pstrSessionGID = ExergyLoginController.getSessionId();
        requestBean.Policy_LoadByRefNo.pstrRefNo = policyNumber.replaceFirst('^0+','');

        return requestBean;
    }
}