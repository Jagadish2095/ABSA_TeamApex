/**
 * @description Integration Utility for ClientSearch Service
 * @author Koketso Mpshane
 * @created 2021-08-13
 */
public class ClientSearch_IU_v1 {
    
    /**
	 * @description method to map request fields to creates a request bean
	 * @param idType
	 * @param idNumber
	 * @return ClientSearch_Req_IB_v1
	 */
     public static ClientSearch_Req_IB_v1 mapRequestFields(Integer idType, String idNumber) {
		ClientSearch_Req_IB_v1 requestBean = new ClientSearch_Req_IB_v1();
		requestBean.Client_Search = new ClientSearch_Req_IB_v1.Client_Search();
		requestBean.Client_Search.pstrSessionGID = ExergyLoginController.getSessionId();
		requestBean.Client_Search.pobjSearchClient = new ClientSearch_Req_IB_v1.PobjSearchClient();
        requestBean.Client_Search.pobjSearchClient.DateOfBirth = '';
        requestBean.Client_Search.pobjSearchClient.Firstname = '';
        requestBean.Client_Search.pobjSearchClient.IdentifierDescription = idNumber;
        requestBean.Client_Search.pobjSearchClient.IdentifierTypeID = idType;
        requestBean.Client_Search.pobjSearchClient.IncrementalSearch = 1;
        requestBean.Client_Search.pobjSearchClient.Initials = '';
        requestBean.Client_Search.pobjSearchClient.ReturnTop = 1;
        requestBean.Client_Search.pobjSearchClient.Surname = '';
        requestBean.Client_Search.pobjSearchClient.TitleID = 0;

        return requestBean;
    }

}