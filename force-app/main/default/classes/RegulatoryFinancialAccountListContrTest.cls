/**
 * @description Test Class for RegulatoryFinancialAccountListContr
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2021-03-08
 */
@isTest
public class RegulatoryFinancialAccountListContrTest {
	@isTest
	static void getProductsList() {
		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		List<Regulatory_Financial_Account__c> displayproductList = RegulatoryFinancialAccountListContr.getProductsList(
			pricingTestDataFactory.opportunity.id,
			'Opportunity'
		);
		system.assertNotEquals(null, displayproductList);
		Test.stopTest();
	}

	@isTest
	static void getProductsListNeg() {
		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
		system.assertNotEquals(null, pricingTestDataFactory);
		Test.startTest();
		try {
			List<Regulatory_Financial_Account__c> displayproductList = RegulatoryFinancialAccountListContr.getProductsList(
				pricingTestDataFactory.opportunity.id,
				'Opportunity'
			);
		} catch (Exception ex) {
			System.debug(ex);
		}
		Test.stopTest();
	}
}