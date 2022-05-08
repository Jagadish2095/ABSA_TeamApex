/*
 * Request Integration Bean for ExperianGetXML2Report Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class ExperianGetXML2Report_Req_IB_v1 extends Base_IB {

	public class GetXML2Report {
		public InputData inputData;
	}

	public GetXML2Report GetXML2Report;

	public class Consumer {
		public Application Application;
	}

	public class InputData {
		public Session Session;
		public Consumer Consumer;
	}

	public class Application {
		public String Surname;
		public String First_Name_1;
		public String National_ID;
		public String RSAid;
		public String Birthday;
	}

	public class Session {
		public String GroupName;
		public String User_Name;
		public String User_Password;
		public String Subscriber_Name;
		public String Subscriber_ID;
		public String Subscriber_Password;
		public String Subscriber_Group_ID;
		public String RequestType;
		public String Environment_Name;
	}

    public static ExperianGetXML2Report_Req_IB_v1 createDummyRequest() {
        ExperianGetXML2Report_Req_IB_v1 requestBean = new ExperianGetXML2Report_Req_IB_v1();
        requestBean.GetXML2Report = new ExperianGetXML2Report_Req_IB_v1.GetXML2Report();
        requestBean.GetXML2Report.inputData = new ExperianGetXML2Report_Req_IB_v1.InputData();
        requestBean.GetXML2Report.inputData.Session = new ExperianGetXML2Report_Req_IB_v1.Session();
        requestBean.GetXML2Report.inputData.Consumer = new ExperianGetXML2Report_Req_IB_v1.Consumer();
        requestBean.GetXML2Report.inputData.Consumer.Application = new ExperianGetXML2Report_Req_IB_v1.Application();
		
        requestBean.GetXML2Report.inputData.Session.GroupName = '018455';
        requestBean.GetXML2Report.inputData.Session.User_Name = 'MERCHTST';
        requestBean.GetXML2Report.inputData.Session.User_Password = 'MERCHTST';
        requestBean.GetXML2Report.inputData.Session.Subscriber_Name = 'MERCHTST';
        requestBean.GetXML2Report.inputData.Session.Subscriber_ID = '018455';
        requestBean.GetXML2Report.inputData.Session.Subscriber_Password = '018455';
        requestBean.GetXML2Report.inputData.Session.Subscriber_Group_ID = '018455';
        requestBean.GetXML2Report.inputData.Session.RequestType = 'XML2';
        requestBean.GetXML2Report.inputData.Session.Environment_Name = 'TEST';

        requestBean.GetXML2Report.inputData.Consumer.Application.Surname = 'OOSTHUIZEN';
        requestBean.GetXML2Report.inputData.Consumer.Application.First_Name_1 = 'CHANEL';
        requestBean.GetXML2Report.inputData.Consumer.Application.National_ID = '8911270127087';
        requestBean.GetXML2Report.inputData.Consumer.Application.RSAid = 'YES';
        requestBean.GetXML2Report.inputData.Consumer.Application.Birthday = '19891127';

        return requestBean;
    }
}