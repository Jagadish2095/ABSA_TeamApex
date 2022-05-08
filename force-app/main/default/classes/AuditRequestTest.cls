@isTest
public class AuditRequestTest {
    private static testmethod void testAuditRequestCtor() {
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
        
        AuditRequest ar = new AuditRequest(sigs);
        system.assert(ar != null);
    }
    private static testmethod void testAuditRequestCtor2() {
        AuditRequest ar = new AuditRequest();
        system.assert(ar != null);
    }   
    private static testmethod void testSetAndGet() {
        User u = [Select id, email, title, lastNAME, mobilephone From User Where id = :userInfo.getUserId()];
        Contact c = new Contact();
        c.lastName = 'Jones';
        insert c;
        AuditRequest ar = new AuditRequest();
        
        list<Signatory> inn = new list<Signatory>();
        for (integer k=0;k<5;k++){
            Signatory s = new Signatory(c);
            inn.add(s);
        }
		ar.set(0, inn);        
        system.assert(ar.get(0) != null);
    }
    private static testmethod void testBasicSetGet() {
        AuditRequest ar = new AuditRequest();
        ar.docName = 'hello';
        ar.docId = 'test';
        ar.requestID = 'test';
        string docName = ar.getDocName();
        system.assert(docName == 'hello' && ar.getRequestId() == 'test');
    }
    private static testmethod void testAllComplete() {
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
        
        AuditRequest ar = new AuditRequest(sigs);
        system.assert(ar.allComplete() == false);
    }
    private static testmethod void testGetLast() {
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
        
        AuditRequest ar = new AuditRequest(sigs);
        system.assert(ar.getLastSigRequest() != null);        
    }
}