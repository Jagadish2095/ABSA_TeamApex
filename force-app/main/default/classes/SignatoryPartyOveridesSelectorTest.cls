/**
 * @description Test Class for SignatoryPartyOveridesSelector
 *
 * @author Vladimir Panajic
 * @since 2019-10-21
 *
 **/
@isTest
public class SignatoryPartyOveridesSelectorTest{
	@isTest
	public static void getSObjectType(){
		Schema.SObjectType newSchema = new SignatoryPartyOveridesSelector().getSObjectType();
        system.assertNotEquals(null, newSchema);
	}

	@isTest
	public static void getSObjectFieldList(){
		List<Schema.SObjectField> fieldsList = new SignatoryPartyOveridesSelector().getSObjectFieldList();
        system.assertNotEquals(null, fieldsList);
	}

	@isTest
	public static void getSignatoryPartyOverides(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Digital_Signature_Admin__c digitalSignatureAdmin = testDataFactory.testDigitalSignatureAdmin;
		Digital_Signature_Signatory__c digitalSignatureSignatory = testDataFactory.testDigitalSignatureSignatory;
		List<Signatory_Party_Overide__c> signatoryPartyOveride = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(testDataFactory.testOpportunity.id, testDataFactory.testDigitalSignatureSignatory.id, 1);
        system.assertNotEquals(null, digitalSignatureAdmin);
	}
}