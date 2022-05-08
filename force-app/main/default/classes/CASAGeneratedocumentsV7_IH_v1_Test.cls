/**
 * @description       : Test Class for CASAGeneratedocumentsV7_IH_v1_Test
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
**/
@isTest
public class CASAGeneratedocumentsV7_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY_GENDOCS = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"0","VersionNo":"0","msgNo":"564","msg":"Risk Profiling for supplied reference number was not completed. Cannot continue"}}}}';
    public static final String NULL_RESPONSE_BODY_GENDOCS = '{""}';
    public static final String NULL_VERSION_RESPONSE_BODY_GENDOCS = '{"Envelope":{"Body":{"GetDocsResponse":{"DocNo":"0","msgNo":"564","msg":"Risk Profiling for supplied reference number was not completed. Cannot continue"}}}}';

    @TestSetup
    static void setup(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CASAGeneratedocumentsV7_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest
    public static void PositiveCallTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,POSITIVE_RESPONSE_BODY_GENDOCS ));
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsByRefNumber('214512');
			System.assert(res.length() > 0, 'Generate documents failed');
			Test.stopTest();
        }
    }

    @isTest
    public static void NullBodyResponseTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING,NULL_RESPONSE_BODY_GENDOCS ));
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsByRefNumber('214512');
			System.assert(res.contains('Error : CASAGeneratedocumentsV7 Null Response'), 'Incorrect Generate documents Error');
			Test.stopTest();
        }
    }

    @isTest
    public static void NullVersionResponseTest() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING,NULL_VERSION_RESPONSE_BODY_GENDOCS ));
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			string res = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsByRefNumber('214512');
			System.assert(res.contains('Error : CASAGeneratedocumentsV7 Version number was not returned'),res);
			Test.stopTest();
        }
    }
}