/**
* @description Apex wrapper class for savings accout General
* @author  Haritha P
* @since   24/02/2020
*/
public class savingsgeneralaccwrapper {
    /** 
    * @description  
    * @return String
    */
    public String Id{get;set;}
     /** 
    * @description 
    * @return String
    */
    public String purposeOfAccount{get;set;}
     /** 
    * @description 
    * @return String
    */
    public String purposeOfAccountText{get;set;}
     /** 
    * @description 
    * @return String
    */
    public String accountActivityCalculator{get;set;}
    /** 
    * @description 
    * @return String
    */
    public String MeetingOf{get;set;}
    /** 
    * @description 
    * @return String
    */
    public String MeetingHeldAt{get;set;}
    /** 
    * @description 
    * @return Date
    */
    public Date MeetingDate{get;set;}
    /** 
    * @description 
    * @return Date
    */
    public Date Extractsigneddate{get;set;}
    /** 
    * @description 
    * @return integer
    */
    public integer Totalnumofaccountstobeopened{get;set;}
    /** 
    * @description 
    * @return integer
    */
    public integer Requirednumberofsignatoriestoopencloseaccounts{get;set;}
    /** 
    * @description 
    * @return integer
    */
    public integer Requirednumofsignatoriestogiveinstructions{get;set;}
    /** 
    * @description 
    * @return String
    */
    public String SourceofFundssavings{get;set;}
    /** 
    * @description 
    * @return String
    */
    public String CommentsonexplanationgivenforSourceoffunds{get;set;}
    /** 
    * @description 
    * @return String
    */
    public String CustomerRegion{get;set;} // added by Manish for W-010115
    /** 
    * @description 
    * @return String
    */
    public String IsThereAnyTPFTP{get;set;} // added by Manish for W-010115
}