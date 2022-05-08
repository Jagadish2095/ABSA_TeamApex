@isTest
public class JSONifyTestClass {
    private static testmethod void testfirst() {
    	User u = [Select id, email, title, lastNAME, mobilephone From User Where id = :userInfo.getUserId()];
        Contact c = new Contact();
        c.lastName = 'Jones';
        insert c;
        
        map<string, string> defaults = new map<string, string>();
        defaults.put('sender','Salesforce');
        defaults.put('language','en');
        defaults.put('silent','false');
        defaults.put('disableWebSigning','false');
        defaults.put('emailNotifications','ALWAYS');
        defaults.put('schedule','WORKFLOW');
        defaults.put('custom_returnType','email');
        
    	ContentVersion cv = new ContentVersion();
        cv.title = 'test';
        cv.versionData = EncodingUtil.base64Decode('test');
        cv.pathOnClient = 'test';
        insert cv;
        
        string resp = JSONify.getRequestBodyForCreatePDFSignatureRequestEvent(false, defaults, u, new Signatory(c),cv);	
        string apiResp = ImpressionApiWrapper.createPDFSignatureRequestEvent('4U70WZqKUq4zYAkwLojHU1gjQUSR0Cs2bz7cYAta',resp);
        system.assert(apiResp != null && resp != null);
        
        System.assert(JSONify.getRequestBodyForDesignDocReplace('bidSet') != null);
        //System.assert(JSONify.getDocFromAuditResponse('bidSet') != null);
        List<String> ls = new List<String>();
        ls.add('Test');
        System.assert(JSONify.getRequestBodyForAddArbitraryTag(ls, 'bidSet') != null);
        JSONify.debugAll('bidSet');
    }
    
    private static testmethod void testInline() {
        ContentVersion cv = new ContentVersion();
        cv.title = 'test';
        cv.versionData = EncodingUtil.base64Decode('test');
        cv.pathOnClient = 'test';
        insert cv;
        
        User u = [Select id, email, title, lastNAME, mobilephone From User Where id = :userInfo.getUserId()];
        Contact c = new Contact();
        c.lastName = 'Jones';
        insert c;
        
        list<list<Signatory>> sigs = new list<list<Signatory>>();
        list<Signatory> inn = new list<Signatory>();
        for (integer k=0;k<5;k++){
            Signatory s = new Signatory(c);
            inn.add(s);
        }
        sigs.add(inn);
        
        map<string, string> chal = new map<string, string>();
        chal.put('challenge','a');
        chal.put('answer','b');
        
        string resp = JSONify.getRequestBodyForCreateInlineSignatureWorkflow(sigs, u, cv, chal, '','');
        string apiResp = ImpressionApiWrapper.createInlineSignatureWorkflow('4U70WZqKUq4zYAkwLojHU1gjQUSR0Cs2bz7cYAta', resp);
		system.assert(apiResp != null && resp != null);        
    }
    
    private static testmethod void testGetRequestBodyForGetRoles() {
        string resp = JSONify.getRequestBodyForGetRoles('test');
        
        system.assert(resp != null);
        
        string apiResp = ImpressionApiWrapper.getRoles('4U70WZqKUq4zYAkwLojHU1gjQUSR0Cs2bz7cYAta', resp);
        
        list<string> parsedResponse = JSONify.parseGetRolesResponse(apiResp);
        system.assert(parsedResponse != null && apiResp != null);
    }
    
    private static testmethod void testGetRequestBodyForDesignDocReplace() {
        list<string> theList = new list<string>();
        theList.add('frist');
        theList.add('second');
        string resp = JSONify.getRequestBodyForDesignDocReplace(theList, 'test');
        
        string apiResp = ImpressionApiWrapper.designDoc('4U70WZqKUq4zYAkwLojHU1gjQUSR0Cs2bz7cYAta', resp);
        system.assert(apiResp != null && resp != null);
    }
    private static testmethod void testGetRequestBodyForWorkflowRequest() {
		list<list<string>> sigs = new list<list<string>>();
        list<string> inn = new list<string>();
        for (integer k=0;k<5;k++){
            inn.add('hello');
        }
        sigs.add(inn);       
        
        string resp = JSONify.getRequestBodyForWorkflowRequest(sigs);
        
        string apiResp = ImpressionApiWrapper.createWorkflow('4U70WZqKUq4zYAkwLojHU1gjQUSR0Cs2bz7cYAta', resp);
        system.assert(apiResp != null && resp!=null);
    }
    private static testmethod void testParseSignatureAuditTrailResponse(){
        string req =  '{"count": 1,"items": [{"Step": 1,"SignatureRequestID": "30f14ed5-4a1d-45dc-a3f4-256a294f8ce8","EventStatus": "RUNNING","LastUpdated": "2019-05-20T06:54:54.202470"}],"workflowID": "889d30d7-c1d8-4650-bf1b-d0f83546f6ac"}';
    	AuditRequest resp = JSONify.parseSignatureAuditTrailResponse(req);
        list<string> resp2 = JSONify.parseSigAuditResponse(req);
        system.assert(resp != null && resp2 != null);
    }
    private static testmethod void testGetSignatureIdsFromInlineWorkflowResponse() {
        string req =  '{"count": 1,"items": [{"Step": 1,"SignatureRequestID": "30f14ed5-4a1d-45dc-a3f4-256a294f8ce8","EventStatus": "RUNNING","LastUpdated": "2019-05-20T06:54:54.202470"}],"workflowID": "889d30d7-c1d8-4650-bf1b-d0f83546f6ac"}';
    	list<string> resp = JSONify.getSignatureIdsFromInlineWorkflowResponse(req);
        system.assert(resp != null);
    }
}