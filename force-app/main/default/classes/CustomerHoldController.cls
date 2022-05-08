/**
 * @description Lightning Component Controller to show customer active imposed holds data in Retail Leads app on Lead record Detail page under Customer Hold tab,
 * And also show same data in Customer Hub app in Person Account details page in related list
 * @author : Santosh Kumar
 * @since : 2021-06-28
 * @W-004273
 */

public class CustomerHoldController {
	/**
	 * @description getClientHoldDetails to get active imposed holds data
	 * @param clientCodeP
	 * @param accNumberP
	 * @param siteCodeP
	 * @return String
	 **/

	@AuraEnabled
	public static String getClientHoldDetails(String clientCodeP, String accNumberP, String siteCodeP) {
		GetClientDetails_Resp_IB_v1 response = GetClientDetails_IH_v1.getClientDetails(clientCodeP, accNumberP, siteCodeP);
		return JSON.serialize(response);
	}
}