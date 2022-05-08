/**
 * @description Test Class for DigitalSignatureAdminsSelector
 *
 * @author Vladimir Panajic
 * @since 2019-10-21
 *
 **/
@isTest
public class DigitalSignatureAdminsSelectorTest{
	@isTest
	public static void getSObjectType(){
		Schema.SObjectType newSchema = new DigitalSignatureAdminsSelector().getSObjectType();
		system.assertNotEquals(null, newSchema);
	}

	@isTest
	public static void getSObjectFieldList(){
		List<Schema.SObjectField> fieldsList = new DigitalSignatureAdminsSelector().getSObjectFieldList();
		system.assertNotEquals(null, fieldsList);
	}

	@isTest
	public static void selectDigitalSignatureAdminByType(){
		List<Digital_Signature_Admin__c> adminList = new DigitalSignatureAdminsSelector().selectDigitalSignatureAdminByType('Record of Advice');
		system.assertNotEquals(null, adminList);
	}
}