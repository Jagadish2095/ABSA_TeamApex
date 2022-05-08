/**
 * @description       : CASAGeneratedocumentsV7 Response Bean
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CASAGeneratedocumentsV7_Resp_IB_v1 extends Base_IB {

	/**
	 * @description       : Envelope Prop
	 **/
	public Envelope Envelope { get; set; }

	/**
	 * @description       : Envelope
	 **/
	public class Envelope {
		public Body Body;
	}

	/**
	 * @description       : Body
	 **/
	public class Body {
		public GetDocsResponse GetDocsResponse;
	}

	/**
	 * @description       : GetDocsResponse
	 **/
	public class GetDocsResponse {
		public String DocNo;
		public String VersionNo;
		public String msgNo;
		public String msg;
		public List<Documentation> documentation;
	}

	/**
	 * @description       : Documentation
	 **/
	public class Documentation {
		public String docCode;
		public String docDesc;
	}
}