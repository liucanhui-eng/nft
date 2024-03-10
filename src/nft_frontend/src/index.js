import { createActor, nft } from "../../declarations/nft_backend";
import { AuthClient } from "@dfinity/auth-client"
import { HttpAgent } from "@dfinity/agent";
import { AccountIdentifier } from "@dfinity/ledger-icp";


let actor = nft;

function formatTimestamp(timestamp) {
  // 创建 Date 对象
  let date = new Date(timestamp / 1000000);
  if (isNaN(date.getTime())) {
    return timestamp;
  }
  // 获取年份
  let year = date.getFullYear();
  // 获取月份
  let month = date.getMonth() + 1;
  month = month < 10 ? '0' + month : month;
  // 获取日期
  let day = date.getDate();
  day = day < 10 ? '0' + day : day;
  // 获取小时
  let hour = date.getHours();
  // 获取分钟
  let minute = date.getMinutes();
  // 获取秒钟
  let second = date.getSeconds();
  // 将日期和时间组合成字符串
  let formattedDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;
  return formattedDate;
}


document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  const input_user_id = document.getElementById("input_user_id").value.toString();

  button.setAttribute("disabled", true);

  // Interact with foo actor, calling the greet method
  var greeting = -1;
  try {
    greeting = await actor.queryNft(input_user_id);
  } catch (error) {
    console.log(error);
    alert("非法参数" + input_user_id);
    return;
  }

  button.removeAttribute("disabled");
  debugger;

  const image = greeting[0].meta[0].key_val_data[0].val.TextContent;
  const vftInfo = greeting[0].meta[0].key_val_data[1].val.TextContent;
  const vftCount = greeting[0].meta[0].key_val_data[2].val.Nat64Content;
  const VFTUpdateTime = greeting[0].meta[0].key_val_data[3].val.IntContent;
  const userId = greeting[0].meta[0].key_val_data[4].val.TextContent;
  const walletAddress = greeting[0].meta[0].key_val_data[5].val.TextContent;
  const mintTime = greeting[0].meta[0].key_val_data[6].val.IntContent;



  document.getElementById("image_mintTime").src = image;
  document.getElementById("vftInfo").innerText = vftInfo;
  document.getElementById("vftCount").innerText = vftCount;
  document.getElementById("VFTUpdateTime").innerText = formatTimestamp(Number(VFTUpdateTime));
  document.getElementById("userId").innerText = userId;
  document.getElementById("walletAddress").innerText = walletAddress;
  document.getElementById("mintTime").innerText = formatTimestamp(Number(mintTime));
  return false;
});




document.getElementById("form2").addEventListener("click", async (e) => {
  const _vftCount = document.getElementById("_vftCount").value;
  const _vftInfo = document.getElementById("_vftInfo").value;
  const _user = document.getElementById("_user").value;
  const _vftUserId = document.getElementById("_vftUserId").value;
  const _reputationPoint = document.getElementById("_reputationPoint").value;
  const _walletAddress = document.getElementById("_walletAddress").value;
  const _SBTGetTime = document.getElementById("_SBTGetTime").value;
  const _SBTMembershipCategory = document.getElementById("_SBTMembershipCategory").value;
  const _STBCardImage = document.getElementById("_STBCardImage").value;

  const VFTParams = {};
  VFTParams.vftCount = BigInt(_vftCount);
  VFTParams.info = _vftInfo;
  VFTParams.user = _user;
  VFTParams.vftUserId = _vftUserId;
  VFTParams.reputationPoint = _reputationPoint;
  VFTParams.walletAddress = _walletAddress;
  VFTParams.SBTGetTime = BigInt(new Date(_SBTGetTime).getTime());
  VFTParams.SBTMembershipCategory = _SBTMembershipCategory;
  VFTParams.STBCardImage = _STBCardImage;
  var result;
  try {
    result = await actor.mintICRC7(VFTParams);
  } catch (error) {
    alert(error)
  }
  debugger;
  alert("success ");
  console.log("_vftCount=" + _vftCount + "\n_vftInfo=" + _vftInfo + "\nuser=" + _user + "\nvftUserId=" + _vftUserId + "\nreputationPoint=" + _reputationPoint + "\nwalletAddress=" + _walletAddress + "\nSBTGetTime=" + new Date(_SBTGetTime).getTime() + "\nSBTMembershipCategory=" + _SBTMembershipCategory + "\nSTBCardImage=" + _STBCardImage);
  return false;
});
document.getElementById("whoami").addEventListener("click", async (e) => {
  e.preventDefault();
  // create an auth client
  let authClient = await AuthClient.create();
  // start the login process and wait for it to finish
  await new Promise((resolve) => {
    authClient.login({
      identityProvider: process.env.II_URL,
      onSuccess: resolve,
    });
  });

  // At this point we're authenticated, and we can get the identity from the auth client:
  const identity = authClient.getIdentity();
  // Using the identity obtained from the auth client, we can create an agent to interact with the IC.
  const agent = new HttpAgent({ identity });
  actor = createActor(process.env.NFT_BACKEND_CANISTER_ID, {
    agent,
  });
  // Using the interface description of our webapp, we create an actor that we use to call the service methods.
  const principal = await actor.whoami();
  const textDecoder = new TextDecoder();
  const accountIdentifier = AccountIdentifier.fromPrincipal({principal:principal})
  alert(accountIdentifier.toHex());

  return false;
});





// 获取 tab 按钮和内容元素
const tabButtons = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-pane');

// 为每个 tab 按钮添加点击事件监听器
tabButtons.forEach(button => {
  button.addEventListener('click', handleTabClick);
});

// 处理 tab 点击事件
function handleTabClick(event) {
  const tabId = event.target.dataset.tab;

  // 隐藏所有 tab 内容
  tabContents.forEach(content => {
    content.style.display = 'none';
  });

  // 显示指定 tab 的内容
  const selectedContent = document.getElementById(tabId);
  selectedContent.style.display = 'block';
}
