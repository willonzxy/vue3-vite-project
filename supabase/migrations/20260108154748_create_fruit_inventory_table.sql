/*
  # Create fruit inventory table

  1. New Tables
    - `fruit_inventory`
      - `id` (uuid, primary key) - Unique identifier
      - `fruit_name` (text) - Name of the fruit
      - `type` (text) - 'in' for incoming, 'out' for outgoing
      - `quantity` (integer) - Amount in kg
      - `unit_price` (decimal) - Price per unit
      - `total_amount` (decimal) - Total transaction amount
      - `description` (text) - Additional notes
      - `created_at` (timestamptz) - When the record was created
  
  2. Security
    - Enable RLS on `fruit_inventory` table
    - Add policies for public access (read, insert, update, delete) for demonstration
    
  Note: This is a simple implementation for demonstration. In production,
  you would want to add authentication and restrict access based on user roles.
*/

CREATE TABLE IF NOT EXISTS fruit_inventory (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fruit_name text NOT NULL,
  type text NOT NULL CHECK (type IN ('in', 'out')),
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price decimal(10, 2) NOT NULL DEFAULT 0,
  total_amount decimal(12, 2) NOT NULL DEFAULT 0,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE fruit_inventory ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
  ON fruit_inventory
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert access for all users"
  ON fruit_inventory
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Enable update access for all users"
  ON fruit_inventory
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Enable delete access for all users"
  ON fruit_inventory
  FOR DELETE
  USING (true);

CREATE INDEX idx_fruit_name ON fruit_inventory(fruit_name);
CREATE INDEX idx_type ON fruit_inventory(type);
CREATE INDEX idx_created_at ON fruit_inventory(created_at);