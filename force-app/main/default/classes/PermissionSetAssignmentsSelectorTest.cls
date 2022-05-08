/**
* @description Test class for PermissionSetAssignmentsSelector
* @since 2019-04-29
**/
@isTest 
public class PermissionSetAssignmentsSelectorTest {
    
    @isTest
    private static void testSelectById() {
        
        PermissionSetAssignmentsSelector permissionSetSelectorTest = new PermissionSetAssignmentsSelector();
        Set<Id> testSet = new Set<Id>();
        List<PermissionSetAssignment> permissionSetList = permissionSetSelectorTest.selectById(testSet);   
        System.assertNotEquals(permissionSetList, null); 
    }
    
    
    @isTest
    private static void testSelectByNameAndUserId() {
        
        PermissionSetAssignmentsSelector permissionSetSelectorTest = new PermissionSetAssignmentsSelector();
        List<PermissionSetAssignment> permissionSetList = permissionSetSelectorTest.SelectByNameAndUserId('Testing', UserInfo.getUserId());   
        System.assertNotEquals(permissionSetList, null); 
    }

    @isTest
    private static void testSelectByUserId() {
        
        PermissionSetAssignmentsSelector permissionSetSelectorTest = new PermissionSetAssignmentsSelector();
        List<PermissionSetAssignment> permissionSetList = permissionSetSelectorTest.selectByUserId(UserInfo.getUserId());   
        System.assertNotEquals(permissionSetList, null); 
    }

}