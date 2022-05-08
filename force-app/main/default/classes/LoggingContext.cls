/**
 * A class to hold logs for callouts performed in an Apex
 * execution context. The client that started this execution context 
 * is responsible for persisting these logs by calling the method
 * {@code LoggingContext#flush()}
 */
public class LoggingContext {

	public static List<Sys_Log_Integration__c> logs = new List<Sys_Log_Integration__c>();
	public static Boolean log = false;
	
	public static void start() {
		log = true;
	}
	
	public static void stash(Sys_Log_Integration__c log) {
		logs.add(log);
	}
	
	public static List<Sys_Log_Integration__c> getLogs() {
		return logs;
	}
	
	public static void clear() {
		logs.clear();
	}
	
	public static void flush() {
		if (!logs.isEmpty()) {
			insert logs;
			clear();
		}
		log = false;
	}

}