import AsyncStorage from '@react-native-async-storage/async-storage'
import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = process.env.EXPO_PUBLIC_SUPABASE_URL
const SUPABASE_KEY = process.env.EXPO_PUBLIC_SUPABASE_KEY

if (!SUPABASE_URL || !SUPABASE_KEY) {
    throw new Error('Missing Supabase env variables in app.json extra')
}

export const supabase = createClient(
    SUPABASE_URL,
    SUPABASE_KEY,
    {
        auth: {
            storage: AsyncStorage,           // 🔒 把 session token 存在 React Native 的 AsyncStorage
            autoRefreshToken: true,          // 🔄 當 access token 快過期時，自動用 refresh token 續期
            persistSession: true,            // 💾 重新啟動 app 時，自動從 storage 載回 session
            detectSessionInUrl: false,       // 🌐 在 URL 查找 session（前端單頁面通常設 false）
        }
    }
)