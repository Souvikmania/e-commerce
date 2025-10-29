-- Fix function security: Set search_path for update_last_updated function
CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.last_updated = NOW();
  RETURN NEW;
END;
$$;