/**
* Apex Integration Response Bean class for CASAPrimaryClientScreening v7
* Test Class Name: CASAPrimaryClientScreening_IH_v3_Test
* @author  Anka Ganta : Absa
* @since   2019-11-24
*
**/
public class CASAPrimaryClientScreening_Req_IB_v3 extends Base_IB 
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
	public String sbu;
	public String originatingSys;
	public String branch;
	public String teller;
    
    public static CASAPrimaryClientScreening_Req_IB_v3 createDummyRequest() {           
        CASAPrimaryClientScreening_Req_IB_v3 screenPrimaryClient = new CASAPrimaryClientScreening_Req_IB_v3();
		screenPrimaryClient.channel = 'AFS';
		screenPrimaryClient.application = 'SALESFORCE';
		screenPrimaryClient.trace = 'N';
		screenPrimaryClient.firstName = 'TRUMP';
		screenPrimaryClient.surnameComp = 'JM';
		screenPrimaryClient.idType = '1';
		screenPrimaryClient.idRegNo = '6304105097182';
		screenPrimaryClient.clientTypeGrp = 'I';
		screenPrimaryClient.dob = '19630410';
		screenPrimaryClient.nationality = 'SOU01';
		screenPrimaryClient.town = 'HATFIELD';
		screenPrimaryClient.cntryOfRes = 'SO003';
		screenPrimaryClient.cntryOfBirth = 'SO003';
		screenPrimaryClient.registerCity = 'SO003';
		screenPrimaryClient.countryPassport = 'SO003';
		screenPrimaryClient.headofficeTown = 'SO003';
		screenPrimaryClient.headofficeCntry = 'SO003';
		screenPrimaryClient.headofficeOtherCntry1 = 'SO003';
		screenPrimaryClient.headofficeOtherCntry2 = 'SO003';
		screenPrimaryClient.headofficeOtherCntry3 = 'SO003';
		screenPrimaryClient.headofficeOtherCntry4 = 'SO003';
		screenPrimaryClient.headofficeOtherCntry5 = 'SO003';
		screenPrimaryClient.sbu = '61';
		screenPrimaryClient.originatingSys = 'SALESFORCE';
		screenPrimaryClient.branch = '3456';
		screenPrimaryClient.teller = 'SADMIN';
        
        
        
        System.debug('CASAPrimaryClientScreening Req v3: ' + screenPrimaryClient);
        return screenPrimaryClient;
    }
    
   
}