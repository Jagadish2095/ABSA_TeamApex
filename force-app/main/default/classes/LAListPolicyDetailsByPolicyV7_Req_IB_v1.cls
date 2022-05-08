/*
 * Request Integration Bean for LAListPolicyDetailsByPolicyV7 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */

public class LAListPolicyDetailsByPolicyV7_Req_IB_v1 extends Base_IB {
    public class LAlistPolicyDetailsbyPolicyNumberV7 {
        public Nbsapdpi nbsapdpi;
        public La950p3i la950p3i;
    }

    public LAlistPolicyDetailsbyPolicyNumberV7 LAlistPolicyDetailsbyPolicyNumberV7;

    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }

    public class La950p3i {
        public String policyNumber;
        //public Object businessSourceIndicator;
    }

    public static LAListPolicyDetailsByPolicyV7_Req_IB_v1 createDummyRequest() {
        LAListPolicyDetailsByPolicyV7_Req_IB_v1 requestBean = new LAListPolicyDetailsByPolicyV7_Req_IB_v1();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7 = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.LAlistPolicyDetailsbyPolicyNumberV7();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.Nbsapdpi();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.La950p3i = new LAListPolicyDetailsByPolicyV7_Req_IB_v1.La950p3i();
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.channel = 'I';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.application = 'ALVS';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.Nbsapdpi.trace = 'Y';
        requestBean.LAlistPolicyDetailsbyPolicyNumberV7.La950p3i.policyNumber = '6440952728';

        return requestBean;
    }
}