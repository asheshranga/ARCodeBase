/**
 * This class is used to provide compression of the String data using LZW (Lempel-Ziv-Welch),
 * a universal lossless data compression algorithm.
 */
public with sharing class LZW 
{
	/**
	 * Represents an empty string value
	 */
	private static final transient String EMPTY_STR = '';
	
	/**
	 * The initial size of the character map
	 */
	private static final transient Integer INIT_MAP_SIZE = 8192;
	
	/**
	 * The maximum size for the character map
	 */
	private static final transient Integer MAX_MAP_SIZE = 65536;
	
	/**
	 * Character map. Maps a string containing a single character
	 * to the unicode value of the character.
	 */
	private static transient Map<String, Integer> charMap;
	
	static
	{
        charMap = new Map<String,Integer>();
        for (integer i = 0; i < INIT_MAP_SIZE; ++i)
            charMap.put(getCharString(i), i);	
	}
	
	
	/**
	 * Compresses the given string and returns the compressed result it as a string
	 *
	 * @param 	originalString	The string to compress
	 * @return	              	The compressed string
	 */
	public static String compress(String originalString) {
		List<Integer> compressed = compressToIntList(originalString);
		return intListToString(compressed);
	}
	
    /**
     *  Compress a string to a list of output symbols.
     *
     *  @uncompressed           The string data to be compressed
     *  @return                 A list of integers which represent the compressed data
     *                          using the LZW compression algorithm.
     */
    public static List<Integer> compressToIntList(String uncompressed) {
        // Build the dictionary.
        integer dictSize = 256;
        Map<String,Integer> dictionary = createAsciiToIntDictionary(dictSize);
 
        String w = EMPTY_STR;
        String[] uncompressedArray = toCharArray(uncompressed);
      
        List<Integer> result = new List<Integer>();
        
        for (String element : uncompressedArray) 
        {
            String wc = w + element;
            if (dictionary.containsKey(wc))
                w = wc;
            else 
            {
                result.add(dictionary.get(w));
                // Add wc to the dictionary.
                dictionary.put(wc, dictSize++);
                w = element;
            }
        }
 
        // Output the code for w.
        if (!w.equals(EMPTY_STR))
            result.add(dictionary.get(w));
        return result;
    }
    
    /**
	 * Decompresses a string and returns the original string
	 *
	 * @param 	compressedString	The compressed string
	 * @return	                	The decompressed string
	 */
	public static String decompress(String compressedString) {
		List<Integer> compressedIntList = stringToIntList(compressedString);
		return decompressIntList(compressedIntList);
	}
    
    /**
     *  Decompress a list of output ks to a string.
     *
     *  @uncompressed                    The compressed data to be uncompressed.
     *  @return                          The uncompressed data in string format.
     *  @throws        SNG_Exception     Thrown if the compressed data is not of
     *                                   a valid format. 
     */
    public static String decompressIntList(List<Integer> compressed) 
    {
        // Build the dictionary.
        integer dictSize = 256;
        Map<Integer,String> dictionary = createIntToAsciiDictionary(dictSize);
 
        Integer[] iArr = new Integer[] {compressed.remove(0)};
        String w = String.fromCharArray(iArr);

        String result = w;
        for (integer k : compressed) {
            String entry;
            if (dictionary.containsKey(k))
                entry = dictionary.get(k);
            else if (k == dictSize)
                entry = w + w.substring(0, 1);
            else
                throw new SNG_Exception('Bad compressed k: ' + k);
 
            result += entry;
 
            // Add w+entry[0] to the dictionary.
            dictionary.put(dictSize++, w + entry.substring(0, 1));
 
            w = entry;
        }
        
        return result;
    }

    /**
     * Creates an ASCII to integer dictionary, which maps the values from
     * ASCII to it's equivalent integer value.
     *
     * @param   dictSize        The dictionary size.
     * @return                  A mapping of the ASCII to its integer value.
     */
    private static Map<String, Integer> createAsciiToIntDictionary(integer dictSize)
    {
    	Map<String,Integer> dictionary = new Map<String,Integer>();
        for (integer i = 0; i < 256; i++)
        {
            dictionary.put(getCharString(i), i);
        }
        
        return dictionary;
    }

    /**
     * Creates an integer to ASCII dictionary, which maps the values from
     * integer to it's equivalent ASCII value.
     *
     * @param   dictSize        The dictionary size.
     * @return                  A mapping of an integer to its ASCII value.
     */    
    private static Map<Integer, String> createIntToAsciiDictionary(integer dictSize)
    {
    	Map<Integer, String> dictionary = new Map<Integer, String>();
        for (integer i = 0; i < 256; i++)
        {
            dictionary.put(i, getCharString(i));
        }    	
        
        return dictionary;
    }
    
    /**
	 * Creates a string from a list of integers (each representing a character)
	 *
	 * @param 	intList	List of integers
	 * @return	       	The string containing the characters from intList
	 */
	private static String intListToString(List<Integer> intList) {
		return String.fromCharArray(intList);
	}
	
	/**
	 * Creates a list of integers (each representing a character) from a string
	 *
	 * @param 	str	The String to return a list of characters for
	 * @return	   	List of characters
	 */
	private static List<Integer> stringToIntList(String str) {
		String[] strArray = toCharArray(str);
		List<Integer> intList = new List<Integer>();
		for (String s : strArray) {
			intList.add(getCharValue(s));
		}
		return intList;
	}

    /**
     * Converts a string to a char array. Since Salesforce does not support a
     * char array, the return type is a string array containing one character
     * of the string per index.
     *
     * @param   strArray        The string to convert to char array.
     * @return                  The char array representation of the string.
     */
    private static String[] toCharArray(String strArray)
    {
        String[] uncompressedArray = strArray.split(EMPTY_STR);
        uncompressedArray.remove(0);
        return uncompressedArray;
    }

    /**
     * Create a string of length 1 with a single unicode character
     *
     * @param   x        The unicode character to make a string for
     * @return           The string containing the single unicode character
     */
    private static String getCharString( integer x ) 
    {
        return String.fromCharArray( new integer[] { x } );
    }
    
    /**
	 * Gets the integer value for the character contained in the given string
	 *
	 * @param 	character	String containing a single character
	 * @return	         	The integer value of the character contained in the string
	 */
    private static Integer getCharValue(String character) {
    	Integer intChar = charMap.get(character);
    	
    	if (null == intChar) {
    		// not found in original map. need to keep looking. extending map as we go,
    		// for further optimization.
    		for (Integer i = charMap.size(); i < MAX_MAP_SIZE; ++i) {
    			String charStr = getCharString(i);
    			charMap.put(charStr, i);
    			if (charStr.equals(character)) {
    				intChar = i;
    				break;
    			}
    		}
    	}
    	
    	return intChar;
    }

}