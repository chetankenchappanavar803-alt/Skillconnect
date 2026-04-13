const SUPABASE_URL = 'https://pokpvnxikvbhfxpgfces.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBva3B2bnhpa3ZiaGZ4cGdmY2VzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMDM0NzgsImV4cCI6MjA5MDg3OTQ3OH0.V1OjGbnGNwNH0md9oNLPWQPFoNUQFpPfSpngdlzC2TQ';

// Google Auth Config
const GOOGLE_CLIENT_ID = '246579726277-eqpo2q5k5llo016uj6be91eblvuqc6tt.apps.googleusercontent.com';

// Initialize Supabase
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
window.supabaseClient = supabaseClient;
window.GOOGLE_CLIENT_ID = GOOGLE_CLIENT_ID;
