/**
 * @description       : Interface for Product Systems
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-09
 * @last modified by  : André Pietersen (IQ Business)
 **/
public interface IProductSystemService {
	/**
	 * @description call Product System
	 * NOTE: make implemented methods @future(callout=true)
	 * @author André Pietersen (IQ Business) | 2021-08-02
     * @param productId
	 * @return ProductSystemDetails
	 */
	ProductSystemDetails callProductSystem(string productId);
}