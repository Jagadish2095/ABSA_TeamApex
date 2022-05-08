/*This is User Limits Lightning component Apex Controller Class
*
* @author Mashudu Raidimi
* @created 08/07/2020
*/

public class UserLimitsController {
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        system.debug(LoggingLevel.FINE,'clientAccountId : '+clientAccountId);
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        system.debug(LoggingLevel.FINE,'customer key : '+accountList[0].CIF__c);
        return accountList[0].CIF__c;
    }
/**
* Retrieves retrieves a list of users
* @param   accNo,userNumber,cifKey
*return list of users
*/
    @AuraEnabled
    public static String getUserList(String accNo,String userNo , String cifKey){
        vBlistusersv1_Resp_IB_v1 response = vBlistusersv1_IH_v1.VBlistUsersV1(accNo,userNo ,cifKey);
        if(response != null){
            vBlistusersv1_Resp_IB_v1.VBlistUsersV1Response getUserLimitRespWrapper = response.VBlistUsersV1Response;
            vBlistusersv1_Resp_IB_v1.Vbp451o vbp451o = getUserLimitRespWrapper.vbp451o;
            List<vBlistusersv1_Resp_IB_v1.Users> userList = vbp451o.Users;
            return JSON.serialize(userList);
        }
        return null;
    }

/**
* Retrieves retrieves client account limits
* @param   userNumber
*return list of limits
*/
    @AuraEnabled
    public static String getAccountLimits(String customerCifKeyP,String userNumberP){
        getTbUserBasicLimits_Resp_IB_v1 resp = getTbUserBasicLimits_IH_v1.getTbUserBasicLimits(customerCifKeyP,userNumberP);
        if( resp.statusCode == 200 && resp != null){
            return JSON.serialize(resp);
        }
        return null;
    }

    @AuraEnabled
    public static Map<String,String> caseClose(String caseId){
        Map<String,String> returnMap = new Map<String,String>();
        try{
            Update new Case(Id=caseId, Status='Closed');
            returnMap.put('isSuccess', 'true');
        }catch(exception ex){
            returnMap.put('isSuccess', 'false');
            returnMap.put('errorMessage', ex.getMessage());
        }
        return returnMap;
    }
}