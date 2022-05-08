/**
 * Response Integration Bean for BusinessTrace Service
 * @author Englarmerdge Mongwe
 * @created 2021-01-08
 */
public class BusinessTrace_Resp_IB_v1 extends Base_IB {
	public String status;
    public Integer statusCode;
    public String message;
    public BusinessTraceResponse BusinessTraceResponse;

	public class BusinessTraceResponse {
		public String BusinessTraceResult;
	}
}