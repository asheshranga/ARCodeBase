/**
 * This class is used as part of the response to the RESTful APIs returning a list of
 * JSON objects.
 */
public virtual class SNG_REST_CollectionOutput implements SNG_REST_IJsonResponseData {
    
    /**
     * A generic array of objects.
     */
    public Object[] items { get; private set; }

    /**
     * Creates an instance of this object.
     *
     * @param  items      A list of objects
     */
    public SNG_REST_CollectionOutput(final List<Object> items)
    {
        this.items = items;
    }

    /**
     * Equality comparison used when the object is used as a key in a map.
     * Verifies the items are equal.
     *
     * @param    obj             The object to compare for equality.
     * @return                   Whether or not the objects are considered equal.
     */
    public virtual boolean equals(Object obj) {
    	
    	if (obj == null || !(obj instanceof SNG_REST_CollectionOutput)) return false;
    	
        SNG_REST_CollectionOutput other = (SNG_REST_CollectionOutput) obj;
        if (items == null) {
            if (other.items != null) {
                return false;
            }
        } else if (!items.equals(other.items)) {
            return false;
        }

        return true;
    }

    /**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
    public virtual integer hashCode() {
        final integer prime = 31;
        return prime + items.hashCode();
    }
}