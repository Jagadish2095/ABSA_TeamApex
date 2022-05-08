/**
* @description This is CaptureRefundDetailsCtrl Lightning component Apex Controller Class
* @author kamil Rega
* @created 2021/10/05
*/

public with sharing class CaptureRefundDetailsCtrl {
    /**
 * @description retrieves client account account number based on AccountId
 * @param  clientAccountId
 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
 */
    @AuraEnabled
    public static CIgetAcctLinkedToClientCode_Resp_IB_v1 getAccountDetails(String clientAccountId) {
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(
                StringConstants.SALESFORCE_STRING,
                accountList[0].CIF__c
        );
        return responseBean;
    }


    /**
 * @description get clietn refund request performed in last 30 days from case transaction
 * @param  caseId
 * @return Case_Transaction__c
 */
    @AuraEnabled
    public static Case_Transaction__c getClientRefundRequest(String caseId) {
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{
                caseId
        }, 1);
        List<Case_Transaction__c> caseTransaction = [SELECT Transaction_Date__c,Amount__c,Reason__c FROM Case_Transaction__c WHERE
                    jobType__c = :'Request Refund' AND Case__r.AccountId = :currentCase[0].AccountId AND  Transaction_Date__c = LAST_N_DAYS:30 ORDER BY Transaction_Date__c DESC LIMIT 1];
        if (!caseTransaction.isEmpty()) {
                return caseTransaction[0];

        } else { throw new AuraHandledException('There is no case Transaction older than 30 days');}

    }

    /**
* @description Calling future method to avoid Uncommitted work Issue
* @param  caseTranasactionIDList List of Ids of Case Transaction
* @work w-013364
*/
    @InvocableMethod(Label='ApproveReject')
    Public static void approveReject(List<Id> caseTranasactionIDList) {
     initiatePayment(caseTranasactionIDList);
    }
    /**
 * @description Future method to initiate  record
 * @param caseTranasactionIDList
 * @work w-013364
 */
    @future(callout=true)
    public static void initiatePayment(List<Id> caseTranasactionIDList) {
        List<Case_Transaction__c> updateCaseTransactionList = new List<Case_Transaction__c>();
        List<Case> updateCaseList = new List<Case>();
        Case_Transaction__c caseTransactionRecord = [
                SELECT Name,Amount__c,Approvers_Comment__c,jobType__c,Case__c,Source_Account__c,Target_Account__c,Source_Account_Type__c,Target_Account_Type__c,Status__c,Reference__c
                FROM Case_Transaction__c
                where Id = :caseTranasactionIDList[0]
                limit 1
        ];
        Case caseRecord = [SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case where Id = :caseTransactionRecord.Case__c limit 1];
        String approverComments;
        List<ProcessInstance> processInstances = [
                select Id, TargetObjectId, (
                        SELECT Id,ActorId, StepStatus, Comments
                        FROM Steps
                        WHERE StepStatus IN :new List<String>{
                                'Approved', 'Rejected'
                        }
                        ORDER By CreatedDate DESC
                )
                from ProcessInstance
                where TargetObjectId in :caseTranasactionIDList
                ORDER By CreatedDate DESC
        ];
        for (ProcessInstance pi : processInstances) {
            for (ProcessInstanceStep step : pi.Steps) { if (step.StepStatus == 'Approved' || step.StepStatus == 'Rejected') { approverComments = step.Comments;}
            }
        }
        //Approvers_Comment__c
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyyMMdd');
        DateTime dt = DateTime.now();
        if (caseTransactionRecord != null && caseTransactionRecord ?.Status__c == 'Approved') {
            caseTransactionRecord.Approvers_Comment__c = approverComments;
            MBinitiatePaymentV10_Resp_IB_v1 res = initiatePayment(String.valueof(dt.hour()) + dt.Minute() + dt.Second() + dt.Millisecond(),
                    todaysDateStr,
                    String.valueOf(caseTransactionRecord.Amount__c),
                    caseTransactionRecord.Source_Account__c,
                    caseTransactionRecord.Source_Account_Type__c,
                    caseTransactionRecord.Target_Account__c,
                    caseTransactionRecord.Target_Account_Type__c,
                    caseTransactionRecord.Reference__c,
                    'Request Refund');
            if (Test.isRunningTest()) {
                //res.MBinitiatePaymentV10Response.mbn301o.respDesc='SUCCESSFUL';
                MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response paymentResponse= new MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response();
                list<MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response>paymentResponseList  = new list<MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response>();
                res.status='OK';
                res.statusCode=200;
                res.StatusMessage='SUCCESS';
                MBinitiatePaymentV10_Resp_IB_v1.mbn301o transactionResponse  = new MBinitiatePaymentV10_Resp_IB_v1.mbn301o();
                list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o> transactionResponseList  = new list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o>();
                transactionResponse.trgAcc='20190720';
                transactionResponse.lastPaymAmnt='SUCCESSFUL';
                transactionResponse.todaysDate='20211019';
                transactionResponse.trgAccType='SA';
                transactionResponse.avbl='302022';
                transactionResponse.respDesc='SUCCESSFUL';
                paymentResponse.mbn301o=transactionResponse;
                paymentResponseList.add(paymentResponse);
                res.responseList=paymentResponseList;
                res.MBinitiatePaymentV10Response=paymentResponse;
            }
                if (res != null && res.statusCode == 200 && res.MBinitiatePaymentV10Response ?.mbn301o ?.respDesc.Contains('SUCCESSFUL')) {
                       String smsText;
                        if (caseTransactionRecord.Target_Account_Type__c == 'CA' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
                            smsText = System.Label.set_off_sms_card_from_Savings;
                        } else if (caseTransactionRecord.Target_Account_Type__c == 'CA' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
                            smsText = System.Label.set_off_sms_card_from_chq;
                        } else if (caseTransactionRecord.Target_Account_Type__c == 'CQ' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
                            smsText = System.Label.set_off_sms_chq_from_savings;
                        } else if (caseTransactionRecord.Target_Account_Type__c == 'CQ' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
                            smsText = System.Label.set_off_sms_chq_from_chq;
                        } else if (caseTransactionRecord.Target_Account_Type__c == 'PL' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
                            smsText = System.Label.set_off_sms_pl_from_savings;
                        } else if (caseTransactionRecord.Target_Account_Type__c == 'PL' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
                            smsText = System.Label.set_off_sms_pl_from_chq;
                        }
                        smsText = smsText ?.replace('xxxxx', res.MBinitiatePaymentV10Response.mbn301o.lastPaymAmnt);
                        NotifyBankerController.notifyClientBySMS(null, caseRecord.Client_Mobile_Phone__c, smsText, 'iTouch SMS Submit - EB Collections');
                        caseTransactionRecord.Status__c = 'Service Response Approved';
                        caseRecord.Description = 'Successfull.';
                        caseRecord.Status = 'Closed';
                        updateCaseList.add(caseRecord);
                        updateCaseTransactionList.add(caseTransactionRecord);
                } else { caseTransactionRecord.Status__c = 'Service Response Failed';
	        	transferCase(
							'Request Refund Escalations',
                             'Awaiting Request Refunds',
							caseRecord.Id,
							'Request Refund failed'
						);
                    updateCaseTransactionList.add(caseTransactionRecord);
                }
        } else if (caseTransactionRecord != null && caseTransactionRecord ?.Status__c == 'Rejected') {
            caseTransactionRecord.Approvers_Comment__c = approverComments;
            caseRecord.Description = 'Request Refunds  Rejected by the Approver.';
            caseRecord.Status = 'Closed';
            updateCaseList.add(caseRecord);
            updateCaseTransactionList.add(caseTransactionRecord);
        }
        update updateCaseList;
        update updateCaseTransactionList;

    }

    /**
* @description verifyAccount
* @param accountNumber
* @param branchCode
* @param accountType
* @return String
*/
    @AuraEnabled
    public static String verifyAccount(String accountNumber, String branchCode, String accountType) {
        dsCheckDigitVerificationV1_Resp_IB_v1 response = dsCheckDigitVerificationV1_IH_v1.dsCheckDigitVerification(accountNumber, branchCode, accountType, 'CR');
        if (response == null || response.rc == null) { throw new AuraHandledException('Account verification response is null.');}
        return response.rc;
    }

    /**
* @description submitForApproval
* @param queueName
* @param caseId
* @return Boolean
*/
    @AuraEnabled
    public static Boolean submitForApproval(String queueName, String caseId) {
        String caseTransactionID = [SELECT Id FROM Case_Transaction__c WHERE Case__c = :caseId AND jobType__c = :'Request Refund' ORDER BY Transaction_Date__c  LIMIT 1].Id;
        Id queueId = [select Id from Group where Type = 'Queue' AND DeveloperNAME = :queueName] ?.Id;
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting deviations for approval Process');
        req.setObjectId(caseTransactionID);
        req.setProcessDefinitionNameOrId('EB_Refunds_Approval');
        req.setNextApproverIds(new Id[]{queueId});
        Approval.ProcessResult result = Approval.process(req);
        return result.isSuccess();
    }

    /**
* @description saveNewJson
* @param caseId
* @param newJson
*/
    @AuraEnabled
    public static void saveNewJson(String caseId, String newJson) {
        List<Case> caseList = new CasesSelector().selectByCaseId(caseId);
        caseList[0].Extended_Request_Data__c = newJson;
        update caseList[0];
    }

    /**
* @description Initiate payment based on client selected Account
* @param payTime
* @param actDate
* @param amount
* @param srcAcc
* @param srcAccType
* @param trgAcc
* @param trgAccType
* @param trgStmtRef
* @param instrRefName
* @return MBinitiatePaymentV10_Resp_IB_v1
*/
    @AuraEnabled
    public static MBinitiatePaymentV10_Resp_IB_v1 initiatePayment(
            String payTime,
            String actDate,
            String amount,
            String srcAcc,
            String srcAccType,
            String trgAcc,
            String trgAccType,
            String trgStmtRef,
            String instrRefName
    ) {
        MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1();
        requestBean.paymTime = payTime;
        requestBean.maxRetrieve = '1';
        requestBean.instrType = 'OOP';
        if (instrRefName != null) {
            requestBean.instrRefName = instrRefName;
        }
        requestBean.actDate = actDate;
        requestBean.amount = amount;
        requestBean.srcAcc = srcAcc;
        requestBean.srcAccType = srcAccType;
        requestBean.srcStmtRef = 'loan to build ';
        requestBean.trgAcc = trgAcc;
        requestBean.trgClrCode = '0';
        requestBean.trgAccType = trgAccType;
        requestBean.trgStmtRef = trgStmtRef; //reference
        requestBean.changeBranch = '8089';
        requestBean.changeTeller = '11012';
        requestBean.benNonResStat = '';
        requestBean.channel = 'BISONTEST';
        requestBean.application = 'EPS';
        requestBean.channelInp = 'BDP';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.srcClrCode = '0';
        requestBean.trace = 'Y';

        MBinitiatePaymentV10_Resp_IB_v1 response = new MBinitiatePaymentV10_Resp_IB_v1();
        for (MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.callToMBinitiatePaymentV10(requestBean).keyset()) {
            response = singleresponse;
            break;
        }
        return response;
    }
    /**
* @author Koketso Mpshane
* @description translate customer account type for text message
* @param systemName
* @param valueType
* @param valueString
* @return String
*/
    @AuraEnabled
    public static String getOutboundTranslation(String systemName, String valueType, String valueString) {
        return Sys_Utilities_Integration.getIntegrationTranslationExternalValue(systemName, valueType, valueString, StringConstants.OUTBOUND_RECORD_TYPE);
    }
    /**
* @description Transfers the Case to a new Service Group
* @param serviceGroupName
* @param serviceTypeName
* @param caseId
* @param queueName
*/
    @AuraEnabled
    public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId, String queueName) {
        CaseTransferActionExt.transferCase(serviceGroupName, serviceTypeName, caseId);
        List<Group> groupList = new GroupsSelector().selectByNameAndType(queueName, 'Queue');
        List<Case> caseList = new CasesSelector().selectById(new Set<Id>{caseId});
        if (groupList.size() > 0 && caseList.size() == 1) {
            caseList[0].OwnerId = groupList[0].Id;
            update caseList;
        }
    }
}