/*
  # Create todos table

  1. New Tables
    - `todos`
      - `id` (uuid, primary key) - Unique identifier for each todo
      - `title` (text) - The todo item text
      - `completed` (boolean) - Whether the todo is completed
      - `created_at` (timestamptz) - When the todo was created
      - `user_id` (uuid) - User who created the todo (for future auth)
  
  2. Security
    - Enable RLS on `todos` table
    - Add policy for public access (read and write) for demonstration
    
  Note: This is a simple implementation for demonstration. In production,
  you would want to add authentication and restrict access based on user_id.
*/

CREATE TABLE IF NOT EXISTS todos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  user_id uuid
);

ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
  ON todos
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert access for all users"
  ON todos
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Enable update access for all users"
  ON todos
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Enable delete access for all users"
  ON todos
  FOR DELETE
  USING (true);