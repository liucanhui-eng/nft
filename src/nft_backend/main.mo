import List "mo:base/List";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
actor {
  stable var data = List.nil<Text>();

  public shared func add(input : Text) : async Nat {
    data := List.push(input, data);
    List.size(data);
  };

  public shared func clean() : async () {
    data := List.nil<Text>();
  };

  public query func query_data() : async Text {
    return debug_show (data);
  };
};
