/*
 * Response Integration Bean for PowerCurveStatusUpdate Service
 * @author Saurabh Pandey
 * @created 2020-11-19
 */

public class PowerCurveStatusUpdate_Resp_IB_v1 extends Base_IB{

	public class Response {
		public ApplicationDV ApplicationDV;
	}

	public Response Response;

	public class ApplicationDV {
		public String APPERRMSG;
	}

}