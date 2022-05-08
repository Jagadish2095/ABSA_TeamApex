//A wrapper for all api functions. 
//To use, just call the name of the endpoint with the required parameters.
public class ImpressionApiWrapper {

    public ImpressionApiWrapper(){}

    public static string getRoles(string apiKey, string body){
        string payload = runCallout(apiKey, body, 'https://mobile.impression.cloud/api/uat/GetRoles', 'POST');
        return payload;
    }

    public static string createWorkflow(string apiKey, string body)
    {
        string payload = runCallout(apiKey, body, 'https://mobile.impression.cloud/api/uat/CreateSignatureWorkflow', 'PUT');
        try {
            Map<String, object> jsonResp = (map<string, object>)JSON.deserializeuntyped(payload);
            String rId = jsonResp.get('workflowID').toString();
            return rId; 
        } catch (Exception ex) {
            system.debug(ex);
            return '';
        }
    }

    //initiates a connection to the rest endpoint, sets up the request and sends it
    public static string createPDFSignatureRequestEvent(string apiKey, string body)
    {
        string payload = runCallout(apiKey, body, 'https://mobile.impression.cloud/api/uat/CreatePDFSignatureRequestEvent', 'PUT');

        try {
            Map<String, object> jsonResp = (map<string, object>)JSON.deserializeuntyped(payload);
            String rId = jsonResp.get('requestID').toString();
            return rId;
        } catch (Exception ex) {
            system.debug(ex);
            return '';
        }
             
    }

    public static PageReference oauthGetToken() {
         //initialise httpRequest
        httpRequest req = new httpRequest();
        string callbackurl = 'https://mobile.impression.cloud/sdk/uat/Register/salesforce';
        string url = 'https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9L8AofS.N0y54cEqVBT27fX2C9f89xbxRCn25TqwT.WC7cTVDVi.H1zp0ZS2Lkc.dUP2pFFKwbsB8IAVu&redirect_uri='+callbackurl;

        req.setEndpoint(url);
        req.setMethod('POST');
        //set headers
        req.setHeader('content-type','application/json');
        //make request
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            //get response payload
            system.debug(res.getBody());
            list<string> h = res.getHeaderKeys();
            string redirectUrl = res.getHeader('Location');

            system.debug(redirectUrl);
            PageReference pageRef = new PageReference(redirectUrl);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (exception ex) { 
            system.debug(ex);
            return new PageReference('/home/home.jsp');
        }
    }

    public static string signatureAuditTrail(string apiKey, string param)
    {
        string payload = runCallout(apiKey, '', 'https://mobile.impression.cloud/api/uat/SignatureAuditTrail/workflow/'+param, 'GET');
        
        return payload;
    }

    public static string docReturn(string apiKey, string param) {
        string payload = runCallout(apiKey, '', 'https://mobile.impression.cloud/api/uat/SignatureAuditTrail/event/'+param+'/document', 'GET');
        return payload;
    }
    public static string signatureAuditRequest(string apiKey, string param) {
        string payload = runCallout(apiKey, '', 'https://mobile.impression.cloud/api/uat/SignatureAuditTrail/event/'+param, 'GET');
        return payload;
    }

    public static string createInlineSignatureWorkflow(string apiKey, string body)
    {
        string payload = runCallout(apiKey, body, 'https://mobile.impression.cloud/api/uat/CreateSignatureWorkflow/inlinesignaturerequest', 'PUT');
        return payload;
    }

    public static string designDoc(string apiKey, string body)
    {
        system.debug(body);
        string payload = runCallout(apiKey, body, 'https://mobile.impression.cloud/api/uat/DesignDocument', 'PUT');
        return payload;
    }

    private static string runCallout(string apiKey, string body, string url, string method)
    {
        //initialise httpRequest
        httpRequest req = new httpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        //set headers
        try {
            req.setHeader('x-api-key',apiKey);
        } catch (exception ex) {
            system.debug(ex);
        }
        req.setHeader('content-type','application/json');
        req.setTimeout(60000);
        //create and attach body
        if (body!='')
            req.setBody(body);
        //make request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        try {
            res = http.send(req); 
        } catch (Exception ex) {
            system.debug(ex);
        }
        //get response payload
        system.debug(res.getBody());
        return res.getBody();
    }
}