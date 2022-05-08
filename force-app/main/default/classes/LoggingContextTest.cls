@isTest
public class LoggingContextTest {

	@isTest
	public static void shouldAddAndClearLogItem() {
		LoggingContext.stash(new Sys_Log_Integration__c());
		System.assert(LoggingContext.getLogs() != null);
		System.assert( 1 == LoggingContext.getLogs().size());
		LoggingContext.clear();
		System.assert( 0 == LoggingContext.getLogs().size());
	}
	
	@isTest
	public static void shouldFlushLogItem() {
		LoggingContext.stash(new Sys_Log_Integration__c());
		System.assert(LoggingContext.getLogs() != null);
		System.assert( 1 == LoggingContext.getLogs().size());
		LoggingContext.flush();
		System.assert( 0 == LoggingContext.getLogs().size());
	}

}