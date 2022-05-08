public class HexToIntegerCoverter {
	public static final List<String> hex = '0123456789abcdef'.split('');    
	public static Integer hexToInteger(String str) {
    	str = str.toLowerCase();
    	String[] hexValue = str.split('');
    	Integer retVal = 0;
    		for(Integer i = 0; i < hexValue.size(); i++) {
        		retVal = (retVal << 4) + hex.indexOf(hexValue[i]);
        }
    return retVal;
	}
}