/*
* Integration Handler for RiskProfileScore Service
* @author Diksha Wasekar
* @created 2020-09-08
*/

public class RiskProfileScore_IU_V1 {
    
    public static RiskProfileScore_Req_IB_V1 mapRequestFields(String questionOne, String questionTwo, String questionThree, String questionFour, String questionFive,String questionSix,String questionSeven) {
        RiskProfileScore_Req_IB_V1 requestBean = new RiskProfileScore_Req_IB_V1();
        
        
        
        requestBean.questionOne =questionOne ;
        requestBean.questionTwo = questionTwo;
        requestBean.questionThree =questionThree;
        requestBean.questionFour =questionFour;
        requestBean.questionFive =questionFive ;
        requestBean.questionSix =questionSix;
        requestBean.questionSeven=questionSeven ;
        
        
        return requestBean;
    }
    
    
}