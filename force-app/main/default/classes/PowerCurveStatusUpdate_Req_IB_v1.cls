/*
 * Request Integration Bean for PowerCurveStatusUpdate Service
 * @author Saurabh Pandey
 * @created 2020-11-19
 */

public class PowerCurveStatusUpdate_Req_IB_v1 extends Base_IB {

	public class APPPRDEXST {
		public String APPLICATIONSTATUS;
		public String FINALISEDDATE;
		public String FINALISEDTIME;
	}

	public Request Request;

	public class RequestedProducts {
		public APPPRDNEWF APPPRDNEWF;
	}

	public class ApplicationDV {
		public String APPAPPAPPLICATIONNUMBER;
		public String DERPCOUNIQUENUMBER;
		public String APPAPPAPPLICATIONTYPE;
		public String APPAPPSTAGEID;
		public List<ExistingProducts> ExistingProducts;
		public String APPAPPAPPLICATIONSTATUS;
		public List<RequestedProducts> RequestedProducts;
		public String APPAPPFINALISEDDATE;
		public String APPAPPFINALISEDTIME;
		public String APPAPPSTATUSCHANGEDATE;
		public String APPAPPSTATUSCHANGETIME;
		public String APPAPPCREDITREFERDATE;
		public String APPAPPCREDITREFERTIME;
		public String APPAPPPRICINGREFERDATE;
		public String APPAPPPRICINGREFERTIME;
	}

	public class ExistingProducts {
		public INTPRDEXST INTPRDEXST;
		public APPPRDEXST APPPRDEXST;
	}

	public class Request {
		public ApplicationDV ApplicationDV;
	}

	public class INTPRDEXST {
		public String ESPINSTRUCTION;
		public String ACCOUNTNUMBER;
	}

	public class APPPRDNEWF {
		public String APPLICATIONSTATUS;
		public String ACCOUNTNUMBER;
		public String ESPINSTRUCTION;
		public String FINALISEDDATE;
		public String FINALISEDTIME;
	}
    
    public static PowerCurveStatusUpdate_Req_IB_v1 createDummyRequest (){
    PowerCurveStatusUpdate_Req_IB_v1 requestBean = new PowerCurveStatusUpdate_Req_IB_v1();
    requestBean.Request = new PowerCurveStatusUpdate_Req_IB_v1.Request();
    requestBean.Request.ApplicationDV = new PowerCurveStatusUpdate_Req_IB_v1.ApplicationDV();
    requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = '46000132887'; 					//stock number
    requestBean.Request.ApplicationDV.DERPCOUNIQUENUMBER = '000000073638';  					//PCO unique number number(field need to ask saurabh )
    requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE = 'O'; 								//o -Ordinary credit default 
    requestBean.Request.ApplicationDV.APPAPPSTAGEID ='SU';          							//SU - status update
    requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSTATUS = 'I';  //need to ask for I frontend value  // Accepted - A ,declined - D, REfer o sanctioning -P, Amend- P , withdrwal - W, I -pipeline for fulfillment
    requestBean.Request.ApplicationDV.APPAPPFINALISEDDATE =  '';     
	requestBean.Request.ApplicationDV.APPAPPFINALISEDTIME = '';
	requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGEDATE = '2020-11-18'; 				//todadys date  //Credit_App_Status_Change_DateTime__c
	requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGETIME = '143001';    				 // todays time                                   //
	requestBean.Request.ApplicationDV.APPAPPCREDITREFERDATE = '2020-11-18'; 				 //if refer to sanctioner or else leave blank     //Sanctioning_Refer_DateTime__c
	requestBean.Request.ApplicationDV.APPAPPCREDITREFERTIME ='143001';       				//if refer to sanctioner or else leave blank     //Sanctioning_Refer_DateTime__c
    requestBean.Request.ApplicationDV.APPAPPPRICINGREFERDATE =  '2020-11-18';  				// same if pricing send date or leave blank    //Pricing_Refer_DateTime__c
    requestBean.Request.ApplicationDV.APPAPPPRICINGREFERTIME = '143001';                                                     				 //Pricing_Refer_DateTime__c
    //we have couple more params bt not sure what data to send there
    requestBean.Request.ApplicationDV.ExistingProducts = new List <PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts>();
    requestBean.Request.ApplicationDV.RequestedProducts = new List <PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts>();
    
    //New Instance of Existing Products
    PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts existingProducts = new PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts();
    existingProducts.APPPRDEXST = new PowerCurveStatusUpdate_Req_IB_v1.APPPRDEXST();
    existingProducts.INTPRDEXST = new PowerCurveStatusUpdate_Req_IB_v1.INTPRDEXST();
    existingProducts.APPPRDEXST.APPLICATIONSTATUS = 'I';  //
    existingProducts.APPPRDEXST.FINALISEDDATE = '';
    existingProducts.APPPRDEXST.FINALISEDTIME = '';
    existingProducts.INTPRDEXST.ACCOUNTNUMBER = '4047435391';
    existingProducts.INTPRDEXST.ESPINSTRUCTION = '77273';
    requestBean.Request.ApplicationDV.ExistingProducts.add(existingProducts);  
    //New Instance of Requested Products 
    PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts requestedProducts = new PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts();   
    requestedProducts.APPPRDNEWF = new PowerCurveStatusUpdate_Req_IB_v1.APPPRDNEWF();
    requestedProducts.APPPRDNEWF.ACCOUNTNUMBER = '';        //
    requestedProducts.APPPRDNEWF.APPLICATIONSTATUS ='I'; 		//W-withdrawal,A - accepted,D - decline ,P - pending
    requestedProducts.APPPRDNEWF.ESPINSTRUCTION = '77273';     //opportunity number // optional on decison summary 
    requestedProducts.APPPRDNEWF.FINALISEDDATE = '';
    requestedProducts.APPPRDNEWF.FINALISEDTIME = '';
    requestBean.Request.ApplicationDV.RequestedProducts.add(requestedProducts);
    return requestBean;
    }
}