/**
 * @description       : Jabulani Mashia
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-1o-16
 * @last modified by  : Brian Maswanganyi
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-15   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-11   André Pietersen (IQ Business)   Pricing expansion
 * 
 **/
@isTest
public class FnBSynopsisTest {
	@testSetup
	static void makeData() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			ROAProduct__c product = new ROAProduct__c();
			product.Name = 'Test';
			product.ProductId__c = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE';
			product.Description__c = 'Gold Package';
			product.Code__c = '11032';
			product.PackageChargeOption__c = 'CQT01S48';
			product.Synopsis__c = 'A transactional account vehicle that allows you to have an affordable Silver, Gold or Platinum Value Bundle pricing option. Each Value Bundle is simple to understand and unique in its design, offering a pricing option that suits your need. You can now take control of your bank charges and benefit from discounts on your monthly management fee, cash backs, option to apply for a credit card, overdraft facilities and numerous other value added benefits.';
			insert product;

			ROAFeature__c feature1 = new ROAFeature__c();
			feature1.Recommended_Income__c = 'R4 000.00';
			feature1.Montly_Fee__c = 'R149.00';
			feature1.Pdf_Url__c = 'http://oneintranet.intra.absaafrica/sites/ppsg/Product%20Information%20UAT/Gold%20Package.pdf';
			feature1.Name = 'Gold Package';
			insert feature1;
		}
	}
	@isTest
	public static void CheckWhenProductListAlternativeHappydayScenario() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			Test.startTest();
			String products = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE';
			List<FnbSynopsesWrapper.Product> resp = FnbSynopses.getProductDetails(products);
			System.assert(resp != null, 'Test failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void NullCheckTestForGoldValueBundle() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			Test.startTest();
			String products = 'PRIVATE_BANKING_ACCOUNT_PRIVATE_BANKING_FOR_YOUNG_PROFESSIONALS,PRIVATE_BANKING_ACCOUNT_PRIVATE_BANKING_ONE,PRIVATE_BANKING_ACCOUNT_PRIVATE_BANKING_TWO,PRIVATE_BANKING_ACCOUNT_BANKING_SPOUSAL_ACCOUNT,ABSA_PROSPERITY,PRIVATE_BANK_SENIORS,ISLAMIC_CHEQUE_GOLD_GRADUATE,ISLAMIC_CHEQUE_GOLD_VALUE_BUNDLE,ISLAMIC_CHEQUE_GOLD_VALUE_BUNDLE_PLUS,ISLAMIC_CHEQUE_PREMIUM_BANKING,ISLAMIC_CHEQUE_PREMIUM_BANKING_PLUS,ISLAMIC_CHEQUE_GOLD_SPOUSE_VALUE_BUNDLE';
			List<FnbSynopsesWrapper.Product> fnbSynopsesList = FnbSynopses.getProductDetails(products);
			System.assert(fnbSynopsesList != null, 'Test failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void CheckWhenMismatchedDescription() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			Test.startTest();
			String products = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
			List<FnbSynopsesWrapper.Product> fnbSynopsesList = FnbSynopses.getProductDetails(products);
			System.assert(fnbSynopsesList.size() > 0, 'Test failed');
			Test.stopTest();
		}
	}

	@isTest
	public static void CheckWhenProductListHappydayScenario() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			Test.startTest();
			String products = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
			List<FnbSynopsesWrapper.Product> fnbSynopsesList = FnbSynopses.getProductDetails(products);
			System.assert(fnbSynopsesList.size() > 0, 'Test failed');
			Test.stopTest();
		}
	}
}