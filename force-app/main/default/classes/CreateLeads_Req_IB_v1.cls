/**
* @description Integration Req for Create Leads function

*/
global class CreateLeads_Req_IB_v1 extends Base_IB{
    
    public string firstName;
    public string lastName;
    public string mobileNumber;
    public string campaignName;
    public string alternativeNo;
    public string emailAddress;
    public string leadType;
    public string comments;
    public string campaignType;
    public string nextTry;
    public string leadCreationTime;
    public string accountNo;
    public string cifKey;
    public string tradingName;
    /**
* @description Integration Utility for Create Leads function

*/
    
    public CreateLeads_Req_IB_v1(){        
    }
     /**
* @description Integration Utility for Create Leads function

* @return response
*/
    Public static List<CreateLeads_Req_IB_v1> createDummyRequest(){
        CreateLeads_Req_IB_v1 requestBean = new CreateLeads_Req_IB_v1();
        requestBean.firstName = 'Saleaforce Test';
        requestBean.lastName = 'Salesforce';
        requestBean.mobileNumber = '0724476653';
        requestBean.campaignName = 'Needs Analysis';
        requestBean.alternativeNo = '0116369563';
        requestBean.emailAddress = 'emailAddress@absa.africa';
        requestBean.leadType = 'New';
        requestBean.comments = 'Test';
        requestBean.campaignType = 'campaignType';
        requestBean.nextTry = '2021-03-09T17:07:28Z';
        requestBean.leadCreationTime = '2021-03-09T17:07:28Z';
        requestBean.accountNo = '0116369563';
        requestBean.cifKey= 'MATHUMB074';
        requestBean.tradingName = 'tradingName';
        
        List<CreateLeads_Req_IB_v1> requestBeanList = new List<CreateLeads_Req_IB_v1>();
        requestBeanList.add(requestBean);
        return requestBeanList;
    }
     /**
* @description Integration Utility for Create Leads function

* @return response
*/
    
    Public static List<CreateLeads_Req_IB_v1> createDummyEmptyRequest(){
        CreateLeads_Req_IB_v1 requestBean = new CreateLeads_Req_IB_v1();
        requestBean.firstName = '';
        requestBean.lastName = '';
        requestBean.mobileNumber = '';
        requestBean.campaignName = '';
        requestBean.alternativeNo = '0116369563';
        requestBean.emailAddress = 'emailAddress@absa.africa';
        requestBean.leadType = 'New';
        requestBean.comments = 'Test';
        requestBean.campaignType = 'campaignType';
        requestBean.nextTry = '2021-03-09T17:07:28Z';
        requestBean.leadCreationTime = '2021-03-09T17:07:28Z';
        requestBean.accountNo = '0116369563';
        requestBean.cifKey= 'MATHUMB074';
        requestBean.tradingName = 'tradingName';
        
        List<CreateLeads_Req_IB_v1> requestBeanList = new List<CreateLeads_Req_IB_v1>();
        requestBeanList.add(requestBean);
        return requestBeanList;
    }
}