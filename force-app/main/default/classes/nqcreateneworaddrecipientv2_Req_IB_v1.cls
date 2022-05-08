public class nqcreateneworaddrecipientv2_Req_IB_v1{

    public NQcreateNewOrAddRecipientV2 NQcreateNewOrAddRecipientV2{get;set;}
    public class trnSelX{
        public String trnSel{get;set;}
        public trnSelX(String input){
            trnSel = input;
        }
        public trnSelX(){
        }
    }
    public class recipientData{
        public String recipNm{get;set;}
        public String email{get;set;}
        public String lng{get;set;}
        public String cellPhone{get;set;}
        public String contactPref{get;set;}
    }
    public class recipientAcnData{
        public list<trnSelX> trnSelX{get;set;}
        public String transmitWindow{get;set;}
        public list<balFreqs> balFreqs{get;set;}
        public String minAm{get;set;}
        public String delInd{get;set;}
        public String prodArea{get;set;}
    }
    public class nqp906i{
        public String notifyCifInd{get;set;}
        public keyFields keyFields{get;set;}
        public String registeringSite{get;set;}
        public String clientNotif{get;set;}
        public recipientAcnData recipientAcnData{get;set;}
        public recipientData recipientData{get;set;}
        public String marketerCode{get;set;}
        public String teller{get;set;}
        public String marketerCodeAmend{get;set;}
        public String sbuCd{get;set;}
    }
    public class NQcreateNewOrAddRecipientV2{
        public nbsmsgi nbsmsgi{get;set;}
        public nqp906i nqp906i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public class nbsmsgi{
        public String msgLanguage{get;set;}
        public finalMsgId finalMsgId{get;set;}
        public String msgTarget{get;set;}
    }
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    }
    public class keyFields{
        public String acn{get;set;}
        public String pnsRecipientId{get;set;}
        public String cif{get;set;}
    }
    public class finalMsgId{
        public String finalMsgCode{get;set;}
        public String finalMsgClass{get;set;}
    }
    public class balFreqs{
        public String balDay{get;set;}
        public balFreqs(String input){
            balDay = input;
        }
          public balFreqs(){
        }
    }
    
    public static nqcreateneworaddrecipientv2_Req_IB_v1 createDummyBean(){
          nqcreateneworaddrecipientv2_Req_IB_v1 requestbean = new nqcreateneworaddrecipientv2_Req_IB_v1();
          nqcreateneworaddrecipientv2_Req_IB_v1.NQcreateNewOrAddRecipientV2 NQcreateNewOrAddRecipientV2bean = new nqcreateneworaddrecipientv2_Req_IB_v1.NQcreateNewOrAddRecipientV2();
          nqcreateneworaddrecipientv2_Req_IB_v1.nqp906i nqp906ibean  = new nqcreateneworaddrecipientv2_Req_IB_v1.nqp906i();
          nqcreateneworaddrecipientv2_Req_IB_v1.finalMsgId finalMsgIdbean  = new nqcreateneworaddrecipientv2_Req_IB_v1.finalMsgId();
          nqcreateneworaddrecipientv2_Req_IB_v1.nbsapdpi nbsapdpibean  = new nqcreateneworaddrecipientv2_Req_IB_v1.nbsapdpi();
          nqcreateneworaddrecipientv2_Req_IB_v1.nbsmsgi nbsmsgibean  = new nqcreateneworaddrecipientv2_Req_IB_v1.nbsmsgi();
          nqcreateneworaddrecipientv2_Req_IB_v1.keyFields keyFieldsbean = new nqcreateneworaddrecipientv2_Req_IB_v1.keyFields();
          nqcreateneworaddrecipientv2_Req_IB_v1.recipientAcnData recipientAcnDatabean = new nqcreateneworaddrecipientv2_Req_IB_v1.recipientAcnData();
          nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX trnSelXbean = new nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX();
          nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs balFreqsbean = new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs();
          List<nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX> trnSelXlistbean = new List<nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX>();
          List<nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs> balFreqslistbean = new List<nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs>();
          nqcreateneworaddrecipientv2_Req_IB_v1.recipientData recipientDatabean = new nqcreateneworaddrecipientv2_Req_IB_v1.recipientData();
          
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
        
          nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
        
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
          
          keyFieldsbean.acn = '4048154875';
          keyFieldsbean.cif = 'JINPIX 001';
          keyFieldsbean.pnsRecipientId = '1';
          
          balFreqsbean.balDay = 'test';
          balFreqslistbean.add(balFreqsbean);
          
          trnSelXbean.trnSel = 'test';
          trnSelXlistbean.add(trnSelXbean);
        
           recipientAcnDatabean.balFreqs = balFreqslistbean;
            recipientAcnDatabean.delInd = 'test';
            recipientAcnDatabean.minAm = 'test';
            recipientAcnDatabean.prodArea = 'test';
            recipientAcnDatabean.transmitWindow = 'test';
            recipientAcnDatabean.trnSelX = trnSelXlistbean;
          
          recipientDatabean.cellPhone = 'test';
          recipientDatabean.contactPref = 'test';
          recipientDatabean.email = 'test@gmail.com';
          recipientDatabean.lng = 'test';
          recipientDatabean.recipNm = 'test';
                
          nqp906ibean.notifyCifInd = '4048154875';
          nqp906ibean.keyFields = keyFieldsbean;//
          nqp906ibean.registeringSite = '034';
          nqp906ibean.clientNotif = '20191001';
          nqp906ibean.recipientAcnData = recipientAcnDatabean;//
          nqp906ibean.recipientData = recipientDatabean;//
          nqp906ibean.marketerCode = 'BDP';  
          nqp906ibean.teller = '01';//
          nqp906ibean.marketerCodeAmend = 'test';//
          nqp906ibean.sbuCd = 'BDP'; 
        
          NQcreateNewOrAddRecipientV2bean.nqp906i = nqp906ibean;
          NQcreateNewOrAddRecipientV2bean.nbsapdpi = nbsapdpibean;
          NQcreateNewOrAddRecipientV2bean.nbsmsgi = nbsmsgibean; 
          requestBean.NQcreateNewOrAddRecipientV2 = NQcreateNewOrAddRecipientV2bean;
          return requestbean;
    
    }
    
}