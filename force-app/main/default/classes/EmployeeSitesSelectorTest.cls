/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Employee_Site__c object
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   29/03/2019
 */

@IsTest
private class EmployeeSitesSelectorTest {

    static testMethod void testGetSObjectType() {

        Schema.SObjectType result = new EmployeeSitesSelector().getSObjectType();

        System.assert(result != null);

    }

    static testMethod void testGetSObjectFieldList() {

        List<Schema.SObjectField> result = new EmployeeSitesSelector().getSObjectFieldList();

        System.assert(result != null);

    }

    static testMethod void testSelectById() {

        Employee__c testEmployee = WillsTestDataFactory.createEmployee('Test', null, 'User', 'T', '9206146218096',
                'SA Identity Document', 'test@test.com', '0123456789', 'E00001', 'B00001', 'AB00001', 'A12345'
        );
        Site__c testSite = WillsTestDataFactory.createSite('Test', 'T00001');
        Employee_Site__c testEmployeeSite = WillsTestDataFactory.createEmployeeSite(testEmployee.Id, testSite.Id);

        Employee_Site__c result = new EmployeeSitesSelector().selectById(testEmployeeSite.Id);

        System.assert(result != null);
    }

    static testMethod void testSelectByEmployeeId() {

        Employee__c testEmployee = WillsTestDataFactory.createEmployee('Test', null, 'User', 'T', '9206146218096',
                'SA Identity Document', 'test@test.com', '0123456789', 'E00001', 'B00001', 'AB00001', 'A12345'
        );
        Site__c testSite = WillsTestDataFactory.createSite('Test', 'T00001');
        Employee_Site__c testEmployeeSite = WillsTestDataFactory.createEmployeeSite(testEmployee.Id, testSite.Id);

        Employee_Site__c result = new EmployeeSitesSelector().selectByEmployeeId(testEmployee.Id);

        System.assert(result != null);

    }

    static testMethod void testSelectBySiteId() {

        Employee__c testEmployee = WillsTestDataFactory.createEmployee('Test', null, 'User', 'T', '9206146218096',
                'SA Identity Document', 'test@test.com', '0123456789', 'E00001', 'B00001', 'AB00001', 'A12345'
        );
        Site__c testSite = WillsTestDataFactory.createSite('Test', 'T00001');
        Employee_Site__c testEmployeeSite = WillsTestDataFactory.createEmployeeSite(testEmployee.Id, testSite.Id);

        List<Employee_Site__c> result = new EmployeeSitesSelector().selectBySiteId(testSite.Id);

        System.assert(result != null);

    }
}