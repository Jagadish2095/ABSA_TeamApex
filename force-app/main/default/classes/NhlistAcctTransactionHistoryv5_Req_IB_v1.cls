/*
* Class for NHlistAcctTransactionHistoryV5 request
* @author Mashudu Raidimi
* @created   2020/03/05
*/
public class NhlistAcctTransactionHistoryv5_Req_IB_v1 extends Base_IB{
    
    public NHlistAcctTransactionHistoryV5 NHlistAcctTransactionHistoryV5{get;set;}
    
    public class NHlistAcctTransactionHistoryV5{
       public nbsapdpi nbsapdpi{get;set;}
       public nhp021i nhp021i{get;set;}
   
    }
    
     public class nbsapdpi {
       public String channel;
       public String application;
       public String trace;
     }

    public class nhp021i {
        public String log{get;set;}
        public String authenticate{get;set;}
        public String accessNumber{get;set;}
        public String user{get;set;}
        public String division{get;set;}
        public String device{get;set;}
        public String origAddress{get;set;}
        public String accountNumber{get;set;}
        public String language{get;set;}
        public String fromDate{get;set;}
        public String toDate{get;set;}
        public String recordType{get;set;}
        public String nbrOfRecsToRtrv{get;set;}
        public String pagingKey{get;set;}
        public String statmentType{get;set;}
        
      
    }
    //dummy request method
    public NhlistAcctTransactionHistoryv5_Req_IB_v1 createDummy(){
        
        NhlistAcctTransactionHistoryv5_Req_IB_v1 req = new NhlistAcctTransactionHistoryv5_Req_IB_v1();
        NhlistAcctTransactionHistoryv5_Req_IB_v1.nhp021i request = new NhlistAcctTransactionHistoryv5_Req_IB_v1.nhp021i();
        
    
        request.log = 'N';
        request.authenticate =  'N';
        request.accessNumber= '04451450000062615';
        request.user ='1';
        request.division = 'ABSA';
        request.device =  'I';
        request.origAddress ='0';
        request.accountNumber ='9050986380';
        request.language =  'E';
        request.fromDate = '20200228';
        request.toDate =  '20200228';
        request.recordType = 'S';
        request.nbrOfRecsToRtrv =  '145';
        request.pagingKey = 'N';
        request.statmentType =  'N';
        
        //reqBeam.nhp021i = request;
       
        return req;
      
    }       
}