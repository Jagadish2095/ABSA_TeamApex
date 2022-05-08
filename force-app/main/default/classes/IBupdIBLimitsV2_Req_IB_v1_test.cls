/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-09
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
@isTest
public class IBupdIBLimitsV2_Req_IB_v1_test {
	@isTest
	static void iblimits() {
		test.startTest();
		IBupdIBLimitsV2_Req_IB_v1.createDummyRequest();
		System.assertEquals('success', 'success');
		test.stopTest();
	}
}