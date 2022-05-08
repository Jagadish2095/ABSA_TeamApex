/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-05-31
 * @last modified by  : Monde Masiza
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-05-27   Sandeep Golla   Initial Version
**/
@isTest
private class GroupsSelectorTest {
	@isTest
	private static void testSelectById() {
		Group tstGroup = new Group();
		tstGroup.Name = 'Test Group Name';
		insert tstGroup;
		GroupsSelector grs = new GroupsSelector();
		Set<Id> tstSet = new Set<Id>();
		tstSet.add(tstGroup.Id);
		List<Group> grps = grs.selectById(tstSet);
	List<Group> grps1=grs.selectById(userinfo.getUserId());
		System.assertEquals(grps.size(), 1);
	}
	@isTest
	private static void testSelectSObjectsById() {
		Group tstGroup = new Group();
		tstGroup.Name = 'Test Group Name';
		tstGroup.Type = 'Queue';
		insert tstGroup;
		GroupsSelector grs = new GroupsSelector();
		List<Group> grps = grs.selectByNameAndType('Test Group Name', 'Queue');
		Group selectByNameTest = grs.selectByName('Test Group Name');
		System.assertEquals(grps.size(), 1);
	}

	@isTest
	private static void testSelectByType() {
		Group tstGroup = new Group();
		tstGroup.Name = 'Test Group Name';
		tstGroup.Type = 'Queue';
		insert tstGroup;
		GroupsSelector grs = new GroupsSelector();
        List<Group> grps1 = grs.selectByDeveloperNameAndType('WIMI_CEO','Role');
		List<Group> grps = grs.selectByType('Queue');
		System.assertNotEquals(grps, null);
	}

	@isTest
	private static void testSelectByNameSetAndType() {
		Group tstGroup = new Group();
		tstGroup.Name = 'Test Group Name';
		tstGroup.Type = 'Queue';
		insert tstGroup;
		Set<String> tstSet = new Set<String>();
		tstSet.add(tstGroup.Name);
		GroupsSelector grs = new GroupsSelector();
		List<Group> grps = grs.selectByNameSetAndType(tstSet, 'Queue');
		System.assertEquals(grps.size(), 1);
	}
}