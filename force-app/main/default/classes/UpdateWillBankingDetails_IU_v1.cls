public class UpdateWillBankingDetails_IU_v1 {

    public static WillBankingDetails_IB_v1 mapRequestFields(String willNoP, String branchCodeP, String bankNameP, String siteCodeP, String branchNameP, String accountTypeP, String accountNumberP, String clientNameP, String effectiveDateP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsRequest_cls requestBean = new WillBankingDetails_IB_v1.BankingDetailsRequest_cls();
        
        requestBean.WillNo = willNoP;
        requestBean.BranchCode = branchCodeP;
        requestBean.BranchName = branchNameP;
        requestBean.BankName = bankNameP;
        requestBean.SiteCode = siteCodeP;
        requestBean.AccountType = accountTypeP;
        requestBean.AccountNumber = accountNumberP;
        requestBean.ClientName = clientNameP;
        requestBean.EffectiveDate = effectiveDateP;
        
        bean.BankingDetailsRequest = requestBean;
        return bean;
    }
    
    public static WillBankingDetails_IB_v1 mapResponseFields(HttpResponse responseP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = (WillBankingDetails_IB_v1.BankingDetailsResponse_cls)JSON.deserialize( responseP.getBody(), WillBankingDetails_IB_v1.BankingDetailsResponse_cls.class);
        
        responseBean.Status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        bean.BankingDetailsResponse = responseBean;
        
        return bean;
    }
    
    public static WillBankingDetails_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        WillBankingDetails_IB_v1 bean = new WillBankingDetails_IB_v1();
        WillBankingDetails_IB_v1.BankingDetailsResponse_cls responseBean = new WillBankingDetails_IB_v1.BankingDetailsResponse_cls();
        
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        bean.BankingDetailsResponse = responseBean;
        
        return bean;
    }
}