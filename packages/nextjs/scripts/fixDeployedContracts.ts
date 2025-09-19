import fs from "fs";

const path = "contracts/deployedContracts.ts";
let content = fs.readFileSync(path, "utf-8");

// ubah deployedOnBlock: "12345" jadi deployedOnBlock: 12345
content = content.replace(/deployedOnBlock:\s*"(\d+)"/g, "deployedOnBlock: $1");

fs.writeFileSync(path, content);
console.log("✅ deployedContracts.ts fixed (deployedOnBlock jadi number)");
