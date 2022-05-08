/**
* Descripton: Apex Integration Utility Bean class for nQupdateNotificationsV1 service
* Test Class Name: nQupdateNotificationsV1_IU_V2
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQupdateNotificationsV1_IU_V2 {
	public static nQupdateNotificationsV1_Req_IB_v2 mapRequestdFields(String CIF , String accountNumber,String siteCode, String tellerCode, String prodArea , boolean payment ,boolean withDrawal,boolean  deposit, boolean  transfer, boolean returned, boolean scheduled,boolean purchase, String notifyTimes, String balanceUpdates, String minimumAmount){    
    
        nQupdateNotificationsV1_Req_IB_v2 requestBean = new nQupdateNotificationsV1_Req_IB_v2();
        
        nQupdateNotificationsV1_Req_IB_v2.NQupdJVProdNotificationAcctSettingsV1 nQupdJVProdNotificationAcctSettingsV1 = new nQupdateNotificationsV1_Req_IB_v2.NQupdJVProdNotificationAcctSettingsV1();
        
        nQupdateNotificationsV1_Req_IB_v2.Nbsapdpi nbsapdpi =  new nQupdateNotificationsV1_Req_IB_v2.Nbsapdpi();
        
        nbsapdpi.application = 'SALESFORCE';
        nbsapdpi.channel = 'SALESFORCE';
        nbsapdpi.trace = 'Y';
        
        nQupdateNotificationsV1_Req_IB_v2.Nbsmsgi nbsmsgi = new nQupdateNotificationsV1_Req_IB_v2.Nbsmsgi();
        
        nQupdateNotificationsV1_Req_IB_v2.FinalMsgId finalMsgId = new  nQupdateNotificationsV1_Req_IB_v2.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        nQupdateNotificationsV1_Req_IB_v2.Nqp204i nqp204i = new nQupdateNotificationsV1_Req_IB_v2.Nqp204i();

        nqp204i.registeringSite = siteCode;
        nqp204i.jvRefNo = '0';
        nqp204i.jvName = '0';
        nqp204i.cif = CIF;
        nqp204i.accountNumber = accountNumber;
        nqp204i.pnsRecipientId = '1';
        nqp204i.clientNotif = '903';
        nqp204i.teller = tellerCode;
        nqp204i.prodArea = prodArea;
        nqp204i.minAm = minimumAmount;
        nqp204i.transmitWindow = notifyTimes;
    
        List<nQupdateNotificationsV1_Req_IB_v2.TrnSelX> trnSelXList = new List<nQupdateNotificationsV1_Req_IB_v2.TrnSelX>();       
        
        if(payment){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('019'));        	
         }
         if(withDrawal){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('039'));
         	
         }
         if(deposit){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('049'));
         }	
         if(transfer){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('079'));
         	
         }
         if(returned){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('059'));
         	
         }
         if(scheduled){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('069'));
         	
         }   
         if(purchase){                                                                  
         	trnSelXList.add(new nQupdateNotificationsV1_Req_IB_v2.TrnSelX('029'));
         	
         }  
        
        
        List<nQupdateNotificationsV1_Req_IB_v2.BalFreqs>  balFreqsList = new List<nQupdateNotificationsV1_Req_IB_v2.BalFreqs>();
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsSunday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsSunday.balDay = balanceUpdates == 'sunday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsSunday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsMonday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsMonday.balDay = balanceUpdates == 'monday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsMonday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsTuesday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsTuesday.balDay = balanceUpdates == 'tuesday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsTuesday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsWednesday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsWednesday.balDay = balanceUpdates == 'wednesday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsWednesday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsThursday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsThursday.balDay = balanceUpdates == 'thursday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsThursday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsFriday= new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsFriday.balDay = balanceUpdates == 'friday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsFriday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsSaturday = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsSaturday.balDay = balanceUpdates == 'saturday' ? 'Y' : 'N';
        balFreqsList.add(balFreqsSaturday);
        
        nQupdateNotificationsV1_Req_IB_v2.BalFreqs balFreqsDaily = new nQupdateNotificationsV1_Req_IB_v2.BalFreqs();
        balFreqsDaily.balDay = balanceUpdates == 'daily' ? 'Y' : 'N';
        balFreqsList.add(balFreqsDaily);
        
        nqp204i.balFreqs = balFreqsList;
        nqp204i.trnSelX = trnSelXList;
       
        nQupdJVProdNotificationAcctSettingsV1.nbsapdpi = nbsapdpi;
        nQupdJVProdNotificationAcctSettingsV1.nbsmsgi = nbsmsgi;
        nQupdJVProdNotificationAcctSettingsV1.nqp204i = nqp204i;
        requestBean.NQupdJVProdNotificationAcctSettingsV1 = nQupdJVProdNotificationAcctSettingsV1;
        
        return requestBean;
        
    }
    
    /* Creates a bean from the response
     * @param: HTTP Response
     * @return: nQupdateNotificationsV1_Resp_IB_v2 bean object
     */
    public static nQupdateNotificationsV1_Resp_IB_v2 mapResponseFields(HttpResponse responseP) {
        nQupdateNotificationsV1_Resp_IB_v2 responseBeanContent;
        
        try {
            nQupdateNotificationsV1_Resp_IB_v2 responseBean = new nQupdateNotificationsV1_Resp_IB_v2();
            responseBeanContent = (nQupdateNotificationsV1_Resp_IB_v2)responseBean.deserialize(responseP.getBody(), nQupdateNotificationsV1_Resp_IB_v2.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('nQcreateNewOrAddRecipientV2 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: nQupdateNotificationsV1_Resp_IB_v2 bean object
     * */

    public static nQupdateNotificationsV1_Resp_IB_v2 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        nQupdateNotificationsV1_Resp_IB_v2 responseBean = new nQupdateNotificationsV1_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('nQupdateNotificationsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
      
}