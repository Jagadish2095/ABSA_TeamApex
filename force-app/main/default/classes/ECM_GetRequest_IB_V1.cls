/*
 * ECM Rest Service
 *
 * @author Masimba Chingwende
 *
 * ECM_GetRequest_IH_V1
 */
public class ECM_GetRequest_IB_V1 {
	
	public GetRequest GetRequest { get; set; }
        
	public class GetRequest {
		
		public String Token { get; set;}
	    public String PID { get; set; }
	}

}