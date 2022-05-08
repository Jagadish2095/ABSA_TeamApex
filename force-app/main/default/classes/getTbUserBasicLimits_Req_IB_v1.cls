/*
 * Request Integration Bean for getTbUserBasicLimits Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class getTbUserBasicLimits_Req_IB_v1 extends Base_IB {
    
    public String customerCifKey;
    public String userNumber;
    
    public static getTbUserBasicLimits_Req_IB_v1  dummyRequest(){  
        getTbUserBasicLimits_Req_IB_v1 bean = new getTbUserBasicLimits_Req_IB_v1();
        bean.customerCifKey = 'BOUCHI 001';
        bean.userNumber = '001';
        return  bean;
    }

}