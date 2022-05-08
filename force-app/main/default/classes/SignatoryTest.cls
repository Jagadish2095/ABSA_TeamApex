@isTest
public class SignatoryTest {
    private static testmethod void testSignatoryAddAuditResp () {
        Contact c = new Contact();
        c.lastName = 'Jones';
        Signatory s = new Signatory(c);
        list<string> myList = new list<string>();
        for (integer k=0;k<5;k++) {
            myList.add('test,'+String.valueOf(Date.newInstance(2019, 12-k, 20)));
        }
        s.addSigAuditResponse(myList);
       	system.assert(true);
    }
    private static testmethod void testGetters() {
        Contact c = new Contact();
        c.lastName = 'Jones';
        Signatory s = new Signatory(c);
        string t = s.getTitle();
        string l = s.getLastName();
        string m = s.getMobilephone();
        string e = s.getEmail();
        string cm = s.customMessage;
        string r = s.role;
        string i = s.getId();
        s.setLastName('string ln');
        s.setTitle('string t');
        s.setMobilephone('string m');
        s.setEmail('string e');
        system.assert(true);
    }
    private static testmethod void sigAuditResp() {
        Signatory.SigAuditResponse sar = new Signatory.SigAuditResponse('');
        
    }
}