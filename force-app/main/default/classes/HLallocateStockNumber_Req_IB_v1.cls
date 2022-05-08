public class HLallocateStockNumber_Req_IB_v1 extends Base_IB 
{    
    public cls_Nbsapdpi nbsapdpi;
    public cls_Nbsmsgi nbsmsgi;
    public cls_Hlp110i hlp110i;
    
    public class cls_Nbsapdpi
    {
        public String channel;
        public String application;
        public String trace;
    }
    
    public class cls_Nbsmsgi
    {
        public String msgLanguage;
    	public String msgTarget;
    	public cls_FinalMsgId finalMsgId;
    }
    
    public class cls_FinalMsgId
    {
        public String finalMsgClass;
        public String finalMsgCode;
    }
    
    public class cls_Hlp110i
    {
    	public String prodCategory;
    	public String prodType;
        public String prodCode;
        public String siteCode;        
    }
    
    public HLallocateStockNumber_Req_IB_v1 createDummyRequest()
    {    
        cls_Nbsapdpi sect1 = new cls_Nbsapdpi();
        sect1.channel = '';
        sect1.application = 'WILLS';
        sect1.trace = 'N';
            
        cls_FinalMsgId sect2sub = new cls_FinalMsgId();
        sect2sub.finalMsgClass = '';
        sect2sub.finalMsgCode = '';
            
        cls_Nbsmsgi sect2 = new cls_Nbsmsgi();
        sect2.msgLanguage = 'E';
        sect2.msgTarget = 'STD';
        sect2.finalMsgId = sect2sub;
            
        cls_Hlp110i sect3 = new cls_Hlp110i();
        sect3.prodCategory = '001';
        sect3.prodType = '410';
        sect3.prodCode = '410';
        sect3.siteCode = '3232';
            
        HLallocateStockNumber_Req_IB_v1 request = new HLallocateStockNumber_Req_IB_v1();
        request.nbsapdpi = sect1;
        request.nbsmsgi = sect2;
        request.hlp110i = sect3;
        
        HLallocateStockNumber_Req_IB_v1 bean = new HLallocateStockNumber_Req_IB_v1();
        bean = request;
        
        System.debug('RequestBean: ' + bean);
        return bean;
    }
}