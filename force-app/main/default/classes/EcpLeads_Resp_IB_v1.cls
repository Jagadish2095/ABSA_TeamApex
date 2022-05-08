/**
 * @author Rajesh Nandigam
 * @since 2021-07-20
 * @description Ecp Leads Response Wrapper
 **/
public class EcpLeads_Resp_IB_v1 extends Base_IB{
        public String requestId;
        public Boolean isValid;
        /**
 * @since 2021-07-20
 * @description Ecp Leads Response Wrapper
 * @return respBean
 **/
    
    public static EcpLeads_Resp_IB_v1 createDummyResponse(){
        EcpLeads_Resp_IB_v1 respBean = new EcpLeads_Resp_IB_v1();
        respBean.requestId = '1fb996ac-6991-4011-bea4-3599dfcd8a8c';
        respBean.isValid = true;
        return respBean;
    }
}