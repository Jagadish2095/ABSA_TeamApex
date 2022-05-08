/**
 * Integration Utility for for GBgetTotalGroupExposureV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020/12/29
 */
public class GBgetTotalGroupExposureV3_IU_v1 {
    /**
     * Creates a request bean
     * @param: clientCode;
     * @return: GBgetTotalGroupExposureV3_Req_IB_v1 bean object
    */
   public static GBgetTotalGroupExposureV3_Req_IB_v1 mapRequestFields(String clientCode) {

       GBgetTotalGroupExposureV3_Req_IB_v1 requestBean = new GBgetTotalGroupExposureV3_Req_IB_v1();
       requestBean.NBSAPDPI = new GBgetTotalGroupExposureV3_Req_IB_v1.NBSAPDPI();
       requestBean.NBSMSGI = new GBgetTotalGroupExposureV3_Req_IB_v1.NBSMSGI_Z();
       requestBean.GSB002I = new GBgetTotalGroupExposureV3_Req_IB_v1.GSB002I_Z();
       requestBean.NBSAPDPI.NBSAPLI = new GBgetTotalGroupExposureV3_Req_IB_v1.NBSAPLI();
       requestBean.NBSMSGI.NBSMSGI = new GBgetTotalGroupExposureV3_Req_IB_v1.NBSMSGI();
       requestBean.GSB002I.GSB002I = new GBgetTotalGroupExposureV3_Req_IB_v1.GSB002I();

       requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'GATEWAY';
       requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'GATEWAY';
       requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';

       requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
       requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

       requestBean.GSB002I.GSB002I.GSB002I_CLIENT_CODE = clientCode;

       System.debug('GBgetTotalGroupExposureV3 Request Bean: ' + requestBean);
       System.debug('GBgetTotalGroupExposureV3 Request Bean: ' + JSON.serializePretty(requestBean));
       return requestBean;
   }
}