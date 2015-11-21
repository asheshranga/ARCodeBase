public class Raj_TestController {
    public Map<String, List<String>> myMap {
        get {
            return new Map<String, List<String>>{
                    'abc' => new List<String>{'123', '456'},
                    'def' => new List<String>{'654', '321'}
                    };
        }
    }
}