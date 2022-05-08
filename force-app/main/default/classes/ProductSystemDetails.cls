/**
 * @description       : ProductSystemDetails
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
 **/
public class ProductSystemDetails {
	/**
	 * @description ProductIdId
	 **/
	public string ProductId { get; set; }
	/**
	 * @description UnitPrice
	 **/
	public decimal UnitPrice { get; set; }
	/**
	 * @description Description
	 **/
	public string Description { get; set; }
	/**
	 * @description AdditionalObjectToUpdate
	 **/
	public sObject AdditionalObjectToUpdate {get; set;}
}