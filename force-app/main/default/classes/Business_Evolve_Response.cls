global class Business_Evolve_Response extends Base_IB{

	global class Products {
		global String ProductCode;
		global String AccountNumber;
        global String Message;
	}

	global String ExecutionLayerRequestID;
	global String SourceID;
	global String Timestamp;
	global String ResultCode;
	global String ResultMessage;
	global String ResultDescription;
	global List<Error> Error;
	global List<Entities> Entities;
	global List<Products> Products;

	global class Error {
		global String ErrorSource;
		global String ErrorMessage;
	}

	global class Entities {
		global String EntityID;
		global String CIFKey;
	}
   
public static Business_Evolve_Response createDummyRequest(){
        
        Business_Evolve_Response bean = new Business_Evolve_Response();
        bean.ExecutionLayerRequestID = 'testExecutionLayerId';
        bean.SourceID= 'testSourceId';
	    bean.Timestamp= '2021/01/18';
	    bean.ResultCode= '1';
	    bean.ResultMessage= 'Suceess';
	    bean.ResultDescription= 'Succeed';
        bean.Error = new List<Business_Evolve_Response.Error>();
        bean.Entities = new List<Business_Evolve_Response.Entities>();
        bean.Products = new List<Business_Evolve_Response.Products>();
        return bean;
    }        
    
}