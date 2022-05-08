/**
 * Integration Utility for for TotalGroupExposure Service
 * @author Englarmerdge Mongwe
 * @created 2020/12/17
 */
public class GBGetContBranchDetV1_IU_v1 {
    public static GBGetContBranchDetV1_Req_IB_v1 mapRequestFields(String clientCode){
        GBGetContBranchDetV1_Req_IB_v1 requestBean = new GBGetContBranchDetV1_Req_IB_v1();
        requestbean.NBSAPDPI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPDPI();
        requestbean.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI_Z();
        requestbean.NBSMSGI.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI();
        requestbean.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I_Z();
        requestbean.GSB021I.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I();
        requestbean.NBSAPDPI.NBSAPLI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPLI();
        requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'GATEWAY';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'GATEWAY';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'T';
        requestbean.GSB021I.GSB021I.GSB021I_CLIENT_CODE = clientCode;
        return requestBean;
    }
}