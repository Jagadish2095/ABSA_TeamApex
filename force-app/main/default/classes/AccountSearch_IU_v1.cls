/**
 * @description Integration Utility class for AccountSearch Service
 * @author Sourabh Yadav
 * @created 2021-08-18
 */
public class AccountSearch_IU_v1 {
	/**
	 * @description Maps a request bean
	 * @param creditorAccountLegacyIdentifier
	 * @return AccountSearch_Req_IB_v1
	 */
	public static AccountSearch_Req_IB_v1 mapRequestFields(String creditorAccountLegacyIdentifier) {
		AccountSearch_Req_IB_v1 requestBean = new AccountSearch_Req_IB_v1();
		requestBean.AccountsSearchCriteria = new AccountSearch_Req_IB_v1.AccountsSearchCriteria();
		requestBean.AccountsSearchCriteria.creditorAccountLegacyIdentifier = creditorAccountLegacyIdentifier;
		requestBean.firstresult = 0;
		requestBean.maxresults = 1;

		return requestBean;
	}
}