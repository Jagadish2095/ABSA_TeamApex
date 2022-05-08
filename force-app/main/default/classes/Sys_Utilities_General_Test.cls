/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-13
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class Sys_Utilities_General_Test {
    private static final String testFieldLength =
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed elit dui, pellentesque a, faucibus vel, ' +
        'interdum nec, diam. Nullam dapibus fermentum ipsum. Fusce consectetuer risus a nunc. Sed ac dolor sit amet purus malesuada congue. Duis risus. ' +
        'Mauris tincidunt sem sed arcu. Curabitur vitae diam non enim vestibulum interdum. Quisque tincidunt scelerisque libero. Nulla non lectus sed nisl ' +
        'molestie malesuada. Nunc tincidunt ante vitae massa. Praesent in mauris eu tortor porttitor accumsan. Aenean vel massa quis mauris vehicula lacinia. ' +
        'Fusce consectetuer risus a nunc. Aliquam erat volutpat. Morbi leo mi, nonummy eget tristique non, rhoncus non leo. Maecenas lorem. In dapibus augue ' +
        'non sapien. Aliquam erat volutpat. Fusce dui leo, imperdiet in, aliquam sit amet, feugiat eu, orci. Lorem ipsum dolor sit amet, consectetuer adipiscing ' +
        'elit. Sed elit dui, pellentesque a, faucibus vel, interdum nec, diam. Nullam dapibus fermentum ipsum. Fusce consectetuer risus a nunc. Sed ac dolor sit ' +
        'amet purus malesuada congue. Duis risus. Mauris tincidunt sem sed arcu. Curabitur vitae diam non enim vestibulum interdum. Quisque tincidunt scelerisque' +
        'libero. Nulla non lectus sed nisl molestie malesuada. Nunc tincidunt ante vitae massa. Praesent in mauris eu tortor porttitor accumsan. Aenean vel massa' +
        'quis mauris vehicula lacinia. Fusce consectetuer risus a nunc. Aliquam erat volutpat. Morbi leo mi, nonummy eget tristique non, rhoncus non leo. ' +
        'Maecenas lorem. In dapibus augue non sapien. Aliquam erat volutpat. Fusce dui leo, imperdiet in, aliquam sit amet, feugiat eu, orci. Lorem ipsum dolor' +
        'sit amet, consectetuer adipiscing elit. Sed elit dui, pellentesque a, faucibus vel, interdum nec, diam.255 Nullam dapibus fermentum ipsum. ' +
        'Fusce consectetuer risus a nunc. Sed ac dolor sit amet purus malesuada congue. Duis risus. Mauris tincidunt sem sed arcu. Curabitur vitae diam non ' +
        'enim vestibulum interdum. Quisque tincidunt scelerisque libero. Nulla non lectus sed nisl molestie malesuada. Nunc tincidunt ante vitae massa. ' +
        'Praesent in mauris eu tortor porttitor accumsan. Aenean vel massa quis mauris vehicula lacinia. Fusce consectetuer risus a nunc. Aliquam erat volutpat.' +
        'Morbi leo mi, nonummy eget tristique non, rhoncus non leo. Maecenas lorem. In dapibus augue non sapien. Aliquam erat volutpat. Fusce dui leo, ' +
        'imperdiet in, aliquam sit amet, feugiat eu, orci.354';

    @isTest
    static void getSObjectFieldLengthNullTest() {
        test.startTest();
        System.assert(  Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, 'test')!= 0);
        test.stopTest();
        
    }

    @isTest
    static void truncateFieldIfNeededTest() {
        test.startTest();
        System.assert(   Sys_Utilities_General.truncateFieldIfNeeded(
            testFieldLength,        
         Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, 'test')) != null);
        test.stopTest();
    }

    @isTest
    static void convertListToMapWithStringKeyTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(testDataFactory.testOpportunity);
         Map<String, List<SObject>> convertedMap = Sys_Utilities_General.convertListToMapWithStringKey(opportunityList, 'Name');
        test.stopTest();
        System.assert(convertedMap.size() >0);
    }

    // Eduardo Salia: 26/10/2020
    @isTest
    static void testIsListBlank() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(testDataFactory.testOpportunity);

        Boolean isListBlank = Sys_Utilities_General.isListBlank(opportunityList);
        System.assertEquals(false, isListBlank);
        test.stopTest();
    }

    @isTest
    static void getEnvironmentTest() {
        test.startTest();
        String environmentString = Sys_Utilities_General.getEnvironment();
        test.stopTest();
        System.assert(environmentString !=  '');
    }

    @isTest
    static void getRecordTypeIdTest() {
        test.startTest();
        Id recordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
        test.stopTest();
        System.assert(recordTypeId !=  null);
    }

    // PJAIN: 20200421
    @isTest
    static void getPriceBookEntryId() {
        test.startTest();
        Product2 testProduct = WillsTestDataFactory.createProduct('Test', 'Test');
        Id priceBookEntryId = Sys_Utilities_General.getPriceBookEntryId(testProduct.Id);
        test.stopTest();
        System.assert(priceBookEntryId != null);
    }

    @isTest
    static void extractListIds() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        test.startTest();
        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(testDataFactory.testOpportunity);
        Set<Id> setIds = Sys_Utilities_General.extractListIds(opportunityList, 'AccountId', true);
        List<String> testList = Sys_Utilities_General.extractListValues(opportunityList, 'Type');
        System.assert(testList != null);
        test.stopTest();
    }

    // 20201016: Humbelani Denge
    @isTest
    static void testGetMultipleSelectOptions() {
        List<String> fieldList = new List<String>{'Account.Type'};
        Map<String, List<CustomSelectOptions>> testMap = Sys_Utilities_General.getMultipleSelectOptions(fieldList);
        System.assertNotEquals(null, testMap.get('Account.Type'));
    }
}