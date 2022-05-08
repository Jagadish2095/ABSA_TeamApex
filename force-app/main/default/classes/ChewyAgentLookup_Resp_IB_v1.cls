/**
* @description Integation Response to get CTI AgentId data from Chewy.
* The Response will consist of User AgentId information.
* @author : Saurabh Pandey
**/

public class ChewyAgentLookup_Resp_IB_v1 extends Base_IB {
    //Standard Fields
	public String status;
    public Integer statusCode;
    public String message;
    // Chewy Response Fields
    public String abNumber;
	public String name;
	public String agentId;
	public String pin;
	public String initState;

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    **/
    public ChewyAgentLookup_Resp_IB_v1(){

    }

}