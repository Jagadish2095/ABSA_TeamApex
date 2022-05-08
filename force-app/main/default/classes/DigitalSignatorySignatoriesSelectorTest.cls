/**
 * @description Test Class for DigitalSignatorySignatoriesSelector
 *
 * @author Vladimir Panajic
 * @since 2019-10-21
 *
 **/
@isTest
public class DigitalSignatorySignatoriesSelectorTest{
	/**
	 * @description getSObjectType description
	 *
	 */
	@isTest
	public static void getSObjectType(){
		Schema.SObjectType newSchema = new DigitalSignatorySignatoriesSelector().getSObjectType();
        system.assertNotEquals(null, newSchema);
	}

	/**
	 * @description getSObjectFieldList description
	 *
	 */
	@isTest
	public static void getSObjectFieldList(){
		List<Schema.SObjectField> fieldsList = new DigitalSignatorySignatoriesSelector().getSObjectFieldList();
        system.assertNotEquals(null, fieldsList);
	}

	/**
	 * @description selectSignatory description
	 *
	 */
	@isTest
	public static void selectSignatory(){
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		List<Digital_Signature_Signatory__c> signatoryList = new DigitalSignatorySignatoriesSelector().selectSignatory(testDataFactory.testDigitalSignatureAdmin.id);
        system.assertNotEquals(null, signatoryList);
		signatoryList = new DigitalSignatorySignatoriesSelector().selectSignatoryByRecordType(testDataFactory.testDigitalSignatureAdmin.id,testDataFactory.testOpportunity.RecordType.Name);
	}
}