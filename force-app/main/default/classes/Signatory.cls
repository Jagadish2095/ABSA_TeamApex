public class Signatory{
    public class SigAuditResponse {
        public string event {get;set;}
        public string updated {get;set;}
        public SigAuditResponse(string s) {
            list<string> ls = s.split(',');
            event= ls[0];
            updated=ls[ls.size()-1];
        }
    }

    public void addSigAuditResponse(list<string> s) {
        for (string str : s) {
            listOfSigAuditResponse.add(new SigAuditResponse(str));
        }

        for (integer out=0;out<listOfSigAuditResponse.size()-1;out++) {
            for (integer inn=out+1;inn<listOfSigAuditResponse.size();inn++) {
                if (listOfSigAuditResponse[out].updated>listOfSigAuditResponse[inn].updated) {
                    sigAuditResponse temp = listOfSigAuditResponse[out];
                    listOfSigAuditResponse[out] = listOfSigAuditResponse[inn];
                    listOfSigAuditResponse[inn] =temp;
                }
            }
        }
    }

    private Contact c;
    public string role {get;set;}
    public string signatureRequestId;
    public string signedStatus {get;set;}
    public integer step;
    public string customMessage {get;set;}
    public list<sigAuditResponse> listOfSigAuditResponse {get;set;}
    public string challenge;
    public string answer;
    public string contactInfo {get;set;}

    public Signatory(Contact c) {
        this.c = c;
        signatureRequestId = '';
        signedStatus = 'UNKNOWN';
        listOfSigAuditResponse = new list<sigAuditResponse>();
        challenge='';
        answer='';
    }

    public string getLastName() {
        return c.lastName;
    }
    public void setLastName(string ln) {
        c.lastName=ln;
    }
    public string getTitle(){
        return c.salutation;
    }
    public void setTitle(string t) {
        c.salutation = t;
    }

    public string getMobilephone(){
        return c.mobilePhone;
    }
    public void setMobilephone(string m) {
        c.mobilePhone = m;
    }
    public string getEmail(){
        return c.email;
    }
    public void setEmail(string e) {
        c.email = e;
    }
    public string getId(){
        return c.id;
    }
}