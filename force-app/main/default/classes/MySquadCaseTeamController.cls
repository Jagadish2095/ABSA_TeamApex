/**
* Apex extension class for the MySquadCaseTeam
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2020-02-11
*
**/
public class MySquadCaseTeamController {
    
    /*Set location
     * 
    * @param  None
    * @return String
    */
    @AuraEnabled
    public static List<User> getMyHubDefaultCaseTeam() {
        
        List<User> caseTeamUserMembers = new List<User>();
        Set<Id> caseTeamTemplateIds = new Set<Id>();
        Set<Id> UserIds = new Set<Id>();

        //Get logged in User's predefined CaseTeams
        List<CaseTeamTemplateMember> caseTeamMemberLoggedInLst = new CaseTeamTemplateMembersSelector().selectByTemplateNameAndUserId('MyHub', UserInfo.getUserId()); 
        System.debug('caseTeamMemberLoggedInLst : ' + caseTeamMemberLoggedInLst);
        
        if(caseTeamMemberLoggedInLst != null && caseTeamMemberLoggedInLst.size() > 0) {
            caseTeamTemplateIds.add (caseTeamMemberLoggedInLst[0].TeamTemplateId);
            
            //Get Case Team Template Members based on Case Team Template
        	List<CaseTeamTemplateMember> caseTeamMemberLst = new CaseTeamTemplateMembersSelector().selectByTemplateId(caseTeamTemplateIds); 
            
            System.debug('caseTeamMemberLst : ' + caseTeamMemberLst);
            if(caseTeamMemberLst != null && caseTeamMemberLst.size() > 0) {
            	//Get User Name and User Role based on ID's
                for(CaseTeamTemplateMember eachMember : caseTeamMemberLst) {
                    UserIds.add(eachMember.MemberId);
                }
                
                //Get User Info based on Case Team Template Members
                for(User eachUser : new UsersSelector().selectByIdWithRole(UserIds)) {
                    System.debug('eachUser : ' + eachUser);
                    caseTeamUserMembers.add(eachUser);
                }
            	
        	}

        } 
        
        if(caseTeamUserMembers != null && caseTeamUserMembers.size() > 0) {
            return caseTeamUserMembers;
        } else {
            return null ;
        }
    }
}