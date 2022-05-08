/**
* Apex controller class for the Aura bundle UserRecordAbsence.
*
* @author Koketso Mpshane
* @since  2020-06-12
*
**/
public class UserRecordAbsenceController {
    
    public static String currentUserId = UserInfo.getUserId();
    
    /*
	* Koketso - method to create an absence record
	* @return - String recordAbsenceId
	* @params - Record_Absence__c recordAbsence
	*/
    @AuraEnabled
    public static String createRecordAbsence(Record_Absence__c recordAbsence) {
        
        system.debug(LoggingLevel.FINE, '***recordAbsence:***'+recordAbsence);
        
        String recordAbsenceId;
        Record_Absence__c newRecord = new Record_Absence__c(); 
        
        Set<String> groupNames = new Set<String>();
        Set<String> recordtypes = new Set<String>{'Retail Sales Lead'};
            
        String branchMangerId;
        String branchHostId;
        String itaMangerId;
        String branchName;
        
        if(recordAbsence != null) {
            
            try {
                
                newRecord = recordAbsence;
                newRecord.User__c = currentUserId;
                
                List<GroupMember> groups  = [Select Group.Name, UserOrGroupId From GroupMember Where UserOrGroupId =:currentUserId];
                
                if(groups.size() > 0){
                    
                    for(GroupMember member: groups){
                        groupNames.add(member.Group.Name); 
                    }
                    
                    system.debug(LoggingLevel.FINE, 'GROUPS:'+groupNames); 
                    
                    List<Service_Group__c> serviceGroupList = new ServiceGroupsSelector().selectByNameAndAssignedRecordType(groupNames, recordtypes);
                    
                    system.debug(LoggingLevel.FINE, 'serviceGroupListSIZE:'+serviceGroupList.size());
                    
                    if(serviceGroupList.size() > 0){
                        branchMangerId = serviceGroupList[0].Manager__c;
                        branchHostId = serviceGroupList[0].X2IC_Manager__c;
                        itaMangerId = serviceGroupList[0].ITA_Manager__c;
                        branchName = serviceGroupList[0].Name;
                    }else{
                        system.debug(LoggingLevel.FINE, '***No Service Group Found***'); 
                        return 'No Service Group Found';
                    }
                }else{
                    system.debug(LoggingLevel.FINE, '***No Queue/Public Group Found***'); 
                    return 'No Service Group Found';
                }
                
                if(branchMangerId == null || String.isBlank(branchMangerId)){
                    return 'No Manager Assigned';
                }
                
                newRecord.Approver__c = branchMangerId;
                newRecord.X2IC_Approver__c = branchHostId;
                newRecord.ITA_Approver__c = itaMangerId;
                newRecord.Branch_Site__c = branchName;
                insert newRecord;
                
                if(newRecord.Id != null){
                    recordAbsenceId = newRecord.Id;
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments(newRecord.Absence_Reason__c + ', submitted for approval');
                    approvalRequest.setObjectId(newRecord.Id);
                    Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                    system.debug(LoggingLevel.FINE, 'Absence approval:'+approvalResult.isSuccess());
                }
            }catch(Exception ex){
                system.debug(LoggingLevel.FINE, '***recordAbsence error***'+ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            }
        }
        
        return recordAbsenceId;
        
    }
    
    /*
    * Koketso - Get logged in User Record Absent days already logged
    * @return List<String> 
    */
    @AuraEnabled
    public static List<Date> getLoggedInUserAbsentDates() {
        
        Date todayDate = system.today();
        Set<Date> datesAbsent = new Set<Date>();
        List<Date> allDatesAbsent = new List<Date>();
        
        List<Record_Absence__c> recordAbsenceList = [Select Id, Start_Date__c, End_Date__c, Status__c, User__c From Record_Absence__c Where User__c =:currentUserId And Status__c != 'Rejected' And End_Date__c >=:todayDate order by Start_Date__c ASC];
       	
        if(recordAbsenceList.size() > 0){
            for(Record_Absence__c ra: recordAbsenceList){
                
                Date firstDateAbsent;
                Date followingDate;
                Date lastDateAbsent = ra.End_Date__c;
                
                if(ra.Start_Date__c < todayDate){
                    firstDateAbsent = todayDate;
                }else{
                    firstDateAbsent = ra.Start_Date__c;
                }
                
                datesAbsent.add(firstDateAbsent);
                
                followingDate = firstDateAbsent.addDays(1);
                
                while(followingDate < lastDateAbsent){
                    datesAbsent.add(followingDate);
                    followingDate = followingDate.addDays(1);
                }
                
                datesAbsent.add(lastDateAbsent);
                
            }
        }
        allDatesAbsent.addAll(datesAbsent);
        system.debug('**allDatesAbsent**'+allDatesAbsent);
        
        return allDatesAbsent;
    }
    
}