/*
 * Integration Handler for RiskProfileScore Service
 * @author Diksha Wasekar
 * @created 2020-09-08
 */
public class RiskProfileScore_Resp_IB_V1 extends Base_IB {

 
    public class Messages {
    }

 
    public List<Body> body;
	
    public class Body {
    public String decisionId;
    public String decisionName;
    public String result;
    public List<Messages> messages;
    public String evaluationStatus;
    }

    
}