/**
 * @description       : Controller to generate contract request
 * @author            : Khaliq Abdul
 * @created 2021-10-18 
 * 1.0   2021-07-27   Khaliq Abdul
 */
@isTest
public class EcmDocumentListTest {
    
    @TestSetup
    static void makeData()
    {
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
            SiteCode__c ='8999',
			Advisor_Code__c = '112233'
		);
		insert au;
        
    }
    
    @isTest
	public static void validateEcmDocumentListTest() {
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
            string strJson ='{"DocumentList":[{"UploadMSG":"OK","ECMPID":"CIS_UAT 01307438CF9049829864370DFF2B9545","DocumentType":"IDDocument","DocumentSubType":"1","DocumentGUID":"9636de6f-474b-471f-9308-2f865c7f04c6","DocumentCode":"000001"},{"UploadMSG":"OK","ECMPID":"CIS_UAT 0CCBAED8259847D8B7DFA8D905B3618D","DocumentType":"ProofOfResidence","DocumentSubType":"1","DocumentGUID":"1e625c8c-5ecf-468b-93ce-bf18d82de173","DocumentCode":"000004"},{"UploadMSG":"OK","ECMPID":"CIS_UAT 0CD9E98576554A10B5BEAD3203A898E0","DocumentType":"Ent_AccountApplication","DocumentSubType":null,"DocumentGUID":"cefb3be7-3087-4939-a799-0787bb3e1f7b","DocumentCode":"000058"}]}';
			EcmDocumentList resp = EcmDocumentList.parse(strJson);
			System.assert(resp != null, 'Test Working');
			Test.stopTest();
		}
	}

}