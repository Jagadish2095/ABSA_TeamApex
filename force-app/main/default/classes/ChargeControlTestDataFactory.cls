/**
 * @description Test Data Factory class for Charge Control records
 * @author  Koketso Mpshane
 * @date    25/08/2021
 */
@isTest
public class ChargeControlTestDataFactory {

    /**
 	* @description Test Data Factory create Charge Control records
	* @return List<Charge_Control__c>
	*/
    public static List<Charge_Control__c> chargeControlRecords(){

		List<Charge_Control__c> chargeControls = new List<Charge_Control__c>();

        for(Integer c = 1; c < 5; c++) {
            Charge_Control__c rec = new Charge_Control__c();
            rec.Charge_Month__c = '20210' + c;
            rec.Charge_Account_Number__c = '0000001234567892';
            rec.Charge_Process_Code__c = '000' + c;
            rec.Charge_Process_Date__c = system.now();
            chargeControls.add(rec);
        }

        return chargeControls;
    }

    /**
 	* @description Test Data Factory create Charge Control record
	* @return Charge_Control__c
	*/
    public static Charge_Control__c createChargeControlRecord(){

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
		account.CIF__c = 'MULLEBM001';
		account.Telebanking_Charge_Account_Number__c = '0000001234567893';
		insert account;

		String currentMonth = String.valueOf(Date.Today().Month());

		Charge_Control__c chargeControl = new Charge_Control__c();
		chargeControl.Composite_Key__c = currentMonth + String.valueOf(account.Id);
		chargeControl.Charge_Month__c = currentMonth.leftPad(6, '0');
		chargeControl.Account__c = account.Id;
		chargeControl.Charge_Account_Number__c = account.Telebanking_Charge_Account_Number__c;
		insert chargeControl;

        return chargeControl;
    }

}