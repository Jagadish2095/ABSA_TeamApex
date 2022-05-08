/**
* @description Test class for ProfilesSelector
* @since 2019-04-29
**/
@isTest 
public class ProfilesSelectorTest {
    
    @isTest
    private static void testSelectById() {
        
        ProfilesSelector testProfilesSelector = new ProfilesSelector();
        Set<Id> testSet = new Set<Id>();
        List<Profile> profileList = testProfilesSelector.selectById(testSet);   
        
    }
    
    @isTest
    private static void testSelectByLoggedInUser() {
        
        ProfilesSelector testProfilesSelector = new ProfilesSelector();
        Profile testProfile = testProfilesSelector.selectByLoggedInUser();   
        
    }

}