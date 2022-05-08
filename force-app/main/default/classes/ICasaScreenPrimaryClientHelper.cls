/**
 * @description       : Interface for CasaScreenPrimaryClientHelper
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-03
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public interface ICasaScreenPrimaryClientHelper {
	/**
	 * @description populateRequest
	 * @author PaulJohn.duRand@absa.africa | 2021-08-02
	 * @param objId
	 * @return CASAScreenPrimaryClientV7_Req_IB_v1
	 **/
	CASAScreenPrimaryClientV7_Req_IB_v1 populateRequest(string objId);
	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-02
	 * @param objId
	 * @param response
	 **/
	void updateObject(string objId, CASAScreenPrimaryClientV7_Resp_IB_v1 response);

    /**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param accountId
    * @return Object
    **/
    Object getCasaDetails(string accountId);
	/**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param accountId
    * @return Object
    **/
    string getCasaReference(string accountId);

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @param accountId
	* @param comments
	**/
	void updateAnalystComments(string accountId,string comments);
}