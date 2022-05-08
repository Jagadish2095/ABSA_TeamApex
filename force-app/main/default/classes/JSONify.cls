//this subclass handles the data of the request body.
//the wrapper will pass in data sources and then we can ask for a requestBody for whatever type of api
//call we wish to make
public class JSONify{
    //c'tor sets up default values that are overwritten when setValues is called
    //once I have a better idea of the endpoints and how the api works, I'll rethink
    //how I manage default values

    //constructs a requestBody string that is required for this particular endpoint
    public static string getRequestBodyForCreatePDFSignatureRequestEvent(boolean first, map<string, string> defaults, User sender, Signatory recipient, ContentVersion file)
    {
        string requestBody  ='{"title": "'+recipient.getTitle()+'","surname": "'+recipient.getLastname()+'","sender": "'+defaults.get('sender')+'",'
            +'"docName": "'+file.title+'","docType": "'+file.fileExtension+'","email": "'+recipient.getEmail()+'",'
            +'"mobile": "'+recipient.getMobilephone()+'","language": "'+defaults.get('language')+'","silent": '+defaults.get('silent')+',"disableWebSigning": '+defaults.get('disableWebSigning')+','
            +'"emailNotifications": "'+defaults.get('emailNotifications')+'","schedule":"'+defaults.get('schedule')+'","custom": {'
            +'"returnType": "'+defaults.get('custom_returnType')+'","returnEmail": "'+sender.email+'"}';
            if (first){
                requestBody=requestBody+', "doc":"'+file.versionData+'"';
            }
            requestBody=requestBody+'}';
    
        return requestBody;
    }

    public static string getRequestBodyForGetRoles(string doc){
        string requestBody = '{"extension":"pdf", "doc":"';
        requestBody=requestBody+doc+'"}';
        return requestBody;
    }

    public static string getRequestBodyForDesignDocReplace(list<string> listOfTerms, string doc){
        string requestBody = '{"type":"REPLACE_TEXT", "sigs":[';
        //iterate through terms
        requestBody=requestBody+'{"signatureName":"'+listOfTerms[0]+'", "role":"';
        string role = listOfTerms[0].substring(listOfTerms[0].indexOf('_')+1,listOfTerms[0].length());
        requestBody=requestBody+role+'"}';
        for (integer i =1; i<listOfTerms.size(); i++){
            requestBody=requestBody+'{"signatureName":"'+listOfTerms[i]+'", "role":"';
            role = listOfTerms[i].substring(listOfTerms[i].indexOf('_')+1,listOfTerms[i].length());
            requestBody=requestBody+role+'"}';
        }
        requestBody = requestBody+'], "doc": "'+doc+'"}';

        return requestBody;
    }

    public static string getRequestBodyForDesignDocReplace(string doc){
        string prefix='imp_';
        string requestBody = '{"type":"PREFIX", "prefix":"'+prefix+'",';
        requestBody = requestBody+'"doc": "'+doc+'"}';

        return requestBody;
    }

    public static string getRequestBodyForWorkflowRequest(list<list<string>> requestIds){
        integer stepCount = requestIds.size();
        string requestBody = '{"stepCount": '+stepCount+','+'"steps": [';
        
        for (integer i=0;i<requestIds.size();i++){
            if (i>0)
                requestBody=requestBody+',';
            requestBody=requestBody+'{"id":'+i+',"condition":"ANY", "requestIDList":';
            requestBody=requestBody+'[';
            for (integer j=0; j<requestIds[i].size(); j++){
                if (j>0)
                    requestBody =requestBody +', ';
                requestBody =requestBody +'"' +requestIds[i][j]+'"';
            }
            requestBody=requestBody+']}';
        }
        requestBody =requestBody+ ']}';
        return requestBody;
    }

    public static string getRequestBodyForCreateInlineSignatureWorkflow(list<list<Signatory>> recipient, User sender, ContentVersion doc, map<string, string> challenge, string apiKey, string customResponse){        
        list<Signatory> flatList = new list<Signatory>();
        for (list<Signatory> subList : recipient) {
            for (Signatory sig : subList) {
                flatList.add(sig);
            }
        }
        
        string requestBody = '{"stepCount":'+flatList.size()+',"sender":"impression", "returnEmail":"'+sender.email+'",'+'"signatories":';

        list<string> sigsJson = new list<string>();
        for (Signatory s : flatList) {
            list<string> items = new list<string>(); 
            items.add('"title":"'+s.getTitle()+'"');
            items.add('"surname":"'+s.getLastname()+'"');
            items.add('"email":"'+s.getEmail()+'"');
            items.add('"mobile":"'+s.getMobilePhone()+'"');
            if (s.challenge!='') {
                items.add('"challenge":"'+s.challenge+'"');
                items.add('"answer":"'+s.answer+'"');
            }
            if (s.customMessage!= '') {
                items.add('"emailBody":"'+s.customMessage+'"');
            }
            items.add('"tags":[{"role":"'+s.role+'","name":"imp_'+s.role+'"}]');
            if (customResponse != '')
                items.add('"custom":'+customResponse+'"');
            string thisSig = String.join(items, ',');
            thisSig = '{'+thisSig+'}';
            sigsJson.add(thisSig);
        }
        string allSigs = String.join(sigsJson,',');
        allSigs = '['+allSigs+']';
        requestBody = requestBody+allSigs+',';          

        string fExt;
        if (doc.fileExtension == null)
            fExt = 'pdf';
        else
            fExt = doc.fileExtension;

        requestBody = requestBody + '"docName":"'+doc.title+'.pdf","docType":"application/'+fExt+'","doc":"';
        requestBody=requestBody+EncodingUtil.base64encode(doc.versionData)+'"}';
        //I need to log the whole of requestBody here..
        return requestBody;
    }

    public static list<string> getSignatureIdsFromInlineWorkflowResponse(string response) {
        list<string> sigIds = new list<string>();

        System.JSONParser parser = JSON.createParser(response);

        while (parser.nextToken()!=null) {
            if (parser.getText() == 'id'){
                parser.nextToken();
                sigIds.add(parser.getText());
            }
        }

        return sigIds;
    }

    public static list<string> parseGetRolesResponse(string apiResponse) {
        list<string> roles = new list<string>();

        System.JSONParser parser = JSON.createParser(apiResponse);

        while (parser.nextToken() != null) {
            if (parser.getText() == 'role'){
                parser.nextToken();
                roles.add(parser.getText());
            }
        }
        return roles;
    }

    public static AuditRequest parseSignatureAuditTrailResponse(string apiResponse){
        AuditRequest steps = new AuditRequest();

        System.JSONParser parser = JSON.createParser(apiResponse);

        integer step;
        string sigReq;
        string status;
        string lastUpdated;

        while (parser.nextToken() != null) {
            
            //get step keyword to get current step
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                parser.getText() == 'step') {

                parser.nextToken();
                step = parser.getIntegerValue()-1;
                //subtract 1 to use zero based counting like a normal person    
            }
            //get request id
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'SignatureRequestID')) {

                parser.nextToken();
                sigReq = parser.getText();
            }

            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'EventStatus')) {
                    
                parser.nextToken();    
                status = parser.getText();
            }

            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'LastUpdated')) {

                parser.nextToken();    
                lastUpdated = parser.getText(); 
                 //here we will add items to lists

                //if step is more than size of steps list, we need to add a new itemList to the steps list
                while (step >= steps.size()) {
                    list<Signatory> newItemList = new list<Signatory>();
                    steps.add(newItemList);
                }
                //now steps is larger. we can call set
                try{
                    SignatureRequest__c p = [Select ContactID__c From SignatureRequest__C Where signatureId__c = :sigReq];
                    Signatory item;
                    try{
                        Contact c = [Select salutation, lastName, email, mobilePhone From Contact Where id = :p.contactID__c];
                        item = new Signatory(c);
                    } catch (exception ex) {
                        item = new Signatory(new Contact());    
                    } 
                    item.signatureRequestId = sigReq;
                    item.signedStatus = status;
                    list<Signatory> currentList = steps.get(step);
                    currentList.add(item);
                    steps.set(step, currentList);
                } catch (exception ex) {
                    system.debug(ex);
                }
            }
        }
        return steps;
    }

    public static string getDocFromAuditResponse(string apiResponse) {
        string doc = '';
        SYSTEM.JSONParser parser = JSON.createParser(apiResponse);

        while (parser.nextToken() != null) {
            if (parser.getText() == 'data') {
                parser.nextToken();
                doc = parser.getText();
            }
        }

        return doc;
    }

    public static string getRequestBodyForAddArbitraryTag(list<string> r, string doc) {
        string requestBody = '{"type":"COORDINATES", "sigs":[';
        //iterate through terms
        requestBody=requestBody+'{"signatureName":"Impression_'+r[0]+'", "role":"';
        requestBody=requestBody+r[0]+'"}';
        for (integer i =1; i<r.size(); i++){
            requestBody=requestBody+'{"signatureName":"Impression_'+r[i]+'", "role":"';
            requestBody=requestBody+r[i]+'"}';
        }
        requestBody = requestBody+'], "doc": "'+doc+'"}';

        return requestBody;
    }

    public static list<string> parseSigAuditResponse(string resp){
        list<string> ret = new list<string>();
        System.JSONParser parser = JSON.createParser(resp);
        string event;

        while (parser.nextToken() != null){
            if (parser.getText() == 'EventStatus') {
                parser.nextToken();
                event = parser.getText();
            }
            if (parser.getText() == 'LastUpdated'){
                parser.nextToken();
                ret.add(event+','+parser.getText());
                system.debug('added '+event+', Last Updated: '+parser.getText());
            }
        }

        return ret;
    }

    public static void debugAll(string sMsg) {
        system.debug('Debug message start');
        for (Integer i = 0; i < sMsg.length(); i=i+300) {
            Integer iEffectiveEnd = (i+300 > (sMsg.length()-1) ? sMsg.length()-1 : i+300);
            System.debug(sMsg.substring(i,iEffectiveEnd));
        }
        system.debug('Debug message end');
    }
}