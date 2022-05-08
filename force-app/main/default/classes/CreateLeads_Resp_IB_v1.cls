/**
* @description Integration Utility for Create Leads function

*/
global class CreateLeads_Resp_IB_v1 extends Base_IB {
	Public String status;
    Public Integer statusCode;
    Public String description;
    Public String dataTable;
    public Data[] data;
    /**
* @description Integration Utility for Create Leads function

*/
    public class Data{
        Public String leadNumber;
        public String Status;
    }
    /**
* @description Integration Utility for Create Leads function

* @return response
*/
    public static list<CreateLeads_Resp_IB_v1> dummyResponse(){
        CreateLeads_Resp_IB_v1 responseBean = new CreateLeads_Resp_IB_v1();
        responseBean.status = 'Success';
        responseBean.statusCode = 200;
        responseBean.description = 'successfully processed';
        responseBean.dataTable = '[{\\\"Status\\\":\\\"Created Successfully\\\",\\\"leadNumber\\\":\\\"Absa2 - 0737179\\\"}]\"}';
        List<CreateLeads_Resp_IB_v1> responseBeanList = new List<CreateLeads_Resp_IB_v1>();
        responseBeanList.add(responseBean);
        return responseBeanList;        
        
        
}
}