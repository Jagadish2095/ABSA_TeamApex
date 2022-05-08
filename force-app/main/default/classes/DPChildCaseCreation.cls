/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-07-07
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-07-07   Sandeep Golla   Initial Version
**/
public class DPChildCaseCreation {

    /**
    * @description
    * @author Sandeep Golla | 2021-07-07
    * @param caseId
    * @param accountId
    **/
    @AuraEnabled
    public static void createChildCaseRB(string caseId, string accountId) {
        try {
            string queueName = '';
            if(accountId != null && accountId != '') {
                Account accRec = new AccountsSelector().selectAllById(accountId);
                if(accRec.Id != null && string.isNotBlank(accRec.SBU_Segment__c)){
                    //Determine whether the customer is RB Customer, If yes then create child case as assign to Queue as per below mappings
                    List<Data_Privacy_RB_Case__mdt> dpQueueList = new DataPrivacyRBCaseSelector().getQueueBasedOnSBUSegmentAndRegion(accRec.SBU_Segment__c,accRec.Owner.RBB_Super_Region__c);
                    if(dpQueueList.size()>0){

                        queueName = dpQueueList[0].Queue_Name__c;
                        List<Service_Group_Type__c> serviceGrpList = new ServiceGroupTypesSelector().selectByServiceGroupNameAndServiceTypeName('Business Banking','Data Privacy Investigation');
                        List<Case> childCases = new CasesSelector().selectByDataPrivacyRBCase(caseId,accRec.Id,'Data Privacy Investigation');
                        if(childCases.size() == 0 && string.isNotBlank(queueName) && serviceGrpList.size() > 0){
                            List<Group> queueList = new GroupsSelector().selectByDeveloperNameAndType(queueName,'Queue');
                            case newCase = new Case();
                            newCase.AccountId = accRec.Id;
                            newCase.ParentId = caseId;
                            newCase.OwnerId = queueList.size() > 0 ? queueList[0].Id : userInfo.getUserId();
                            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
                            if(string.isBlank(accRec.Name)) {
                                newCase.Subject = accRec.FirstName + ' ' + accRec.LastName + ' ' + serviceGrpList[0].Service_Type__r.Name;
                            }
                            else {
                                newCase.Subject = accRec.Name + ' ' + serviceGrpList[0].Service_Type__r.Name;
                            }
                            newCase.Type__c = serviceGrpList[0].Service_Type__r.Name;
                            newCase.Type = serviceGrpList[0].Service_Type__r.Type__c;
                            newCase.Subtype__c = serviceGrpList[0].Service_Type__r.Subtype__c;
                            newCase.sd_Service_Group__c = serviceGrpList[0].Service_Group__r.Name;
                            newCase.sd_Original_Service_Group__c = serviceGrpList[0].Service_Group__r.Name;
                            newCase.sd_Service_Group_Type_Id__c = serviceGrpList[0].Id;
                            newCase.sd_Original_Service_Queue__c = serviceGrpList[0].Service_Group__r.Queue__c;
                            newCase.Phone__c = accRec.Phone;
                            newCase.Email__c = accRec.PersonEmail;
                            newCase.Communication_Method__c = accRec.Communication_Method__c;
                            insert newCase;
                        }
                        else{
                            system.debug('Child already  present'+childCases[0]);
                        }
                    }
                    system.debug('Metadata Record'+dpQueueList.size());
                }
            }
        }
        catch(exception e){
            system.debug('Exception---'+e.getMessage());
        }
    }
}