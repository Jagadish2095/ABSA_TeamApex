/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-22-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class CASAScreenRelatedParty_Req_IB_v3 extends Base_IB 
{
	public String channel;
	public String application;
	public String trace;
	public String firstName;
	public String surnameComp;
	public String idType;
	public String idRegNo;
	public String clientTypeGrp;
	public String dob;
	public String nationality;
	public String town;
	 public String territory;
	public String cntryOfRes;
	public String cntryOfBirth;
	public String registerCity;
	public String countryPassport;
	public String headofficeTown;
	public String headofficeCntry;
	public String headofficeOtherCntry1;
	public String headofficeOtherCntry2;
	public String headofficeOtherCntry3;
	public String headofficeOtherCntry4;
    public String headofficeOtherCntry5;
	public String primaryClientRef;
	public String relationship;
	public String branch;
	public String teller;
	public String originatingSys;
   
 /**
	 * @description createDummyRequestV3
	 * @return CASAScreenRelatedParty_Req_IB_v1
	 
    
    public static CASAScreenRelatedParty_Req_IB_v1 createDummyRequest() {           
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
        
        System.debug('CASAScreenRelatedParty Req: ' + screenRelatedParty);
        return screenRelatedParty;
    }*/
	/**
	 * 
	 * @description createDummyRequestV3
	 * @return CASAScreenRelatedParty_Req_IB_v1
	 */

	public static CASAScreenRelatedParty_Req_IB_v3 createDummyRequestV3() {           
        CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
        screenRelatedParty.channel = 'SALESFORCE';
        screenRelatedParty.application = 'BDP';
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
        
        System.debug('CASAScreenRelatedParty Req: ' + screenRelatedParty);
        return screenRelatedParty;
    }
    
}