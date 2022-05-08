/*
 * Integration Utility class for NHGetAccountDetailv3 Service
 * @author Mashudu Raidimi
 * @created 2020-08-11
 */
public class NHGetAccountDetailv3_IU_v1 {
    
    public static NHGetAccountDetailv3_Req_IB_v1 mapRequestFields(String  combiNumberP,String accountNumberP){
        
        NHGetAccountDetailv3_Req_IB_v1 bean = new NHGetAccountDetailv3_Req_IB_v1();
        bean.NHgetAccountDetailV3 = new NHGetAccountDetailv3_Req_IB_v1.NHgetAccountDetailV3();
        bean.NHgetAccountDetailV3.nbsapdpi = new NHGetAccountDetailv3_Req_IB_v1.nbsapdpi();
        bean.NHgetAccountDetailV3.nhp039i = new NHGetAccountDetailv3_Req_IB_v1.nhp039i();
        
        bean.NHgetAccountDetailV3.nbsapdpi.trace = 'Y';
        bean.NHgetAccountDetailV3.nbsapdpi.application = 'BDP';
		bean.NHgetAccountDetailV3.nbsapdpi.channel = 'BDP';
        
        bean.NHgetAccountDetailV3.nhp039i.division = 'ABSA';
		bean.NHgetAccountDetailV3.nhp039i.user = '1';
		bean.NHgetAccountDetailV3.nhp039i.device = 'W';
		bean.NHgetAccountDetailV3.nhp039i.accessNumber = accountNumberP;
		bean.NHgetAccountDetailV3.nhp039i.origAddress = '0';
		bean.NHgetAccountDetailV3.nhp039i.authenticate = 'N';
		bean.NHgetAccountDetailV3.nhp039i.combiNumber = combiNumberP;
		bean.NHgetAccountDetailV3.nhp039i.log = 'N';
		bean.NHgetAccountDetailV3.nhp039i.language = 'E';
		bean.NHgetAccountDetailV3.nhp039i.accountNumber = accountNumberP;
        
        return bean;
    }

}