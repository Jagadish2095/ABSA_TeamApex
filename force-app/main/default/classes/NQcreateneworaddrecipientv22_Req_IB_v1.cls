/*
* Integration Request Bean for NQcreateneworaddrecipientv2 Service  (for NOTIFY ME integration flow)
* @author Satya Boyenepalli
* @created 01-12-2020
*/

public class NQcreateneworaddrecipientv22_Req_IB_v1 extends Base_IB {
    public class RecipientAcnData {
        public String prodArea;
        public List<TrnSelX> trnSelX;
        public String minAm;
        public String transmitWindow;
        public List<BalFreqs> balFreqs;
        public String delInd;
    }
    
    public NQcreateNewOrAddRecipientV2 NQcreateNewOrAddRecipientV2;
    
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }
         
    public class NQcreateNewOrAddRecipientV2 {
      @AuraEnabled  public Nbsapdpi nbsapdpi;
      @AuraEnabled  public Nbsmsgi nbsmsgi;
      @AuraEnabled  public Nqp906i nqp906i;
    }
    
    public class KeyFields {
        public String cif;
        public String acn;
        public String pnsRecipientId;
    }
    
    public class TrnSelX {
        public String trnSel;
    }
    
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }
    
    public class Nqp906i {
        public String registeringSite;
        public KeyFields keyFields;
        public String clientNotif;
        public String sbuCd;
        public String teller;
        public String notifyCifInd;
        public RecipientData recipientData;
        public RecipientAcnData recipientAcnData;
        public String marketerCode;
        public String marketerCodeAmend;
    }
    
    public class RecipientData {
        public String recipNm;
        public String contactPref;
        public String lng;
        public String email;
        public String cellPhone;
    }
    
    public class BalFreqs {
        public String balDay;
    }
    
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    
    public static NQcreateneworaddrecipientv22_Req_IB_v1 CreateDummyBean(){
        NQcreateneworaddrecipientv22_Req_IB_v1 requestbean = new NQcreateneworaddrecipientv22_Req_IB_v1();
        NQcreateneworaddrecipientv22_Req_IB_v1.NQcreateNewOrAddRecipientV2 NQcreateNewOrAddRecipientV2bean = new NQcreateneworaddrecipientv22_Req_IB_v1.NQcreateNewOrAddRecipientV2();
        NQcreateneworaddrecipientv22_Req_IB_v1.nqp906i nqp906ibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nqp906i();
        NQcreateneworaddrecipientv22_Req_IB_v1.finalMsgId finalMsgIdbean  = new NQcreateneworaddrecipientv22_Req_IB_v1.finalMsgId();
        NQcreateneworaddrecipientv22_Req_IB_v1.nbsapdpi nbsapdpibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nbsapdpi();
        NQcreateneworaddrecipientv22_Req_IB_v1.nbsmsgi nbsmsgibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nbsmsgi();
        NQcreateneworaddrecipientv22_Req_IB_v1.keyFields keyFieldsbean = new NQcreateneworaddrecipientv22_Req_IB_v1.keyFields();
        NQcreateneworaddrecipientv22_Req_IB_v1.recipientAcnData recipientAcnDatabean = new NQcreateneworaddrecipientv22_Req_IB_v1.recipientAcnData();
        NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX trnSelXbean = new NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX();
        NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs balFreqsbean = new NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs();
        List<NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX> trnSelXlistbean = new List<NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX>();
        List<NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs> balFreqslistbean = new List<NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs>();
        NQcreateneworaddrecipientv22_Req_IB_v1.recipientData recipientDatabean = new NQcreateneworaddrecipientv22_Req_IB_v1.recipientData();
        
        nbsapdpibean.channel = 'SF';
            nbsapdpibean.application = 'SF';
            nbsapdpibean.trace = 'N';
            
            nbsmsgibean.msgLanguage = 'E';
             nbsmsgibean.msgTarget = 'STD';
            finalMsgIdbean.finalMsgClass = '';
            finalMsgIdbean.finalMsgCode = '';
            nbsmsgibean.finalMsgId = finalMsgIdbean;
            
            nqp906ibean.registeringSite = '8474';
            keyFieldsbean.acn ='9050544469';   /*accountNumber; */
            keyFieldsbean.cif ='MOOIM  002';  /*account.CIF__c; */
            keyFieldsbean.pnsRecipientId = '1';
            nqp906ibean.keyFields = keyFieldsbean;
            nqp906ibean.clientNotif = '903';
            nqp906ibean.sbuCd = 'F'; 
            nqp906ibean.teller = '1469';
            nqp906ibean.notifyCifInd = 'N';
            recipientDatabean.recipNm ='Sizwe'; /* recipName;*/
            recipientDatabean.contactPref = 'S';
            recipientDatabean.lng = 'E';
            recipientDatabean.email = 'email';
            recipientDatabean.cellPhone = '0797530041'; /*cellphone;*/
            nqp906ibean.recipientData = recipientDatabean;
            recipientAcnDatabean.prodArea ='SAVINGS';/* productType;*/
            trnSelXbean.trnSel = '19';
            trnSelXlistbean.add(trnSelXbean);
            recipientAcnDatabean.trnSelX = trnSelXlistbean;
            recipientAcnDatabean.minAm = '0';
            recipientAcnDatabean.transmitWindow = 'L';
            balFreqsbean.balDay='Y';
            balFreqslistbean.add(balFreqsbean);
            recipientAcnDatabean.balFreqs = balFreqslistbean;
            recipientAcnDatabean.delInd = 'N';
            nqp906ibean.recipientAcnData = recipientAcnDatabean;
            nqp906ibean.marketerCode = '1332';
            nqp906ibean.marketerCodeAmend = '0';
            NQcreateNewOrAddRecipientV2bean.nbsapdpi = nbsapdpibean;
            NQcreateNewOrAddRecipientV2bean.nbsmsgi = nbsmsgibean; 
            NQcreateNewOrAddRecipientV2bean.nqp906i = nqp906ibean;
          requestBean.NQcreateNewOrAddRecipientV2 = NQcreateNewOrAddRecipientV2bean;
        return requestbean;
        
    }
    
}