/**
 * @description Request Integration Bean for AccountSearch Service
 * @author Sourabh Yadav
 * @created 2021-08-17
 */
public class AccountSearch_Req_IB_v1 extends Base_IB {
	/**
	 * @description AccountsSearchCriteria
	 * @author Sourabh Yadav
	 * @created 2021-08-17
	 */
	public class AccountsSearchCriteria {
		public String creditorAccountLegacyIdentifier;
	}

	public AccountsSearchCriteria accountsSearchCriteria ;
	public Integer firstresult ;
	public Integer maxresults ;

	/**
	 * @description createDummyRequest
	 * @return AccountSearch_Req_IB_v1
	 * @author Sourabh Yadav
	 * @created 2021-08-17
	 */
	public static AccountSearch_Req_IB_v1 createDummyRequest() {
		AccountSearch_Req_IB_v1 requestBean = new AccountSearch_Req_IB_v1();
		AccountsSearchCriteria ac = new AccountsSearchCriteria();
		ac.creditorAccountLegacyIdentifier = '0000000000001827';
		requestBean.accountsSearchCriteria = ac;
		requestBean.firstresult = 0;
		requestBean.maxresults = 1;

		return requestBean;
	}
}