/**
 * @description       : Integration Handler for CIS
 * @author            : Mohammed Junaid
 * @group             :
 * @last modified on  : 2021-12-07
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log
 * Ver   Date         Author            Modification
 * 1.0   2021-05-24   Mohammed Junaid   Initial Version
**/

public class CIS_IH_v1 {

    private static final string APINAME = 'Jitterbit2';
    private static final string LOGIN_PATH = 'Channel Integration Login';
    private static final string DOC_UPLOAD_PATH = 'Channel Integration Add';
    private static final string GET_DOC_PATH = 'Channel Integration Get';
    private static final string LOGOUT_PATH = 'Channel Integration Logout';

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-12-07 
    * @param fileName 
    * @param documentType 
    * @param attach 
    * @param acc 
    * @param subDocumentType 
    * @param fromGoldenSource 
    * @param body 
    * @param jointCIF 
    * @return CIS_AddDocResult_IB_v1 
    **/
    public static CIS_AddDocResult_IB_v1 uploadDocument(string fileName, string documentType, attachment attach, account acc, string subDocumentType, string fromGoldenSource, String body , string jointCIF){
        CIS_LoginResult_IB_V1 login = getLoginCredentials();
        CIS_AddDocRequest_IB_v1 addDocRequest = CIS_IU_v1.mapAddDocRequestFields(login, fileName, documentType, attach, acc,subDocumentType, fromGoldenSource,body,jointCIF);
        CIS_AddDocResult_IB_v1 responseBean = (CIS_AddDocResult_IB_v1) Sys_Utilities_Integration.integrationServiceCall(addDocRequest, null, DOC_UPLOAD_PATH, CIS_AddDocResult_IB_v1.class);
        return responseBean;
    }


    /**
    * @description Get Document from Amber
    * @param pid
    * @return CIS_GetDocResult_IB_V1
    **/
    public static CIS_GetDocResult_IB_V1 downloadDocument(String pid){
        CIS_LoginResult_IB_V1 login = getLoginCredentials();
        CIS_GetDocRequest_IB_V1 getDocRequest = CIS_IU_v1.mapGetDocRequestfields(login, pid);
        CIS_GetDocResult_IB_V1 responseBean = (CIS_GetDocResult_IB_V1) Sys_Utilities_Integration.integrationServiceCall(getDocRequest, null, GET_DOC_PATH, CIS_GetDocResult_IB_V1.class);
        return responseBean;
    }

     /**
    * @description Get Document from Amber
    * @param pid
    * @param keepDoc
    * @return CIS_GetDocResult_IB_V1
    **/
    public static CIS_VerifyDocument_IB_Resp_v1 verifyDocument(String pid , boolean keepDoc){
        string SERVICE_NAME = 'VerifyDocument';
        CIS_LoginResult_IB_V1 login = getLoginCredentials();
        CIS_VerifyDocuments_IB_Req_v1 requestBean = new CIS_VerifyDocuments_IB_Req_v1();
        requestBean.Token = login.Token;
        requestBean.DocumentPid = pid;
        requestBean.KeepDocument = keepDoc;
        
        CIS_VerifyDocument_IB_Resp_v1 responseBean = (CIS_VerifyDocument_IB_Resp_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, SERVICE_NAME, CIS_VerifyDocument_IB_Resp_v1.class);
        return responseBean;
    }

    /**
    * @description Method to get Login token from CIS
    * @return CIS_LoginResult_IB_V1
    **/
    public static CIS_LoginResult_IB_V1 getLoginCredentials(){
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(APINAME, Sys_Utilities_General.getEnvironment(), LOGIN_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> credentials = new Map<String, String>();
        String[] usernameStore = service.Username__c.split('@');
        credentials.put('username', usernameStore[0]);
        credentials.put('password', service.Password__c);
        credentials.put('store', usernameStore[1]);

        //creating the request to get the login token from AMBER
        CIS_LoginRequest_IB_V1 logRequest = new CIS_LoginRequest_IB_V1();
        CIS_LoginRequest_IB_V1.LoginRequest loginRequest = new CIS_LoginRequest_IB_V1.LoginRequest();
        loginRequest.Datastore = credentials.get('store');
        loginRequest.UserName = credentials.get('username');
        loginRequest.Password = credentials.get('password');
        logRequest.LoginRequest = loginRequest;

        //string jsonString = json.serializepretty(logRequest);
       /* HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(api ,service , jsonString); */
         CIS_LoginResult_IB_V1 responseBean = (CIS_LoginResult_IB_V1) Sys_Utilities_Integration.integrationServiceCall(logRequest, null, LOGIN_PATH, CIS_LoginResult_IB_V1.class);
        return responseBean;

        }
}