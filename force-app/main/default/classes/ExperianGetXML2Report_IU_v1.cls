/*
 * Integration Utility class for ExperianGetXML2Report Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class ExperianGetXML2Report_IU_v1 {

    /* Creates a request bean
     * @return: ExperianGetXML2Report_Req_IB_v1 bean object
     */
    public static ExperianGetXML2Report_Req_IB_v1 mapRequestFields(String Surname, String First_Name_1, String National_ID, String RSAid, String Birthday) {
        ExperianGetXML2Report_Req_IB_v1 requestBean = new ExperianGetXML2Report_Req_IB_v1();
        requestBean.GetXML2Report = new ExperianGetXML2Report_Req_IB_v1.GetXML2Report();
        requestBean.GetXML2Report.inputData = new ExperianGetXML2Report_Req_IB_v1.InputData();
        requestBean.GetXML2Report.inputData.Session = new ExperianGetXML2Report_Req_IB_v1.Session();
        requestBean.GetXML2Report.inputData.Consumer = new ExperianGetXML2Report_Req_IB_v1.Consumer();
        requestBean.GetXML2Report.inputData.Consumer.Application = new ExperianGetXML2Report_Req_IB_v1.Application();

        requestBean.GetXML2Report.inputData.Session.RequestType = 'XML2';

		if (Sys_Utilities_General.getEnvironment() == StringConstants.PRODUCTION_STRING) {
			requestBean.GetXML2Report.inputData.Session.Environment_Name = 'PRODUCTION';
		} else {
			requestBean.GetXML2Report.inputData.Session.Environment_Name = 'TEST';
		}

        requestBean.GetXML2Report.inputData.Session.GroupName = System.Label.Experian_GroupName;
        requestBean.GetXML2Report.inputData.Session.User_Name = System.Label.Experian_User_Name;
        requestBean.GetXML2Report.inputData.Session.User_Password = System.Label.Experian_User_Password;
        requestBean.GetXML2Report.inputData.Session.Subscriber_Name = System.Label.Experian_Subscriber_Name;
        requestBean.GetXML2Report.inputData.Session.Subscriber_ID = System.Label.Experian_Subscriber_ID;
        requestBean.GetXML2Report.inputData.Session.Subscriber_Password = System.Label.Experian_Subscriber_Password;
        requestBean.GetXML2Report.inputData.Session.Subscriber_Group_ID = System.Label.Experian_Subscriber_Group_ID;

        requestBean.GetXML2Report.inputData.Consumer.Application.Surname = Surname;
        requestBean.GetXML2Report.inputData.Consumer.Application.First_Name_1 = First_Name_1;
        requestBean.GetXML2Report.inputData.Consumer.Application.National_ID = National_ID;
        requestBean.GetXML2Report.inputData.Consumer.Application.RSAid = RSAid;
        requestBean.GetXML2Report.inputData.Consumer.Application.Birthday = Birthday;

        return requestBean;
    }
}