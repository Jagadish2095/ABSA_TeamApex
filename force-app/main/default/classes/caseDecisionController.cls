/**
 * @description       : caseDecisionController for Decision tab
 * @author            : Gulafsha
 * @last modified on  : 2021-10-18
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-14   Gulafsha   Initial Version
**/


public class caseDecisionController {

    /**
    * @description getQueueMembers
    * @author Gulafsha | 2021-07-14 
    * @param caseId 
    * @return Case 
    **/
    @AuraEnabled
    public static  Case getQueueMembers(Id caseId ) {
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(caseId);
        List<Case> caseList = new CasesSelector().selectQueueByCaseId(caseSetId);
        if(caseList != null && caseList.size() > 0) {
            return caseList[0];
        } else {
            return null;
        }
    }

    /**
    * @description fetchUser
    * @author Gulafsha | 2021-07-14 
    * @return user 
    **/
   @AuraEnabled
    public static user fetchUser() {
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u;
    }

    /**
    * @description fetchProductInfo
    * @author Gulafsha | 2021-07-14 
    * @param caseProductId 
    * @return Boolean 
    **/
    @AuraEnabled
    public static Boolean fetchProductInfo(String caseProductId) {
        List<Application_Product__c> AppProd = new ApplicationProductSelector().selectforCase(caseProductId);
        if (!AppProd.isEmpty() && AppProd.size() > 0 && AppProd != null){
            if(AppProd[0].Overdraft_Type__c.contains('REDUCING')){
                return true;
            }
        }
        return false;
    }

    /**
    * @description checkproductInfo
    * @author Gulafsha | 2021-07-14 
    * @param caseId 
    * @param mandatenumber 
    * @return string 
    **/
    @AuraEnabled
    public static string checkproductInfo(string caseId,integer mandatenumber) {
        List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(caseId, 1);
        String retVal;
        if(caseList[0].Product__c=='Overdraft'){
         Cqupdautooverdraftloadv2_Resp_IB_v1 responseBean = updateoverdraftservice.updateoverdraft(caseList[0].Application_Product_Id__c, caseid, mandatenumber);  
         if(responseBean != null){
                    if(responseBean.statusCode == 200){
                      //  system.debug('responseBean.CQS573O'+responseBean.CQS573O);
                        if(responseBean.CQS573O != null){
                          //  system.debug('responseBean.CQS573O.outputArea.outputReturnCode'+responseBean.CQS573O.outputArea.outputReturnCode);
                            if(responseBean.CQS573O.outputArea.outputReturnCode == 0){
                                //Cqupdautooverdraftloadv2_Resp_IB_v1.NBSAPDPO NBSAPDPO = responseBean.NBSAPDPO;
                                retVal = 'Successfull';
                            } else {
                                retVal = 'Error: ' + responseBean.NBSMSGO3.errorMessagesOutput.messageEntryTable[0].errorMessageText;
                            }
                        }

                    } else {
                        retVal = 'Error';
                    }
                }
        }
        else if(caseList[0].Product__c=='COVID-19 Bank Guarantee'||caseList[0].Product__c=='Term Loan'){
         retVal =  MbCreateInstructionV2(caseList); 
        }

       
        return retVal;
    }
    /**
    * @description MbCreateInstructionV2
    * @author Gulafsha | 2021-07-14 
    * @param caseList 
    * @return string 
    **/
    @AuraEnabled
    public static string MbCreateInstructionV2(List<Case> caseList) {
        //List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(caseId, 1);
        Id appProductId = caseList[0].Application_Product_Id__c;
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProductId));
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        List<Payment_Plan__c> onceOffPayment = new PaymentPlansSelector().selectByApplicationProductId(appProductId);
        string response;

        if(onceOffPayment != null && onceOffPayment.size() > 0){
            for(Payment_Plan__c payment: onceOffPayment){
                MbCreateInstructionV2_Resp_IB_v1 responseBean = MbCreateInstructionV2_IH_v1.MbCreateInstructionV2(mapRequestFieldsMbCreate(appProdRec, user, payment));

                if(responseBean != null){
                    if(responseBean.statusCode == 200){
                        if(responseBean.nbsmsgo != null){
                            if(responseBean.nbsmsgo.nbrUserMsgs != '0'){
                                MbCreateInstructionV2_Resp_IB_v1.Mbp304o mbp304o = responseBean.mbp304o;
                                response = mbp304o.respDesc;
                            } else {
                                response = 'Error: ' + responseBean.nbsmsgo.msgEntry[0].msgTxt;
                            }
                        }

                    } else {
                        response = 'Error';
                    }
                }
            }
        }

        return response;
    }

    /**
    * @description createDecisionHistory
    * @author Gulafsha | 2021-07-14 
    * @param selectedOption 
    * @param comments 
    * @param details 
    * @param approver 
    * @param mbp304o 
    * @param caseId 
    * @param acctNumber 
    * @param reasonsRejected 
    * @return String 
    **/
    @AuraEnabled
    public static String createDecisionHistory(string selectedOption, string comments, string details,string approver, String mbp304o, string caseId,String acctNumber,String reasonsRejected){
        List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(caseId, 1);
        Id appProductId = caseList[0].Application_Product_Id__c;
        String bankerid = caseList[0].Relationship_Banker__c;
        String bankername = caseList[0].Relationship_Banker__r.Name;
        String caseNo =  caseList[0].CaseNumber;
        String accountNumber = acctNumber;
       
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProductId));
        if(appProdRec.Product_State__c == 'New'){
            appProdRec.Account_Number__c = Double.valueOf(acctNumber);
        }
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        String caseproduct = caseList[0].Product__c;
        String response = '';
        if(caseList[0].Product__c=='COVID-19 Bank Guarantee'||caseList[0].Product__c=='Term Loan'){
        List<Payment_Plan__c> onceOffPayment = new PaymentPlansSelector().selectByApplicationProductId(appProductId);

        for(Payment_Plan__c payment: onceOffPayment){
            MBinitiatePaymentV12_Resp_IB_v1 responseBean = MBinitiatePaymentV12_IH_v1.mbInitiatePaymentV12(mapRequestFieldsMBinit(appProdRec, user, payment));

            if(responseBean != null){
                if(responseBean.nbsmsgo3 != null){
                    if(responseBean.nbsmsgo3.nbrUserMsgs != '0'){
                        response = responseBean.nbsmsgo3.msgEntry[0].msgTxt;
                    } 
                } else {
                    response = 'MBinitiatePaymentV12_IH_v1 error';
                }
            } else {
                response = 'MBinitiatePaymentV12_IH_v1 error';
            }
        }
        }
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(caseId);
        caseList = new CasesSelector().selectByIdWithDecisionHistoryTracking(caseSetId);
        Decision_History__c decisionRecord = new Decision_History__c();

        if(caseList != null && caseList.size() > 0) {
           	caseList[0].Account_Number__c = acctNumber;
            decisionRecord.Decision__c = selectedOption;
            decisionRecord.Comments__c = comments;
            decisionRecord.Details__c = details;
            if(caseproduct=='COVID-19 Bank Guarantee'||caseproduct=='Term Loan'){
            decisionRecord.Status__c = mbp304o;
            }
            else if(caseproduct=='Overdraft'){
             decisionRecord.Status__c = selectedOption;
            }
            decisionRecord.Case__c = caseList[0].Id;

            if(selectedOption == 'Requested More Information'){
                decisionRecord.Approver__c = approver;
                caseList[0].Is_Case_Rejected__c = true;
            } else {
                decisionRecord.Approver_Submitter__c = approver;
            }

            try{
                insert decisionRecord;
                update caseList[0];
                update appProdRec;
                response = 'SUCCESS';
            } catch(exception e){
                response = 'ERROR '+ e ;
            }

            if(selectedOption == 'Accepted' && String.isNotBlank(bankerid)){
                
                if(caseList[0].Status=='Closed'){
                       //  String body =' Application has been successfully fulfilled.';
                 String body = 'Hello'+ bankername +',\n\n Please note, Case Number: '+caseNo+' has been successfully fulfilled.\n Account Number: '+accountNumber +' \n Customer Name:'+caseList[0].Account.Name+'\n Opportunity Number'+caseList[0].Opportunity__r.Opportunity_Number__c+' \n\n Kind regards \nRBB Credit Fulfilment';
             	FeedItem post = new FeedItem();
                post.ParentId = bankerid;
                post.Body = body;
                insert post;
               /*if(!Test.isRunningTest()){
                    ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), caseList[0].Opportunity__c ,'Hello ' +bankername+'' +body+'');
                }*/
        			pcoCallout(caselist[0].Id,caselist[0].opportunity__c);
                }
                if(caseList[0].Status=='Closed'&& (caseproduct=='Credit Card' || caseproduct=='Bank Guarantee' )){
                String body = 'Hi '+bankername+',\n\n Please note, Case Number: '+caseNo+'has been successfully paid-out.\n Customer Name:'+caseList[0].Account.Name+'\n Opportunity Number'+caseList[0].Opportunity__r.Opportunity_Number__c+' \n\n Kind regards \nRBB Credit Fulfilment';
                FeedItem post = new FeedItem();
                post.ParentId = bankerid;
                post.Body = body;
                insert post;
                    
                  }
            }
            
             if(selectedOption == 'Requested More Information' && String.isNotBlank(bankerid)){
               
                String body = 'Hi '+bankername+',\n\n Please note, Case Number: '+caseNo+' has been rejected.Due to following reason(s) \n';
               //  body= body+;
               Integer i =0;
                 if(reasonsRejected !=null){
                     
                     reasonsRejected = reasonsRejected.removeStart('[');
                     reasonsRejected = reasonsRejected.removeEnd(']');
                     reasonsRejected = reasonsRejected.remove('"');
                     for(String r : reasonsRejected.split(',')){
                         i++;
                         body= body+i+'. ' +r +'\n';
                     } 
                 }
                 
                body = body +'\n Comments: '+comments; 
                body = body +'\n Account Number: '+accountNumber +'\n Customer Name: '+caseList[0].Account.Name+'\n Opportunity Number '+caseList[0].Opportunity__r.Opportunity_Number__c+' \n\n Kind regards \nRBB Credit Fulfilment';
                FeedItem post = new FeedItem();
                post.ParentId = bankerid;
                post.Body = body;
                insert post;
            	
            }
        }
        
       
        return response;
    }

    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-18 
    * @param caseId 
    * @param OpportunityId 
    **/
      @future(callout = true)
    public static void pcoCallout(Id caseId,Id OpportunityId){
        
        PowerCurveStatusUpdate.pcoCallout(OpportunityId);
    } 
    /**
    * @description mapRequestFieldsMbCreate
    * @author Gulafsha | 2021-07-14 
    * @param appProdRec 
    * @param user 
    * @param onceOffPayment 
    * @return MbCreateInstructionV2_Req_IB_v1 
    **/
    public static MbCreateInstructionV2_Req_IB_v1 mapRequestFieldsMbCreate(Application_Product__c appProdRec, User user, Payment_Plan__c onceOffPayment){
        ABFgetQuoteInfoForEspV5_Req_IB_V1 appProdQuoteReqBean = (ABFgetQuoteInfoForEspV5_Req_IB_V1) JSON.deserialize(appProdRec.Quotes_Input_Request__c, ABFgetQuoteInfoForEspV5_Req_IB_V1.class);
        ABFgetQuoteInfoForEspV5_Req_IB_V1.PLSA71I plsa71i = appProdQuoteReqBean.PLSA71I;
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputCopybookLayout inputCopybookLayout = plsa71i.inputCopybookLayout;

         ABFgetQuoteInfoForEspV5_Resp_IB_V1 appProdQuoteRespBean = (ABFgetQuoteInfoForEspV5_Resp_IB_V1) JSON.deserialize(appProdRec.Quotes_Output_Response__c, ABFgetQuoteInfoForEspV5_Resp_IB_V1.class);
        ABFgetQuoteInfoForEspV5_Resp_IB_V1.PLSA71O plsa710 = appProdQuoteRespBean.PLSA71O;
        ABFgetQuoteInfoForEspV5_Resp_IB_V1.outputCopybookLayout outputCopybookLayout = plsa710.outputCopybookLayout;

        MbCreateInstructionV2_Req_IB_v1 requestBean = new MbCreateInstructionV2_Req_IB_v1();
        MbCreateInstructionV2_Req_IB_v1.MBcreateInstructionV2 MBcreateInstructionV2 = new MbCreateInstructionV2_Req_IB_v1.MBcreateInstructionV2();

        MbCreateInstructionV2_Req_IB_v1.Nbsapdpi nbsapdpi = new MbCreateInstructionV2_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'SALESFOR';
        nbsapdpi.application = 'SALESFOR';
        nbsapdpi.trace = 'N';
        MBcreateInstructionV2.nbsapdpi = nbsapdpi;

        MbCreateInstructionV2_Req_IB_v1.FinalMsgId finalMsgId = new MbCreateInstructionV2_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';

        MbCreateInstructionV2_Req_IB_v1.Nbsmsgi nbsmsgi = new MbCreateInstructionV2_Req_IB_v1.Nbsmsgi();
        nbsmsgi.finalMsgId = finalMsgId;
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        MBcreateInstructionV2.nbsmsgi = nbsmsgi;

        MbCreateInstructionV2_Req_IB_v1.Mbp304i mbp304i = new MbCreateInstructionV2_Req_IB_v1.Mbp304i();
        mbp304i.channel = 'ESP';
        mbp304i.function = 'CREATE';
        mbp304i.maxRetrieve = '1';
        mbp304i.confirmInd = 'C';
       // mbp304i.actDate = formatDateString(System.today());
       // mbp304i.startDate = formatDateString(System.today());
       // mbp304i.endDate = '';
        mbp304i.srcAcc = String.valueOf(appProdRec.Source_Account__c);
        mbp304i.srcAccType = '';
        mbp304i.srcClrCode = String.valueOf(appProdRec.Source_Clearance_Code__c);//'632005';
        mbp304i.srcStmtRef = onceOffPayment.Statement_Reference__c;
        mbp304i.trgAcc = String.valueOf(onceOffPayment.Target_Account__c);
        mbp304i.trgAccType='02';//onceOffPayment.Target_Account_Type__c;
        mbp304i.trgClrCode = onceOffPayment.Target_Clearance_Code__c;
        mbp304i.trgStmtRef = onceOffPayment.Statement_Reference__c;
        mbp304i.chqFlag = 'N';
        mbp304i.mandNo = '';
        mbp304i.creditTrack='';
        mbp304i.notifInd = 'N';
        mbp304i.iipAllowInd = 'N';
        mbp304i.lastMaintBrnch = user.SiteCode__c;
        mbp304i.lastMaintTell = user.Teller_Operator_Code__c;
        mbp304i.lastMaintOvrId = user.Supervisor__c; 
        if(appProdRec.Debit_Order_Type__c == 'Debit'){
            mbp304i.instrType = 'DOD';
            mbp304i.doType = 'DA';
           // mbp304i.minPayAmnt = outputCopybookLayout.outputTotalInstalmentAmount;
        } else if(appProdRec.Debit_Order_Type__c == 'Fixed'){
            mbp304i.instrType = 'DOF';
            mbp304i.doType = 'FA';
            mbp304i.amount = String.valueOf(appProdRec.Fixed_Debit_Order_Amount__c);//onceOffPayment.Amount_Fullfillment__c;
            mbp304i.actDate = formatDateString(System.today());
            mbp304i.startDate = outputCopybookLayout.outputDateFirstInstalment;//formatDateString(System.today());
            mbp304i.endDate = outputCopybookLayout.outputDateLastInstalment;//formatDateString(System.today() + 1);
            mbp304i.payDay = outputCopybookLayout.outputDateFirstInstalment.right(2);//outputCopybookLayout.outputDateFirstInstalment.Substring(0,outputCopybookLayout.outputDateFirstInstalment.length()-5);//'0';
            mbp304i.minPayAmnt ='0'; //String.valueOf(appProdRec.Fixed_Debit_Order_Amount__c);
            mbp304i.maxPayAmnt ='9999999999999.99';
            mbp304i.futureInd ='';
			mbp304i.accessAcc ='';
			mbp304i.instrRefName ='TestXXX';
			mbp304i.trgBusinessCode ='';
			mbp304i.priNo ='';
			mbp304i.srcFaxCode ='0';
			mbp304i.srcFaxNo ='0';
			mbp304i.srcFaxText ='';
			mbp304i.srcCellCode ='0';
            mbp304i.srcCellNo ='0';
			mbp304i.srcCellText ='';
			mbp304i.srcEmailAddr ='';
			mbp304i.srcEmailText ='';
			mbp304i.srcNotifMed ='E';
            mbp304i.trgFaxCode ='0';
            mbp304i.trgFaxNo ='0';
            mbp304i.trgFaxText ='';
            mbp304i.trgCellCode ='0';
            mbp304i.trgCellNo ='0';
            mbp304i.trgCellText ='';
            mbp304i.trgEmailAddr ='';
            mbp304i.trgEmailText ='';
            mbp304i.trgNotifMed ='';
            mbp304i.cardAuth ='0';
            mbp304i.lastMaintOvr2Id ='';
            if(inputCopybookLayout.inputRepaymentFrequency == '12'){//Annually
                mbp304i.freq = '1Y';
            } else if(inputCopybookLayout.inputRepaymentFrequency == '1'){//Monthly
                mbp304i.freq = '1M';
            } else if(inputCopybookLayout.inputRepaymentFrequency == '3'){//Quartelly
                mbp304i.freq = '3M';
            } else if(inputCopybookLayout.inputRepaymentFrequency == '6'){//Semi-Annually
                mbp304i.freq = '6M';
            }
        }

        MBcreateInstructionV2.Mbp304i = mbp304i;

        requestBean.MBcreateInstructionV2 = MBcreateInstructionV2;

        return requestBean;
    }

    /**
    * @description mapRequestFieldsMBinit
    * @author Gulafsha | 2021-07-14 
    * @param appProdRec 
    * @param user 
    * @param onceOffPayment 
    * @return MBinitiatePaymentV12_Req_IB_v1 
    **/
    public static MBinitiatePaymentV12_Req_IB_v1 mapRequestFieldsMBinit(Application_Product__c appProdRec, User user, Payment_Plan__c onceOffPayment){
        ABFgetQuoteInfoForEspV5_Req_IB_V1 appProdQuoteReqBean = (ABFgetQuoteInfoForEspV5_Req_IB_V1) JSON.deserialize(appProdRec.Quotes_Input_Request__c, ABFgetQuoteInfoForEspV5_Req_IB_V1.class);
        ABFgetQuoteInfoForEspV5_Req_IB_V1.PLSA71I plsa71i = appProdQuoteReqBean.PLSA71I;
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputCopybookLayout inputCopybookLayout = plsa71i.inputCopybookLayout;

        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);

        MBinitiatePaymentV12_Req_IB_v1 requestBean = new MBinitiatePaymentV12_Req_IB_v1();
        MBinitiatePaymentV12_Req_IB_v1.Nbsapdpi nbsapdpi = new MBinitiatePaymentV12_Req_IB_v1.Nbsapdpi();
        nbsapdpi.channel = 'SALESFOR';
        nbsapdpi.application = 'SALESFOR';
        nbsapdpi.trace = 'Y';
        requestBean.nbsapdpi = nbsapdpi;

        MBinitiatePaymentV12_Req_IB_v1.FinalMsgId finalMsgId = new MBinitiatePaymentV12_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';

        MBinitiatePaymentV12_Req_IB_v1.Nbsmsgi nbsmsgi = new MBinitiatePaymentV12_Req_IB_v1.Nbsmsgi();
        nbsmsgi.finalMsgId = finalMsgId;
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        requestBean.nbsmsgi = nbsmsgi;

        MBinitiatePaymentV12_Req_IB_v1.Mbp301i mbp301i = new MBinitiatePaymentV12_Req_IB_v1.Mbp301i();
        mbp301i.channelI = 'SALESFOR';
        mbp301i.paymTime = formatTimeString(local);
        mbp301i.maxRetrieve = '1';
        mbp301i.tieb = '0';
        mbp301i.multiNo = '0';
        mbp301i.instrType = 'OOP';
        mbp301i.instrRefName = onceOffPayment.Statement_Reference__c;
        mbp301i.actDate = formatDateString(System.today());
        mbp301i.amount = onceOffPayment.Amount_Fullfillment__c;
        mbp301i.instrNo = '0';
        mbp301i.srcAcc = String.valueOf(appProdRec.Account_Number__c);
        mbp301i.srcAccType = '';
        mbp301i.srcClrCode = '632005';
        mbp301i.srcStmtRef = onceOffPayment.Statement_Reference__c;
        mbp301i.trgAcc = String.valueOf(onceOffPayment.Target_Account__c);
        mbp301i.trgClrCode = onceOffPayment.Target_Clearance_Code__c;
        mbp301i.trgAccType = '02';
        mbp301i.trgStmtRef = onceOffPayment.Statement_Reference__c;
        mbp301i.retryDate = '0';
        mbp301i.retryAmount = '0';
        mbp301i.acbUcIndex = '0';
        mbp301i.changeBranch = user.SiteCode__c;
        mbp301i.changeTeller = user.Teller_Operator_Code__c;
        mbp301i.paymNo = '1';
        mbp301i.tellerAmtAuth = '0';
        mbp301i.agcy = '0';
        mbp301i.feSwitchFee = '0';
        mbp301i.feStan = '0';
        mbp301i.exdt = '0';
        mbp301i.tranInd = '0';
        mbp301i.budgetNo = '0';
        mbp301i.consolAmnt = '0';
        mbp301i.emvrqAmtAuth = '0';
        mbp301i.emvrqAmtOther = '0';
        mbp301i.emvrqTermCntryCde = '0';
        mbp301i.emvrqTranCrncyCde = '0';
        mbp301i.emvrqTranDat = '0';
        mbp301i.emvddDfNameLgth = '0';
        mbp301i.emvrpAuthDataLgth = '0';
        mbp301i.merchantNumber = '0';
        mbp301i.foreignAmnt = '0';
        mbp301i.benNonResStat = 'n';
        requestBean.Mbp301i = mbp301i;

        return requestBean;
    }

    /**
    * @description formatDateString
    * @author Gulafsha | 2021-07-14 
    * @param dateString 
    * @return String 
    **/
    private static String formatDateString(Date dateString){
        return String.valueOf(dateString.format()).replace('/','');
    }

    /**
    * @description formatTimeString
    * @author Gulafsha | 2021-07-14 
    * @param dateString 
    * @return String 
    **/
    private static String formatTimeString(DateTime dateString){
        return String.valueOf(dateString).split(' ')[1].replace(':','');
    }
}