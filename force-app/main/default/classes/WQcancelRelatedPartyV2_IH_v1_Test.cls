/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-29-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class WQcancelRelatedPartyV2_IH_v1_Test {
  public static final String POSITIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Related party ref 121211010 has been delinked to primary ref "}';
  public static final String NEGATIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success"}';
  /**
   * @description  make dummy data
   * 
   */
  @testSetup
	public static void makeData() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
	//	Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
  Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
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
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CASA_CANCEL_RELATED_PARTY_V7});
	}
  private static WQcancelRelatedPartyV2_Resp_IB_v1 callCancelMethod() {
    WQcancelRelatedPartyV2_Req_IB_v1    dummyBean = WQcancelRelatedPartyV2_Req_IB_v1.createDummyRequestV3();
    WQcancelRelatedPartyV2_Resp_IB_v1  responseBean = WQcancelRelatedPartyV2_IH_v1.cancelRelatedParty(dummyBean);
       return responseBean;
   }
  
@isTest
    public static void cancelrelatedPositive() {
 
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NEGATIVE_RESPONSE_BODY));
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
            // Set mock callout class
        
        System.runAs(au) {
        Test.startTest();
        WQcancelRelatedPartyV2_Resp_IB_v1 response = callCancelMethod();// WQcancelRelatedPartyV2_IH_v1.cancelRelatedParty(request);
        System.assert(response.statusCode == 200,'assert failed'); 
          Test.stopTest();
        }
 }
 @isTest 
 public static void cancelrelatedNegaitive() {
 
  Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
      // Set mock callout class
  
  System.runAs(au) {
  Test.startTest();
  WQcancelRelatedPartyV2_Resp_IB_v1 response = callCancelMethod();// WQcancelRelatedPartyV2_IH_v1.cancelRelatedParty(request);
    
  System.assert(response.message== null,'assert failed'); 
    Test.stopTest();
  }
}
}