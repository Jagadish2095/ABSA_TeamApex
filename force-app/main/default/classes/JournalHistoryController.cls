/**
 * Mashudu Raidimi
* Retrieves client transaction list  based on Account number
*
* @param   accountNumber,fromDate,toDate
*return list of trasactions
* 
*/ 
public class JournalHistoryController {

    /**
     * @author Mashudu Raidimi
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

        //FOR TESTING REMOVE 
        //pAccountNumber = '4048017641';

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
     * @author Rudolf Niehaus
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

        return transList;
    }

    /**
     * @author Rudolf Niehaus
     * filterTransactions : Filter the result set bases on filter criteria
     * @param  String iipRefNo
     * @param  Date payDate
     * @param  String data
     * @param  String admin
     * @param  String airtime
     * @param  String accFee
     * @param  String immediateDT
     * @return List<Transaction_Filter_List__c>
     */
    @AuraEnabled
    public static List<Transaction_Filter_List__c> filterTransactions(String iipRefNo, Date payDate, 
                                                                     String data, String admin,
                                                                     String airtime, String accFee, String immediateDT,String debit,
                                                                     String credit, String Correction, String debitTest, String creditTest){
        
        String processingDateStr = '';

        if(payDate != null){

            String dateFormatString = 'yyyy-MM-dd';
            Datetime dt = Datetime.newInstance(payDate.year(), payDate.month(), payDate.day());
            processingDateStr = dt.format(dateFormatString);

        }
       
        
        //Build-up SOQL filter query                                                                
        String query = 'Select Processing_Date__c,Effective_Date__c,Description1__c,Description2__c,Description3__c,' +
                       'Transaction_Amount__c,Transaction_Cost__c,Balance_After_Transaction__c,Transaction_Type__c,' +
                       'Event_Number__c,Line_Number__c,Transaction_Category__c ' +
                       'From Transaction_Filter_List__c';                              

        if(String.isNotBlank(iipRefNo) && String.isNotBlank(processingDateStr)){
            query+= ' Where (Description2__c =  \'' + iipRefNo + '\'';
            query+=  ' AND Processing_Date__c = ' + processingDateStr + ')';
        }else{
            if(String.isNotBlank(iipRefNo)){
                query+= ' Where (Description2__c =  \'' + iipRefNo + '\')';
            }else if(String.isNotBlank(processingDateStr)){
                query+=  ' Where (Processing_Date__c = ' + processingDateStr + ')';
            }
        }

        if( String.isNotBlank(data) || String.isNotBlank(admin) || String.isNotBlank(airtime) || String.isNotBlank(accFee) || String.isNotBlank(immediateDT) ||String.isNotBlank(debit)||String.isNotBlank(credit)
           ||String.isNotBlank(correction) || String.isNotBlank(debitTest) || String.isNotBlank(creditTest)){

            if(String.isBlank(iipRefNo) && String.isBlank(processingDateStr)){
                query+= ' Where (';
            }else{
                query+= ' AND (';
            }
           

            if(String.isNotBlank(data)){
                query+= 'Description1__c = \'' + data + '\' OR ';
            }
            if(String.isNotBlank(admin)){
                query+= 'Description1__c = \'' + admin + '\' OR ';
            }
            if(String.isNotBlank(airtime)){
                query+= 'Description1__c = \'' + airtime + '\' OR ';
            }
            if(String.isNotBlank(accFee)){
                query+= 'Description1__c = \'' + accFee + '\' OR ';
            }
            if(String.isNotBlank(immediateDT)){
                query+= 'Description1__c = \'' + immediateDT + '\' OR ';
            }
            if(String.isNotBlank(debit)){
                query+= 'Description1__c = \'' + debit + '\' OR ';
            }
            if(String.isNotBlank(debitTest)){
                query+= 'Description1__c = \'' + debitTest + '\' OR ';
            }
            if(String.isNotBlank(creditTest)){
                query+= 'Description1__c = \'' + creditTest + '\' OR ';
            }
            if(String.isNotBlank(credit)){
                query+= 'Description1__c = \'' + credit + '\' OR ';
            }
            if(String.isNotBlank(correction)){
                query+= 'Description1__c = \'' + correction + '\' OR ';
            }

            query = query.substring(0,query.length() -3);

            query+= ')';
        }

        query+= ' ORDER BY Processing_Date__c ASC';

        System.debug('RUDIX ##' + query);

        List<Transaction_Filter_List__c> filterList = Database.query( query );

        return filterList;
    
    }

    /**
     * @author Rudolf Niehaus
     * closeCaseAction : Close a case from the screen flow
     * @param Id caseRecordId
     */
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