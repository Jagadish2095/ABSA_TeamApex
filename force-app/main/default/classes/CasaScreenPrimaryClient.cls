/**
 * @description       : Used to Casa Primary Client
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-03
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CasaScreenPrimaryClient {
	private ICasaScreenPrimaryClientHelper casaScreenPrimaryClientHelper;
	private String accountId;

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @param objId
	**/
	public CasaScreenPrimaryClient(string objId){
		setClassVariables(objId);
	}

	/**
	 * @description Call Casa Screen Primary Client
	 * @author PaulJohn.duRand@absa.africa | 2021-08-01
	 * @return string
	 **/
	public string callService() {
		CASAScreenPrimaryClientV7_Req_IB_v1 requestBean = casaScreenPrimaryClientHelper.populateRequest(accountId);
		CASAScreenPrimaryClientV7_Resp_IB_v1 response = CASAScreenPrimaryClientV7_IH_v1.CASAScreenPrimaryClientV7(requestBean);
		response.casaStatus = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(response.refNo);
		casaScreenPrimaryClientHelper.updateObject(accountId, response);
		return JSON.serialize(response);
	}

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @return string
	**/
	public string getAnnalystComments() {
		String casaRef = casaScreenPrimaryClientHelper.getCasaReference(accountId);
		String casaComments = Wqgetanalystcommentsv7_IH_v2.GetAnalystCommentsByRefNumber(casaRef);
		if(!casaComments.contains('Error')){
		 casaScreenPrimaryClientHelper.updateAnalystComments(accountId, casaComments);
		}
        return casaComments;
	}

	/**
	 * @description getPrimaryCasaDetails
	 * @return object
	 */
	public object getPrimaryCasaDetails() {
		return casaScreenPrimaryClientHelper.getCasaDetails(accountId);
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-03
	 * @return string
	 **/
	public string getCasaReference() {
		return casaScreenPrimaryClientHelper.getCasaReference(accountId);
	}

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @param objId
	**/
	private void setClassVariables(string objId){
	 accountId = BranchFunctions.getAccountId(objId);
		casaScreenPrimaryClientHelper = (ICasaScreenPrimaryClientHelper) ClassImplementationFactory.getClassImplementation(
			'ICasaScreenPrimaryClientHelper',
			accountId
		);
	}
}