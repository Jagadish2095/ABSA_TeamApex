public class CreateAssetsLiabilities_Req_IB_v1 extends Base_IB
{
    public String Operation;
    public String WillNo;
    public String Assets;
    public String FarmingTestator;
    public String FarmingTestatrix;
    public String FixedPropTestator;
    public String FixedPropTestatrix;
    public String MineralTestator;
    public String MineralTestatrix;
    public String MovAssetsTestator;
    public String MovAssetsTestatrix;
    public String BusIntTestator;
    public String BusIntTestatrix;
    public String LiquidAssTestator;
    public String LiquidAssTestatrix;
    public String AssetsPayTestator;
    public String AssetsPayTestatrix;
    public String OtherAssTestator;
    public String OtherAssTestatrix;
    public String Liabilities;
    public String MortgaugeTestator;
    public String MortgaugeTestatrix;
    public String OverDraftTestator;
    public String OverDraftTestatrix;
    public String CreditTestator;
    public String CreditTestatrix;
    public String TaxTestator;
    public String TaxTestatrix;
    public String SuretyTestator;
    public String SuretyTestatrix;
    public String LoanLTestator;
    public String LoanLTestatrix;
    public String OtherLTestator;
    public String OtherLTestatrix;
    public String Assurance;
    public String MortgageAssTestator;
    public String MortgageAssTestatrix;
    public String OutCededAssTestator;
    public String OutCededAssTestatrix;
    public String AssetAmt;
    public String LiabilAmt;
    public String FeeCode;
    public String FeeDescription;
    public String FeeAmount;
    
        
    public CreateAssetsLiabilities_Req_IB_v1 createDummyRequest()
    {  
    	CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
    	reqBean.Operation = 'WRITE ASS';
        reqBean.WillNo = '41000051343';
        reqBean.Assets =  'Y';
        reqBean.FarmingTestator =  '0';
        reqBean.FarmingTestatrix =  '0';
        reqBean.FixedPropTestator =  '0';
        reqBean.FixedPropTestatrix =  '0';
        reqBean.MineralTestator =  '0';
        reqBean.MineralTestatrix =  '0';
        reqBean.MovAssetsTestator =  '0';
        reqBean.MovAssetsTestatrix =  '0';
        reqBean.BusIntTestator =  '0';
        reqBean.BusIntTestatrix =  '0';
        reqBean.LiquidAssTestator =  '0';
        reqBean.LiquidAssTestatrix =  '0';
        reqBean.AssetsPayTestator =  '0';
        reqBean.AssetsPayTestatrix =  '0';
        reqBean.OtherAssTestator =  '800'; //Used to create total asset  (main participant)
        reqBean.OtherAssTestatrix =  '0';//Used to create total asset (Joint participant)
        reqBean.Liabilities =  'N';
        reqBean.MortgaugeTestator =  '0';
        reqBean.MortgaugeTestatrix =  '0';
        reqBean.OverDraftTestator =  '0';
        reqBean.OverDraftTestatrix =  '0';
        reqBean.CreditTestator =  '0';
        reqBean.CreditTestatrix =  '0';
        reqBean.TaxTestator =  '0';
        reqBean.TaxTestatrix =  '0';
        reqBean.SuretyTestator =  '0';
        reqBean.SuretyTestatrix =  '0';
        reqBean.LoanLTestator =  '0';
        reqBean.LoanLTestatrix =  '0';
        reqBean.OtherLTestator =  '0'; //Used to create total Liabilities  (main participant)
        reqBean.OtherLTestatrix =  '0'; //Used to create total Liabilities (Joint participant)
        reqBean.Assurance =  'Y';
        reqBean.MortgageAssTestator =  '0';
        reqBean.MortgageAssTestatrix =  '0';
        reqBean.OutCededAssTestator =  '0';
        reqBean.OutCededAssTestatrix =  '0';
        reqBean.AssetAmt = '0';
        reqBean.LiabilAmt =  '0';
        reqBean.FeeCode =  '19';
        reqBean.FeeDescription =  'DISCOVERY/MOMENTUM CONSULT (EXTR EXEC)';
        reqBean.FeeAmount =  '1725.00';
        
        return reqBean;
    }
}