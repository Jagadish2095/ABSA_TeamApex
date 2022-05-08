/**
 * @description       : Get Document Request class for CIS
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          	  Modification
 * 1.0   05-25-2021   Mohammed Junaid U   Initial Version
**/

public class CIS_GetDocRequest_IB_V1 extends Base_IB{
    //Request payload has been changed based on the feedback from BA
    public String Token;
	public String PID;
    /**
	 * @description constructor
	 */
    public CIS_GetDocRequest_IB_V1(){}
    /*public GetRequest GetRequest { get; set; }

	public class GetRequest {

		public String Token { get; set;}
	    public String PID { get; set; }
	} */

}