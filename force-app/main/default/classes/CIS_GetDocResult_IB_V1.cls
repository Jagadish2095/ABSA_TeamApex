/**
 * @description       : Get Document Result class for CIS
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          	  Modification
 * 1.0   05-25-2021   Mohammed Junaid U   Initial Version
**/

public class CIS_GetDocResult_IB_V1 extends Base_IB {

    public GetResult GetResult;
	public MetaData MetaData;
	public Content Content;
	/**
	 * @description
	 */
	public class MetaData{
		public String CreationDate;
		public String LastModifiedDate;
		public String PID;
		public String Creator;
		public String ItemType;
		public list<Fields> Fields;
	}
	/**
	 * @description
	 */
	public class GetResult{
		public String Detail;
		public String Status;
	}
	/**
	 * @description
	 */
	public class Fields{
		public String Size;
		public String Description;
		public String Value;
		public String Unique;
		public String Type;
		public String Nullable;
		public String Name;
	}
	/**
	 * @description
	 */
	public class Content{
		public String FileName;
		public String Data;
		public String MimeType;
	}
	/**
	 * @description constructor
	 */
    public CIS_GetDocResult_IB_V1(){}
}