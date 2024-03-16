import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Array "mo:base/Array";
import List "mo:base/List";

module {
  public type ICRC7NonFungibleToken = {
    logo : LogoResult;
    name : Text;
    symbol : Text;
    maxLimit : Nat16;
  };

  public type ApiError = {
    #Unauthorized;
    #InvalidTokenId;
    #ZeroAddress;
    #Other;
  };

  public type Result<S, E> = {
    #Ok : S;
    #Err : E;
  };

  public type OwnerResult = Result<Principal, ApiError>;
  public type TxReceipt = Result<Nat, ApiError>;

  public type TransactionId = Nat;
  public type TokenId = Nat64;

  public type InterfaceId = {
    #Approval;
    #TransactionHistory;
    #Mint;
    #Burn;
    #TransferNotification;
  };

  public func getSBTCardLevel(cardType : Text) : Nat {
    switch (cardType) {
      case ("AIRDROP") { return 1 };
      case ("BATTERY") { return 2 };
      case ("LIGHTING") { return 3 };
      case ("THUNDER") { return 4 };
      case _ { return 0 };
    };
  };

  public type LogoResult = {
    logo_type : Text;
    data : Text;
  };

  public type Nft = {
    op : Text;
    tid : Nat;
    from : Text;
    to : Text;
    owner : Text;
    id : TokenId;
    meta : MetadataDesc;
  };

  public type UpdateNftOption = {
    update_index : Nat;
    update_size : Nat;
  };

  //嗯嗯。可以这样。user{ userid，wallet，vft_total,  details，nft, has_nft}

  public type VftUserInfo = {
    userId : Text;
    wallet : ?Text;
    vft_total : ?Float;
    var vft_total_statements : Text;
    var details : Text;
    nft : ?Nft;
    task_code : Text;
  };
  //index,user_id,task_code,vft_total,timestamps;
  public type VftRecord = {
    index : Text;
    user_id : Text;
    task_code : Text;
    vft_total : Text;
    timestamps : Text;
  };

  public type ExtendedMetadataResult = Result<{ metadata_desc : MetadataDesc; token_id : TokenId }, ApiError>;

  public type MetadataResult = Result<MetadataDesc, ApiError>;

  public type MetadataDesc = [MetadataPart];

  public type MetadataPart = {
    purpose : MetadataPurpose;
    key_val_data : [var MetadataKeyVal];
    data : Blob;
  };

  public type MetadataPurpose = {
    #Preview;
    #Rendered;
  };

  public type MetadataKeyVal = {
    key : Text;
    val : MetadataVal;
  };

  public type MetadataVal = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content : Nat8;
    #Nat16Content : Nat16;
    #Nat32Content : Nat32;
    #Nat64Content : Nat64;
    #IntContent : Int;
  };

  public type MintReceipt = Result<MintReceiptPart, ApiError>;

  public type MintReceiptPart = {
    accountId : Text;
    nft : Nft;
  };
};
