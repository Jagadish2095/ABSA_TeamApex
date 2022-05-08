public  class PublicGroupUsersController {

    @AuraEnabled
    public static List<User> fetchUserData(Id groupId){

        set<id> userIdSet = fetchUserIdsFromPublicGroups(new Set<Id>{groupId});
		List<User> userList = new List<User>([SELECT FirstName, LastName, UserRole.Name, BRID__c, Profile.Name FROM USER WHERE Id IN :userIdSet]);
		System.debug('userList.size ==> '+ userList.size());
		return userList;
        
    }

	//Get User Id's From Public Groups
	public static set<id> fetchUserIdsFromPublicGroups(set<id> groupids){

		Set<Id> result            = new Set<Id>();
        String userType           = Schema.SObjectType.User.getKeyPrefix();
        String groupType          = Schema.SObjectType.Group.getKeyPrefix();
        String roleType           = Schema.SObjectType.UserRole.getKeyPrefix();
        Set<Id> groupIdProxys     = new Set<Id>();
        Set <Id> groupWithRole    = new Set<Id>();
        set<Id> groupWithRoleNSub = new set<Id>();

        List<GroupMember> gmList = new List<GroupMember>();
        gmList = [SELECT Id, UserOrGroupId,GroupId,Group.type From GroupMember Where GroupId in :groupIds];
        Set<Id> usOrGIdList = new Set<Id>();
        for(GroupMember gm :gmList){
            usOrGIdList.add(gm.UserOrGroupId);
        }
		Map<Id,Group> grMap = new Map<Id,Group>([SELECT Id, relatedid, type FROM Group WHERE Id IN :usOrGIdList]);

		id firstelement = null;
		for(Id i: groupids){
            firstelement = i;
            break;
        }

        if(String.valueOf(firstelement.getSObjectType()) == 'Group'){
            for(GroupMember m : gmList) {
                System.debug('GM ==>: ' + m);
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType)){
                    result.add(m.UserOrGroupId);
                }
                else if(grMap.get(m.UserOrGroupId) != null && (grMap.get(m.UserOrGroupId).relatedid != null && ((String)grMap.get(m.UserOrGroupId).relatedid).startsWith(roleType) )){
					System.debug('type is ==> '+grMap.get(m.UserOrGroupId).type); 
                
                    if(grMap.get(m.UserOrGroupId).type == 'Role')    
                        groupWithRole.add(grMap.get(m.UserOrGroupId).relatedid);
                    else if(grMap.get(m.UserOrGroupId).type == 'RoleAndSubordinatesInternal') 
                        groupWithRoleNSub.add(grMap.get(m.UserOrGroupId).relatedid);     
                }
                // If the user or group id is a group
   
                else if (((String)m.UserOrGroupId).startsWith(groupType)) {                   
                    // Call this function again but pass in the group found within this group
                    groupIdProxys.add(m.UserOrGroupId);
                }
            }
            //system.debug('groupwithrole::::'+groupWithRole);
            if(groupWithRoleNSub.size() > 0){
                groupWithRoleNSub.addALL(fetchChildRoleIds(groupWithRoleNSub));
                Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :groupWithRoleNSub AND isActive =: true]);
                result.addALL(users.keyset());   
            }
            else if(groupWithRole.size()>0){
                Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :groupWithRole AND isActive =: true]);
                result.addALL(users.keyset());
            }
           
            if(groupIdProxys.size() > 0)
            {
                result.addAll(fetchUserIdsFromPublicGroups(groupIdProxys));
            }
        }
        System.debug('RRRRRRRR: '+result);
        return result; 
	}
	
	//Get all child Role Id's
    public static Set<Id> fetchChildRoleIds(Set<Id> roleIds){
		
		Set<Id> currentRoleIds = new Set<Id>();

		// get all of the roles underneath the passed roles
		for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :roleIds AND ParentRoleID != null limit 40000]){
			currentRoleIds.add(userRole.Id);
		}
		
		// go fetch some more roles!
		if(currentRoleIds.size() > 0){
			currentRoleIds.addAll(fetchChildRoleIds(currentRoleIds));
		}
		return currentRoleIds;
	}

}