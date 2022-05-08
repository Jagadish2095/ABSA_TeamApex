/**
 * @description       : Test class for CreditGroupViewController class
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-07-05   Himanshu.Nimje@absa.africa   Initial Version
 **/

@isTest
public class CreditGroupViewControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"NBSAPDPO":{"NBSAPLO":{"NBNAPLO_REASON_CODE":0,"NBNAPLO_RETURN_CODE":0,"NBNAPLO_SERVICE_VERSION":"BUSO001"}},"GSB025O":{"GSB025O":{"GSB025O_ULT_PRIMARY_CLIENT":"ALAGENC003","GSB025O_NO_OF_CLIENTS":17,"GSB025O_GROUP_DETAIL":[{"GSB025O_STATUS_IND":"","GSB025O_GROUP_NUM":1,"GSB025O_CLIENT_LINK":"ALAGENC003","GSB025O_PRIM_OR_GRPMEM":"P"},{"GSB025O_STATUS_IND":"","GSB025O_GROUP_NUM":1,"GSB025O_CLIENT_LINK":"ALAGENC003","GSB025O_PRIM_OR_GRPMEM":"G"} ]}}}';

	/**
	 * @description Data Creation
	 * @author Himanshu.Nimje@absa.africa | 2021-07-05
	 **/
	@testSetup
	public static void dataCreation() {
		Account account = new Account();
		account.Name = 'Absa Bank';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'ADHAUS 003';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
		insert account;

		IntegrationTestDataFactory.insertIntegrationSettings(
			ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME,
			new List<String>{ GBgetCmsFullCrGroups_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			CQgetOverdraftDetailsV4_IH_v1.INTEGRATION_SERVICE_NAME,
			new List<String>{ CIgetClientDetailsV12_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	public static void testCreditGroupViewContrl() {
		List<Account> accList = [SELECT Id, CIF__c FROM Account LIMIT 1];
		GBgetCmsFullCrGroups_IH_v1_Test.cmsCreditGroupTestMock();
		Test.startTest();
		Account acc = CreditGroupViewController.getAccounts(accList[0].Id);
		string accName = CreditGroupViewController.getClientName(accList[0].CIF__c);
		List<CreditGroupViewController.CreditGrpViewWrapper> lstGrpView = CreditGroupViewController.GetCreditGroupView(accList[0].Id);
		System.assertNotEquals(null, lstGrpView);
		Test.stopTest();
	}

	@isTest
	public static void testCreditGroupViewContrl1() {
		Test.startTest();
		string accName = CreditGroupViewController.getClientName('ADHAUS 003');
		System.assertNotEquals(null, accName);
		Test.stopTest();
	}
}