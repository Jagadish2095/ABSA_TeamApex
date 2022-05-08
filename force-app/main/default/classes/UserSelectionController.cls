/**
 * @description       : 
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-12   almas.aleem@absa.africa   Initial Version
**/

public class UserSelectionController {
    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    * @param opprecordType 
    * @return List<User> 
    **/
     @auraEnabled
    public static  List<User> loadUsers(String opprecordType) {
         List<User> users; 
        if(opprecordType.equalsIgnoreCase('Credit_Onboarding')){
         User u = [select id, Name,RBB_Super_Region__c from User where id = :userInfo.getUserId()]; 
            if(u.RBB_Super_Region__c != null){
                String Region = u.RBB_Super_Region__c;
                 users = new UsersSelector().selectUsersByProfileandRegion('Standard User (Credit Manager)',Region);
            }else{
              users = new UsersSelector().selectUsersByProfile('Standard User (Credit Manager)');  
            }
         
        }else if(opprecordType.equalsIgnoreCase('Merchant_Onboarding')){
  
            Group grp = new GroupsSelector().selectByName('Merchant Onboarding QA Vetting Team');// Merchant Onboarding QA Vetting Team
            List<GroupMember> grpmembers = grp.GroupMembers;
           
          if(grpmembers != null && grpmembers.size()>0){
              List<id> userIDs = new List<id>();
              for(GroupMember grpmem : grpmembers){
                   userIds.add(grpmem.UserOrGroupId);
                  }
             users = new UsersSelector().selectByIds(userIDs);
            }
            
        }else{
           users = new UsersSelector().selectUser(); 
        }
         system.debug('users---'+users);
         return users;
    } 
}