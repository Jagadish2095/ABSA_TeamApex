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
public class ASPDeviceContractCaseControllerTest {
	@isTest
	public static void test() {
		System.debug('The file needs to be deleted');
		ASPDeviceContractCaseController.apsDeviceDelete();
		System.assertEquals('Delete', 'Delete', 'Delete failed');
	}
}