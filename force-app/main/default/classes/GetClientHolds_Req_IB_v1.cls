/*US:W-002572
*Description:Web Service Request class to get Client Holds From CIF For Client Hold Indicator
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-07-31
*/
public class GetClientHolds_Req_IB_v1 extends Base_IB{
 	public String channel = '?'; 
	public String application = '?' ; 
	public String trace = '?' ; 
	public String msgLanguage = '?'; 
	public String msgTarget = '?'; 
	public String functionIn = 'R'; 
	public String acnoa = '0' ; 
	public String clcda ;  //this is client code-->cif key from account
	public String idrqb = '' ; 
	public String iestb = ''; 
	public String destb = ''; 
	public String dspsb = '' ; 
	public String curab = ''; 
	public String gaddb = ''; 
	public String cphyb = ''; 
	public String cempb = ''; 
	public String idrq2b = '' ; 
	public String iest2b = ''; 
	public String cura2b = ''; 
	public String apdbb = ''; 
	public String apdtb = '0'; 
	public String codbb = '' ; 
	public String codtb = '0' ; 
	public String mcomb = ''; 
	public String ibrab = ''; 
	public String inbrb = ''; 
	public String plbrb = '0'; 
	public String dtbrb = '0'; 
	public String teller = '12'; 
	public String branch = '12'; 
    public String override_Z = '0'; //in json override
	public String forensicHold = '' ; 
	public String finCrimeHold = '' ; 
	public String clntAgrmntIssued = ''; 
}