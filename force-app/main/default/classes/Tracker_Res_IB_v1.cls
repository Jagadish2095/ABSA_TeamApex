/*
* Request Integration Bean for Tracker Service for Absa Instant Life
* @author Satya Boyenepalli
* @created 2021-07-28
*/


/**
* @description Trackeresponse
*/
public with sharing class Tracker_Res_IB_v1 extends Base_IB {
/**
* @description ValidationErrors
*/
    public List<ValidationErrors> ValidationErrors;
/**
* @description Leads
*/
	public List<Leads> Leads;
/**
* @description ValidationErrors
*/
   	   public class ValidationErrors {
           public String id;
           public String Message;
	}
/**
* @description Leads
*/
	public class Leads {
		public String FirstName;
		public String LastName;
		public String LeadDate;
		public String CallbackDateTime;
		public String LeadStatus;
	}

 /**
* @description dummyResponse
* @return Tracker_Res_IB_v1
*/
    public static Tracker_Res_IB_v1 dummyResponse() {
    Tracker_Res_IB_v1 responseBean = new Tracker_Res_IB_v1();
     responseBean.Leads = new List<Tracker_Res_IB_v1.Leads>();
     return responseBean;
    }
}