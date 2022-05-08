public class EstampController {
    
    /* Lightning cmp controller for Estamp Reference Number
* Author: Himanshu Nimje (Mphatek)
* Date :  23/07/2020 
* */
    
    
    @AuraEnabled
    
    public static String getAccountDetails(String estempRefno,String tranYY, String tranMM , String tranDD, String tranHr,String tranmin ){
        
        System.debug('estempRefno'+estempRefno+tranYY+tranMM+tranDD+tranHr+tranmin );
        integer  Y1=integer.valueof(tranYY.substring(2, 3));
        integer Y2=integer.valueof(tranYY.substring(3, 4));
        integer M1=integer.valueof(tranMM.substring(0, 1));
        integer  M2=integer.valueof(tranMM.substring(1, 2));
        integer D1=integer.valueof(tranDD.substring(0, 1));
        integer D2=integer.valueof(tranDD.substring(1, 2));
        integer H1=integer.valueof(tranHr.substring(0, 1));
        integer H2=integer.valueof(tranHr.substring(1, 2));
        integer mi1=integer.valueof(tranmin.substring(0, 1));
        integer mi2= integer.valueof(tranmin.substring(1, 2));  
        
        integer S1=integer.valueof(estempRefno.substring(0, 1));
        integer S2=integer.valueof(estempRefno.substring(1, 2));
        integer S3=integer.valueof(estempRefno.substring(2, 3));
        integer S4=integer.valueof(estempRefno.substring(3, 4));
        integer S5=integer.valueof(estempRefno.substring(4, 5));
        integer S6=integer.valueof(estempRefno.substring(5, 6));
        integer S7=integer.valueof(estempRefno.substring(6, 7));
        integer S8=integer.valueof(estempRefno.substring(7, 8));
        integer S9=integer.valueof(estempRefno.substring(8, 9));
        integer S10=integer.valueof(estempRefno.substring(9, 10));
        integer S11=integer.valueof(estempRefno.substring(10, 11));
        integer S12=integer.valueof(estempRefno.substring(11, 12));
        integer S13=integer.valueof(estempRefno.substring(12, 13));
        integer S14=integer.valueof(estempRefno.substring(13, 14));
        integer S15=integer.valueof(estempRefno.substring(14, 15));
        integer S16=integer.valueof(estempRefno.substring(15, 16));
        integer A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16;
        String accNumber;
        
        
        //for A1 -  ((S1 + 10) - ((mi2 + 2) Mod 10)) Mod 10
        integer tmp1 ;
        tmp1 = math.mod((mi2 + 2) , 10) ;
        system.debug('tmp1 '+ tmp1);
        A1=  math.mod((S1 + 10) - (tmp1) , 10);
        system.debug('A1 '+ A1);      
        
        //for A2 -  ((S6 + 10) - ((mi1 + 3) Mod 10)) Mod 10
        integer tmp2 ;
        tmp2 = math.mod((mi1 + 3) , 10) ;
        system.debug('tmp2 '+ tmp2);
        A2=  math.mod((S6 + 10) - (tmp2) , 10);
        system.debug('A2 '+ A2);  
        
        //for A3 -  ((S9 + 10) - ((H2 + 4) Mod 10)) Mod 10
        integer tmp3 ;
        tmp3 = math.mod((H2 + 4) , 10) ;
        system.debug('tmp3 '+ tmp3);
        A3=  math.mod((S9 + 10) - (tmp3) , 10);
        system.debug('A3 '+ A3);  
        
        //for A4 - ((S14 + 10) - ((H1 + 5) Mod 10)) Mod 10
        integer tmp4 ;
        tmp4 = math.mod((H1 + 5) , 10) ;
        system.debug('tmp4 '+ tmp4);
        A4=  math.mod((S14 + 10) - (tmp4) , 10);
        system.debug('A4 '+ A4);
        
        //for A5 - ((23 - mi2) - S11) Mod 10
        A5=  math.mod(((23 - mi2) - S11) , 10);
        system.debug('A5 '+ A5);
        
        //for A6 - ((21 - mi1) - S2) Mod 10
        A6=  math.mod(((21 - mi1) - S2), 10);
        system.debug('A6 '+ A6);
        
        //for A7 - ((19 - H2) - S16) Mod 10
        A7=  math.mod( ((19 - H2) - S16), 10);
        system.debug('A7 '+ A7);
        
        //for A8 - ((17 - H1) - S7) Mod 10
        A8=  math.mod( ((17 - H1) - S7), 10);
        system.debug('A8 '+ A8);
        
        //for A9 - ((S3 + 10) - ((Y1 + mi2) Mod 10)) Mod 10
        integer tmp9 ;
        tmp9 = math.mod((Y1 + mi2) , 10) ;
        system.debug('tmp9 '+ tmp9);
        A9=  math.mod((S3 + 10) - (tmp9) , 10);
        system.debug('A9 '+ A9);
        
        //for A10 - ((S13 + 10) - ((Y2 + mi1) Mod 10)) Mod 10
        integer tmp10 ;
        tmp10 = math.mod((Y2 + mi1) , 10) ;
        system.debug('tmp10 '+ tmp10);
        A10=  math.mod((S13 + 10) - (tmp10) , 10);
        system.debug('A10 '+ A10);
        
        //for A11 - ((S10 + 10) - H2) Mod 10
        A11 =  math.mod( ((S10 + 10) - H2), 10);
        system.debug('A11 '+ A11);
        
        //for A12 - ((S4 + 10) - H1) Mod 10
        A12 =  math.mod( ((S4 + 10) - H1), 10);
        system.debug('A12 '+ A12);
        
        //for A13 - ((S12 + 10) - ((D2 + 6) Mod 10)) Mod 10
        integer tmp13 ;
        tmp13 = math.mod((D2 + 6) , 10) ;
        system.debug('tmp13 '+ tmp13);
        A13=  math.mod((S12 + 10) - (tmp13) , 10);
        system.debug('A13 '+ A13);
        
        //for A14 - ((S8 + 10) - ((D1 + 7) Mod 10)) Mod 10
        integer tmp14 ;
        tmp14 = math.mod((D1 + 7) , 10) ;
        system.debug('tmp14 '+ tmp14);
        A14=  math.mod((S8 + 10) - (tmp14) , 10);
        system.debug('A14 '+ A14);
        
        //for A15 -  ((S5 + 10) - ((M2 + 8) Mod 10)) Mod 10
        integer tmp15 ;
        tmp15 = math.mod((M2 + 8) , 10) ;
        system.debug('tmp15 '+ tmp15);
        A15=  math.mod((S5 + 10) - (tmp15) , 10);
        system.debug('A15 '+A15);      
        
        //for A16  - ((S15 + 10) - ((M1 + 9) Mod 10)) Mod 10
        integer tmp16 ;
        tmp16 = math.mod((M1 + 9) , 10) ;
        system.debug('tmp16 '+tmp16);
        A16=  math.mod((S15 + 10) - (tmp16) , 10);
        system.debug('A16 '+A16);
        
        accNumber =String.valueOf(A1)+String.valueOf(A2)+String.valueOf(A3)+String.valueOf(A4)+String.valueOf(A5)+String.valueOf(A6)+String.valueOf(A7)+String.valueOf(A8)+String.valueOf(A9)+String.valueOf(A10)+String.valueOf(A11)+String.valueOf(A12)+String.valueOf(A13)+String.valueOf(A14)+String.valueOf(A15)+String.valueOf(A16);
        system.debug('accNumber '+ accNumber);
        
        return accNumber;
        
    }
    
    
    @AuraEnabled
    
    public static String getAccountInfo(String accNumber){
        
        ADAPT360_Resp_IB_v1 clientProfilesBean;
        try{            
            clientProfilesBean = ADAPT360_IH_v1.retrieveClientDetails('accountNumber', accNumber, 'CIB_VIEW', false);
            if (clientProfilesBean.ClientDetails != null) {
                System.debug(LoggingLevel.Finest,'###getClientDetailsBean - clientProfilesBean: ' + clientProfilesBean);
               /* if(clientProfilesBean != null) {
                    for (ADAPT360_Resp_IB_v1.ClientDetails client : clientProfilesBean.ClientDetails) {
                        ADAPT360_Resp_IB_v1.AccountInfo[] arrayAccountInfo = client.account;
                        if(arrayAccountInfo != null){
                            System.debug(LoggingLevel.Finest,' #### arrayAccountInfo: ' + arrayAccountInfo);
                            return JSON.serialize(arrayAccountInfo);
                        }
                    }
                }
				*/
                
               return JSON.serialize(clientProfilesBean);
            } else {
                return null;
            }            
        }catch(Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderBase : getAdapt360ClientBean - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage()); 
        }
    }
    
    /**
     * @author Himanshu Nimje
     * loadTransactions : get all transactions back from the service
     * and insert the response into an temp object to be used for filtering
     * Load a deafult of 3 months
     * @param  String pAccountNumber
     * @param  Date fromDate
     * @param  Date toDate
     * @return List<Transaction_Filter_List__c>
     */
    @AuraEnabled
    public static List<Transaction_Filter_List__c> loadTransactions(String pAccountNumber, Date fromDate, Date toDate){

        String errMessage = '';

        //Load default 3 months of transactions
        if(fromDate == null || toDate == null){
            fromDate = Date.today();
            fromDate = fromDate.addMonths(-3);
            toDate = Date.today();
        }

        Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = NhlistAcctTransactionHistoryv5_IH_v1.callTonhlistaccttransactionhistoryv5( pAccountNumber,
                                                                                                                                                                            fromDate.format().replace('/',''), 
                                                                                                                                                                            toDate.format().replace('/',''));
       
        NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = (new List<NhlistAccTransactionHistoryv5_Resp_IB_v1>(responseMap.keySet()))[0];

        if(responseBean.statusCode == 200){
            
            NhlistAccTransactionHistoryv5_Resp_IB_v1.NHlistAcctTransactionHistoryV5Response cls_retrieveTransactionInqWrapper = responseBean.NHlistAcctTransactionHistoryV5Response;
            NhlistAccTransactionHistoryv5_Resp_IB_v1.nhp021o nhp021o = cls_retrieveTransactionInqWrapper.nhp021o;

            List<NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails> transactionData = nhp021o.StatementDetails;

            List<Transaction_Filter_List__c> transList = new List<Transaction_Filter_List__c>();

            for(NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails rec :transactionData){

                //Date conversion
                String year = '';
                String month =  '';
                String day =  ''; 

                String processDate = rec.processingDate;

                if(processDate.length() >= 8){
                    year = processDate.substring(0,4);
                    month = processDate.substring(4,6);
                    day = processDate.substring(6); 
                    processDate = year + '-' + month + '-' + day;
                }else{
                    processDate = '0';
                }

                String effectDate = rec.effectiveDate;

                if(effectDate.length() >= 8){
                    year = effectDate.substring(0,4);
                    month = effectDate.substring(4,6);
                    day = effectDate.substring(6); 
                    effectDate = year + '-' + month + '-' + day;
                }else{
                    effectDate = '0';
                }

                Transaction_Filter_List__c trans = new Transaction_Filter_List__c();

                trans.Processing_Date__c = (processDate != '0') ? Date.valueOf(processDate) : null;
                trans.Effective_Date__c = (effectDate != '0') ? Date.valueOf(effectDate) : null;
                trans.Description1__c = rec.description1;
                trans.Description2__c = rec.description2;
                trans.Description3__c = rec.description3; 
                trans.Transaction_Amount__c = rec.tranAmount;
                trans.Transaction_Cost__c = rec.tranCost;
                trans.Balance_After_Transaction__c = rec.balAfterTran; 
                trans.Transaction_Type__c = rec.tranType;
                trans.Event_Number__c = rec.eventNum;
                trans.Line_Number__c = rec.lineNum;
                trans.Transaction_Category__c = rec.tranCat;

                transList.add(trans);

            }

            return insertData(transList);
            
        }else{
           
            errMessage = 'No transactions for selected dates';   
            return new List<Transaction_Filter_List__c>();
        }
          
    }
    
    
    /**
     * @author Himanshu Nimje
     * insertData : Delete existing and then insert the transaction result from the service 
     * into a custom object to be used for filtering
     * @param  List<Transaction_Filter_List__c> transList
     * @return List<Transaction_Filter_List__c>
     */
    private static List<Transaction_Filter_List__c> insertData(List<Transaction_Filter_List__c> transList){

        //Clean out object if not empty already
        List<Transaction_Filter_List__c> deleteRecs = [Select Id From Transaction_Filter_List__c];

        if(deleteRecs.size() > 0){

            try{
                delete deleteRecs;
            }catch(DmlException ex){
                throw ex;
            }
        }

        //Insert new transaction list
        try{
            insert transList;
        }catch(DmlException ex){
            throw ex;
        }
		
        System.debug('transaction data :' + transList);
        return transList;
    }
    
    /**
     * @author Himanshu Nimje
     * closeCaseAction : Close a case from the screen flow
     * @param Id caseRecordId
     */
    @AuraEnabled
    public static void closeCaseAction(Id caseRecordId ){
        
        String errorMsg = 'Exception';
        AuraHandledException ex = new AuraHandledException(errorMsg);

        try{
            
            if(caseRecordId != null){
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Status = 'Closed';
                Update caseObj;
            }

        }catch(DmlException e){
            throw new AuraHandledException( e.getMessage());
        }
    
    }
    
}