/*
* Request Integration Bean for CASAScreenRelatedParty Service 
* @author Pitso Sekhu
* @created 2019-03-13
*/

public class CASAScreenRelatedParty_Req_IB_v2 extends Base_IB 
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
	public String cntryOfRes;
	public String cntryOfBirth;
	public String primaryClientRef;
	public String relationship;
	public String branch;
	public String teller;
	public String originatingSys;
    public String countryPassport;
    
    public CASAScreenRelatedParty_Req_IB_v2 createDummyRequest() {           
        CASAScreenRelatedParty_Req_IB_v2 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v2();
        screenRelatedParty.channel = 'SALESFORCE';
        screenRelatedParty.application = 'WILLS';
        screenRelatedParty.trace = 'Y';
        screenRelatedParty.firstName = 'Pitso';
        screenRelatedParty.surnameComp = 'Sekhu';
        screenRelatedParty.idType = '3';
		screenRelatedParty.idRegNo = '8410265224082';
		screenRelatedParty.clientTypeGrp = 'I';
		screenRelatedParty.dob = '19841026';
		screenRelatedParty.nationality = 'ZA';
		screenRelatedParty.town = '';
		screenRelatedParty.cntryOfRes = 'ZA';
		screenRelatedParty.cntryOfBirth = '';
		screenRelatedParty.primaryClientRef = '2039944';
		screenRelatedParty.relationship = '210305';
		screenRelatedParty.branch = '2626';
		screenRelatedParty.teller = 'EXRN181';
		screenRelatedParty.originatingSys = 'WILLS';
        
        System.debug('CASAScreenRelatedParty Req: ' + screenRelatedParty);
        return screenRelatedParty;
    }
    
}