/**

 * @description Controller for Unclaimed Funds Services

 * @Author: Mbuyiseni Mbhokane
 * @Since: 05/10/2020
 */
public class UnclaimedFundsController {
    
    //Added by Mbuyiseni Mbhokane : Method to call UFGetUnclaimedFundsHistV1Service
    /*@AuraEnabled
    public static String getUnclaimedFundsHistV1(String UFN643I_ACCOUNT_NUMBER, String UFN643I_CHEQUE_NUMBER, String UFN643I_CLIENT_CODE, String UFN643I_CLIENT_NUM, String UFN643I_LAST_ACCOUNT_NUMBER, String UFN643I_NUMBER_PREV_ACCOUNTS, String UFN643I_BRANCH_CODE){
        String unclaimedFundsHistResponse;
        try{
            UFGetUnclaimedFundsHistV1_Req_IB_v1 historyRequestBean = UFGetUnclaimedFundsHistV1_IU_v2.mapRequestFields(UFN643I_ACCOUNT_NUMBER, UFN643I_CHEQUE_NUMBER, UFN643I_CLIENT_CODE, UFN643I_CLIENT_NUM, UFN643I_LAST_ACCOUNT_NUMBER, UFN643I_NUMBER_PREV_ACCOUNTS, UFN643I_BRANCH_CODE);
            UFGetUnclaimedFundsHistV1_Resp_IB_v1 historyResponseBean = UFGetUnclaimedFundsHistV1_IH_v2.getUnclaimedFundsHist(historyRequestBean);
            if((historyResponseBean != null)){
                unclaimedFundsHistResponse = historyResponseBean.serialize(historyResponseBean);
                System.debug('unclaimedFundsHistResponse: '+ unclaimedFundsHistResponse);
            }
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
        }      
        return unclaimedFundsHistResponse;
        
    }
    
    //Added by Mbuyiseni Mbhokane : Method to call UFGetUnclaimedFundsDetailsV1Service
    @AuraEnabled
    public static String getUnclaimedFundsDetailsV1(String recordNumber){
        
        String unclaimedFundsDetailsResponse;
        try{
			UFGetUnclaimedFundsDetailsV1_Req_IB_v1 fundsDetailsRequestBean = UFGetUnclaimedFundsDetailsV1_IU_v2.mapRequestFields(recordNumber);
            UFGetUnclaimedFundsDetailsV1_Resp_IB_v1 fundsDetailsResponseBean = UFGetUnclaimedFundsDetailsV1_IH_v2.getUnclaimedFundsDetails(fundsDetailsRequestBean);
            if((fundsDetailsResponseBean != null)){
                unclaimedFundsDetailsResponse = fundsDetailsResponseBean.serialize(fundsDetailsResponseBean);
                System.debug('unclaimedFundsDetailsResponse: '+ unclaimedFundsDetailsResponse);
            }
            
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
        }
        
        return unclaimedFundsDetailsResponse;
    }
    
    //Added by Mbuyiseni Mbhokane : Method to call UFUpdUnclaimedFundsStaleCorrV1Service
    @AuraEnabled
    public static String updUnclaimedFundsStaleCorrV1(String UFN637I_ACCOUNT_NBR, String UFN637I_AMOUNT, String UFN637I_CLIENT_CODE, String UFN637I_CLIENT_NUM, String UFN637I_CONFIRM_IND, String UFN637I_EFFECTIVE_DATE, String UFN637I_IMS_SYSID, String UFN637I_STO_TIE){
        String updUnclaimedFundsStaleCorrResponse;
        try{
            UFUpdUnclaimedFundsStaleCorrV1_Req_IB_v1 fundsStaleCorrRequestBean = UFUpdUnclaimedFundsStaleCorrV1_IU_v2.mapRequestFields(UFN637I_ACCOUNT_NBR, UFN637I_AMOUNT, UFN637I_CLIENT_CODE, UFN637I_CLIENT_NUM, UFN637I_CONFIRM_IND, UFN637I_EFFECTIVE_DATE, UFN637I_IMS_SYSID, UFN637I_STO_TIE);
            UFUpdUnclaimedFundStaleCorrV1_Resp_IB_v1 fundsStaleCorrResponseBean = UFUpdUnclaimedFundsStaleCorrV1_IH_v2.updUnclaimedFundsStaleCorr(fundsStaleCorrRequestBean);
            if((fundsStaleCorrResponseBean != null)){
                updUnclaimedFundsStaleCorrResponse = fundsStaleCorrResponseBean.serialize(fundsStaleCorrResponseBean);
                System.debug('updUnclaimedFundsStaleCorrResponse: '+ updUnclaimedFundsStaleCorrResponse);   
            }
            
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
        }
        return updUnclaimedFundsStaleCorrResponse;
    }
    
    //Added by Mbuyiseni Mbhokane : Method to call UFGetUnclaimedFundsStaleCorrV1Service
    @AuraEnabled
    public static String getUnclaimedFundsStaleCorrV1(String UFN636I_ACCOUNT_NBR, String UFN636I_CLIENT_CODE, String UFN636I_CLIENT_NUM, String UFN636I_IMS_SYSID, String UFN636I_LAST_RECORD, String UFN636I_STO_NOACC){
        String getUnclaimedFundsStaleCorrResponse;
        try{
			
            UFGetUnclaimedFundsStaleCorrV1_Req_IB_v1 getUnclaimedFundsStaleCorrReqBean = UFGetUnclaimedFundsStaleCorrV1_IU_v2.mapRequestFields(UFN636I_ACCOUNT_NBR, UFN636I_CLIENT_CODE, UFN636I_CLIENT_NUM, UFN636I_IMS_SYSID, UFN636I_LAST_RECORD, UFN636I_STO_NOACC);
            UFGetUnclaimedFundStaleCorrV1_Resp_IB_v1 getUnclaimedFundsStaleCorrRespBean = UFGetUnclaimedFundsStaleCorrV1_IH_v2.getUnclaimedFundStaleCorr(getUnclaimedFundsStaleCorrReqBean);
            if((getUnclaimedFundsStaleCorrRespBean != null)){
                getUnclaimedFundsStaleCorrResponse = getUnclaimedFundsStaleCorrRespBean.serialize(getUnclaimedFundsStaleCorrRespBean);
                System.debug('getUnclaimedFundsStaleCorrResponse: '+ getUnclaimedFundsStaleCorrResponse);
            }
            
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
        }
        return getUnclaimedFundsStaleCorrResponse;
    }

    //Added by Mbuyiseni Mbhokane : Method to call UFGetUnclaimedFundsPayoutV1 service
    @AuraEnabled
    public static String getUnclaimedFundsPayout(){
        String unclaimedFundsPayoutResponse;
        try{
            UFGetUnclaimedFundsPayoutV1_Req_IB_v1 getUnclaimedFundsPayoutReqBean = UFGetUnclaimedFundsPayoutV1_IU_v2.mapRequestFields();
            UFGetUnclaimedFundsPayoutV1_Resp_IB_v1 getUnclaimedFundsPayoutRespBean = UFGetUnclaimedFundsPayoutV1_IH_v2.getUnclaimedFundsPayout(getUnclaimedFundsPayoutReqBean);
            if ((getUnclaimedFundsPayoutRespBean != null) && (getUnclaimedFundsPayoutRespBean.statusCode ==200)) {
                unclaimedFundsPayoutResponse = getUnclaimedFundsPayoutRespBean.serialize(getUnclaimedFundsPayoutRespBean);
                System.debug('unclaimedFundsPayoutResponse : '+ unclaimedFundsPayoutResponse);
            }
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
        return unclaimedFundsPayoutResponse;
        
    }*/

    //Added By Mbuyiseni Mbhokane: call CQgetAcctHoldsMaintV4 to get Cheque Account details.

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param accountNumberP 
    * @return String 
    **/

    @AuraEnabled
    public static String viewHoldsOnchequeAccount(String accountNumberP){
        String chequeAccountHoldsResponse = ViewAccountHoldsController.cqgetaccountholdsdetail(accountNumberP);
        System.debug('cheque account response: '+ chequeAccountHoldsResponse);
        return chequeAccountHoldsResponse;
    }

    //Added By Mbuyiseni Mbhokane: call SVgetAccountHoldsDetailV4 to get Savings Account Details

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param accountNumberP 
    * @return String 
    **/

    @AuraEnabled
    public static String viewHoldsOnSavingsAccount(String accountNumberP){
        String savingsAccountHoldsResponse = ViewAccountHoldsController.svgetaccountholdsdetail(accountNumberP);
        return savingsAccountHoldsResponse;
    }

    //Added By Mbuyiseni Mbhokane: call CIgetAcctLinkedToClientCode service to get clients accounts

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param clientAccountId 
    * @return string 
    **/

    @AuraEnabled
    public static string getAccountLinkedToClient(String clientAccountId){
        String linkedAccountForClientResponse =  AddBeneficiaryController.getAccountDetails(clientAccountId);
        return linkedAccountForClientResponse;
    }

    //Added by Mbuyiseni Mbhokane: call SVupdateAccountHoldsV4 service

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param accountNumber 
    * @param frozenInd 
    * @param stoppedInd 
    * @param dormantInd 
    * @param semiDormantInd 
    * @param exclEstateInd 
    * @param exclInslvntInd 
    * @param courtOrderInd 
    * @param signingAuthInd 
    * @param monitorActivityInd 
    * @param potBadDebtInd 
    * @param legalActionInd 
    * @param nonResidentInd 
    * @param lostBookInd 
    * @param blockedInd 
    * @param offlineEnqInd 
    * @param securityMessageInd 
    * @param restricHoldInd 
    * @param exceedMaxBalInd 
    * @param wtiCountry 
    * @param rbaEddHold 
    * @return string 
    **/

    @AuraEnabled
    public static string svUpdateHolds(String accountNumber, String frozenInd, String stoppedInd, String dormantInd, String semiDormantInd, String exclEstateInd, String exclInslvntInd, String courtOrderInd, String signingAuthInd, String monitorActivityInd, String potBadDebtInd, String legalActionInd, String nonResidentInd, String lostBookInd, String blockedInd, String offlineEnqInd, String securityMessageInd, String restricHoldInd, String exceedMaxBalInd, String wtiCountry, String rbaEddHold){
        String svHoldsResponse = ViewAccountHoldsController.svUpdateaccountholds(accountNumber, frozenInd, stoppedInd, dormantInd, semiDormantInd, exclEstateInd, exclInslvntInd, courtOrderInd, signingAuthInd, monitorActivityInd, potBadDebtInd, legalActionInd, nonResidentInd, lostBookInd, blockedInd, offlineEnqInd, securityMessageInd, restricHoldInd, exceedMaxBalInd, wtiCountry, rbaEddHold);
        return svHoldsResponse;
    }

    //Added by Mbuyiseni Mbhokane: call CQupdAcctHoldsV4 service

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param accountNumber 
    * @param blocked 
    * @param courtOrder 
    * @param mandateRequired 
    * @param dormant 
    * @param semiDormant 
    * @param confiscated 
    * @param externalTransfer 
    * @param staff 
    * @param creditAccount 
    * @param excludeFromEstate 
    * @param blockAdhocDbt 
    * @param blockAdhocCrd 
    * @param specialRqpRedirect 
    * @param commercialPropFin 
    * @param misHold 
    * @param genSecMsg 
    * @param wapWildAccPickup 
    * @param exclFromInsolvent 
    * @param digitalHold 
    * @param odSwitchInd 
    * @return string 
    **/

    @AuraEnabled
    public static string cqUpdateHolds(String accountNumber, String blocked, String courtOrder, String mandateRequired, String dormant, String semiDormant, String confiscated, String externalTransfer, String staff, String creditAccount, String excludeFromEstate, String blockAdhocDbt, String blockAdhocCrd, String specialRqpRedirect, String commercialPropFin, String misHold, String genSecMsg, String wapWildAccPickup, String exclFromInsolvent, String digitalHold, String odSwitchInd){
        String cqHoldsResponse = ViewAccountHoldsController.validateChequeHolds(accountNumber, blocked, courtOrder, mandateRequired, dormant, semiDormant, confiscated, externalTransfer, staff, creditAccount, excludeFromEstate, blockAdhocDbt, blockAdhocCrd, specialRqpRedirect, commercialPropFin, misHold, genSecMsg, wapWildAccPickup, exclFromInsolvent, digitalHold, odSwitchInd);
        return cqHoldsResponse;
    }

    //added by Mbuyiseni Mbhokane: call CQgetCloseAccountDetailsV4API service

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param CQS534I_ACCOUNT_NBR 
    * @param CQS534I_EFFECTIVE_CLSD_DATE 
    * @return string 
    **/

    @AuraEnabled
    public static string cqGetCloseAccDetails(String CQS534I_ACCOUNT_NBR, String CQS534I_EFFECTIVE_CLSD_DATE){
        
        Date todaysDate = Date.today();
        CQS534I_EFFECTIVE_CLSD_DATE = String.valueOf(todaysDate).replace('-', '');

        String closeAccountDetailsResponse;
        try {
            CQgetCloseAccountDetailsV4API_Req_IB_v1 closeAccountRequest = CQgetCloseAccountDetailsV4API_IU_v1.mapRequiredFields(CQS534I_ACCOUNT_NBR, CQS534I_EFFECTIVE_CLSD_DATE);
            CQgetCloseAccountDetailsV4API_Resp_IB_v1 closeAccountResponse = CQgetCloseAccountDetailsV4API_IH_v1.getCloseAccountDetails(closeAccountRequest);
            if (closeAccountResponse != null) {
                closeAccountDetailsResponse = closeAccountResponse.serialize(closeAccountResponse);
            }
        } catch (Exception e) {
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
        return closeAccountDetailsResponse;
    }

    //added by Mbuyiseni Mbhokane: call CQUpdClosureDetailsV1 service

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param CQN960I_ACCOUNT_NBR 
    * @param CQN960I_CLOSE_REASON 
    * @return string 
    **/

    @AuraEnabled
    public static string cqUpdateCloseAccDetails(String CQN960I_ACCOUNT_NBR, String CQN960I_CLOSE_REASON){
        String updateAccountClosureDetails;
        try {
            CQUpdClosureDetailsV1_Req_IB_v1 requestBean = CQUpdClosureDetailsV1_IU_v1.mapRequiredFields(CQN960I_ACCOUNT_NBR, CQN960I_CLOSE_REASON);
            CQUpdClosureDetailsV1_Resp_IB_v1 responseBean = CQUpdClosureDetailsV1_IH_v1.updateCloseAccountDetails(requestBean);
            if (responseBean != null) {
                updateAccountClosureDetails = responseBean.serialize(responseBean);
            }
        } catch (Exception e) {
            System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }

        return updateAccountClosureDetails;
    }
}