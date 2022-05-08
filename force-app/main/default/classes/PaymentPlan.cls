/**
 * This is the class definition for a payment plan record as part of the opportunity wizard revision/redraft process
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-04-10
 */

public class PaymentPlan {
    public String accNumber {get; set;}
    public String accType {get; set;}
    public String bankName {get; set;}
    public String branchCode {get; set;}
    public String branchName {get; set;}
    public String name {get; set;}
    public String frequency {get; set;}
    public Decimal amount {get; set;}
    public String method {get; set;}
    public String status {get; set;}
    public String type {get; set;}


}