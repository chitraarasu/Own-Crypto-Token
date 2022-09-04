import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";

actor Token {
    var owner : Principal =  Principal.fromText("4fou6-ng7ca-lrhbf-dcdm5-voupe-ejppu-h5jyf-s7rl6-k2rlv-qvnpv-xae");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "DCHI"; 

    private stable var balanceEntries: [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    if (balances.size() < 1) {
      balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal): async Nat {
        var balance : Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };
        return balance;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    public shared(msg) func chechOut(): async Text {
        Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller) == null){
            let amount = 10000;
            var res = await transfer(msg.caller, amount);
            return res; 
        } else {
            return "Already claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
        let fromBalance = await balanceOf(msg.caller);
        if(fromBalance >= amount){
            var newFromBalance: Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await balanceOf(to);
            var newToBalance: Nat = toBalance + amount;
            balances.put(to, newToBalance);
            return "Success";
        } else {
            return "Insufficient Funds";
        }
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
        Debug.print(debug_show(balanceEntries));
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        };
    };
}