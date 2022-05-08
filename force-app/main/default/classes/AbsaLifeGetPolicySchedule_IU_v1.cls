/**
 * @description Integration Utility for Absa Life get policy schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-19
 */

public class AbsaLifeGetPolicySchedule_IU_v1 {
    /**
	 * @description Endpoint suffix string for the handler class
	 * @param policyNumber String
	 * @return queryParams String
	 */
	public static String policyScheduleEndPoint(
		String policyNumber
	) {
		String queryParams = '?policyNumber='+policyNumber;
		return queryParams;
	}
}