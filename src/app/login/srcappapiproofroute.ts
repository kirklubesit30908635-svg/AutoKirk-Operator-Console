import { createClient } from '@supabase/supabase-js';
import { cookies } from 'next/headers';

export async function GET() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

  const cookieStore = cookies();
  const cookieHeader = cookieStore.getAll().map(c => `${c.name}=${c.value}`).join('; ');

  const supabase = createClient(supabaseUrl, anonKey, {
    global: { headers: { Cookie: cookieHeader } },
  });

  const { data: userData, error: userError } = await supabase.auth.getUser();
  const uid = userData?.user?.id ?? null;

  const { data: isFounder, error: founderError } = await supabase.rpc('is_founder');

  // ARE-1 table read (adjust if your schema differs)
  const { data: tasks, error: tasksError } = await supabase
    .from('operator_tasks')
    .select('id')
    .limit(1);

  return Response.json({
    uid,
    userError: userError?.message ?? null,
    isFounder: isFounder ?? null,
    founderError: founderError?.message ?? null,
    operatorTasksReadable: !tasksError,
    tasksError: tasksError?.message ?? null,
  });
}
