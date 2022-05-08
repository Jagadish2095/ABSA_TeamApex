/*
* Test Integration Handler for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

@isTest

public class CASAScreenRelatedParty_Resp_IB_v3_test {
  @isTest static void createDummyRequesttest() {
      
       CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyResp = new CASAScreenRelatedParty_Resp_IB_v3();
        screenRelatedPartyResp.msgNo = '0';
        screenRelatedPartyResp.msg = 'CSA 0 added succesfully';
        screenRelatedPartyResp.refNo = '0';
        screenRelatedPartyResp.respStatus = '';
      
    CASAScreenRelatedParty_Resp_IB_v3 resp =  CASAScreenRelatedParty_Resp_IB_v3.createDummyRequest();
 System.assert(resp.msg== 'CSA 0 added succesfully' , 'assert failed');
  }
   
    
  
}