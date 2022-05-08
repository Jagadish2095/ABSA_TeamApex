/*
 * Integration Handler for RiskProfileScore Service
 * @author Diksha Wasekar
 * @created 2020-09-08
 */
public class RiskProfileScore_Req_IB_V1 extends Base_IB{


	public String questionOne;
	public String questionTwo;
	public String questionThree;
	public String questionFour;
	public String questionFive;
	public String questionSix;
	public String questionSeven;

	
	
    public static RiskProfileScore_Req_IB_V1 createDummyRequest() {
        RiskProfileScore_Req_IB_V1 requestBean = new RiskProfileScore_Req_IB_V1();

        requestBean.questionOne = 'A';
        requestBean.questionTwo = 'A';
        requestBean.questionThree = 'A';
        requestBean.questionFour = 'F';
        requestBean.questionFive = 'A';
        requestBean.questionSix = 'A';
        requestBean.questionSeven = 'A';

        return requestBean;
    }
    
    
    
}