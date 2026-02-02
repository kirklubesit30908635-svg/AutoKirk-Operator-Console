import { supabase } from "@/lib/supabase/client";

/**
 * Root authority lookup
 */
export async function getFounder(userId: string) {
  return supabase
    .from("founder.founders")
    .select("*")
    .eq("user_id", userId)
    .single();
}

/**
 * Create a new decision thread
 */
export async function createThread(
  title: string,
  createdBy: string
) {
  return supabase
    .from("founder.threads")
    .insert({
      title,
      created_by: createdBy,
    })
    .select()
    .single();
}

/**
 * Append a command/log entry to a thread
 */
export async function appendMessage(
  threadId: string,
  content: string
) {
  return supabase
    .from("founder.messages")
    .insert({
      thread_id: threadId,
      content,
    })
    .select()
    .single();
}
