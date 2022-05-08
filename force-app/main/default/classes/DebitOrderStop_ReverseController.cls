public class DebitOrderStop_ReverseController {
    /*--
* Lightning Component for Account Selection
*
* @author  Srikanth : Absa
* @version v1.0
* @since   2020-03-03
*
--*/       
    @AuraEnabled
    public static dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o viewDebitOrderDetails(String AccountId,string FrmDate){
        Map<dSretrieveDebitsCreditsInqV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = dSretrieveDebitsCreditsInqV2_IH_v1.callTodSretrieveDebitsCreditsInqV2(AccountId,FrmDate);
        
        dSretrieveDebitsCreditsInqV2_Resp_IB_v1 responseBean = (new List<dSretrieveDebitsCreditsInqV2_Resp_IB_v1>(responseMap.keySet()))[0];
        
        if(responseBean.statusCode == 200){
            dSretrieveDebitsCreditsInqV2_Resp_IB_v1.DSretrieveDebitsCreditsInqV2Response cls_retrieveDebitsCreditsInqWrapper = responseBean.DSretrieveDebitsCreditsInqV2Response;
            dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o dsp973o = cls_retrieveDebitsCreditsInqWrapper.Dsp973o;
            return dsp973o;
        }else{
            
            system.debug('Error');
        }
        
        return null;
        
    }
    
    @AuraEnabled
    Public static void sendEmailOnCaseClose(Id caseRecordId)
    {
        if(caseRecordId!=null){
            Case caseObj = new Case(Id=caseRecordId);
            caseObj.Status = 'Closed';
            Update caseObj;
        }                                
    }
    @AuraEnabled
    public static Map<String,String> deleteDebitOrderDetails(dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o response, List<String> selectedValues, String accountNumber, String actionItem, String actionReason, String caseId){
        Map<String,String> returnWrapper = new Map<String,String>{'state'=>'success','message'=> 'done'}; 
            
            String actionReasonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
                StringConstants.EPS_STRING,
                'Response Code',
                actionReason,
                StringConstants.OUTBOUND_RECORD_TYPE
            );
        system.debug(actionReasonTranslated);
        system.debug('selectedValues'+response);
        UsersSelector userSelectorRef = new UsersSelector();
        User loggedinUser = userSelectorRef.selectById(UserInfo.getUserId());
        CasesSelector caseSelector = new CasesSelector();
        Case selectedCase = caseSelector.selectByCaseId(caseId)[0];      
        List<dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList> debitCreditList = new List<dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList>(); 
        //response.debitCreditList;
        for(String selectedvalue : selectedValues){
            if(selectedvalue != null) debitCreditList.add(response.debitCreditList[Integer.valueOf(selectedvalue)]);
        }
        system.debug('selectedValues'+debitCreditList);
        
        if(actionItem == 'StopDebitOrder'){
            dSaddStopPaymentV2_Req_IB_v1 requestBean = dSaddStopPaymentV2_IU_v1.mapRequestdFields(); 
            
            dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea dsc976iInputAreaBean = new dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea();
            
            dsc976iInputAreaBean.accNo = accountNumber; //'4047433399';
            dsc976iInputAreaBean.actDate =  debitCreditList[0].actionDate; //'20191017';
            dsc976iInputAreaBean.userCode =debitCreditList[0].userCode; // '0110';
            dsc976iInputAreaBean.userRef = debitCreditList[0].userRef; //'01023423 011     CC';
            dsc976iInputAreaBean.amount = debitCreditList[0].amount; //'100';
            dsc976iInputAreaBean.brnch = loggedinUser.SiteCode__c; //'32322';
            dsc976iInputAreaBean.teller = loggedinUser.Teller_Operator_Code__c; //'12122';
            dsc976iInputAreaBean.caseNo = String.valueof(selectedCase.CaseNumber).replace('C-',''); // '12345678';//casenmbr.CaseNumber;	
            dsc976iInputAreaBean.institution = debitCreditList[0].nameOfInst; //'ABSA CARD';
            dsc976iInputAreaBean.effDate = debitCreditList[0].effFrmDate; //'20191009'
            
            dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2 DSaddStopPaymentV2bean = new dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2();
            DSaddStopPaymentV2bean.dsc976iInputArea = dsc976iInputAreaBean;
            requestBean.DSaddStopPaymentV2 = DSaddStopPaymentV2bean;
            Map<dSaddStopPaymentV2_Resp_IB_v1, List<Sys_Log_Integration__c>>  responseMap = dSaddStopPaymentV2_IH_v1.callTodSaddStopPaymentV2(requestBean);
            
            dSaddStopPaymentV2_Resp_IB_v1 responseBean = (new List<dSaddStopPaymentV2_Resp_IB_v1>(responseMap.keySet()))[0];
            if(responseBean.statusCode == 200) {
                if(responseBean.DSaddStopPaymentV2Response.dsc976oOutput.dsc976oRespCode == '0'){
                    
                    returnWrapper.put('state', 'success');
                    returnWrapper.put('message', responseBean.DSaddStopPaymentV2Response.dsc976oOutput.dsc976oRespDesc);
                    return returnWrapper;
                }else{
                    
                    returnWrapper.put('state', 'error');
                    returnWrapper.put('message', responseBean.DSaddStopPaymentV2Response.dsc976oOutput.dsc976oRespDesc);
                    return returnWrapper;
                }
            }else{
                
                returnWrapper.put('state', 'error');
                returnWrapper.put('message', responseBean.StatusMessage);
                return returnWrapper;
            }
        }else  if(actionItem == 'ReverseDebitOrder'){
            gPpaymReturnV1_Req_IB_v1 requestBean = gPpaymReturnV1_IU_v1.mapRequestdFields();  
            gPpaymReturnV1_Req_IB_v1.gpp506i gpp506iBean = new gPpaymReturnV1_Req_IB_v1.gpp506i();
            system.debug(actionReasonTranslated);
            gpp506iBean.func = 'SRDT';
            gpp506iBean.versionI = '00';
            gpp506iBean.acno = accountNumber;
            gpp506iBean.tkey = debitCreditList[0].tieb; 
            gpp506iBean.resn = actionReasonTranslated;
            gpp506iBean.brcd = loggedinUser.SiteCode__c;
            gpp506iBean.tell = loggedinUser.Teller_Operator_Code__c;
            gpp506iBean.sitetp = '034';//loggedinUser.SiteType__c;
            gpp506iBean.spare = '33';
            requestBean.GPpaymReturnV1.gpp506i = gpp506iBean; 
            Map<gPpaymReturnV1_Resp_IB_v1, List<Sys_Log_Integration__c>> ppResponseMap =  gPpaymReturnV1_IH_v1.callTogPpaymReturnV1(requestBean);
            gPpaymReturnV1_Resp_IB_v1 ppResponseBean = (new List<gPpaymReturnV1_Resp_IB_v1>(ppResponseMap.keySet()))[0];
            
            if(ppResponseBean.statusCode == 200) {
                if(ppResponseBean.GPpaymReturnV1Response.gpp506o.respCode == '0'){                   
                    returnWrapper.put('state', 'success');
                    returnWrapper.put('message', ppResponseBean.GPpaymReturnV1Response.gpp506o.respDesc);
                    return returnWrapper;
                }else{
                    
                    returnWrapper.put('state', 'error');
                    returnWrapper.put('message',  ppResponseBean.GPpaymReturnV1Response.gpp506o.respDesc);
                    return returnWrapper;
                }
            }else{
                
                returnWrapper.put('state', 'error');
                returnWrapper.put('message', ppResponseBean.StatusMessage);
                return returnWrapper;
            }
        }
        return returnWrapper;
        
    }
}