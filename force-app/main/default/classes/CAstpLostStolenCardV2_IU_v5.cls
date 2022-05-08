/** 
* @description Integration Utility Bean for CAstpLostStolenCard Service
* @author Madhava Palla
* @created 2019-09-17
*/
public class CAstpLostStolenCardV2_IU_v5 {
    /**
	 * @description method to request fields
	 * @param cardDetailsMap
	 * @return CAstpLostStolenCardV2_Req_IB_v5
	 */
    public static CAstpLostStolenCardV2_Req_IB_v5 mapRequest(Map<String, String> cardDetailsMap){

        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

        CAstpLostStolenCardV2_Req_IB_v5 requestBean = new CAstpLostStolenCardV2_Req_IB_v5();
        requestBean.channel = StringConstants.SALESFORCE_STRING;
            requestBean.application = StringConstants.SALESFORCE_STRING; //BDP
            requestBean.trace = 'Y';
            requestBean.msgLanguage = 'E';
            requestBean.msgTarget = 'STD';
            requestBean.plasticNbr = cardDetailsMap.get('plasticNbr');
            requestBean.scnAction = 'ADD';
            requestBean.operatorId = 'BDP';
            requestBean.visaFrdRsn = '0';
            requestBean.mciFrdTyp = '';
            requestBean.tmsLs = cardDetailsMap.get('tmsLs');
            requestBean.lsRptdBy = 'CLNT';
            requestBean.lsHowRptdCd = 'PHN';
            requestBean.lsRptRsnCd = cardDetailsMap.get('lsRptRsnCd');
            requestBean.lsDt = cardDetailsMap.get('lsDt');
            requestBean.lsTmOfLoss = cardDetailsMap.get('lsTmOfLoss');
            requestBean.lsDtLstUsed = cardDetailsMap.get('lsDtLstUsed');
            requestBean.lsPlLstUsed = cardDetailsMap.get('lsPlLstUsed');
            requestBean.phnNbrPer = cardDetailsMap.get('phnNbrPer');
            requestBean.phnNbrBus = cardDetailsMap.get('phnNbrBus');
            requestBean.lsNbrCrdsMiss = '1';
            requestBean.distSiteCd = (cardDetailsMap.get('distSiteCd') == '' || cardDetailsMap.get('distSiteCd') == null)? currentUser.SiteCode__c: cardDetailsMap.get('distSiteCd');
            requestBean.distReasCd = (cardDetailsMap.get('distReasCd') == '' || cardDetailsMap.get('distReasCd') == null)? 'CB': cardDetailsMap.get('distReasCd');
            requestBean.crdIsSgndInd = cardDetailsMap.get('crdIsSgndInd');
            requestBean.pinIsSafeInd = cardDetailsMap.get('pinIsSafeInd');
            requestBean.advcNoUseInd = cardDetailsMap.get('advcNoUseInd');
            requestBean.circCd = cardDetailsMap.get('circCd');
            requestBean.whereLs = cardDetailsMap.get('whereLs');
            requestBean.howLostLn1 = cardDetailsMap.get('howLostLn1');
            requestBean.pxiStatNew = cardDetailsMap.get('pxiStatNew');
            requestBean.pxiStatOld = 'AAA';
            requestBean.axiXfrEffDt = String.valueOf(Integer.valueOf(Datetime.now().format('yyyyMMdd'))-19000000);//1191003
            requestBean.axiXfrRsn = cardDetailsMap.get('axiXfrRsn');
            requestBean.axiFrdCd = '0';
            requestBean.sof1 = cardDetailsMap.get('sof1');
            requestBean.sof2 = '';
            requestBean.sof3 = '';
            requestBean.sof4 = '';
            requestBean.sof5 = '';
            requestBean.crdRep = cardDetailsMap.get('crdRep');
            requestBean.siteCd = currentUser.SiteCode__c;
            requestBean.abnr = currentUser.AB_Number__c;
            requestBean.tellernr = currentUser.Teller_Operator_Code__c;//789

            return requestBean;
            
    }

    //

    /**
	 * @description Populates the Get CAstpLostStolenCardV2 service request bean from the parameters passed
	 * @param serviceWrapper
	 * @return CAstpLostStolenCardV2_Req_IB_v5
	 */
    public static CAstpLostStolenCardV2_Req_IB_v5 mapRequestFields(StopAndReplaceCardsServiceWrapper serviceWrapper){
        CAstpLostStolenCardV2_Req_IB_v5 requestBean = new CAstpLostStolenCardV2_Req_IB_v5();
        
        if(serviceWrapper != null){
            
            requestBean.channel = StringConstants.SALESFORCE_STRING;
            requestBean.application = StringConstants.SALESFORCE_STRING;
            requestBean.trace = 'Y';
            requestBean.msgLanguage = 'E';
            requestBean.msgTarget = 'STD';
            requestBean.scnAction = 'ADD';
            requestBean.operatorId = 'BDP';
            requestBean.visaFrdRsn = '';
            requestBean.mciFrdTyp = '';
            requestBean.tmsLs = '1';
            requestBean.lsRptdBy = 'CLNT';
            requestBean.lsHowRptdCd = 'PHN';
            requestBean.lsNbrCrdsMiss = '1';
            requestBean.pxiStatOld = 'AAA';
            requestBean.axiXfrEffDt = String.valueOf(Integer.valueOf(Datetime.now().format('yyyyMMdd'))-19000000);
            requestBean.axiFrdCd = '0';
            requestBean.sof2 = '';
            requestBean.sof3 = '';
            requestBean.sof4 = '';
            requestBean.sof5 = '';
            requestBean.tellernr = '999999';
            requestBean.plasticNbr = serviceWrapper.plasticNbr;
            requestBean.lsRptRsnCd = serviceWrapper.reason;
            Date cardLsDate =serviceWrapper.cardLostDate;
            String lsDt=(datetime.newInstance(cardLsDate.year(),cardLsDate.month(),cardLsDate.day())).format('yyyyMMdd');
            requestBean.lsDt = String.valueOf(Integer.valueOf(lsDt)-19000000);
            requestBean.lsTmOfLoss = string.valueOf((serviceWrapper.cardLostTime).second());
            Date cardLstUsedDate = serviceWrapper.cardLastUsedDate;
            String lsDtLstUsed = (datetime.newInstance(cardLstUsedDate.year(),cardLstUsedDate.month(),cardLstUsedDate.day())).format('yyyyMMdd');
            requestBean.lsDtLstUsed = String.valueOf(Integer.valueOf(lsDtLstUsed)-19000000);
            requestBean.lsPlLstUsed = serviceWrapper.cardLastUsedPlace;
            requestBean.phnNbrPer = serviceWrapper.homePhone;
            requestBean.phnNbrBus = serviceWrapper.officePhone;
            
            if(serviceWrapper.replaceCard == true){
                requestBean.distReasCd = [Select id,External_Value__c,Internal_Value__c from Integration_Translation__c where Internal_Value__c=:serviceWrapper.distReasCode limit 1].External_Value__c;
                
                if(requestBean.distReasCd =='CB'){
                    requestBean.distSiteCd = serviceWrapper.distSiteCode;
                }else{
                    requestBean.distSiteCd = '8114';
                }
            }else{
                requestBean.distReasCd = 'SP'; 
                requestBean.distSiteCd = '8114';
            }
            
            requestBean.crdIsSgndInd = serviceWrapper.wasCardSigned == true ? 'Y' : 'N';
            requestBean.pinIsSafeInd = serviceWrapper.didCardHaveSafePin == true ? 'Y' : 'N';
            requestBean.advcNoUseInd = serviceWrapper.doNotUseCard == true ? 'Y' : 'N';
            requestBean.circCd = serviceWrapper.circumstances;
            requestBean.whereLs = serviceWrapper.cardLostPlace;
            requestBean.howLostLn1 = serviceWrapper.cardLostDiscription;
            requestBean.axiXfrRsn = serviceWrapper.reason;
            requestBean.sof1 = serviceWrapper.sof1 == true ? '20' : '  ';
            requestBean.crdRep = serviceWrapper.replaceCard == true ? 'Y' : 'N';
            requestBean.siteCd = serviceWrapper.agentSiteCode;
            
            if (serviceWrapper.reason == 'APP' || serviceWrapper.reason == 'LST') {
                
                requestBean.pxiStatNew = 'L0P';
                
            } else if (serviceWrapper.reason == 'STL') {
                
                requestBean.pxiStatNew = 'L1P';
                
            }
            
            List<User> userList = [SELECT AB_Number__c
                                   FROM User
                                   WHERE Id =: UserInfo.getUserId()
                                   LIMIT 1];
            
            if (userList != null && userList.size() > 0) {
                
                requestBean.abnr = userList[0].AB_Number__c;
                
            }
            
        }
        
        return requestBean;
    }

    /**
	 * @description Populates the CAstpLostStolenCardV2 Details response bean from an http response
	 * @param respP
     * @param serviceWrapper
	 * @return CAstpLostStolenCardV2_Req_IB_v5
	 */
    public static CAstpLostStolenCardV2_Resp_IB_v5 mapResponseFields(HttpResponse respP,StopAndReplaceCardsServiceWrapper serviceWrapper){
        CAstpLostStolenCardV2_Resp_IB_v5 responseBean = new CAstpLostStolenCardV2_Resp_IB_v5();
       
        responseBean = (CAstpLostStolenCardV2_Resp_IB_v5)responseBean.deserialize( respP.getBody(), CAstpLostStolenCardV2_Resp_IB_v5.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        responseBean.plasticCardNum = serviceWrapper.plasticNbr;
        responseBean.accHolderName = serviceWrapper.accHolderName;
        return responseBean;
    }

    /**
	 * @description Populates the CAstpLostStolenCardV2 Details response bean as failed with the necessary data
	 * @param statusCodeP
     * @param statusP
     * @param messageP
	 * @return CAstpLostStolenCardV2_Req_IB_v5
	 */
    public static CAstpLostStolenCardV2_Resp_IB_v5 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        CAstpLostStolenCardV2_Resp_IB_v5 CAstpLostStolenCardV2Response = new CAstpLostStolenCardV2_Resp_IB_v5();
        CAstpLostStolenCardV2Response.message = messageP;
        CAstpLostStolenCardV2Response.status = statusP;
        CAstpLostStolenCardV2Response.statusCode = statusCodeP;
        return CAstpLostStolenCardV2Response;
    }
}