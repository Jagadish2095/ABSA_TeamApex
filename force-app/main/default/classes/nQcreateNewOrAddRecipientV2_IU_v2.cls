/**
* Descripton: Apex Integration Utility Bean class for nqcreateneworaddrecipientv2 service
* @description Test Class Name: nqcreateneworaddrecipientv2_IU_v2
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQcreateNewOrAddRecipientV2_IU_v2 {
    
	/**
	* @description 
	* @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-29 
	* @param CIF 
	* @param accountNumber 
	* @param siteCode 
	* @param tellerCode 
	* @param sbuCd 
	* @param recipName 
	* @param contactPref 
	* @param language 
	* @param email 
	* @param cellPhone 
	* @param prodArea 
	* @param payment 
	* @param withDrawal 
	* @param deposit 
	* @param transfer 
	* @param returned 
	* @param scheduled 
	* @param purchase 
	* @param notifyTimes 
	* @param balanceUpdates 
	* @param minimumAmount 
	* @return nQcreateNewOrAddRecipientV2_Req_IB_v2 
	**/
	public static nQcreateNewOrAddRecipientV2_Req_IB_v2 mapRequestdFields(String CIF , String accountNumber,String siteCode, String tellerCode, String sbuCd, String recipName, String contactPref,String language,String email, String cellPhone, String prodArea , boolean payment ,boolean withDrawal,boolean  deposit, boolean  transfer, boolean returned, boolean scheduled,boolean purchase, String notifyTimes, String balanceUpdates, String minimumAmount){    
    
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
        keyFields.cif = CIF;
        keyFields.acn = accountNumber;
        keyFields.pnsRecipientId = '0';//'1';//W-13694
        nqp906i.registeringSite = siteCode;
        nqp906i.keyFields = keyFields;
        nqp906i.clientNotif = '903';
        nqp906i.sbuCd = sbuCd;
        nqp906i.teller = tellerCode;
        nqp906i.notifyCifInd = 'N';
        nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientData recipientData = new  nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientData();
        recipientData.recipNm = recipName;
        recipientData.contactPref = contactPref;
        recipientData.lng = language;
        recipientData.email = email;
        recipientData.cellPhone = cellPhone;
        nqp906i.recipientData = recipientData;
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientAcnData recipientAcnData = new nQcreateNewOrAddRecipientV2_Req_IB_v2.RecipientAcnData();
        recipientAcnData.prodArea = prodArea;
        
        List<nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX> trnSelXList = new List<nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX>();       
        
        if(payment){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('019'));        	
         }
         if(withDrawal){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('039'));
         	
         }
         if(deposit){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('049'));
         }	
         if(transfer){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('079'));
         	
         }
         if(returned){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('059'));
         	
         }
         if(scheduled){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('069'));
         	
         }   
         if(purchase){                                                                  
         	trnSelXList.add(new nQcreateNewOrAddRecipientV2_Req_IB_v2.TrnSelX('029'));
         	
         }  
        
        recipientAcnData.trnSelX = trnSelXList;
        recipientAcnData.minAm = minimumAmount;
        //W-13694 : Anka Ganta
       if(notifyTimes != null)
       recipientAcnData.transmitWindow = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('Onboarding','Transmit Window', notifyTimes, StringConstants.OUTBOUND_RECORD_TYPE);
        
        List<nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs>  balFreqsList = new List<nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs>();
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsSunday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsSunday.balDay = balanceUpdates == 'sunday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsSunday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsMonday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsMonday.balDay = balanceUpdates == 'monday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsMonday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsTuesday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsTuesday.balDay = balanceUpdates == 'tuesday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsTuesday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsWednesday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsWednesday.balDay = balanceUpdates == 'wednesday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsWednesday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsThursday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsThursday.balDay = balanceUpdates == 'thursday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsThursday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsFriday= new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsFriday.balDay = balanceUpdates == 'friday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsFriday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsSaturday = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsSaturday.balDay = balanceUpdates == 'saturday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsSaturday);
        
        nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs balFreqsDaily = new nQcreateNewOrAddRecipientV2_Req_IB_v2.BalFreqs();
        balFreqsDaily.balDay = balanceUpdates == 'daily' ? 'Y' : 'N';
        balFreqsList.add(balFreqsDaily);
        
        recipientAcnData.balFreqs =  balFreqsList;
        recipientAcnData.delInd = 'N';
        nqp906i.recipientAcnData = recipientAcnData;
        nqp906i.marketerCode = '11332';
        nqp906i.marketerCodeAmend = '11332';
        nQcreateNewOrAddRecipientV2.nbsapdpi = nbsapdpi;
        nQcreateNewOrAddRecipientV2.nbsmsgi = nbsmsgi;
        nQcreateNewOrAddRecipientV2.nqp906i = nqp906i;
        requestBean.NQcreateNewOrAddRecipientV2 = nQcreateNewOrAddRecipientV2;
        
        return requestBean;
            
   }   
    
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-29 
    * @param responseP 
    * @return nQcreateNewOrAddRecipientV2_Resp_IB_v2 
    **/
    public static nQcreateNewOrAddRecipientV2_Resp_IB_v2 mapResponseFields(HttpResponse responseP) {
        nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBeanContent;
        
        try {
            nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = new nQcreateNewOrAddRecipientV2_Resp_IB_v2();
            responseBeanContent = (nQcreateNewOrAddRecipientV2_Resp_IB_v2)responseBean.deserialize(responseP.getBody(), nQcreateNewOrAddRecipientV2_Resp_IB_v2.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            
        }

    
        return responseBeanContent;
    }
    
    

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-29 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return nQcreateNewOrAddRecipientV2_Resp_IB_v2 
    **/
    public static nQcreateNewOrAddRecipientV2_Resp_IB_v2 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = new nQcreateNewOrAddRecipientV2_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        
        return responseBean;
    }

}