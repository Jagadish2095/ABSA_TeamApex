/**
 * @description utility class for get challenges service(W-009112)
 * @author Humbelani Denge
 * Created 2021/05/10
 */
public class GetChallenges_IU_v1 {
	/**
	 * @description map request bean fields
	 * @param cifKey
	 * @return GetChallenges_Req_IB_v1
	 */
	public static GetChallenges_Req_IB_v1 mapRequestFields(String cifKey) {
		GetChallenges_Req_IB_v1 requestBean = new GetChallenges_Req_IB_v1();
		requestBean.cifKey = cifKey;
		requestBean.header = new GetChallenges_Req_IB_v1.Header();
		requestBean.header.applicationId = 'SALESFORCE';

		return requestBean;
	}
}