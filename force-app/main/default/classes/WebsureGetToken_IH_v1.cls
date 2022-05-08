/*
 * Integration Handler for Websure Get Token Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class WebsureGetToken_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Websure Get Token Service';

    	public static WebsureGetToken_Resp_IB_v1 WebsureGetToken() {
        String userID='ABPB500';
		String sessionID = UserInfo.getSessionID();
		String content = '?'+'userID='+EncodingUtil.urlEncode(userID, 'UTF-8')+'&sessionID='+EncodingUtil.urlEncode(sessionID, 'UTF-8');
        WebsureGetToken_Resp_IB_v1 responseBean = (WebsureGetToken_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(null, content, INTEGRATION_SERVICE_NAME, WebsureGetToken_Resp_IB_v1.class);
        return responseBean;
    }	
}