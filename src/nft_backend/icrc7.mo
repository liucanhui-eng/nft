import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import List "mo:base/List";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Types "./Types";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Int "mo:base/Int";
import HttpTypes "HttpTypes";
import Cycles "mo:base/ExperimentalCycles";

type ListType = List.List<Types.Nft>;

shared actor class ICRC7NFT(custodian : Principal) = Self {
  //       初始事务ID
  stable var transactionId : Types.TransactionId = 0;
  // 初始 nft货币值为空
  stable var nfts = List.nil<Types.Nft>();
  // 初始化 custodians 数组
  // 数组中存放的元素是 Principal
  // stable var custodians = List.make<Principal>(custodian);
  // 初始化 logo 图片
  stable var logo : Types.LogoResult = { data = "xxx"; logo_type = "xxx" };
  // 初始化 name 名称
  stable var name : Text = "nft";
  stable var symbol : Text = "icrc7";

  // 初始化 最大发行量
  stable var maxLimit : Nat16 = 9_999;
  // 创建一个新的主体 aaaaa-aa
  let null_address : Principal = Principal.fromText("aaaaa-aa");


  let updateNftOption : Types.UpdateNftOption = {
    update_index = 99;
    update_size = 500;
  };

  type VFTParams = {
    user : Text;
    STBCardImage : Text;
    SBTMembershipCategory : Text;
    SBTGetTime : Nat; // 获取时间
    vftCount : Nat64; // vft 数量
    // updateTime : Nat32;
    info : Text; //补充信息
    accountId : Text; //vft user id
    walletAddress : Text; //钱包地址
    reputationPoint : Text; //声誉值
    // Minttime : Nat;
  };

  func getSubNft() : List.List<Types.Nft> {
    var sub:List.List<Types.Nft> = List.nil<Types.Nft>();
    loop {
      if (updateNftOption.update_index == List.size(nfts) or List.size(sub)==updateNftOption.update_size) {
        return sub;
      };
      let update:?Types.Nft = List.get(nfts, updateNftOption.update_index);
      switch (update) {
        case (null) {};
        case (?update) {
          sub:=List.push(update, sub);
        };
      };
    };
    sub;
  };

  public query func queryNft(userId : Text) : async ?Types.Nft {
    // let user = Principal.fromText(userId);
    let result = List.find(nfts, func(token : Types.Nft) : Bool { token.owner == userId });
    result;
  };
  public query func queryNfts() : async ?Types.Nft {
    return List.get(nfts, 0);
  };

  public shared ({ caller }) func whoami() : async Principal {
    return caller;
  };
  public shared ({ caller }) func mintICRC7(VFT : VFTParams) : async Types.MintReceipt {
    let now : Int = Time.now();
    // let STBCardImage = Blob.fromArray([97, 98, 99]);
    let SBTGetTime : Nat32 = 1;
    let SBTMembershipCategory = "register";
    let meat : Types.MetadataPart = {
      data = Blob.fromArray([97, 98, 99]);
      key_val_data : [Types.MetadataKeyVal] = [
        { key = "STBCardImage"; val = #TextContent(VFT.STBCardImage) },
        { key = "VFTInfo"; val = #TextContent(VFT.info) },
        { key = "VFTCount"; val = #Nat64Content(VFT.vftCount) },
        { key = "VFTUpdateTime"; val = #IntContent(now) },
        { key = "accountId"; val = #TextContent(VFT.accountId) },
        { key = "walletAddress"; val = #TextContent(VFT.walletAddress) },
        { key = "mintTime"; val = #IntContent(now) },
      ];
      purpose : Types.MetadataPurpose = #Preview;
    };
    let metadataArray : [Types.MetadataPart] = [meat];
    let desc : Types.MetadataDesc = metadataArray;
    return await realMintICRC7(VFT.accountId, desc);
  };

  func realMintICRC7(accountId : Text, metadata : Types.MetadataDesc) : async Types.MintReceipt {
    // custodians := List.push(Principal.fromText("d6g4o-amaaa-aaaaa-qaaoq-cai"), custodians);
    let newId = Nat64.fromNat(List.size(nfts));
    let nft : Types.Nft = {
      from = accountId;
      id = newId;
      meta = metadata;
      op = "7mint";
      owner = accountId;
      tid = transactionId;
      to = accountId;
    };
    nfts := List.push(nft, nfts);
    transactionId += 1;
    return #Ok({
      accountId = accountId;
      nft = nft;
    });
  };

  // ========================http request==========================================================================================

  public func do_send_post(body : Text) : async Text {

    let url = "";
    let host = "";
    Cycles.add(230_850_258_000);
    let ic : HttpTypes.IC = actor ("aaaaa-aa");
    let http_response : HttpTypes.HttpResponsePayload = await ic.http_request(get_http_req(body, url, host));
    let response_body : Blob = Blob.fromArray(http_response.body);
    let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };

    //6. RETURN RESPONSE OF THE BODY
    // let result : Text = decoded_text # ". See more info of the request sent at: " # url # "/inspect";
    let result : Text = decoded_text;
    result;
  };

  func get_http_req(body : Text, url : Text, host : Text) : HttpTypes.HttpRequestArgs {
    let request_body_json : Text = body;
    let request_body_as_Blob : Blob = Text.encodeUtf8(request_body_json);
    let request_body_as_nat8 : [Nat8] = Blob.toArray(request_body_as_Blob);
    let transform_context : HttpTypes.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };
    return {
      url = url;
      max_response_bytes = null; //optional for request
      headers = get_http_header(host);
      //note: type of `body` is ?[Nat8] so we pass it here as "?request_body_as_nat8" instead of "request_body_as_nat8"
      body = ?request_body_as_nat8;
      method = #post;
      transform = ?transform_context;
    };
  };

  func get_http_header(host : Text) : [HttpTypes.HttpHeader] {
    return [
      { name = "Host"; value = host # ":443" },
      { name = "User-Agent"; value = "http_post_sample" },
      { name = "Content-Type"; value = "application/json" },
      { name = "Idempotency-Key"; value = "123456" },
      { name = "task"; value = "vft" },
    ];
  };

  public query func transform(raw : HttpTypes.TransformArgs) : async HttpTypes.CanisterHttpResponsePayload {
    let transformed : HttpTypes.CanisterHttpResponsePayload = {
      status = raw.response.status;
      body = raw.response.body;
      headers = [
        {
          name = "Content-Security-Policy";
          value = "default-src 'self'";
        },
        { name = "Referrer-Policy"; value = "strict-origin" },
        { name = "Permissions-Policy"; value = "geolocation=(self)" },
        {
          name = "Strict-Transport-Security";
          value = "max-age=63072000";
        },
        { name = "X-Frame-Options"; value = "DENY" },
        { name = "X-Content-Type-Options"; value = "nosniff" },
      ];
    };
    transformed;
  };

};
