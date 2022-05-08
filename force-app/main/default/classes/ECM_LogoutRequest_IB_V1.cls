/**
 * ECM_LogoutRequest_IB_V1
 */
public class ECM_LogoutRequest_IB_V1 extends Base_IB {
    
    public LogoutRequest LogoutRequest { get; set; }
    
    public class LogoutRequest {    	
    	public String Token { get; set; }
    }

}