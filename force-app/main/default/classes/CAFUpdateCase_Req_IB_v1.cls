/**
 * @description Integration Request  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 
 
 */
public with sharing class CAFUpdateCase_Req_IB_v1 extends Base_IB{
    public SaveCase SaveCase;
 /**
 * @description Integration Request  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26

 * @return 
 
 */
    public class TheCase {
		public String Id;
		public String ParentId;
		public String ReferenceNumber;
		public String DefinitionId;
		public String DefinitionVersion;
		public String Password;
		public String Data;
		public String Status;
		public String Created;
		public String Updated;
		public String DisplayName;
		public String FreeTextTag;
	}
 /**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26

 
 */
    public class SaveCase {
		public TheCase theCase;
		public String savedBy;
	}
 /**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 * @return 
 
 */
    // the dummy request
    public static CAFUpdateCase_Req_IB_v1 createDummy() {
        //Function to format the Date to match the bcmssavecase Service
        Datetime dt = datetime.now();
        String day = String.valueOf(dt.format('dd'));
        String month = String.valueOf(dt.format('MM'));
        String year = String.valueOf(dt.Year());
        String hour = String.valueOf(dt.format('hh'));
        String min = String.valueOf(dt.format('mm'));
        String sec = String.valueOf(dt.format('ss'));
        String millisec = String.valueOf(dt.millisecond());
        String dateForm = year + '-' + month + '-' + day + 'T' + hour + ':' + min + ':' + sec + '.' + millisec;

        string encode = 'PENsYWltc0RPYz48SW5kaXZpZHVhbD48SWROdW1iZXI+NjQwNTAxNTA2MzA4OTwvSWROdW1iZXI+PEZpcnN0TmFtZXM+R0lGVCBDSElLV0FNQTwvRmlyc3ROYW1lcz48U3VybmFtZT5BQlNBIFRFU1Q8L1N1cm5hbWU+PENpZktleT5EVUJFR0MgMDAyPC9DaWZLZXk+PC9JbmRpdmlkdWFsPjwvQ2xhaW1zRE9jPg==';

        CAFUpdateCase_Req_IB_v1 requestBean = new CAFUpdateCase_Req_IB_v1();
        requestBean.SaveCase = new CAFUpdateCase_Req_IB_v1.SaveCase();
        requestBean.SaveCase.TheCase = new CAFUpdateCase_Req_IB_v1.TheCase();
        requestBean.SaveCase.TheCase.ReferenceNumber = 'Salesforce';
        requestBean.SaveCase.TheCase.DefinitionId = 'BB5C18CF-D806-440F-8110-443445D717B4';
        requestBean.SaveCase.TheCase.DefinitionVersion = '1';
        requestBean.SaveCase.TheCase.Data = String.valueOf(encode);
        requestBean.SaveCase.TheCase.Status = 'Open';
        requestBean.SaveCase.TheCase.Created = dateForm;
        requestBean.SaveCase.TheCase.Updated = dateForm;
        requestBean.SaveCase.TheCase.DisplayName = '';
        requestBean.SaveCase.TheCase.FreeTextTag = '';

        return requestBean;
    }
}