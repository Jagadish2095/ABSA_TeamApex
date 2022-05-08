/*
* Integration Utility for Create Will Banking Details Service
* Maps the request & responses to Will Banking Details Bean
* @author Danie Booysen
* @created 2019-02-08
*/
public class CreateWillBankingDetails_IU_v1 {
    
    public static WillBankingDetails_IB_v1 mapRequestFields(String willNoP, String branchCodeP, String branchNameP, String bankNameP, String siteCodeP, String accountTypeP, String accountNumberP, String clientNameP, String effectiveDateP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsRequest_cls requestBean = new WillBankingDetails_IB_v1.BankingDetailsRequest_cls();
        
        requestBean.WillNo = willNoP;
        requestBean.BranchCode = branchCodeP;
        requestBean.BankName = bankNameP;
        requestBean.SiteCode =  siteCodeP;
        requestBean.BranchName = branchNameP;
        requestBean.AccountType = accountTypeP;
        requestBean.AccountNumber = accountNumberP;
        requestBean.ClientName = clientNameP;
        requestBean.EffectiveDate = effectiveDateP;
        
        bean.BankingDetailsRequest = requestBean;
        System.debug('Create Will Banking Details Request: ' + bean);
        return bean;
    }
    
    public static WillBankingDetails_IB_v1 mapResponseFields(HttpResponse responseP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = new WillBankingDetails_IB_v1.BankingDetailsResponse_cls();
        responseBean = (WillBankingDetails_IB_v1.BankingDetailsResponse_cls)JSON.deserialize( responseP.getBody(), WillBankingDetails_IB_v1.BankingDetailsResponse_cls.class);
        responseBean.Status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        bean.BankingDetailsResponse = responseBean;
        System.debug('Create Will Banking Details Response: ' + bean);
        return bean;
    }
    
    public static WillBankingDetails_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = new WillBankingDetails_IB_v1.BankingDetailsResponse_cls();
        
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        bean.BankingDetailsResponse = responseBean;
        System.debug('Create Will Banking Details Response: ' + bean);
        return bean;
    }
}