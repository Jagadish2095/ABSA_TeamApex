/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-08-10
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/

public class CITCheckController {

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    * @return String 
    **/

	@AuraEnabled
    public static String verificationCheck(){

        User userObj = new UsersSelector().selectById(UserInfo.getUserId());
		System.debug('Current User ----> ' + userObj.Agent_ID__c);
		//ChewyAgentStatus_Req_IB_v1  requestBean = new ChewyAgentStatus_Req_IB_v1();
        if(userObj != null){
            if(userObj.AB_Number__c != ''){
               String abNumber = userObj.AB_Number__c;
               if(userObj.Agent_ID__c == ''){
                	ChewyAgentLookup_Resp_IB_v1 responseBean = ChewyAgentLookup_IH_v1.getAgentIdFromChewy(userObj.AB_Number__c);
        			if((responseBean != Null ) && (responseBean.statusCode == 200)){
                        return getAgentStatus(responseBean.agentId);
                     }
               }else{
                   	   return getAgentStatus(userObj.Agent_ID__c);
                 }

               }
             }

        return null;
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    * @param agentId 
    * @return String 
    **/
    public static String getAgentStatus(String agentId){

        ChewyAgentStatus_Req_IB_v1  requestBean = new ChewyAgentStatus_Req_IB_v1();
        requestBean.userId = '';
        requestBean.agentId = agentId;

        System.debug('Request ------->' + requestBean);
        ChewyAgentStatus_Resp_IB_v1 responseChewy = ChewyAgentStatus_IH_v1.ChewyAgentStatus(requestBean);
           if((responseChewy != Null ) && (responseChewy.statusCode == 200) ){
              if(responseChewy.payloadObj != null){
               		if(responseChewy.payloadObj.activeConnections != null && responseChewy.payloadObj.activeConnections.Size() > 0){
                   		if(responseChewy.payloadObj.activeConnections[0].authentication.verified && responseChewy.payloadObj.activeConnections[0].authentication.identified){
                       		return responseChewy.payloadObj.activeConnections[0].ucId + '#' + responseChewy.payloadObj.activeConnections[0].authentication.verified + '#' + responseChewy.payloadObj.activeConnections[0].authentication.identified + '#' + responseChewy.payloadObj.activeConnections[0].servicingCif;
                   		}else{
                       		return 'Not Verified';
                   		}
               		}else{
                   		return 'No Data';
               }
           }
    }
         return null;
 }
}