/******************************************************
 * 
 * Author : Tracy de Bruin
 * 
 * 14/06/2018 - TdB - 
 * 
 * ***************************************************/
public class AuditTrailLog 
{
    
    public static Exception_Audit_Trail__c auditTrail;
    
    public static void logException(Exception e, String status, String severity, String classname, String method, String devnote)
    {
        
        auditTrail = new Exception_Audit_Trail__c();  
        auditTrail.Severity__c = severity;
        auditTrail.Status__c = status;
        auditTrail.Class_Name__c = classname;
        auditTrail.Exception_Date_Time__c = System.now();
        if(e != null)
        {
            auditTrail.Line_Number__c = e.getLineNumber();
        	auditTrail.Stack_Trace__c = e.getStackTraceString();
            auditTrail.Exception_Message__c = e.GetMessage();
        }
        
        auditTrail.Method_Name__c = method;
        auditTrail.Developer_Notes__c = devnote;
        
        try{
            insert auditTrail;
            System.debug('Error was logged in the Exception_Audit_Trail Object');
            if(e != null)
            {
                System.debug(e.getMessage());
            }
            
        }catch(DMLException ex){
            System.debug('Error could not be logged in the audit trail object');
            System.debug(ex.getMessage());
            System.debug('Original Error below:');
            System.debug(e.getMessage());
        }
        
    }
}