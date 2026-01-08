import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export interface Todo {
  id: string
  title: string
  completed: boolean
  created_at: string
  user_id: string | null
}

export interface FruitInventory {
  id: string
  fruit_name: string
  type: 'in' | 'out'
  quantity: number
  unit_price: number
  total_amount: number
  description: string
  created_at: string
}
