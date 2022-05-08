public class AddAccountToPortfolio_UI_v1 
{
    
    public static AddAccountToPortfolio_Req_IB_v1 mapRequestFields(String clientCode, String accountNo, string dateAccOpen, string siteAccOpen, string tellerNo, string product, string casaRefNum, string srcOfFnds1, string srcOfFnds2,string srcOfFnds3, string srcOfFnds4, string srcOfFnds5, string sec129DeliveryAddr)   
    {               
        AddAccountToPortfolio_Req_IB_v1 PortfolioAccountRequestBean = new AddAccountToPortfolio_Req_IB_v1();        
        
        PortfolioAccountRequestBean.clientCode = clientCode;
        PortfolioAccountRequestBean.accountNo = accountNo;
        PortfolioAccountRequestBean.dateAccOpen = dateAccOpen;
        PortfolioAccountRequestBean.siteAccOpen = siteAccOpen;
        PortfolioAccountRequestBean.tellerNo = tellerNo;
        PortfolioAccountRequestBean.product = product;
        PortfolioAccountRequestBean.casaRefNum = casaRefNum;
        PortfolioAccountRequestBean.srcOfFnds1 = srcOfFnds1;
        PortfolioAccountRequestBean.srcOfFnds2 = srcOfFnds2;
        PortfolioAccountRequestBean.srcOfFnds3 = srcOfFnds3;
        PortfolioAccountRequestBean.srcOfFnds4 = srcOfFnds4;
        PortfolioAccountRequestBean.srcOfFnds5 = srcOfFnds5;
        PortfolioAccountRequestBean.sec129DeliveryAddr = sec129DeliveryAddr;
        
        
        System.debug('AddAccountToPortfolio Request Bean: ' + PortfolioAccountRequestBean);
        return PortfolioAccountRequestBean;
    }
    
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: AddAccountToPortfolio_Resp_IB_v1 bean object
    */
    public static AddAccountToPortfolio_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {        
        AddAccountToPortfolio_Resp_IB_v1 responseBean = new AddAccountToPortfolio_Resp_IB_v1();
        AddAccountToPortfolio_Resp_IB_v1 responseBeanContent = (AddAccountToPortfolio_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), AddAccountToPortfolio_Resp_IB_v1.class);
        
        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';
        
        System.debug('Account To Portfolio Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: AddAccountToPortfolio_Resp_IB_v1 bean object
    * */
    
    public static AddAccountToPortfolio_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        AddAccountToPortfolio_Resp_IB_v1 responseBean = new AddAccountToPortfolio_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('Account To Portfolio Failed Response bean: ' + responseBean);
        return responseBean;
    }
}