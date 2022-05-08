/*
 * ECM Rest Service
 *
 * @author Masimba Chingwende
 *
 * ECM_LoginRequest_IH_V1
 */
public class ECM_LoginRequest_IB_V1 {
	
	public LoginRequest LoginRequest { get; set; }
        
	public class LoginRequest {
		
		public String DataStore { get; set;}
	    public String UserName { get; set; }
	    public String Password { get; set; }
	}

}