/*
 * Integration Utility class for getTbUserBasicLimits Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class getTbUserBasicLimits_IU_v1 {

    public static getTbUserBasicLimits_Req_IB_v1 mapRequestFields(String  customerCifKeyP,String userNumberP){
        getTbUserBasicLimits_Req_IB_v1 requestBean = new getTbUserBasicLimits_Req_IB_v1();
        requestBean.customerCifKey = customerCifKeyP;
        requestBean.userNumber = userNumberP;
        return requestBean;
    }
   
}