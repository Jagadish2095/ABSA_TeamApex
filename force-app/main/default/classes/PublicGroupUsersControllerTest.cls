@isTest
public class PublicGroupUsersControllerTest {

    @isTest
    static void testfetchUserIdsFromPublicGroups(){

        //Group
        Group parentPublicGroup = new Group(Name = 'Test Group', Type ='Regular');
        insert parentPublicGroup;
        Group childPublicGroup = new Group(Name = 'Child Group', Type ='Regular');
        insert childPublicGroup;

        //Users
        String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String email = 'UserAdmin@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName, MobilePhone='0823389021');
        Insert adm;


		UserRole role = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role'); 
        insert role;

        String uniqueUserName2 = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String email2 = 'UserAdmin2@testorg.com';
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User adm2 = new User(Alias = 'standt', Email=email2,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p2.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName2, MobilePhone='0823389021', UserRole = role);
        Insert adm2;

        //Group Members
        // 1. Group
        GroupMember pg = new GroupMember(GroupId = parentPublicGroup.Id, UserOrGroupId =childPublicGroup.Id);
        insert pg;

        //2 Role
        /*Group roleGroup = new Group(Name = 'Role Group', Type ='Role');
        insert roleGroup;
        GroupMember testRoleMember = new GroupMember(GroupId = parentPublicGroup.Id, UserOrGroupId =roleGroup.Id);
        insert testRoleMember;*/

        //3 User
        GroupMember testUserMember = new GroupMember(GroupId = parentPublicGroup.Id, UserOrGroupId =adm.Id);
        insert testUserMember;

        Test.startTest();
        List<User> fetchUserDatatest = PublicGroupUsersController.fetchUserData(parentPublicGroup.Id);
        Set<Id> fetchUserDatatest2 = PublicGroupUsersController.fetchChildRoleIds(new Set<Id>{role.Id});
        Test.stopTest();
    }

}