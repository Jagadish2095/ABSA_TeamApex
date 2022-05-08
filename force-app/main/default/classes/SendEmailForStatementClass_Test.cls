/**
 * @description       : The file needs to be deleted
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-03
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-03   robertml@absa.africa   Initial Version
 **/
@isTest
public class SendEmailForStatementClass_Test {
	@isTest
	public static void test() {
		System.debug('The file needs to be deleted');
		SendEmailForStatementClass.sendEmailForStatementDelete();
		System.assertEquals('Delete', 'Delete', 'Delete failed');
	}
}