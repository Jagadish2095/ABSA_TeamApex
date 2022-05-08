@isTest 
private class AuditTrailLogTest {

    @isTest
    private static void testlogException() {
        
        try {
            throw new TestException();
        } catch (Exception e) {    
            AuditTrailLog.logException(e, 'Test Status', 'Test Severity', 'Test classname', 'Test method', 'Test DevNote');
        }    
        
    }
 
public class TestException extends Exception { }  
 
}