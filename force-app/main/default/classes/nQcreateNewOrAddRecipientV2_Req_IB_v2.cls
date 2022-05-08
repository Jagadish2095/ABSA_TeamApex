/*
 * Request Bean for nQcreateNewOrAddRecipientV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */

public class nQcreateNewOrAddRecipientV2_Req_IB_v2 extends Base_IB{
    
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
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nqp906i nqp906i;
	}

	public class KeyFields {
		public String cif;
		public String acn;
		public String pnsRecipientId;
	}

	public class TrnSelX {
		public String trnSel;
        public TrnSelX(String input){
            trnSel = input;
        }
        public TrnSelX(){
        }
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
    
    public static nQcreateNewOrAddRecipientV2_Req_IB_v2 createDummyRequest(){
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2 requestBean = new nQcreateNewOrAddRecipientV2_Req_IB_v2();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.NQcreateNewOrAddRecipientV2 nQcreateNewOrAddRecipientV2 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.NQcreateNewOrAddRecipientV2();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nbsapdpi nbsapdpi =  new nQcreateNewOrAddRecipientV2_Req_IB_v2.Nbsapdpi();
        
        nbsapdpi.application = 'SALESFORCE';
        nbsapdpi.channel = 'SALESFORCE';
        nbsapdpi.trace = 'Y';
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nbsmsgi nbsmsgi = new nQcreateNewOrAddRecipientV2_Req_IB_v2.Nbsmsgi();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.FinalMsgId finalMsgId = new  nQcreateNewOrAddRecipientV2_Req_IB_v2.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nqp906i nqp906i = new nQcreateNewOrAddRecipientV2_Req_IB_v2.Nqp906i();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.KeyFields keyFields = new nQcreateNewOrAddRecipientV2_Req_IB_v2.KeyFields();
        keyFields.cif = 'MOOIM  002';
        keyFields.acn = '9050544469';
        keyFields.pnsRecipientId = '1';
        nqp906i.registeringSite = '3043';
        nqp906i.keyFields = keyFields;
        nqp906i.clientNotif = '903';
        nqp906i.sbuCd = 'B';
        nqp906i.teller = '11012';
        nqp906i.notifyCifInd = 'N';
        nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientData recipientData = new  nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientData();
        recipientData.recipNm = 'Muvhuso';
        recipientData.contactPref = 'S';
        recipientData.lng = 'E';
        recipientData.email = '';
        recipientData.cellPhone = '0797530041';
        nqp906i.recipientData = recipientData;
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientAcnData recipientAcnData = new nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientAcnData();
        recipientAcnData.prodArea = 'SAVINGS';
        
        List<nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX> trnSelXList = new List<nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX>();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX trnSelX = new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX();
        trnSelX.trnSel = '10';
        nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX trnSelXBean = new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX();
        trnSelXBean.trnSel = '10';
        trnSelXList.add(trnSelX);
        trnSelXList.add(trnSelXBean);
        recipientAcnData.trnSelX = trnSelXList;
        recipientAcnData.minAm = '1150';
        recipientAcnData.transmitWindow = 'L';
        nqp906i.recipientAcnData = recipientAcnData;
        List<nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs>  balFreqsList = new List<nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs>();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs1 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs1.balDay = 'Y';
        balFreqsList.add(balFreqs1);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs2 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs2.balDay = 'N';
        balFreqsList.add(balFreqs2);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs3 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs3.balDay = 'N';
        balFreqsList.add(balFreqs3);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs4 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs4.balDay = 'N';
        balFreqsList.add(balFreqs4);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs5 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs5.balDay = 'N';
        balFreqsList.add(balFreqs5);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs6 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs6.balDay = 'N';
        balFreqsList.add(balFreqs6);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs7 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs7.balDay = 'N';
        balFreqsList.add(balFreqs7);
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqs8 = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqs8.balDay = 'N';
        balFreqsList.add(balFreqs8);
        recipientAcnData.balFreqs =  balFreqsList;
        recipientAcnData.delInd = 'N';
        nqp906i.marketerCode = '11332';
        nqp906i.marketerCodeAmend = '11332';
        nQcreateNewOrAddRecipientV2.nbsapdpi = nbsapdpi;
        nQcreateNewOrAddRecipientV2.nbsmsgi = nbsmsgi;
        nQcreateNewOrAddRecipientV2.nqp906i = nqp906i;
        requestBean.NQcreateNewOrAddRecipientV2 = nQcreateNewOrAddRecipientV2;
        return requestBean;
    }

}