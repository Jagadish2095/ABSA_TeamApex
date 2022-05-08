/**
* Descripton: Apex Integration Utility  class for nhlistAcctTransactionHistoryv5 service
* @author  Mashudu Raidimi
* @Date   2020-03-31
*
**/
public class NhlistAcctTransactionHistoryv5_IU_v1 {
    
    
     public static NhlistAcctTransactionHistoryv5_Req_IB_v1 mapRequestdFields(String accountNumberP,String fromDateP,String toDateP){    
    
        NhlistAcctTransactionHistoryv5_Req_IB_v1 requestBean = new NhlistAcctTransactionHistoryv5_Req_IB_v1();
        NhlistAcctTransactionHistoryv5_Req_IB_v1.nhp021i request = new NhlistAcctTransactionHistoryv5_Req_IB_v1.nhp021i();
        NhlistAcctTransactionHistoryv5_Req_IB_v1.nbsapdpi req = new NhlistAcctTransactionHistoryv5_Req_IB_v1.nbsapdpi();
         
        req.application = 'BDP';
        req.channel = 'BDP';
        req.trace = 'Y';
         
        request.log = 'N';
        request.authenticate =  'N';
        request.accessNumber= accountNumberP;//'04451450000062615';
        request.user ='1';
        request.division = 'ABSA';
        request.device =  'I';
        request.origAddress ='0';
        request.accountNumber = accountNumberP;//;//'9050986380';//
        request.language =  'E';
        request.fromDate = fromDateP;//'20200228';//
        request.toDate =  toDateP;//'20200228';//.'20200228';
        request.recordType = 'S';
        request.nbrOfRecsToRtrv =  '145';
        request.pagingKey = 'N';
        request.statmentType =  'N';
       
        NhlistAcctTransactionHistoryv5_Req_IB_v1.NHlistAcctTransactionHistoryV5 RqBeanValue = new NhlistAcctTransactionHistoryv5_Req_IB_v1.NHlistAcctTransactionHistoryV5();
        RqBeanValue.nbsapdpi = req;
        RqBeanValue.nhp021i = request;
         
        requestBean.NHlistAcctTransactionHistoryV5 = RqBeanValue;
        
        System.debug('Request Bean'+requestBean) ;   
         return requestBean;
  }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: NhlistAccTransactionHistoryv5_Resp_IB_v1 bean object
      * */
    public static NhlistAccTransactionHistoryv5_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = (NhlistAccTransactionHistoryv5_Resp_IB_v1)JSON.deserialize( respP.getBody(), NhlistAccTransactionHistoryv5_Resp_IB_v1.class);     
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Response bean: ' + responseBean);
        return responseBean;
    }
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: NhlistAccTransactionHistoryv5_Resp_IB_v1 bean object
      * */
    
     public static NhlistAccTransactionHistoryv5_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = new NhlistAccTransactionHistoryv5_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }

}