/*
* Integration Utility for Get Will Banking Details Service
* Maps the responses to Will Banking Details Bean
* @author Danie Booysen
* @created 2019-02-11
*/
public class GetWillBankingDetails_IU_v1 {
    
        public static WillBankingDetails_IB_v1 mapResponseFields(HttpResponse responseP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = new WillBankingDetails_IB_v1.BankingDetailsResponse_cls();
        responseBean = (WillBankingDetails_IB_v1.BankingDetailsResponse_cls)JSON.deserialize( responseP.getBody(), WillBankingDetails_IB_v1.BankingDetailsResponse_cls.class);
        responseBean.Status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        bean.BankingDetailsResponse = responseBean;
        System.debug('Get Will Banking Details Response: ' + bean);
        return bean;
    }
    
    public static WillBankingDetails_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = new WillBankingDetails_IB_v1.BankingDetailsResponse_cls();
        
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        bean.BankingDetailsResponse = responseBean;
        System.debug('Get Will Banking Details Response: ' + bean);
        return bean;
    }
}