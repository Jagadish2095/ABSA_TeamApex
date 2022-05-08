/* Lightning cmp controller for Payment Request (Telephonic) based upon payment type
* Author: Himanshu Nimje (Mphatek)
* Date :  02/03/2020
*
* Second Author : Srikanth
* Date: 02/08/2020
*
* Modified : Future Payment Added (Service- CreateInstruction added for Future Dated Payment)
* modified by : Himanshu Nimje (Mphatek)
* Date Modified: 02/20/2020

* Modified : Future Payment  and completePayment
* modified by : Lulu Rankwe
* Date Modified: 27/02/2020
*/

public class PaymentRequestController {
    
/*  Humbelani Denge 
*   Date added: 08/01/2021
*/
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId) {
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        
        if (accountList?.size() != 1) {
            return 'Error: Account not found with Id: ' + clientAccountId;
        }
        
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING, accountList[0].CIF__c);
        
        if (response == null) {
            return 'Error: Blank response received from service.';
        }
        if (String.isNotBlank(response.nbsmsgo3?.msgEntry?.msgTxt)) {
            return 'Error: ' + response.nbsmsgo3.msgEntry.msgTxt;
        }
        if (response.statusCode != 200) {
            return 'Error: ' + response.message;
        }
        if (response.cip047o?.outputTable == null) {
            return 'Error: Unexpected response received. Service Response: ' + json.serialize(response);
        }
        
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = response.cip047o.outputTable;
        return JSON.serialize(accTypes);
    }
    
    
    /**
* Get the Daily Limits for the Source Bank Account selected
* Author : Srikanth
* @ param accountNumber
* @ return result (String)
*/
    @AuraEnabled
    public static String getDailyLimits(String selectedCombiNumber) {
        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(selectedCombiNumber);
        CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
        if (responseBean.statusCode == 200) {
            CCgetDailyLimits_Resp_IB_v1.CCgetDailyLimitsV2Response wrapper = responseBean.CCgetDailyLimitsV2Response;
            CCgetDailyLimits_Resp_IB_v1.ccp312o cls_CCp312o = wrapper.ccp312o;
            return JSON.serialize(cls_CCp312o);
        }
        return null;
    }
    
    /**
* Initiate Payment the Source Bank Account selected
* Author : Lulu Rankwe
* @ params
* @ return result (String)
*/
    @AuraEnabled
    public static MBinitiatePaymentV10_Resp_IB_v1 intiatePayment(
        String payTime,
        String actDate,
        String amount,
        String srcAcc,
        String srcAccType,
        String srcStmtRef,
        String trgAcc,
        String trgClrCode,
        String trgAccType,
        String trgStmtRef,
        String paymIipInd,
        String instrRefName,
        String tieb
    ) {
        String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            StringConstants.EPS_STRING,
            'Account Type',
            trgAccType,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        System.debug('trgAccTypeTrans ' + trgAccTypeTrans);
        
        for (
            MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.callMBinitiatePayment(
                payTime,
                actDate,
                amount,
                srcAcc,
                srcAccType,
                srcStmtRef,
                trgAcc,
                trgClrCode,
                trgAccTypeTrans,
                trgStmtRef,
                paymIipInd,
                instrRefName,
                tieb
            )
            .keyset()
        ) {
            if (singleresponse != null) {
                if (singleresponse.statusCode == 200) {
                    system.debug('response tt' + singleresponse);
                    return singleresponse;
                }
            }
        }
        
        return null;
    }
    
    /**
* Pay Beneficiary
*  Author : Lulu Rankwe
* @ param Strings
* @ return result (String)
*/
    @AuraEnabled
    public static MBinitiatePaymentV10_Resp_IB_v1 payBeneficiary(
        String clientAccountId,
        String paymTime,
        String accessAcc,
        String instrRefName,
        String actDate,
        String amount,
        String instrNo,
        String srcAcc,
        String srcAccType,
        String srcStmtRef,
        String trgAcc,
        String trgClrCode,
        String trgAccType,
        String trgStmtRef,
        String paymIipInd,
        String tieb
    ) {
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        String cifKey = accountList[0].CIF__c;
        
        String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            StringConstants.EPS_STRING,
            'Account Type',
            trgAccType,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        for (
            MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.payBeneficiary(
                paymTime,
                accessAcc,
                cifKey,
                instrRefName,
                actDate,
                amount,
                instrNo,
                srcAcc,
                srcAccType,
                srcStmtRef,
                trgAcc,
                trgClrCode,
                trgAccTypeTrans,
                trgStmtRef,
                paymIipInd,
        		tieb
            )
            .keyset()
        ) {
            if (singleresponse != null) {
                if (singleresponse.statusCode == 200) {
                    system.debug('response' + singleresponse);
                    return singleresponse;
                }
            }
        }
        
        return null;
    }
    
    /**
* Future Dated Payment
* Author : Himanshu Nimje
*  modified Lulu Rankwe
* @ return result (String CreateInstruction_Resp_IB_v1)
*/
    @AuraEnabled
    public static string intiatefuturePayment(
        String srcAccountNumber,
        String srcAccountType,
        String amount,
        String trgAccNumberP,
        String trgBranchCodeP,
        String trgAccReferenceP,
        String trgAccTypeP,
        String futureDateP,
        String futureSourceRef,
        String accessAcc
    ) {
        string result;
        String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            StringConstants.EPS_STRING,
            'Account Type',
            trgAccTypeP,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        String srcAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            StringConstants.EPS_STRING,
            'Account Type',
            srcAccountType,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        
        CreateInstruction_Req_IB_v1 requestBean = new CreateInstruction_Req_IB_v1();
        requestBean.accessAcc = accessAcc;
        
        futureDatep = futureDatep.replace('-', '');
        System.debug('*********future Date******** ' + futureDatep);
        CreateInstruction_Req_IB_v1 ReqBean = new CreateInstruction_Req_IB_v1();
        CreateInstruction_Resp_IB_v1 respBean = CreateInstruction_IH_v1.MBCreateInstructionFuture(
            srcAccountNumber,
            srcAccTypeTrans,
            amount,
            trgAccNumberP,
            trgBranchCodeP,
            trgAccReferenceP,
            trgAccTypeTrans,
            futureDatep,
            futureSourceRef,
            accessAcc
        );
        if (respBean.respDesc == 'SUCCESSFUL PROCESS') {
            result = 'SUCCESSFUL PROCESS';
        } else {
            result = respBean.respDesc;
        }
        return result;
    }
    
    /*
*complete immediate payment using uniqueEFT
* Author Lulu Rankwe
* @Para uniqueEft
* return strings(result)
* @ return result
*/
    @AuraEnabled
    public static String completePayment(String uniqueEft) {
        String result;
        
        // if(uniqueEft != null){
        MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.mBcomplEpSpaymentV4(uniqueEft);
        MBcomplEpSpaymentV4_Resp_IB_v1.MBcomplEpSpaymentV4Response outputBean = singleresponse.MBcomplEpSpaymentV4Response;
        
        if (outputBean != null) {
            MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o output = outputBean.mbp302o;
            if (singleresponse.statusCode == 200) {
                if (output.respDesc == 'SUCCESSFUL PROCESS') {
                    result = output.respDesc;
                } else {
                    result = output.respDesc;
                }
            }
        }
        // }
        return result;
    }
    
    /*
*complete immediate payment  for pay beneficiary
* Author Lulu Rankwe
* @Para uniqueEft
*  @Para paymNo
* @ return result
*/
    @AuraEnabled
    public static String completeBeneficiaryPayment(String uniqueEft, String paymNo) {
        String result;
        
        if (uniqueEft != null && paymNo != null) {
            MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.payBeneficiary(uniqueEft, paymNo);
            MBcomplEpSpaymentV4_Resp_IB_v1.MBcomplEpSpaymentV4Response outputBean = singleresponse.MBcomplEpSpaymentV4Response;
            
            if (outputBean != null) {
                MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o output = outputBean.mbp302o;
                if (singleresponse.statusCode == 200) {
                    if (output.respDesc == 'SUCCESSFUL PROCESS') {
                        result = output.respDesc;
                    } else {
                        result = output.respDesc;
                    }
                }
            }
        }
        return result;
    }
    
    /*
* Get the account beneficiaries using CIF Key & account number
* Author: JQUEV & DBOOYSEN
*/
    @AuraEnabled
    public static MBlistInstructionsPerSrcAccV1_Resp_IB_v1 getBeneficiariesList(String cifKey, String selectedAccount) {
        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 responseBean = MBlistInstructionsPerSrcAccV1_IH_v1.mblistinstrpersourceaccv1(cifKey, selectedAccount);
        return responseBean;
    }
    
    @AuraEnabled
    public static String getBankBranchCode(String bankName) {
        if (bankName == 'ABSA BANK') {
            return '632005';
        } else if (bankName == 'BIDVEST BANK LIMITED') {
            return '462005';
        } else if (bankName == 'CAPITEC BANK LIMITED') {
            return '470010';
        } else if (bankName == 'FIRSTRAND') {
            return '250655';
        } else if (bankName == 'INVESTEC BANK LIMITED') {
            return '580105';
        } else if (bankName == 'NEDBANK') {
            return '198765';
        } else if (bankName == 'STD S.A.') {
            return '051001';
        }
        return null;
    }
    
    @AuraEnabled
    public static Lookup__c getSelectedBranchRecordDetails(String branchCode) {
        Set<String> branchCodeSet = new Set<String>();
        branchCodeSet.add(branchCode);
        List<Lookup__c> lookupList = new LookupsSelector().selectByBranchCode(branchCodeSet);
        
        if (lookupList != null && lookupList.size() > 0) {
            return lookupList[0];
        } else {
            return null;
        }
    }
    /*
* Get additional details for selected Branch
* User Lookup__c
*/
    @AuraEnabled
    public static Lookup__c getBankIdByName(String bankName) {
        List<Lookup__c> lookupList = new LookupsSelector().selectByName(BankName);
        
        if (lookupList != null && lookupList.size() > 0) {
            return lookupList[0];
        } else {
            return null;
        }
    }
    
    /**
* method return list of instructions for future payment
* @ params   srcAcc, clientAccountId, origStatus
* @ return result (String)
*/
    
    @AuraEnabled
    public static String getIntsructionList(String clientAccountId, String srcAcc) {
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        String cifKey = accountList[0].CIF__c;
        
        if (clientAccountId != null) {
            Map<MBListsourceinstructionsv1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.mbListSourceInstructions(
                cifKey,
                srcAcc
            );
            MBListsourceinstructionsv1_Resp_IB_v1 responseBean = (new List<MBListsourceinstructionsv1_Resp_IB_v1>(responseMap.keySet()))[0];
            if (responseBean != null) {
                if (responseBean.statusCode == 200) {
                    if (responseBean.MBlistSourceInstructionsV1Response != null) {
                        if (responseBean.MBlistSourceInstructionsV1Response.mbn305o != null) {
                            return JSON.serialize(responseBean.MBlistSourceInstructionsV1Response.mbn305o);
                        }
                    }
                }
            }
        }
        return null;
    }
    
    /**
* update selected instructions for future payment
* @ params   srcAcc, clientAccountId, origStatus
* @ return result (String)
*/
    
    @AuraEnabled
    public static string updateFuturePayment(
        String clientAccountId,
        String instrNo,
        String amount,
        String instrRefName,
        String srcAccNumber,
        String srcAccType,
        String srcBranchCode,
        String srcRef,
        String trgAccNumber,
        String trgAccType,
        String trgBranchCode,
        String trgRef,
        String actDate
    ) {
        String errorMsg = 'Exception';
        system.debug('instr: ' + instrNo);
        system.debug('amount: ' + amount);
        AuraHandledException ex = new AuraHandledException(errorMsg);
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        String cifKey = accountList[0].CIF__c;
        
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
        String siteCode = currentUser.SiteCode__c;
        String teller = currentUser.Teller_Operator_Code__c;
        String actDateP = actDate.replace('-', '');
        
        try {
            if (clientAccountId != null) {
                if (cifKey != null) {
                    //Update Callout
                    Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.updateInstruction(
                        cifKey,
                        instrNo,
                        amount,
                        instrRefName,
                        srcAccNumber,
                        srcAccType,
                        srcBranchCode,
                        srcRef,
                        trgAccNumber,
                        trgAccType,
                        trgBranchCode,
                        trgRef,
                        siteCode,
                        teller,
                        actDateP
                    );
                    MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
                    MBupdateInstructionV1_Resp_IB_v1.Mbp300o respData = responseBean.MBupdateInstructionV1Response.Mbp300o;
                    
                    //if(responseBean != null ){
                    if (respData != null) {
                        // update successfull
                        if (respData.respCode == '0') {
                            return respData.respDesc + '  UPDATED';
                        } else {
                            // update failed with error
                            ex.setMessage(respData.respDesc);
                            throw ex;
                        }
                    } else {
                        ex.setMessage('There was an error updating the record');
                        throw ex;
                    }
                } else {
                    ex.setMessage('There was an error retrieving the Client CIF Number');
                    throw ex;
                }
            } else {
                ex.setMessage('There was an error retrieving the Client record');
                throw ex;
            }
        } catch (Exception e) {
            System.debug('Update Beneficiary exception : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string removePayment(String clientAccountId, String instrNo) {
        String errorMsg = 'Exception';
        AuraHandledException ex = new AuraHandledException(errorMsg);
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        String cifKey = accountList[0].CIF__c;
        
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
        String siteCode = currentUser.SiteCode__c;
        String teller = currentUser.Teller_Operator_Code__c;
        
        try {
            if (clientAccountId != null) {
                if (cifKey != null) {
                    //Update  Callout
                    Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2Forpayment(
                        cifKey,
                        instrNo,
                        siteCode,
                        teller
                    );
                    
                    // Get first key from the map
                    MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
                    
                    MBdeleteInstructionV2_Resp_IB_v1.Mbp306o respData = responseBean.MBdeleteInstructionV2Response.Mbp306o;
                    
                    if (respData != null) {
                        // removed successfull
                        if (respData.respCode == '0') {
                            return respData.respDesc + ' REMOVED';
                        } else {
                            //remove failed with error
                            ex.setMessage(respData.respDesc);
                            throw ex;
                        }
                    } else {
                        //Reponse Bean is empty
                        ex.setMessage('There was an error removing the record');
                        throw ex;
                    }
                } else {
                    ex.setMessage('There was an error retrieving the Client CIF Number');
                    throw ex;
                }
            } else {
                ex.setMessage('There was an error retrieving the Client record');
                throw ex;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}