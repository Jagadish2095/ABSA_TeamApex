/**
 * @description       : Product System Service Handler
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
 **/
public class ProductSystemServiceHandler {
	/**
	* @description getPricebookEntry
	* @author André Pietersen (IQ Business) | 2021-09-10
	* @param productId
	* @param unitPrice
	* @return PricebookEntry
	**/
	public static PricebookEntry getPricebookEntry(string productId, decimal unitPrice) {
		List<PricebookEntry> priceBookEntries = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :productId];
		PricebookEntry pricebookEntry;

		if (priceBookEntries.size() > 0) {
			priceBookEntries[0].UnitPrice = unitPrice;
			pricebookEntry = priceBookEntries[0];
		} else {
			Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = TRUE LIMIT 1];

			pricebookEntry = new PricebookEntry();
			pricebookEntry.Pricebook2Id = standardPriceBook.Id;
			pricebookEntry.Product2Id = productId;
			pricebookEntry.UnitPrice = unitPrice;
			pricebookEntry.UseStandardPrice = false;
			pricebookEntry.IsActive = true;
		}
		return PricebookEntry;
	}
}