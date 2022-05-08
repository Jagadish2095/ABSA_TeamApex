/**
 * @description       : PackageFeeServiceControllerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-28
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-09-13   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-09-27   André Pietersen (IQ Business)   Added cheque service
**/
@isTest
public class PackageFeeServiceControllerTest {
    public static final String POSITIVE_RESPONSE_BODY = '{"CAS096O": {"can096oOutPutArea": { "wkOptInstalItems": 73.80, "wkCrlIntRate": 17.500, "wkClientDialCode": 0,            "wkInstalPaymentMWO": "M",            "wkCrProviderNM": "ABSA CARD",            "wkBlInstal": 0.00,            "wkDateAdded": 0,            "wkBlInstalXtras": 0.00,            "wkCrProviderTel": "11 501-5050",            "wkBlTotFees": 0.00,            "wkAccountFee": 25.00,            "wkCrProviderAddr4": "0001",            "wkCrProviderAddr3": "PRETORIA",            "wkMonthlyServiceFee": 0.00,            "wkCrProviderAddr2": "",            "wkCrProviderAddr1": "P O BOX 3915",            "wkiResult": "00",            "wkQuoteGenReturnCode": "",            "wkCrlInstal": 1500.00,            "wkRbpInd": "N",            "wkTotalCredit": 18000,            "wkInitFee": 0.00,            "wkOptInstalDesc": "",            "wkClientTel": "",            "wkCrlTotFees": 0.00,            "wkiNewStatus": "OFF",            "wkBlTotInterest": 0.00,            "wkVariableIntMarkup": 14.000,            "wkactType": "INT",            "wkAcctTypeDesc": "ABSA GOLD CARD VISA GOLD CREDIT CARD",            "wkTotAllInstals": 0.00,            "wkClpPct": 0.41,            "wkSurname": "",            "wkCrlTotAllInstal": 21150.00,            "wkQuoteCurrentStat": "OFF",            "wkBlIntRate": 0.000,            "wkLcpFee": 0.00,            "wkClientLang": "",            "wkCrlTotInterest": 3150.00,            "wkName": "",            "wkClientAddr1": "",            "wkClientAddr3": "",            "wkDateUpdated": 1210928,            "wkClientAddr2": "",            "wkClientAddr4": "",            "wkCrlNbrInstal": 12,            "wkCrlInstalXtras": 262.50,            "wkClpAmt": 73.80,            "wkTotInterestFees": 3150.00,            "wkiQuoteNumber": 0,            "wkBlTotAllInstal": 0.00        }    }}';
    public static final String POSITIVE_RESPONSE_BODY_CHEQUE = '{"IPCBPTariffEnquiryResponse": {"GroupCode": {"ChargeCode": [{"BaseFee": null, "ChargeDescription": "Monthly Account Fees",                    "MaxCharge": "R999999999.99",                    "MinCharge": "R0.00",                    "MinTierMaxTier": "Balance R-99999999999999.99999999 to R29999",                    "Rate": "R109.00"                },                {                    "BaseFee": null,                    "ChargeDescription": "Monthly Account Fees",                    "MaxCharge": null,                    "MinCharge": null,                    "MinTierMaxTier": "Balance greater than R29999",                    "Rate": "R54.50"                }            ],            "GroupDescription": "Monthly Fees"        },        "accountId": null,        "accountName": null,        "accountType": null,        "cifKey": null,        "clientName": null,        "enquiryDate": "28/09/2021",        "groupLeaderkey": "N/A",        "negScheme": null,        "nextCapDate": null,        "pricingScheme": "Gold Package",        "returnCode": 0    }}';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CAactionQuotationV6_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ IPCBPTariffEnquiry_IH_v1.INTEGRATION_SERVICE_NAME });

		Product2 prod = new Product2(Name = 'Gold Package', Product_System__c = 'Package Fee System');
		insert prod;

        ROAFeature__c feature = new ROAFeature__c(Name = 'Gold Package');
		insert feature;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;
	}
    @isTest
	static void testPositive() {
		// Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CHEQUE));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Product2 product = [SELECT Name FROM Product2 WHERE Name = 'Gold Package'];
		Test.startTest();
		ProductSystemDetails response = PackageFeeServiceController.callProductSystem(product.Id);
		System.assert(response != null, 'Test unsuccessful');
		Test.stopTest();
	}
}