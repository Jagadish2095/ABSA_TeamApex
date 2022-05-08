public class CreateWillRecord_Req_IB_v1 extends Base_IB
{
	public String WillNo;
  	public String CIFKey;
  	public Integer DomicileSite;
  	public String CorpCode;
  	public Integer TransactionSite;
  	public Integer TellerNo;
  	public Integer EffectiveDate;
  	
  	public CreateWillRecord_Req_IB_v1 createDummyRequest()
  	{
  	    CreateWillRecord_Req_IB_v1 reqBean = new CreateWillRecord_Req_IB_v1();
                
        reqBean.WillNo = '41000003904';
        reqBean.CIFKey = 'WILLM 0778';
        reqBean.DomicileSite = 3232;
        reqBean.CorpCode = 'ABS';
        reqBean.TransactionSite = 3232;
        reqBean.TellerNo = 0;   
        reqBean.EffectiveDate = 20190128;  
        
        return reqBean;
    }
}