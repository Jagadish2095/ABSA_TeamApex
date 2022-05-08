/**
 * @description       : 
 * @author            : Monde Masiza
 * @last modified on  : 2021-11-22
 * @last modified by  : Sulochana.Desam@absa.africa
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-02   Monde Masiza   Initial Version
**/
@isTest
private class GroupMemberSelectorTest {
  
    @isTest
	private static void testSelectSObjectsById() {
		Group tstGroup = new Group();
		tstGroup.Name = 'Test Group Name';
		tstGroup.Type = 'Queue';
		insert tstGroup;
        UserRole ur = new UserRole(Name = 'CEO');
        insert ur;
		//GroupsSelector grs = new GroupsSelector();
		GroupMemberSelector grs = new GroupMemberSelector();
        List<GroupMember> gr=grs.selectByGroupName(ur.id,userinfo.getUserId(),tstGroup.name,tstGroup.id);
        System.assertNotEquals(null, grs);
		List<GroupMember> gr5=grs.selectByGroupName(ur.id,userinfo.getUserId(),tstGroup.name,tstGroup.id);
		List<GroupMember> gr1=grs.selectByGroupType(userinfo.getUserId()); 
		List<GroupMember> gr2=grs.selectByGroupTypeInbound(ur.id,userinfo.getUserId());
		List<GroupMember> gr3=grs.selectByGroupTypeExtendedCover(ur.id,userinfo.getUserId());
		List<GroupMember> gr4=grs.selectByGroupTypeCreditLife(ur.id,userinfo.getUserId());
		List<GroupMember> gr6=grs.selectByRole(ur.id,userinfo.getUserId(), 'Queue');
        grs.getSObjectFieldList();
        grs.getSObjectType();
		
	}
}