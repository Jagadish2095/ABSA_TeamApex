/**
 * @description Integration request class for LDPgetAccountInfoV2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class LDPgetAccountInfoV2_Req_IB_v1 extends Base_IB{
	public cls_LDPgetAccountInfoV2 LDPgetAccountInfoV2;
/**
 * @description cls_LDPgetAccountInfoV2 Description
 *
 */
    public class cls_LDPgetAccountInfoV2{
		public cls_nbsapdpi nbsapdpi;
		public cls_ld300a2i ld300a2i;
	}

    /**
     * @description cls_nbsapdpi Description
     *
     */
	public class cls_nbsapdpi{
		public String channel;
		public String application;
		public String trace;
	}

    /**
     * @description cls_ld300a2i Description
     *
     */
	public class cls_ld300a2i{
		public String clientCode;
		public String accountNumber;

	}
}