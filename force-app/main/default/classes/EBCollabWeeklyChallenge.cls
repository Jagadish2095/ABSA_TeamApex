/**
* @description Controller class for EBCollabArcadeWeeklyChallenge component
* @author Bhanumurty Rayala
* @created 2021-05-25
* @User story W-011455, W - 012944
*/
public class EBCollabWeeklyChallenge {

     @AuraEnabled
    /**
	* @description get the Group member details based on the member Id value
    * @param groupId group record Id from the component.
	* @return groupMemberList List of Group Member records
	*/
    public static List<CollaborationGroupMember> getGroupMemberInformation(String groupId){
        List<CollaborationGroupMember> groupMemberList = new List<CollaborationGroupMember>([SELECT Id, CollaborationGroupId, CollaborationGroup.Name, MemberId, Member.Name, CollaborationRole FROM CollaborationGroupMember WHERE MemberId =: UserInfo.getUserId() AND CollaborationGroupId =: groupId]);
        return groupMemberList;
    }

    @AuraEnabled
    /**
	* @description get the weekly challenge records
    * @param collaborationGroupId passing the collaboration group Id to fetch the weekly challenges records based on the Id
	* @return challengeList List of Collaboration records
	*/
    public static List<Collaboration__c> getWeeklyChallenge(String collaborationGroupId){

        List<Collaboration__c> challengeList = new List<Collaboration__c>([SELECT Id, Name, Select_Challenge__c, Challenge_Name__c, Winner_Criteria__c, End_Date__c, Select_Winner__r.Name, Start_Date__c, Duration__c, Collaboration_Group_Id__c FROM Collaboration__c WHERE Collaboration_Group_Id__c =: collaborationGroupId]);
        return challengeList;
    }

    @AuraEnabled
    /**
	* @description get the members based on the group
    * @param collaborationGroupId passing the collaboration group Id to fetch the Collaboration group members records based on the Id
	* @return userLists List of users based on the Collaboration Group Member Id
	*/
    public static List<User> getGroupMembers(String collaborationGroupId){

        List<CollaborationGroupMember> groupMemberLists = new List<CollaborationGroupMember>([SELECT Id, CollaborationGroupId, CollaborationGroup.Name, MemberId, Member.Name FROM CollaborationGroupMember WHERE CollaborationGroupId =: collaborationGroupId]);
        Set<Id> groupMemberIdSets = new Set<Id>();
        for(CollaborationGroupMember member : groupMemberLists){
            groupMemberIdSets.add(member.MemberId);
        }
        UsersSelector user = new UsersSelector();
        List<User> userLists = user.selectById(groupMemberIdSets);
        return userLists;
    }

     @AuraEnabled
    /**
	* @description insert/update the weekly challenge record
	* @param selectedChallenge String picklist value from the weekly challenge modal of selected challenge
    * @param otherChallenge String if the picklisted value of select challenge is "other" then it should display the new challenge name field
    * @param lookWinner String value from modal for what you looking in the winner
    * @param endDate Date value for the challenge to end
    * @param buttonAction String the action which is selected to determine the DML operation
    * @param recordId String for the Update operation on the Collaboration record
    * @param collaborationGroupId passing the collaboration group Id to insert the records
	*/

    public static void createWeeklyChallenge(String selectedChallenge, String otherChallenge, String lookWinner, Date endDate, String buttonAction, String recordId, String collaborationGroupId){

        Collaboration__c collab;
        if(String.isBlank(recordId)){
            collab = new Collaboration__c();
        }else{
            collab = new Collaboration__c(id = recordId);
        }
        collab.Name = selectedChallenge + String.valueOf(system.today()).replace('-', '');
        collab.Winner_Criteria__c = lookWinner;
        collab.End_Date__c = endDate;
        if(String.isEmpty(otherChallenge) || String.isBlank(otherChallenge)){
            collab.Select_Challenge__c = selectedChallenge;
        }else{
            collab.Select_Challenge__c = otherChallenge;
            collab.Challenge_Name__c = otherChallenge;
        }
            if(buttonAction == 'ADD'){
                collab.Collaboration_Group_Id__c = collaborationGroupId;
                insert collab;
            }else if(buttonAction == 'EDIT'){
                update collab;
            }
    }

    @AuraEnabled
    /**
	* @description assign winner for the weekly challenge record
    * @param recordId String Collaboration record
	* @param winner String User Id
    * @param duration String, picklist value from assign winner modal
    * @param startDate Date from assign modal
    * @param comment String Comment from the assign winner modal
	*/
    public static void assignWinner(String recordId, String winner, String duration, Date startDate, String comment){

        Collaboration__c collab = new Collaboration__c(Id = recordId);
        collab.Select_Winner__c = winner;
        collab.Duration__c = duration;
        collab.Start_Date__c = startDate;
        collab.Comments__c = comment;
        update collab;

        EBCollabWeeklyChallenge.postWinner(recordId, winner, comment);
    }

    /**
	* @description post winner for the achievement chatter rally board updates
    * @param recordId String Collaboration record
	* @param winner String User Id
    * @param comment String Comment from the assign winner modal
	*/
    public static void postWinner(String recordId, String winner, String comment) {

        User userWinner = [SELECT Id, Name FROM User WHERE Id =: winner];
        Collaboration__c collab = [SELECT Id, Select_Challenge__c, Collaboration_Group_Id__c FROM Collaboration__c WHERE id =: recordId];

        String chatBody = '#Achievements ' + comment + ' ' + userWinner.Name + ' '+ 'for winning the challenge'+ ' '+ collab.Select_Challenge__c;
        FeedItem post = new FeedItem();
        post.ParentId = collab.Collaboration_Group_Id__c;
        post.Body = chatBody;
        insert post;
    }
}