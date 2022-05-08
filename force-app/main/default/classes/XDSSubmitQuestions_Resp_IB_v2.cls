/** 
 * @description Response Integration Bean for SubmitXDSQuestions Service
 * @author Sudhakar Reddy
 * @created 23 SEP 2021 
 */
public class XDSSubmitQuestions_Resp_IB_v2 extends Base_IB {

    public Boolean errors;
    public List<ErrorList> errorList;
    public String authenticationDescription;
    public Double authenticationPercentage;
    public Object blockingReason;
    public Integer blockingId;
    public Object noOfAttemptsRemaining;
    public Boolean authenticated;

    /**
    * @description ErrorList
    */
    public class ErrorList {
        public String field;
		    public String description;
    }

  }