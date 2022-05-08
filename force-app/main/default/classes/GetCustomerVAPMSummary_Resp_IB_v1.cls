/**
* GetCustomerVAPMSummary_Resp_IB_v1
*
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-09-13
*
*
*
**/

public class GetCustomerVAPMSummary_Resp_IB_v1 {
    
    
    public String status;
    public Integer statusCode;
    public String message;
   
    public GetCustomerVapmSummaryResponse getCustomerVapmSummaryResponse;
    
    public class GetCustomerVapmSummaryResponse{
         public GetCustomerVapmSummaryResult getCustomerVapmSummaryResult;
    }
   public class GetCustomerVapmSummaryResult{
        public String IsSuccess;
        public String ResultCode;
        public CustomerVapmSummary customerVapmSummary;
    }
   public class CustomerVapmSummaryDto{
        public String CustomerGroupLeaderKey;
 		public String CustomerKey;
 		public String CustomerValue2MonthsAgo;
 		public String CustomerValueLastMonth;
 		public String GroupValue2MonthsAgo;
 		public String GroupValueLast12Months;
 		public String GroupValueLast24Months;
 		public String GroupValueLastMonth;
 		public String InformationDate;
 		public String ItemCode;
 		public String ItemDesc;          
   }
    
    public class CustomerVapmSummary{
         public List<CustomerVapmSummaryDto> customerVapmSummaryDto;
         
   }
}