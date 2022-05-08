/**
 * @description Test class for TransactionsFilterSelector.cls
 * @author Humbelani Denge
 */
@IsTest
public class TransactionsFilterSelectorTest {
	@TestSetup
	static void makeData() {
		Transaction_Filter_List__c transRecord = new Transaction_Filter_List__c();
		transRecord.Processing_Date__c = date.today();
		transRecord.Description1__c = 'Ref';
		transRecord.Description2__c = 'MONTHLY ACC FEE';
		insert transRecord;
	}

    @IsTest
    static void testGetByDate(){
        TransactionsFilterSelector selector = new TransactionsFilterSelector();
        List<Transaction_Filter_List__c> transList = selector.getByDate(Date.today());

        Test.startTest();
        System.assertEquals(1, transList.size(), 'Assert Failed');
        Test.stopTest();
    }

    @IsTest
    static void getByDateAndDesc(){
        TransactionsFilterSelector selector = new TransactionsFilterSelector();
        String dscSearch = '\'%' + String.escapeSingleQuotes('MONTHLY ACC FEE') + '%\'';
        List<Transaction_Filter_List__c> transList = selector.getByDateAndDesc(Date.today(), dscSearch);

        Test.startTest();
        System.assertEquals(1, transList.size(), 'Assert Failed');
        Test.stopTest();
    }

    @IsTest
    static void getByTransactionSet(){
        TransactionsFilterSelector selector = new TransactionsFilterSelector();
        List<Transaction_Filter_List__c> transList = selector.getByTransactionSet(new Set<String>{'Ref'});

        Test.startTest();
        System.assertEquals(1, transList.size(), 'Assert Failed');
        Test.stopTest();
    }

    @IsTest
    static void getByDescription(){
        TransactionsFilterSelector selector = new TransactionsFilterSelector();
        String dscSearch = '\'%' + String.escapeSingleQuotes('MONTH') + '%\'';
        List<Transaction_Filter_List__c> transList = selector.getByDescription(dscSearch);

        Test.startTest();
        System.assertEquals(1, transList.size(), 'Assert Failed');
        Test.stopTest();
    }
}