/**
* @description Request Bean class for the ClientSearch
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 12/08/2021
*/
public class ClientSearch_Req_IB_v1 extends Base_IB {

	public Client_Search Client_Search;
	
    /**
	* @description wrapper class ClientSearch
	*/
	public class Client_Search {
		public String pstrSessionGID;
		public PobjSearchClient pobjSearchClient;
		public String pstrValidationMessage;
	}
	
    /**
	* @description wrapper class PobjSearchClient
	*/
	public class PobjSearchClient {
		public String DateOfBirth;
		public String Firstname;
		public String IdentifierDescription;
		public Integer IdentifierTypeID;
		public Integer IncrementalSearch;
		public String Initials;
		public Integer ReturnTop;
		public String Surname;
		public Integer TitleID;
	}
    
    /**
	 * @description method used for dummy request
	 * @return ClientSearch_Req_IB_v1
	 */
	public static ClientSearch_Req_IB_v1 createDummyRequest() {
		ClientSearch_Req_IB_v1 requestBean = new ClientSearch_Req_IB_v1();
		requestBean.Client_Search = new ClientSearch_Req_IB_v1.Client_Search();
		requestBean.Client_Search.pstrSessionGID = 'A29DD414-682E-412B-A9F9-35109CCF4410';
		requestBean.Client_Search.pobjSearchClient = new ClientSearch_Req_IB_v1.PobjSearchClient();
        requestBean.Client_Search.pobjSearchClient.DateOfBirth = '';
        requestBean.Client_Search.pobjSearchClient.Firstname = '';
        requestBean.Client_Search.pobjSearchClient.IdentifierDescription = '9101160730088';
        requestBean.Client_Search.pobjSearchClient.IdentifierTypeID = 1;
        requestBean.Client_Search.pobjSearchClient.IncrementalSearch = 1;
        requestBean.Client_Search.pobjSearchClient.Initials = '';
        requestBean.Client_Search.pobjSearchClient.ReturnTop = 1;
        requestBean.Client_Search.pobjSearchClient.Surname = '';
        requestBean.Client_Search.pobjSearchClient.TitleID = 0;

		return requestBean;
	}

}