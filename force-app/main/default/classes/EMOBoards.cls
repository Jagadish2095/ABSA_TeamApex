/**
 * @description This is the Controller Class for the EMO Boards Component for the get loged user details and save collaboration records
 *
 * @author  Nagpal
 * @since   2021-06-04
 * Work Id: W-011445
 */

public class EMOBoards {
	public static String groupMemberId;

	/**
	 * @description Method for geting loged user
	 *
	 * @return  User   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static User fetchUser() {
		User user = [SELECT id, FirstName FROM User WHERE id = :userInfo.getUserId()];
		return user;
	}

	/**
	 * @description This is a method to create collaboration records
	 *
	 * @param name     The search key word to look for
	 * @param mood        The object to search in
	 * @param gif        The object to search in
	 * @param userId        The object to search in
	 * @param collaborationGroupId        The object to search in
	 *
	 * @return  string with message 'Success' or 'Already inserted'
	 */
	@AuraEnabled
	public static String createCollaboration(String name, String mood, String gif, String userId, String collaborationGroupId) {
		List<String> existedReportByNameList = new List<String>();
		List<Collaboration__c> CollaborationRecordList = [SELECT Report_By__c FROM Collaboration__c WHERE Reported_Date__c = TODAY];
		if (!CollaborationRecordList.isEmpty()) {
			for (Collaboration__c collboration : CollaborationRecordList) {
				existedReportByNameList.add(collboration.Report_By__c);
			}
		}
		Collaboration__c collaNewRecord = new Collaboration__c();
		if (!existedReportByNameList.contains(userId)) {
			if (String.isNotBlank(name)) {
				collaNewRecord.Name = name + ' ' + userId;
			}
			collaNewRecord.RecordTypeId = Collaboration__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Emo_Board').getRecordTypeId();
			collaNewRecord.Capture_Mood__c = mood;
			collaNewRecord.GIF_URL__c = gif;
			collaNewRecord.Report_By__c = userId;
			collaNewRecord.Collaboration_Group_Id__c = collaborationGroupId;
			insert collaNewRecord;
			return 'Success';
		} else {
			return 'You already selected your mood for the day';
		}
	}

	/**
	 * @description This is a method to get collaboration records
	 *
	 *@param selectedMoodDate     The object to search in
	 *@param groupMemberId
	 *@return  List<sObject>   The list of sObjects as specified as part of the search criteria
	 */
	@AuraEnabled
	public static List<Collaboration__c> getCollaborationMood(Date selectedMoodDate, String groupMemberId) {
		List<Collaboration__c> CollaborationRecordList = new List<Collaboration__c>();
		if (String.isNotBlank(groupMemberId)) {
			if (selectedMoodDate != null && String.isNotBlank(groupMemberId)) {
				CollaborationRecordList = [
					SELECT Owner.Name, Capture_Mood__c, GIF_Image__c
					FROM Collaboration__c
					WHERE Reported_Date__c = :selectedMoodDate AND Collaboration_Group_Id__c = :groupMemberId
				];
			}
		}
		return CollaborationRecordList;
	}
	/**
	 * @description get the Group member details based on the member Id value
	 * @return groupMemberList List of Group Member records
	 */
	@AuraEnabled
	public static List<CollaborationGroupMember> getGroupMemberInfo() {
		List<CollaborationGroupMember> groupMemberList = new List<CollaborationGroupMember>(
			[
				SELECT Id, CollaborationGroupId, CollaborationGroup.Name, MemberId, Member.Name, CollaborationRole
				FROM CollaborationGroupMember
				WHERE MemberId = :userInfo.getUserId()
			]
		);
		return groupMemberList;
	}
}