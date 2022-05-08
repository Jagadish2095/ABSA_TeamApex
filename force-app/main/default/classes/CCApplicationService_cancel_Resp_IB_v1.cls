/*
 * Response Integration Bean for CCApplicationService cancel
 * @author Prudence Shirindzi
 * @created 2020-10-20
 */
public class CCApplicationService_cancel_Resp_IB_v1 extends Base_IB {
    public String status;
    public Integer statusCode;
    public String message;
    
    public cancelApplicationResponse cancelApplicationResponse;
    
	public class Responsereturn{
		public responseCommons responseCommons;
	}
	public class responseCommons{
		public String success;
		public String messageTimeStamp;
	}
	public class cancelApplicationResponse{
		public Responsereturn Responsereturn;
	}
     public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
     }
}