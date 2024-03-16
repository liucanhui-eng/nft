import Text "mo:base/Text";

module {

    let start : Text = ",\"";
    let mid : Text = "\":\"";
    let _start : Text = "{";
    let _end : Text = "}";
    let semicolon : Text = "\"";

    public func addJson(json : ?Text, key : Text, value : Text) : Text {
        switch (json) {
            case (null) { return semicolon # key # mid # value # semicolon };
            case (?json) { return json #start #key # mid # value # semicolon };
        };
    };

   public func toJsonStr(json : Text) : Text {
        return _start #json # _end;
    };
};
