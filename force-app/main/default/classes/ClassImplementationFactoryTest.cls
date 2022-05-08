/**
 * @description       : Class Implementation Factory Testclass
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
@isTest
public class ClassImplementationFactoryTest {
	/**
	 * @description       : Class Implementation Factory Testclass
	 **/
	@testSetup
	public static void setup() {
		String accountId = TestMetaDataFactory.insertTestObject('Account', 'BranchNTPAccount');
	}

	@isTest
	static void getClassImplementation() {
		String accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		Object casaScreenPrimaryClientHelper = (ICasaScreenPrimaryClientHelper) ClassImplementationFactory.getClassImplementation(
			'ICasaScreenPrimaryClientHelper',
			accountId
		);
		system.assert(casaScreenPrimaryClientHelper != null);
	}

	@isTest
	static void getClassImplementationByStringRef() {
		Object casaScreenPrimaryClientHelper = (Object) ClassImplementationFactory.getClassImplementationByStringRef('');
		system.assert(casaScreenPrimaryClientHelper != null);
	}
}