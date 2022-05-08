/*
 * Integration Utility class for exergyLogin Service
 * @author chandra Bhushan Singh
 * @created 2021-02-04
 * @W-007772,007776,007778,007777,007783
 */

public class ExergyLogin_IU_v1 {

    /* Creates a request bean
     * @return: ExergyLogin_Req_IB_v1 bean object
     */
    public static ExergyLogin_Req_IB_v1 mapRequestFields(String sessionID) {
        String exergyLoginCredentials = Label.Exergy_Login_Credentials;
        List<String> credentialsList=  exergyLoginCredentials.split(';');

        ExergyLogin_Req_IB_v1 requestBean = new ExergyLogin_Req_IB_v1();
		requestBean.Login = new ExergyLogin_Req_IB_v1.Login();
        requestBean.Login.PobjUser = new ExergyLogin_Req_IB_v1.PobjUser();

        requestBean.Login.PobjUser.Password = credentialsList.get(1);
        requestBean.Login.PobjUser.SessionID = sessionID;
        requestBean.Login.PobjUser.UserName = credentialsList.get(0);

        return requestBean;
    }
}