public class CreateAssetsLiabilities_IU_v1 
{
	public static CreateAssetsLiabilities_Req_IB_v1 mapRequestFields(CreateAssetsLiabilities_Req_IB_v1 createAssetsUi)
    {           
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
                
    	reqBean.Operation = createAssetsUi.Operation;
        reqBean.WillNo = createAssetsUi.WillNo;
        reqBean.Assets =  createAssetsUi.Assets;
        reqBean.FarmingTestator =  createAssetsUi.FarmingTestator;
        reqBean.FarmingTestatrix =  createAssetsUi.FarmingTestatrix;
        reqBean.FixedPropTestator =  createAssetsUi.FixedPropTestator;
        reqBean.FixedPropTestatrix =  createAssetsUi.FixedPropTestatrix;
        reqBean.MineralTestator =  createAssetsUi.MineralTestator;
        reqBean.MineralTestatrix =  createAssetsUi.MineralTestatrix;
        reqBean.MovAssetsTestator =  createAssetsUi.MovAssetsTestator;
        reqBean.MovAssetsTestatrix =  createAssetsUi.MovAssetsTestatrix;
        reqBean.BusIntTestator =  createAssetsUi.BusIntTestator;
        reqBean.BusIntTestatrix =  createAssetsUi.BusIntTestatrix;
        reqBean.LiquidAssTestator =  createAssetsUi.LiquidAssTestator;
        reqBean.LiquidAssTestatrix =  createAssetsUi.LiquidAssTestatrix;
        reqBean.AssetsPayTestator =  createAssetsUi.AssetsPayTestator;
        reqBean.AssetsPayTestatrix =  createAssetsUi.AssetsPayTestatrix;
        reqBean.OtherAssTestator =  createAssetsUi.OtherAssTestator;
        reqBean.OtherAssTestatrix =  createAssetsUi.OtherAssTestatrix;
        reqBean.Liabilities =  createAssetsUi.Liabilities;
        reqBean.MortgaugeTestator =  createAssetsUi.MortgaugeTestator;
        reqBean.MortgaugeTestatrix =  createAssetsUi.MortgaugeTestatrix;
        reqBean.OverDraftTestator =  createAssetsUi.OverDraftTestator;
        reqBean.OverDraftTestatrix =  createAssetsUi.OverDraftTestatrix;
        reqBean.CreditTestator =  createAssetsUi.CreditTestator;
        reqBean.CreditTestatrix =  createAssetsUi.CreditTestatrix;
        reqBean.TaxTestator =  createAssetsUi.TaxTestator;
        reqBean.TaxTestatrix =  createAssetsUi.TaxTestatrix;
        reqBean.SuretyTestator =  createAssetsUi.SuretyTestator;
        reqBean.SuretyTestatrix =  createAssetsUi.SuretyTestatrix;
        reqBean.LoanLTestator =  createAssetsUi.LoanLTestator;
        reqBean.LoanLTestatrix =  createAssetsUi.LoanLTestatrix;
        reqBean.OtherLTestator =  createAssetsUi.OtherLTestator;
        reqBean.OtherLTestatrix =  createAssetsUi.OtherLTestatrix;
        reqBean.Assurance = createAssetsUi.Assurance;
        reqBean.MortgageAssTestator =  createAssetsUi.MortgageAssTestator;
        reqBean.MortgageAssTestatrix =  createAssetsUi.MortgageAssTestatrix;
        reqBean.OutCededAssTestator =  createAssetsUi.OutCededAssTestator;
        reqBean.OutCededAssTestatrix =  createAssetsUi.OutCededAssTestatrix;
        reqBean.AssetAmt =  createAssetsUi.AssetAmt;
        reqBean.LiabilAmt =  createAssetsUi.LiabilAmt;
        reqBean.FeeCode =  createAssetsUi.FeeCode;
        reqBean.FeeDescription =  createAssetsUi.FeeDescription;
        reqBean.FeeAmount =  createAssetsUi.FeeAmount;
       
        System.debug('Create Assets Liabilities Request Bean: ' + reqBean);
        return reqBean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CreateAssetsLiabilities_Resp_IB_v1 bean object
     */
    public static CreateAssetsLiabilities_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        CreateAssetsLiabilities_Resp_IB_v1 bean = new CreateAssetsLiabilities_Resp_IB_v1();
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = (CreateAssetsLiabilities_Resp_IB_v1)bean.deserialize(responseP.getBody(), CreateAssetsLiabilities_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Create Assets Liabilities Response Bean: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CreateAssetsLiabilities_Resp_IB_v1 bean object
     * */    
    public static CreateAssetsLiabilities_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = new CreateAssetsLiabilities_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}