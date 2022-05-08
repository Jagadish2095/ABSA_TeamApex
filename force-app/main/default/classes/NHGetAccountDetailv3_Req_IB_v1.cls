/*
 * Request Integration Bean for NHGetAccountDetailv3 Service
 * @author Mashudu Raidimi
 * @created 2020-08-11
 */
public class NHGetAccountDetailv3_Req_IB_v1 extends Base_IB{
    
    public NHgetAccountDetailV3 NHgetAccountDetailV3;		
	public class nhp039i{	
		public String division;
		public String user;
		public String device;
		public String accessNumber;
		public String origAddress;
		public String authenticate;
		public String combiNumber;
		public String log;
		public String language;
		public String accountNumber;
	}	
	public class NHgetAccountDetailV3{	
		public nbsapdpi nbsapdpi;
		public nhp039i nhp039i;
	}	
	public class nbsapdpi{	
		public String trace;
		public String application;
		public String channel;
	}
    
    public static NHGetAccountDetailv3_Req_IB_v1 dummyRequest(){
        
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
		bean.NHgetAccountDetailV3.nhp039i.accessNumber = '00000008052424088';
		bean.NHgetAccountDetailV3.nhp039i.origAddress = '0';
		bean.NHgetAccountDetailV3.nhp039i.authenticate = 'N';
		bean.NHgetAccountDetailV3.nhp039i.combiNumber = '04451430000038047';
		bean.NHgetAccountDetailV3.nhp039i.log = 'N';
		bean.NHgetAccountDetailV3.nhp039i.language = 'E';
		bean.NHgetAccountDetailV3.nhp039i.accountNumber = '00000008052424088';
        
        return bean;
    }
}