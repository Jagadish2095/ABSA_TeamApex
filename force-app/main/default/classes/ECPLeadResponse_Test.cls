/**
 * @description       :
 * @author            : jacobuschristiaan.delange@absa.africa
 * @group             :
 * @last modified on  : 2021-05-27
 * @last modified by  : jacobuschristiaan.delange@absa.africa
 * Modifications Log
 * Ver   Date         Author                                  Modification
 * 1.0   2021-05-25   jacobuschristiaan.delange@absa.africa   Initial Version
 **/
@isTest
public class ECPLeadResponse_Test {
	@isTest
	static void testParse() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '6211275132089';
		accountList[0].AccountNumber = '6211275132089';
		accountList[0].Country_of_Citizenship__c = 'South Africa';
		accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
		accountList[0].Gender__pc = 'Male';
		accountList[0].FinServ__Status__c = 'InActive';
		insert accountList;
		system.assertEquals('ABSA TEST', accountList[0].LastName, 'assertion failed');

		String json = '{"updateAccount":{"activeAccount":{"ExecutionLayerRequestId":"12345678","AccountNo":"2456789632","LeadProductInterest":[{"Prod1":"Merchant Smartpay"},{"Prod2":"Protect your Employees"}],"FirstName":"firstnametest","DisplayName":"lastnametest","Email":"jitterbit5@email.com","Mobile":"829632356","AccountNoDateTime":"2021/05/07 9:28 AM"}}}';
		ECPLeadResponse obj = ECPLeadResponse.parse(json);
		ECPLeadRequest.ECPLeadRequestCall(accountList[0].Id, 'merchant', 'Active');
		System.assert(obj != null, 'object not null');
	}
}