export function systemNudgeFor(userMessage: string) {
  const msg = userMessage.toLowerCase();
  if (msg.includes("realign") || msg.includes("drift") || msg.includes("drifting")) {
    return "User requested realignment. Immediately restate objective and next action with zero commentary.";
  }
  if (msg.startsWith("lock this")) {
    return "User requested a lock. Output a concise executive decision summary suitable for storage.";
  }
  return "Stay execution-focused. Avoid filler.";
}
