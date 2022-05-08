/*
* Request Integration Bean for exergyLogin Service
* @author chandra Bhushan Singh
* @created 2021-02-04
* @W-007772,007776,007778,007777,007783
*/

public class ExergyLogin_Req_IB_v1 extends Base_IB  {

	public Login Login;

	public class PobjUser {
		public String Password;
		public String SessionID;
		public String UserName;
	}

	public class Login {
		public PobjUser pobjUser;
	}

	public static ExergyLogin_Req_IB_v1 createDummyRequest() {
        ExergyLogin_Req_IB_v1 requestBean = new ExergyLogin_Req_IB_v1();
        requestBean.Login = new ExergyLogin_Req_IB_v1.Login();
        requestBean.Login.PobjUser = new ExergyLogin_Req_IB_v1.PobjUser();
        requestBean.Login.PobjUser.Password = 'Password1';
        requestBean.Login.PobjUser.SessionID = '18adf2f0-7366-4b50-807f-be93cfa21b95';
        requestBean.Login.PobjUser.UserName = 'test1';

        return requestBean;
    }
}