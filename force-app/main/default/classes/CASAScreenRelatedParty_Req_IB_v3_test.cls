/*
* Test Integration Handler for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

@isTest


public class CASAScreenRelatedParty_Req_IB_v3_test {
/* @isTest static void createDummyRequesttest() {
      
      
        CASAScreenRelatedParty_Req_IB_v1 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v1();
        screenRelatedParty.channel = 'SALESFORCE';
        screenRelatedParty.application = 'WILLS';
        screenRelatedParty.trace = 'N';
        screenRelatedParty.firstName = 'Test25102017105243';
        screenRelatedParty.surnameComp = 'Last25102017105243';
        screenRelatedParty.idType = '1';
		screenRelatedParty.idRegNo = '9710256796082';
		screenRelatedParty.clientTypeGrp = 'I';
		screenRelatedParty.dob = '19971025';
		screenRelatedParty.nationality = 'SOU01';
		screenRelatedParty.town = 'ZWIDE';
		screenRelatedParty.cntryOfRes = 'SO003';
		screenRelatedParty.cntryOfBirth = 'SO003';
		screenRelatedParty.primaryClientRef = '120001185';
		screenRelatedParty.relationship = '125346';
		screenRelatedParty.branch = '3456';
		screenRelatedParty.teller = 'ABLMAZB';
		screenRelatedParty.originatingSys = 'WILLS';
        
      
    CASAScreenRelatedParty_Req_IB_v1 resp =  CASAScreenRelatedParty_Req_IB_v1.createDummyRequest();
 System.assert(resp.firstName== 'Test25102017105243' , 'assert failed');
  }*/
    
     @isTest static void createDummyRequesttestv3() {
      
      
        CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
        screenRelatedParty.channel = 'SALESFORCE';
        screenRelatedParty.application = 'WILLS';
        screenRelatedParty.trace = 'N';
        screenRelatedParty.firstName = 'Test25102017105243';
        screenRelatedParty.surnameComp = 'Last25102017105243';
        screenRelatedParty.idType = '1';
		screenRelatedParty.idRegNo = '9710256796082';
		screenRelatedParty.clientTypeGrp = 'I';
		screenRelatedParty.dob = '19971025';
		screenRelatedParty.nationality = 'SOU01';
		screenRelatedParty.town = 'ZWIDE';
		screenRelatedParty.cntryOfRes = 'SO003';
		screenRelatedParty.cntryOfBirth = 'SO003';
		screenRelatedParty.primaryClientRef = '120001185';
		screenRelatedParty.relationship = '125346';
		screenRelatedParty.branch = '3456';
		screenRelatedParty.teller = 'ABLMAZB';
		screenRelatedParty.originatingSys = 'WILLS';
        
      
    CASAScreenRelatedParty_Req_IB_v3 resp =  CASAScreenRelatedParty_Req_IB_v3.createDummyRequestV3();
 System.assert(resp.firstName== 'Test25102017105243' , 'assert failed');
  }
}