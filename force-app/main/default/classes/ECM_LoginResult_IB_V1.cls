/**
 * ECM_LoginResult_IH_V1
 *
 * @author Masimba Chingwende
 */
public class ECM_LoginResult_IB_V1  {
	
    public LoginResult LoginResult { get; set; }
    
    public String Token { get; set; }
    
    public class LoginResult {
        
        public String Status { get; set; }
        
        public String Detail { get; set; }
    }
    
    public static ECM_LoginResult_IB_V1 getExample() {
    	ECM_LoginResult_IB_V1 example = new ECM_LoginResult_IB_V1();
    	example.Token = '12345';
    	example.LoginResult = new LoginResult();
    	example.LoginResult.Status = 'Ok';
    	example.LoginResult.Detail = 'Ok';
    	return example;
    }
    
}