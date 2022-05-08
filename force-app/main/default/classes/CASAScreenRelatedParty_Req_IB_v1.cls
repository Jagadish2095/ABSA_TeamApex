public class CASAScreenRelatedParty_Req_IB_v1 extends Base_IB 
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
    
    public CASAScreenRelatedParty_Req_IB_v1 createDummyRequest() {           
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
    }
    
}