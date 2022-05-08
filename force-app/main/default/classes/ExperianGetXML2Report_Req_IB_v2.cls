/*
 * Request Integration Bean for ExperianGetXML2Report Service version 2
 * @author Danie Booysen
 * @created 2020-09-30
 */

public class ExperianGetXML2Report_Req_IB_v2 extends Base_IB {

	public class GetXML2Report {
		public String GroupName;
		public String User_Name;
		public String User_Password;
		public String Subscriber_Name;
		public String Subscriber_ID;
		public String Subscriber_Password;
		public String Subscriber_Group_ID;
		public String RequestType;
        public String Environment_Name;

		public String Surname;
		public String First_Name_1;
		public String National_ID;
		public String RSAid;
		public String Birthday;
	}

	public GetXML2Report[] GetXML2Report;


    public static ExperianGetXML2Report_Req_IB_v2 createDummyRequest() {
        ExperianGetXML2Report_Req_IB_v2 requestBean = new ExperianGetXML2Report_Req_IB_v2();
        ExperianGetXML2Report_Req_IB_v2.GetXML2Report getXML2ReportObj= new ExperianGetXML2Report_Req_IB_v2.GetXML2Report();
        List<ExperianGetXML2Report_Req_IB_v2.GetXML2Report> GetXML2ReportList = new List<ExperianGetXML2Report_Req_IB_v2.GetXML2Report>();

        getXML2ReportObj.GroupName = '018455';
        getXML2ReportObj.User_Name = 'MERCHTST';
        getXML2ReportObj.User_Password = 'MERCHTST';
        getXML2ReportObj.Subscriber_Name = 'MERCHTST';
        getXML2ReportObj.Subscriber_ID = '018455';
        getXML2ReportObj.Subscriber_Password = '018455';
        getXML2ReportObj.Subscriber_Group_ID = '018455';
        getXML2ReportObj.RequestType = 'XML2';
        getXML2ReportObj.Environment_Name = 'TEST';

        getXML2ReportObj.Surname = 'OOSTHUIZEN';
        getXML2ReportObj.First_Name_1 = 'CHANEL';
        getXML2ReportObj.National_ID = '8911270127087';
        getXML2ReportObj.RSAid = 'YES';
        getXML2ReportObj.Birthday = '19891127';
        GetXML2ReportList.add(getXML2ReportObj);

        requestBean.GetXML2Report = GetXML2ReportList;
        return requestBean;
    }
}