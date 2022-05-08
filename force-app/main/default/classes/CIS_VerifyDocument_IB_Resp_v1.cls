/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-09-30
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/



public class CIS_VerifyDocument_IB_Resp_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;
    
	public UpdateResult UpdateResult;

/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-09-30
 * @last modified by  : muvhuso.nekhubvi@absa.africa
  **/

	public class UpdateResult {
		public String Status;
		public String Detail;
	}
}