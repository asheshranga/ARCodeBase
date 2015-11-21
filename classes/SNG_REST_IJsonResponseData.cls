/**
 * This marker interface is used within the SNG_REST_JsonResponse class to create flexibility
 * in the data member among the various APIs
 */
public interface SNG_REST_IJsonResponseData {

    boolean equals(Object obj);
    integer hashCode();
}