/*
 * Integration Utility class for LAListPolicyDetailsByPolicyV7 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */

public class LAListPolicyDetailsByPolicyV7_IU_v1 {

    /* Creates a request bean
     * @return: LAListPolicyDetailsByPolicyV7_Req_IB_v1 bean object
     */
    public static LAListPolicyDetailsByPolicyV7_Req_IB_v1 mapRequestFields(String policyNumber) {
        LAListPolicyDetailsByPolicyV7_Req_IB_v1 requestBean = new LAListPolicyDetailsByPolicyV7_Req_IB_v1();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7 = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.LAlistPolicyDetailsbyPolicyNumberV7();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.Nbsapdpi();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.La950p3i = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.La950p3i();

        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.channel = 'I';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.application = 'ALVS';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.trace = 'Y';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.La950p3i.policyNumber = policyNumber.replaceFirst('^0+','');

        return requestBean;
    }
}